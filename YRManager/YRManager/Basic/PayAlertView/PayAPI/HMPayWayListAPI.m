//
//  HMPayWayListAPI.m
//  HotelManager
//
//  Created by YR on 2017/3/29.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPayWayListAPI.h"
#import <objc/runtime.h>

static char SELECTEDPAYWAY = 'b';

@implementation HMPayWayListAPI

- (NSString *)methodName
{
    return @"spring/order/fwddsk/payType";
}

@end


@implementation HMPayWayListAPI (SelectedPayway)


- (HMTallyBookPayway *)selectedPayway{
    return objc_getAssociatedObject(self, &SELECTEDPAYWAY);
}

- (void)setSelectedPayway:(HMTallyBookPayway *)selectedPayway{
    objc_setAssociatedObject(self, &SELECTEDPAYWAY, selectedPayway, OBJC_ASSOCIATION_ASSIGN);
}

@end
