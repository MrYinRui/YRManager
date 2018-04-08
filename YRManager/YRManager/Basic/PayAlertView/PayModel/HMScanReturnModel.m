//
//  HMScanReturnModel.m
//  HotelManager
//
//  Created by YR on 2018/3/22.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMScanReturnModel.h"

@implementation HMScanReturnModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"errCode":@"err_code",
             @"tranId":@"transaction_id",
             @"errCodeDes":@"err_code_des",
             @"mchId":@"mch_id",
             @"nonceStr":@"nonce_str",
             @"resultCode":@"result_code",
             @"returnCode":@"return_code",
             @"returnMsg":@"return_msg"
             };
}

@end
