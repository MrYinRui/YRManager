//
//  HMAlipayScanAPI.h
//  HotelManager
//
//  Created by YR on 2018/3/23.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HTTPAPI.h"

@interface HMAlipayScanAPI : HTTPAPI

@property (nonatomic, strong) NSString  *subject;           //!<订单标题
@property (nonatomic, strong) NSString  *body;              //!<商品描述
@property (nonatomic, strong) NSString  *totalAmount;       //!<订单总金额，单位为元，
@property (nonatomic, strong) NSString  *authCode;
//!<用户支付宝中的“付款码”信息(可选，不传则进行扫描)

@end
