//
//  HMWeChatPayAPI.h
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HTTPAPI.h"

@interface HMWeChatPayAPI : HTTPAPI

@property (nonatomic, copy) NSString    *spbillCreateIp;    //!<支付手机IP
@property (nonatomic, copy) NSString    *body;              //!<描述
@property (nonatomic, assign) float     totalAmount;        //!<金额

@end
