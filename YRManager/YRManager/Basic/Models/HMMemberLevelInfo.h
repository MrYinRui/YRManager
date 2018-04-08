//
//  HMMemberLevelInfo.h
//  HotelManager
//
//  Created by r on 17/6/20.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMMemberLevelInfo : NSObject<NSCopying>

@property (nonatomic, copy) NSString *guid;//!<主键guid
@property (nonatomic, copy) NSString *levelName;//!<会员级别
@property (nonatomic, assign) NSInteger discount;//!<折扣
@property (nonatomic, assign) NSInteger memberTotalPoints;//!<会员积分
@property (nonatomic, assign) NSInteger memberBalancePoints;//!<会员积分余额
@property (nonatomic, assign) NSInteger roomNight;//!<间夜数
@property (nonatomic, assign) CGFloat accountBalance;//!<账户余额

@end
