//
//  HMWeChatScanAPI.m
//  HotelManager
//
//  Created by YR on 2018/3/15.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMWeChatScanAPI.h"
#import "UIDevice+LPGetIP.h"

@implementation HMWeChatScanAPI

- (NSString *)methodName
{
    return @"spring/pay/wechat/wechatMicroPay";
}

- (NSString *)spbillCreateIp
{
    return [UIDevice currentIP];
}

@end
