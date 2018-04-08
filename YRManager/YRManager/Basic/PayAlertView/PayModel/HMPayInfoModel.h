//
//  HMPayInfoModel.h
//  HotelManager
//
//  Created by YR on 2017/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSaveHotelServiceOrderAPI.h"

@interface HMPayInfoModel : NSObject

@property (nonatomic, strong) NSString *guid;           //!<订单主键
@property (nonatomic, strong) NSString *lock_guid;      //!<锁房的主键
@property (nonatomic, strong) NSString *hymc;           //!<花园名称
@property (nonatomic, strong) NSString *louceng;        //!<楼层
@property (nonatomic, strong) NSString *yk;             //!<余款
@property (nonatomic, strong) NSString *rzrq;           //!<入住日期
@property (nonatomic, strong) NSString *tfrq;           //!<退房日期
@property (nonatomic, strong) NSString *fjh;            //!<房间号
@property (nonatomic, strong) NSString *fh;             //!<房间门牌号
@property (nonatomic, strong) NSString *rzts;           //!<入住天数
@property (nonatomic, strong) NSString *ffxj;
@property (nonatomic, strong) NSString *ffyj;
@property (nonatomic, strong) NSString *fwmj;
@property (nonatomic, strong) NSString *fx;
@property (nonatomic, strong) NSString *fxmc;
@property (nonatomic, strong) NSString *lxdh;
@property (nonatomic, strong) NSString *orderType;      //!<0:全日房 1:钟点房
@property (nonatomic, strong) NSString *ptmc;
@property (nonatomic, strong) NSString *rzxz;
@property (nonatomic, strong) NSString *ttmc;
@property (nonatomic, strong) NSString *yj;
@property (nonatomic, strong) NSString *ysk;
@property (nonatomic, strong) NSString *zje;

//!<外来客信息保存，需要在支付前调用
@property (nonatomic, strong) HMSaveHotelServiceOrderAPI *saveHotelServiceOrderAPI;

@end
