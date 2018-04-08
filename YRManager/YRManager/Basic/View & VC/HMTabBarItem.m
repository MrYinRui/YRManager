//
//  HMTabBarItem.m
//  HotelManager
//
//  Created by r on 17/2/21.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMTabBarItem.h"

@implementation HMTabBarItem

+ (instancetype)tabBarItemWithTitle:(NSString *)title normalImg:(NSString *)normalImg selectImg:(NSString *)selectImg{
    
    HMTabBarItem *item = [HMTabBarItem new];
    item.titleLabel.font = kFont(12);
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [item setTitleColor:kGreenColor forState:UIControlStateSelected];
    [item setTitle:title forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
    item.titleLabel.textAlignment = NSTextAlignmentCenter;
    item.imageView.contentMode = UIViewContentModeCenter;
    item.backgroundColor = kGreenColor;
    
    return item;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = kScaleNum(25);
    CGFloat imageX = 0;
    CGFloat imageW = self.width;
    CGFloat imageH = self.height - kScaleNum(25);
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleW = self.width;
    CGFloat titleX = 0;
    CGFloat titleH = kScaleNum(25);
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
