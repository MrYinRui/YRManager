//
//  HMSavePayInfoAPI.m
//  HotelManager
//
//  Created by YR on 2017/4/5.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMSavePayInfoAPI.h"
#import "NSObject+JsonString.h"

@implementation HMSavePayInfoAPI

- (NSString *)methodName
{
    return @"spring/order/curDay/savePayInfo";
}

- (NSDictionary *)parameters
{
    return @{@"paydata":[_paydata jsonString]};
}

@end
