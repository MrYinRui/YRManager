//
//  HMCheckInCondition.h
//  HotelManager
//
//  Created by YR on 2017/10/25.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMOrder,HMLodger;

@interface HMCheckInCondition : NSObject

@property (nonatomic, strong) NSString  *isNoshow;          //!<是否有noshow未处理单（1.有0.无）
@property (nonatomic, strong) HMOrder   *noShowOrder;

@property (nonatomic, strong) NSString  *isOverdue;         //!<是否有逾期未离单（1.有 0.无）
@property (nonatomic, strong) HMOrder   *overdueOrder;

@property (nonatomic, strong) NSString  *isSameRoomOrder;   //!<是否存在不同类型的已入住订单（1.有   0.无）
@property (nonatomic, strong) NSString  *isBalance;         //!<入住人是否有余款  （0.正常1.欠款）

@property (nonatomic, strong) NSString  *isComplete;        //!<入住人是否完整   （1.非完整  0.完整）
@property (nonatomic, strong) HMLodger  *completeLoger;

@property (nonatomic, strong) NSString  *isRepeat;
//!<入住人是否有重复  （1.身份证重复  2.手机  3身份证和手机  0.无重复）
@property (nonatomic, strong) HMLodger  *repeatLodger;

@property (nonatomic, strong) NSString  *isRoomClean;       //!<房间是否洁房（0.洁房  1.非洁房）
@property (nonatomic, strong) NSString  *isIn;              //!<入住状态（-1 入住异常  0待住  1入住成功）

@property (nonatomic, strong) NSString  *sendSuccess;       //!<蓝牙发送是否成功

@end
