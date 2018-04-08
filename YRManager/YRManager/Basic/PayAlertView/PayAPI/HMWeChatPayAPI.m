//
//  HMWeChatPayAPI.m
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMWeChatPayAPI.h"
#import "UIDevice+LPGetIP.h"

@implementation HMWeChatPayAPI

- (NSString *)spbillCreateIp
{
    return [UIDevice currentIP];
}

- (NSString *)methodName
{
    return @"spring/pay/wechat/wechatUnifiedorder";
}

@end
