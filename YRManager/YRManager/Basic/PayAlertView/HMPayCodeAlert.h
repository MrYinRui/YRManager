//
//  HMWeChatCodeAlert.h
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMPayOrderModel.h"
#import "HMAlertBasicView.h"

@interface HMPayCodeAlert : HMAlertBasicView

- (instancetype)initWith:(HMPayOrderModel *)orderModel payType:(PayWay)type;

- (instancetype)initWithPayWay:(PayWay)payWay title:(NSString *)title totalMoney:(double)money;

@end
