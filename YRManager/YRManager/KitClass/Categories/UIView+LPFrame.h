//
//  UIView+HMFrame.h
//  HotelManager
//
//  Created by xun on 16/7/19.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LPFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@end
