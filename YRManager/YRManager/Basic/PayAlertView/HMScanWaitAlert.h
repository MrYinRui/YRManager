//
//  HMScanWaitAlert.h
//  HotelManager
//
//  Created by YR on 2018/3/23.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMAlertBasicView.h"

@interface HMScanWaitAlert : HMAlertBasicView

- (instancetype)initOutTradeNo:(NSString *)outTradeNo tradeNo:(NSString *)tradeNo relateGuid:(NSString *)relateGuid payWay:(PayWay)payWay;

@end
