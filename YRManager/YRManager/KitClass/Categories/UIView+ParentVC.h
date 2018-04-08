//
//  UIView+ParentVC.h
//  HotelManager-Pad
//
//  Created by r on 17/1/10.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ParentVC)

// 通过响应者链条获取view所在的控制器
- (UIViewController *)parentController;

@end
