//
//  HMConfirmPayVC.h
//  HotelManager
//
//  Created by YR on 2017/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMBasicVC.h"
#import "HMPayWayModel.h"
#import "HMPaySuccessVC.h"
@class HMPayInfoModel;

@interface HMConfirmPayVC : HMBasicVC

@property (nonatomic, strong) HMPaySuccessVC *successVC;
@property (nonatomic, strong) NSString *isTurnClean;
@property (nonatomic, assign) BOOL banPrice;//!<禁止修改价格，yes不能修改

- (instancetype)initWithOrders:(NSArray *)orderGuids payType:(PayType)payType payModel:(HMPayWayModel *)payModel;

- (instancetype)initWithOrders:(NSArray *)orderGuids payType:(PayType)payType payModel:(HMPayWayModel *)payModel And:(HMPayInfoModel *)payInfoModel;

- (void)refreshPayWayOrders:(NSArray *)orderGuids payType:(PayType)payType payModel:(HMPayWayModel *)payModel;

@end
