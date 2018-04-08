//
//  HMMemberPayVC.h
//  HotelManager
//
//  Created by YR on 2017/8/1.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMBasicVC.h"
#import "HMPaySuccessVC.h"
@class HMSavePayInfoModel;

@interface HMMemberPayVC : HMBasicVC

- (instancetype)initMemberGuids:(NSString *)orderGuid withPayType:(PayType)payType payModel:(HMPayWayModel *)payModel;
- (instancetype)initOrderedPayGuid:(NSString *)orderGuid money:(double)money payType:(PayType)payType;

@property (nonatomic, strong) HMPaySuccessVC *successVC;

@property (nonatomic, assign) BOOL noCallSavePayInfoApi;//!< 是否 不调用保存支付订单api

@property (nonatomic, copy)   void(^memberPayBlock)(NSMutableArray<HMSavePayInfoModel *> *paydata);


@end
