//
//  UIView+ParentVC.m
//  HotelManager-Pad
//
//  Created by r on 17/1/10.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import "UIView+ParentVC.h"

@implementation UIView (ParentVC)

- (UIViewController *)parentController
{
//    UIResponder *responder = [self nextResponder];
    UIResponder *responder = self;
    while (responder) {
        HMLog(@"%@",responder);
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end
