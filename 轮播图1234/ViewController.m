//
//  ViewController.m
//  轮播图1234
//
//  Created by 咪咕 on 16/5/22.
//  Copyright © 2016年 咪咕. All rights reserved.
//

#import "ViewController.h"
#import "MGTImageCycleView.h"

@interface ViewController ()<MGTImageCycleViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005.jpg"]];
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    demoContainerView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
    [self.view addSubview:demoContainerView];
    
//    self.title = @"轮播Demo";
    
    // 情景一：采用本地图片实现
    NSArray *imageNames = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg",
                            // 本地图片请填写全名
                            ];
    
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    // 情景三：图片配文字
    NSArray *titles = @[@"黄寺大街熬枯受淡杰卡斯 ",
                        @"大卡数量打数量打开始",
                        @"DNA上课了大卡数量打",
                        @"代码快老师的卡仕达"
                        ];
    
    CGFloat w = self.view.bounds.size.width;
    
    /*本地加在图片*/
    MGTImageCycleView *view1 = [MGTImageCycleView loadImageCycleViewWithFrame:CGRectMake(0, 64, w, 180) LoadImageName:imageNames];
    view1.delegate = self;
    [demoContainerView addSubview:view1];
    view1.autoCycleTime = 3;
    view1.titlesArray = titles;
    view1.pageDotColor = [UIColor yellowColor];
    view1.currentPageDotColor = [UIColor greenColor];
    

    /**网络加载图片*/
    MGTImageCycleView *view2 = [MGTImageCycleView NetworkImageCycleViewWithFrame:CGRectMake(0, 280, w, 180) delegate:self PlaceholderImage:[UIImage imageNamed:@"hi.jpg"]];
    view2.autoCycleTime = 2;
    view2.titlesArray = titles;
    view2.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
    view2.networkImageUrlArray = imagesURLStrings;
    [demoContainerView addSubview:view2];
    
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(MGTImageCycleView *)cycleScrollView didSelectedNetworkImageAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
//    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
