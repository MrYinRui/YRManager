//
//  HMOrder+Selected.m
//  HotelManager
//
//  Created by Seven on 2017/5/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMOrder+Selected.h"
#import <objc/runtime.h>

@implementation HMOrder (Selected)

- (BOOL)order_isSelected {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setOrder_isSelected:(BOOL)order_isSelected {
    objc_setAssociatedObject(self, @selector(order_isSelected), @(order_isSelected), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)interrelatedOrderCheckoutCanSelected {
    
    if(self.getOrderStatus == LIVING){
        return [self.type isEqualToString:@"1"];//钟点房
    }else if (self.getOrderStatus == WOULD_LEAVE ||
              self.getOrderStatus == WOULD_LEAVE_WITHOUT_CHECK ||
              self.getOrderStatus == OVERDEU_NOT_AWAY ||
              self.getOrderStatus == FRONT_DESK_HURRY_CHECK_UP ||
              self.getOrderStatus == CUSTOMER_HURRY_CHECK_UP  ||
              self.getOrderStatus == RESPONIBLE_CHECK   ||
              self.getOrderStatus == OTHERS_CHECK  ||
              self.getOrderStatus == CHECK_WITH_NO_PROBLEM ||
              self.getOrderStatus == CHECK_WITH_MATTER
              ){
        return YES;
    }else {
        return NO;
    }
    
}



@end
