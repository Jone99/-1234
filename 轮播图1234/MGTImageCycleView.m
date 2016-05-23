//
//  MGTImageCycleView.m
//  轮播图Text
//
//  Created by 咪咕 on 16/5/20.
//  Copyright © 2016年 咪咕. All rights reserved.
//

#import "MGTImageCycleView.h"
#import "UIView+MGTExtension.h"
#import "UIImageView+WebCache.h"
#import "MGTCollectionViewCell.h"

#define kCycleScrollViewInitialPageControlDotSize CGSizeMake(10, 10)


NSString *Identifier = @"collectionViewCell";

@interface  MGTImageCycleView ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**滑动图*/
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)UIPageControl *pageControl;

@property (nonatomic, strong)NSArray *datasourceArray;//数据源
/**总页数*/
@property (nonatomic, assign)NSInteger totalPageCell;

@property (nonatomic, strong)UIImageView *backgroundImageView;//背景图片

@end

@implementation MGTImageCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMessage];//初始化信息 默认信息
        [self setupCollectionView]; //创建UICollectionView
    }
    return self;
}

- (void)initMessage
{
    
    _pageControlShowStyle = UIPageControlShowStyleRight;
    _autoCycleTime = 2.0;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _titleTextFont = [UIFont systemFontOfSize:13];
    _titleTextColor = [UIColor whiteColor];
    _titleTextBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    _titleTextHeight = 30;
    _isAutoRoll = YES;
    _showPageControl = YES;
    _pageControlDotSize = kCycleScrollViewInitialPageControlDotSize;
}

//本地图片
+ (instancetype)loadImageCycleViewWithFrame:(CGRect)frame LoadImageName:(NSArray *)loadImageName
{
    MGTImageCycleView *imageCycleView = [[self alloc]initWithFrame:frame];
    imageCycleView.loadImageArray = [NSMutableArray arrayWithArray:loadImageName];
    return imageCycleView;
}
/**网络图片*/
+ (instancetype)NetworkImageCycleViewWithFrame:(CGRect)frame delegate:(id<MGTImageCycleViewDelegate>)delegate PlaceholderImage:(UIImage *)placeholderImage
{
    MGTImageCycleView *imageCycleView = [[self alloc]initWithFrame:frame];
    imageCycleView.delegate = delegate;
    imageCycleView.placeholderImage = placeholderImage;
    return imageCycleView;
}


- (void)setupCollectionView
{
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewLayout.minimumLineSpacing = 0;
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionViewLayout = collectionViewLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
    collectionView.backgroundColor = [UIColor blueColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[MGTCollectionViewCell class] forCellWithReuseIdentifier:Identifier];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    [self addSubview:collectionView];
    _collectionView = collectionView;
}

#pragma mark - setter方法

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    if (!self.backgroundImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:imageView belowSubview:self.collectionView];
        self.backgroundImageView = imageView;
    }
    self.backgroundImageView.image = placeholderImage;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize
{
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.currentPageIndicatorTintColor = currentPageDotColor;
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.pageIndicatorTintColor = pageDotColor;
}

- (void)setIsAutoRoll:(BOOL)isAutoRoll
{
    _isAutoRoll = isAutoRoll;
    [self cancelTimerCycle];
    if (_isAutoRoll) {
        [self setupTimer];
    }
}

- (void)setAutoCycleTime:(CGFloat)autoCycleTime
{
    _autoCycleTime = autoCycleTime;
    [self setIsAutoRoll:self.isAutoRoll];
}

- (void)setDatasourceArray:(NSArray *)datasourceArray
{
    if (datasourceArray.count < _datasourceArray.count) {
        [_collectionView setContentOffset:CGPointZero animated:NO];
    }
    _datasourceArray = datasourceArray;
    _totalPageCell = self.datasourceArray.count * 100;
    if (datasourceArray.count !=1) {
        self.collectionView.scrollEnabled = YES;
        [self setIsAutoRoll:self.isAutoRoll];
    }else{
        [self cancelTimerCycle];
        self.collectionView.scrollEnabled = NO;
    }
    [self setupPageControl];
    [self.collectionView reloadData];
    if (datasourceArray.count) {
        [self.backgroundImageView removeFromSuperview];
    }else{
        if (self.backgroundImageView && !self.backgroundImageView.superview) {
            [self insertSubview:self.backgroundImageView belowSubview:self.collectionView];
        }
    }
}

- (void)setNetworkImageUrlArray:(NSArray *)networkImageUrlArray
{
    _networkImageUrlArray = networkImageUrlArray;
    NSMutableArray *array = [NSMutableArray array];
    [_networkImageUrlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        }else if ([obj isKindOfClass:[NSURL class]]){
            NSURL *url = obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [array addObject:urlString];
        }
    }];
    self.datasourceArray = [array copy];
}

- (void)setLoadImageArray:(NSArray *)loadImageArray
{
    _loadImageArray = loadImageArray;
    self.datasourceArray = [loadImageArray copy];
}

#pragma mark - timer
- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoCycleTime target:self selector:@selector(autoCycleTimeView) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)cancelTimerCycle
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - action

- (void)setupPageControl
{
    if (self.datasourceArray.count == 0) return;
    if (self.datasourceArray.count == 1) return;
    int indexOnPageControl = [self currentIndex] % self.datasourceArray.count;
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = self.datasourceArray.count;
    pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
    pageControl.pageIndicatorTintColor = self.pageDotColor;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = indexOnPageControl;
    [self addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)autoCycleTimeView
{
    if (0 == _totalPageCell) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    if (targetIndex >= _totalPageCell) {
            targetIndex = _totalPageCell * 0.5;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex
{
    if (_collectionView.mg_Width == 0 || _collectionView.mg_Height == 0) {
        return 0;
    }
    int index = 0;
    if (_collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_collectionView.contentOffset.x + _collectionViewLayout.itemSize.width * 0.5) / _collectionViewLayout.itemSize.width;
    }else{
        index = (_collectionView.contentOffset.y + _collectionViewLayout.itemSize.height * 0.5) / _collectionViewLayout.itemSize.height;
    }
    return index;
}



#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionViewLayout.itemSize = self.frame.size;
    _collectionView.frame = self.bounds;
    if (_collectionView.contentOffset.x == 0 && _totalPageCell) {
        int targetIndex = 0;
        targetIndex = _totalPageCell * 0.5;
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    CGSize size = CGSizeZero;
    size = CGSizeMake(self.datasourceArray.count * 50, 10);
    
    CGFloat x = (self.mg_Width - size.width)*0.5;
    x = self.collectionView.mg_Width - size.width - 10;

    CGFloat y = self.collectionView.mg_Height - size.height - 10;
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalPageCell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MGTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.datasourceArray.count;
    NSString *imagePath = self.datasourceArray[itemIndex];
    
    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        }else{
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imageView.image = image;
        }
    }else if ([imagePath isKindOfClass:[UIImage class]]){
        cell.imageView.image = (UIImage *)imagePath;
    }
    if (_titlesArray.count && itemIndex < _titlesArray.count) {
        cell.title = _titlesArray[itemIndex];
    }
    if (!cell.hasConfigured) {
        cell.titleBackgroundTextColor = self.titleTextBackgroundColor;
        cell.titleTextHeight = self.titleTextHeight;
        cell.titleTextColor = self.titleTextColor;
        cell.titleTextFont =  self.titleTextFont;
        cell.hasConfigured = YES;
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.clipsToBounds = YES;
    }
    return cell;
}

#pragma warn
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"23456");
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectedNetworkImageAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectedNetworkImageAtIndex:indexPath.item % self.datasourceArray.count];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.datasourceArray.count) return;
    int itemIndex = [self currentIndex];
    int indexOnPageControl = itemIndex % self.datasourceArray.count;
    

    _pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isAutoRoll) {
        [self cancelTimerCycle];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAutoRoll) {
        [self setupTimer];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self scrollViewDidEndScrollingAnimation:self.collectionView];
//}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    if (!self.datasourceArray.count) return;
//    int itemIndex = [self currentIndex];
//    int indexOnPageControl = itemIndex % self.datasourceArray.count;
//    
//    if ([self.delegate ]) {
//        <#statements#>
//    }
//    
//}






















@end
