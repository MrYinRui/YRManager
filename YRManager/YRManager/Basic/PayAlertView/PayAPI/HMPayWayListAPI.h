//
//  HMPayWayListAPI.h
//  HotelManager
//
//  Created by YR on 2017/3/29.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HTTPAPI.h"

@class HMTallyBookPayway;

@interface HMPayWayListAPI : HTTPAPI

/* 此字段代表  支付 支付 支付 */
/**1支付，2折扣支付3.换房支付 4.续住支付5.已订支付,11.取消支付信息 nonCash.非现核销 memberRecharge 会员充值*/
@property (nonatomic, copy) NSString    *payType;   //!<支付信息类型

@end


@interface HMPayWayListAPI (SelectedPayway)

//@property (nonatomic, weak) HMTallyBookPayway *selectedPayway;


@end
