//
//  HMConfirmPayInfoAPI.h
//  HotelManager
//
//  Created by YR on 2017/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HTTPAPI.h"

@interface HMConfirmPayInfoAPI : HTTPAPI

@property (nonatomic, strong) NSString *guid;       //!<订单的主键
@property (nonatomic, strong) NSString *payType;    //!<

@end
