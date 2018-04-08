//
//  NSDateComponents+Calendar.h
//  HotelManager
//
//  Created by r on 17/3/2.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,CalenderSwitch) {
    CalenderSwitchPlus = 1,  //➕
    CalenderSwitchMinus = -1 //➖
};

@interface NSDateComponents (Calendar)

// 返回somedayComponents所在月份的所有dateCompontents（包括第一行和最后一行为了凑整的上个月和下个月的部分dateCompontents）
+ (NSArray <NSDateComponents *> *)dateCompontentsWithSomedayComponents:(NSDateComponents *)somedayComponents;

// somedayComponents 加上 year、month、day 或减去 year、month、day （传入负值）后的日期
+ (NSDateComponents *)dateComponents:(NSDateComponents*)somedayComponents AfterYears:(NSInteger)year months:(NSInteger)month days:(NSInteger)day;

//七天 显示
+ (NSArray <NSDateComponents *> *)oneWeekCompontentsWithSomedayComponets:(NSDateComponents *)somedayComponents
                                                               andSwitch:(CalenderSwitch)switchType
                                                       isContainRightDay:(BOOL)contain; //是否包含当天

+ (NSArray <NSDateComponents *> *)oneWeekCompontensContainsToday;

// 某天那个月  上一个月或下一个月 切换 显示月初七天
+ (NSArray <NSDateComponents *> *)switchOneMonthCompontentsWithSomedayComponets:(NSDateComponents *)somedayComponents
                                                                      andSwitch:(CalenderSwitch)switchType;

// 半年 切换
+ (NSArray <NSDateComponents *> *)halfYearlyCompontentsWithACertainMonth:(NSDateComponents *)aCertainMonthComponets
                                                               andSwitch:(CalenderSwitch)switchType
                                                     isContainRightMonth:(BOOL)contain; //是否包含当月

+ (NSArray<NSDateComponents *> *)halfYearlyCompontensContainsRightMonth;

// 一年一年切换 显示上半年
+ (NSArray<NSDateComponents *> *)oneYearCompontentsWithComponets:(NSDateComponents *)components
                                                       andSwitch:(CalenderSwitch)switchType;

- (NSDateComponents *)earlierDateComponentsWith:(NSDateComponents *)dateComponents;

@end
