//
//  MGTCollectionViewCell.h
//  轮播图Text
//
//  Created by 咪咕 on 16/5/22.
//  Copyright © 2016年 咪咕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGTCollectionViewCell : UICollectionViewCell

/**图片*/
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)NSString *title;

@property (nonatomic, strong)UIColor *titleTextColor;
@property (nonatomic, strong)UIFont *titleTextFont;
@property (nonatomic, strong)UIColor *titleBackgroundTextColor;
@property (nonatomic, assign)CGFloat titleTextHeight;

@property (nonatomic, assign)BOOL hasConfigured;

@end
