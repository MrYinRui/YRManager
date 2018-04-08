//
//  HMPayOrderModel.h
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPayOrderModel : NSObject

@property (nonatomic, copy) NSString *Id;        //!<订单ID
@property (nonatomic, copy) NSString *outTradeNo;//!<商户订单号
@property (nonatomic, copy) NSString *title;     //!<标题
@property (nonatomic, copy) NSString *descr;     //!<描述
@property (nonatomic, copy) NSString *url;       //!<支付url
@property (nonatomic, assign) CGFloat money;     //!<金额

@end
