//
//  HMOrder+ChargeOff.m
//  HotelManager
//
//  Created by Seven on 2017/6/20.
//  Copyright © 2017年 Xun. All rights reserved.
//  协议订单 核销

#import "HMOrder+ChargeOff.h"
#import <objc/runtime.h>

#define kSetE   self.e = self.totalPrice - self.currentRoomPrice - self.deposit;
#define kSetN   self.n = self.paied - self.e - self.agreementTotalPrice;
@implementation HMOrder (ChargeOff)
- (double)e {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
- (void)setE:(double)e {
    objc_setAssociatedObject(self, @selector(e), @(e), OBJC_ASSOCIATION_RETAIN);
}

- (double)n {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setN:(double)n {
    objc_setAssociatedObject(self, @selector(n), @(n), OBJC_ASSOCIATION_RETAIN);
}

- (void)manuallySetE {
    kSetE;
}

- (BOOL)isShowChargeOffView {
    
    if (self.platformGuid != nil && self.platformGuid.length) {
        kSetE
        kSetN
        if (self.e > 0 && self.n < 0) {
            return YES;
        }else {
            return NO;
        }
        
    }else {
        return NO;
    }
}

- (BOOL)newest_isShowChangeOffView {
    if (self.platformGuid != nil && self.platformGuid.length) {
        kSetE
        if (self.e > 0) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

- (BOOL)multiOrders_isShowChangeOffView {
    kSetE
    if (self.e > 0) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)singleOrder_isShowChangeOffView {
    
    return  [self newest_isShowChangeOffView];
    
}


@end
