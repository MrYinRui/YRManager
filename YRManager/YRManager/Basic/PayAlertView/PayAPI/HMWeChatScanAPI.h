//
//  HMWeChatScanAPI.h
//  HotelManager
//
//  Created by YR on 2018/3/15.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HTTPAPI.h"

@interface HMWeChatScanAPI : HTTPAPI

@property (nonatomic, strong) NSString  *spbillCreateIp;    //!<终端IP
@property (nonatomic, strong) NSString  *body;              //!<商品描述
@property (nonatomic, assign) double    totalAmount;        //!<订单总金额，单位为元，
@property (nonatomic, strong) NSString  *authCode;
//!<"扫码支付授权码，设备读取用户微信中的条码或者二维码信息（可选，不传则进行扫描） 

@end
