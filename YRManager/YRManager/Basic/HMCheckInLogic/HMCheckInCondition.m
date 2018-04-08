//
//  HMCheckInCondition.m
//  HotelManager
//
//  Created by YR on 2017/10/25.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMCheckInCondition.h"
#import "HMOrder.h"
#import "HMLodger.h"

@implementation HMCheckInCondition

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"noShowOrder":[HMOrder class],
             @"overdueOrder":[HMOrder class],
             @"completeLoger":[HMLodger class],
             @"repeatLodger":[HMLodger class]
             };
}

@end
