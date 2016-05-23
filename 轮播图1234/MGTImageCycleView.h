//
//  MGTImageCycleView.h
//  轮播图Text
//
//  Created by 咪咕 on 16/5/20.
//  Copyright © 2016年 咪咕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

@class MGTImageCycleView;

@protocol MGTImageCycleViewDelegate <NSObject>

//点击图片响应此方法
- (void)cycleScrollView:(MGTImageCycleView *)cycleScrollView didSelectedNetworkImageAtIndex:(NSInteger)index;

@end

@interface MGTImageCycleView : UIView

//网络轮播图初始化
+ (instancetype)NetworkImageCycleViewWithFrame:(CGRect)frame delegate:(id<MGTImageCycleViewDelegate>)delegate PlaceholderImage:(UIImage *)placeholderImage;

//本地初始化轮播图

+ (instancetype)loadImageCycleViewWithFrame:(CGRect)frame LoadImageName:(NSArray *)loadImageName;

/**数据源*/
/**网络图片*/
@property (nonatomic, strong)NSArray *networkImageUrlArray;

/**文子显示*/
@property (nonatomic, strong)NSArray *titlesArray;

/**本地图片*/
@property (nonatomic, strong)NSArray *loadImageArray;



//----------------------**属性的设置**----------------------

/** 滚动时间 */
@property (nonatomic, assign)CGFloat autoCycleTime;

/** 圆点位置的设置 */
@property (nonatomic, assign)UIPageControlShowStyle pageControlShowStyle;

/**占位图片*/
@property (nonatomic, strong)UIImage *placeholderImage;

/** 是否自动滚动*/
@property (nonatomic, assign)BOOL isAutoRoll;

@property (nonatomic, assign)id<MGTImageCycleViewDelegate>delegate;
/**圆点属性*/
/**当前分页控件颜色*/
@property (nonatomic, strong)UIColor *currentPageDotColor;

/**其他分页控件颜色*/
@property (nonatomic, strong)UIColor *pageDotColor;;

/** 是否显示分页控件 */
@property (nonatomic, assign)BOOL showPageControl;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/**文子的颜色*/
@property (nonatomic, strong)UIColor *titleTextColor;

/**文子大小*/
@property (nonatomic, strong)UIFont *titleTextFont;

/**轮播文字的背景色*/
@property (nonatomic, strong)UIColor *titleTextBackgroundColor;

/** 轮播图文字的高度 */
@property (nonatomic, assign)CGFloat titleTextHeight;

///** block方式监听点击 */
//@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);
//
///** block方式监听滚动 */
//@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

@end
