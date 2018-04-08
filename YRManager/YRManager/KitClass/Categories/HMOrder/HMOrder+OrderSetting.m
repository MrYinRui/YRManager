//
//  HMOrder+OrderSetting.m
//  HotelManager
//
//  Created by Seven on 2017/6/15.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMOrder+OrderSetting.h"
#import <objc/runtime.h>
#import "HMTallyBookPayway.h"

static char PAYWAY = 'a';
@implementation HMOrder (OrderSetting)

- (BOOL)payClear {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setPayClear:(BOOL)payClear {
    objc_setAssociatedObject(self, @selector(payClear), @(payClear), OBJC_ASSOCIATION_RETAIN);
}

- (double)tempPrice {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTempPrice:(double)tempPrice {
    objc_setAssociatedObject(self, @selector(tempPrice), @(tempPrice), OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray<HMOrderSettingsPayInfo *> *)payWays {
    return objc_getAssociatedObject(self, &PAYWAY);
}

- (void)setPayWays:(NSMutableArray<HMTallyBookPayway *> *)payWays{
    objc_setAssociatedObject(self, &PAYWAY, payWays, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray<HMPaiedDetailModel *> *)fetchPaymentList:(NSString *)remark
                                             fjPath:(NSString *)path {
    
    NSArray *payways = [self payWays];
    NSMutableArray <HMPaiedDetailModel *>*paiedList = [NSMutableArray array];
    for (int i = 0; i < payways.count; i++) {
        HMOrderSettingsPayInfo *payInfo = payways[i];
        
        HMPaiedDetailModel *paiedDetail = [HMPaiedDetailModel new];
        paiedDetail.skje  = payInfo.payments.floatValue;
        paiedDetail.skfs  = payInfo.payWay.sklxGuid;
        paiedDetail.lsh   = payInfo.payNumber;
        paiedDetail.bz    = remark;
        paiedDetail.fj_path = path;
        
        paiedDetail.payedMoney = self.add_payments;
        
        [paiedList addObject:paiedDetail];
    }
    return paiedList;
}


@end
