//
//  UIView+MGTExtension.m
//  轮播图Text
//
//  Created by 咪咕 on 16/5/20.
//  Copyright © 2016年 咪咕. All rights reserved.
//

#import "UIView+MGTExtension.h"

@implementation UIView (MGTExtension)

- (void)setMg_Width:(CGFloat)mg_Width
{
    CGRect temp = self.frame;
    temp.size.width = mg_Width;
    self.frame = temp;
}

- (CGFloat)mg_Width
{
    return self.frame.size.width;
}

- (void)setMg_Height:(CGFloat)mg_Height
{
    CGRect temp = self.frame;
    temp.size.height = mg_Height;
    self.frame = temp;
}

- (CGFloat)mg_Height
{
    return self.frame.size.height;
}

- (void)setMg_X:(CGFloat)mg_X
{
    CGRect temp = self.frame;
    temp.origin.x = mg_X;
    self.frame = temp;
}

- (CGFloat)mg_X
{
    return self.frame.origin.x;
}

- (void)setMg_Y:(CGFloat)mg_Y
{
    CGRect temp = self.frame;
    temp.origin.y = mg_Y;
    self.frame = temp;
}

- (CGFloat)mg_Y
{
    return self.frame.origin.y;
}

@end
