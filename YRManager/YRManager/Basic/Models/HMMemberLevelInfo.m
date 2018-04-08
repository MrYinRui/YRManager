//
//  HMMemberLevelInfo.m
//  HotelManager
//
//  Created by r on 17/6/20.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMMemberLevelInfo.h"
#import "MJExtension.h"

@implementation HMMemberLevelInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"memberTotalPoints":@"integralTotal",
             @"memberBalancePoints":@"integralBalance",
             };
}

- (id)copyWithZone:(NSZone *)zone {
    
    HMMemberLevelInfo *memberLevelInfo = [[[self class] allocWithZone:zone] init];
    
    memberLevelInfo.guid = self.guid;
    memberLevelInfo.levelName = self.levelName;
    memberLevelInfo.discount = self.discount;
    memberLevelInfo.memberTotalPoints = self.memberTotalPoints;
    memberLevelInfo.memberBalancePoints = self.memberBalancePoints;
    memberLevelInfo.roomNight = self.roomNight;
    memberLevelInfo.accountBalance = self.accountBalance;
    
    return memberLevelInfo;
}

@end
