//
//  MGTCollectionViewCell.m
//  轮播图Text
//
//  Created by 咪咕 on 16/5/22.
//  Copyright © 2016年 咪咕. All rights reserved.
//

#import "MGTCollectionViewCell.h"
#import "UIView+MGTExtension.h"

@implementation MGTCollectionViewCell
{
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    return self;
}

- (void)setTitleBackgroundTextColor:(UIColor *)titleBackgroundTextColor
{
    _titleBackgroundTextColor = titleBackgroundTextColor;
    _titleLabel.backgroundColor = titleBackgroundTextColor;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    _titleTextColor = titleTextColor;
    _titleLabel.textColor = titleTextColor;
}

- (void)setTitleTextFont:(UIFont *)titleTextFont
{
    _titleTextFont = titleTextFont;
    _titleLabel.font = titleTextFont;
}

#pragma mark - setup
- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = [NSString stringWithFormat:@"   %@",title];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    CGFloat titleLabelW = self.mg_Width;
    CGFloat titleLabelH = _titleTextHeight;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = self.mg_Height - titleLabelH;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    _titleLabel.hidden = !_titleLabel.text;
}



@end
