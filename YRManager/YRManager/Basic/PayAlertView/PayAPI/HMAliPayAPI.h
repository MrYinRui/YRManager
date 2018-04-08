//
//  HMAliPayAPI.h
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HTTPAPI.h"

@interface HMAliPayAPI : HTTPAPI

@property (nonatomic, copy) NSString *body;         //!< 商品描述
@property (nonatomic, copy) NSString *subject;      //!< 标题
@property (nonatomic, assign) float totalAmount;    //!< 总金额

@end
