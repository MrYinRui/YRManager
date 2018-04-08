//
//  HMCheckInNewLogic.h
//  HotelManager
//
//  Created by YR on 2017/10/24.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMOrder;

@interface HMCheckInNewLogic : NSObject

@property (nonatomic, copy) void (^CheckinBlock)(BOOL success); //!<入住回调

+ (instancetype)logicWithOrder:(HMOrder *)order vc:(UIViewController *)vc;


/**
 刷新订单信息再办理入住（换房后入住用到）
 */
- (void)executeWithFreshOrder:(void (^)(HMOrder *order))refreshBlock;

/**
 执行入住逻辑
 */
//- (void)execute;
- (void)commonExecute;

/**
 判断是否有入住人登记信息
 
 @return 是否有人登记
 */
//- (BOOL)isAnybodyRecordInfo;

- (BOOL)isNeedPay;

- (BOOL)isRoomClean;

@end
