//
//  HMScanReturnModel.h
//  HotelManager
//
//  Created by YR on 2018/3/22.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMScanReturnModel : NSObject

@property (nonatomic, strong) NSString *appid;          //!<
@property (nonatomic, strong) NSString *errCode;        //!<
@property (nonatomic, strong) NSString *errCodeDes;     //!<
@property (nonatomic, strong) NSString *mchId;          //!<
@property (nonatomic, strong) NSString *nonceStr;       //!<
@property (nonatomic, strong) NSString *outTradeNo;     //!<商户订单号
@property (nonatomic, strong) NSString *tranId;         //!<微信交易单号
@property (nonatomic, strong) NSString *resultCode;     //!<支付结果是否成功
@property (nonatomic, strong) NSString *returnCode;     //!<支付请求是否成功
@property (nonatomic, strong) NSString *returnMsg;      //!<
@property (nonatomic, strong) NSString *sign;           //!<

@end
