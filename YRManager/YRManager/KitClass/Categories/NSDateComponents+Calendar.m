//
//  NSDateComponents+Calendar.m
//  HotelManager
//
//  Created by r on 17/3/2.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "NSDateComponents+Calendar.h"

@implementation NSDateComponents (Calendar)

+ (NSArray<NSDateComponents *> *)dateCompontentsWithSomedayComponents:(NSDateComponents *)somedayComponents {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    // 该月1号是星期几 (Sunday:1, Monday:2, Tuesday:3, Wednesday:4, Thursday:5 Friday:6, Saturday:7)
    NSDateComponents *firstDayComp = [NSDateComponents firstDayDateWithSomedayComponents:somedayComponents];
    NSInteger firstWeekday = firstDayComp.weekday;
    for (NSInteger i = 1; i <= (firstWeekday - 1); i++) {
        
        NSDateComponents *lastDayComp = [NSDateComponents dateComponents:firstDayComp AfterYears:0 months:0 days:-i];
        [arr insertObject:lastDayComp atIndex:0];
    }
    
    // 该月有几天
    NSInteger length = [NSDateComponents daysOfMonthWithSomedayComponents:somedayComponents];
    for (NSInteger i = 1; i <= length; i++) {
        NSDateComponents *dateComp = [[NSDateComponents alloc] init];
        dateComp.year = somedayComponents.year;
        dateComp.month = somedayComponents.month;
        dateComp.day = i;
        [arr addObject:dateComp];
    }
    
    if (arr.count % 7 == 0) {
        return arr;
    }
    
    // 最后一行补齐
    NSInteger makeUpNum = 7 - (arr.count % 7);
    // 该月最后一天
    NSDateComponents *endDayComp = [NSDateComponents endDayDateWithSomedayComponents:somedayComponents];
    for (NSInteger i = 1; i <= makeUpNum; i++) {
        
        NSDateComponents *nextDayComp = [NSDateComponents dateComponents:endDayComp AfterYears:0 months:0 days:i];
        [arr addObject:nextDayComp];
    }
    
    return arr;
}

// someday 所在月份天数
+ (NSInteger)daysOfMonthWithSomedayComponents:(NSDateComponents *)somedayComponents {
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *somedayDate = [calendar dateFromComponents:somedayComponents];
    NSInteger length = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:somedayDate].length;
    
    return length;
}

// someday 所在月份第一天
+ (NSDateComponents *)firstDayDateWithSomedayComponents:(NSDateComponents *)somedayComponents {
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *firstDayComp = [[NSDateComponents alloc] init];
    firstDayComp.year = somedayComponents.year;
    firstDayComp.month = somedayComponents.month;
    firstDayComp.day = 1;
    
    NSDate *firstDayDate = [calendar dateFromComponents:firstDayComp];
    
    return [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:firstDayDate];
}

// someday 所在月份最后一天
+ (NSDateComponents *)endDayDateWithSomedayComponents:(NSDateComponents *)somedayComponents {
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *somedayDate = [calendar dateFromComponents:somedayComponents];
    NSInteger length = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:somedayDate].length;
    NSDateComponents *endDayComp = [[NSDateComponents alloc] init];
    endDayComp.year = somedayComponents.year;
    endDayComp.month = somedayComponents.month;
    endDayComp.day = length;
    
    NSDate *endDayDate = [calendar dateFromComponents:endDayComp];
    
    return [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:endDayDate];
}

// someday 加上year,month,day后的未来日期(传入正值)，或减去year,month,day后的过去日期(传入付值)
+ (NSDateComponents *)dateComponents:(NSDateComponents*)somedayComponents AfterYears:(NSInteger)year months:(NSInteger)month days:(NSInteger)day {
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.year = year;
    component.month = month;
    component.day = day;
    NSDate *somedayDate = [calendar dateFromComponents:somedayComponents];
    NSDate *newDate = [calendar dateByAddingComponents:component toDate:somedayDate options:0];
    
    return [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:newDate];
}

+ (NSArray<NSDateComponents *> *)oneWeekCompontentsWithSomedayComponets:(NSDateComponents *)somedayComponents
                                                              andSwitch:(CalenderSwitch)switchType
                                                      isContainRightDay:(BOOL)contain{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *somedayDate = [calendar dateFromComponents:somedayComponents];
    
    // 该月有几天
    NSInteger length = [NSDateComponents daysOfMonthWithSomedayComponents:somedayComponents];
    NSInteger dif = length - somedayComponents.day;
    NSInteger flag = 0;
    
    if (switchType == CalenderSwitchPlus) {
        flag = 1;
        
        if (dif < 7 && dif > 0) {
            somedayComponents.day = length - 7;
            somedayDate = [calendar dateFromComponents:somedayComponents];
        }
        
    } else if (switchType == CalenderSwitchMinus) {
        flag = -1;
        
        if (somedayComponents.day < 7 && somedayComponents.day != 1) {
            somedayComponents.day = 8;
            somedayDate = [calendar dateFromComponents:somedayComponents];
        }
        
    }
    if (contain) {
        for (NSInteger i = 0; i < 7; i++) {
            NSDate *targetDate = [NSDate dateWithTimeInterval:flag * i * (24 * 60 * 60) sinceDate:somedayDate];
            NSDateComponents *targetComponets = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:targetDate];
            if (flag == 1) {
                [arr addObject:targetComponets];
            } else {
                [arr insertObject:targetComponets atIndex:0];
            }
        }
        
    } else {
        
        for (NSInteger i = 1; i <= 7; i++) {
            NSDate *targetDate = [NSDate dateWithTimeInterval:flag * i * (24 * 60 * 60) sinceDate:somedayDate];
            NSDateComponents *targetComponets = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:targetDate];
            if (flag == 1) {
                [arr addObject:targetComponets];
            } else {
                [arr insertObject:targetComponets atIndex:0];
            }
        }
    }
    
    return arr;
    
}

+ (NSArray<NSDateComponents *> *)oneWeekCompontensContainsToday {
    
    NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSinceNow:(24 * 60 * 60)];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *tomorrowComponets = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:tomorrowDate];
    
    return [NSDateComponents oneWeekCompontentsWithSomedayComponets:tomorrowComponets andSwitch:CalenderSwitchMinus isContainRightDay:NO];
}

+ (NSArray<NSDateComponents *> *)switchOneMonthCompontentsWithSomedayComponets:(NSDateComponents *)somedayComponents andSwitch:(CalenderSwitch)switchType  {
    
    NSMutableArray *arr = [NSMutableArray array];
    somedayComponents.day = 1;
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *somedayDate = [calendar dateFromComponents:somedayComponents];
    
    NSDate *targetDate;
    
    NSDateComponents *adjustComponets = [[NSDateComponents alloc] init];
    adjustComponets.year = 0;
    adjustComponets.day = 0;
    
    if (switchType == CalenderSwitchMinus) {
        adjustComponets.month = -1;
        
    } else if (switchType == CalenderSwitchPlus) {
        adjustComponets.month = 1;
    }
    targetDate = [calendar dateByAddingComponents:adjustComponets toDate:somedayDate options:0];
    
    for (NSInteger i = 0; i < 7; i++) {
        NSDate *newDate = [NSDate dateWithTimeInterval: i  * (24 * 60 * 60) sinceDate:targetDate];
        NSDateComponents *newComponets = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:newDate];
        
        [arr addObject:newComponets];
    }
    
    return  arr;
}

+ (NSArray<NSDateComponents *> *)halfYearlyCompontentsWithACertainMonth:(NSDateComponents *)aCertainMonthComponets
                                                              andSwitch:(CalenderSwitch)switchType
                                                    isContainRightMonth:(BOOL)contain{
    NSMutableArray *arr = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *adjustComponets = [[NSDateComponents alloc] init];
    adjustComponets.year = 0;
    adjustComponets.day = 0;
    NSInteger flag = 0;
    NSDate *targetDate;
    
    if (switchType == CalenderSwitchMinus) {
        
        flag = -1;
        
        if (contain) {
            
            if (aCertainMonthComponets.month <= 6) {
                aCertainMonthComponets.month = 7;
            }else {
                aCertainMonthComponets.month = 13;
            }
            
            
        } else {
            
            if (aCertainMonthComponets.month <= 6) {
                aCertainMonthComponets.month = 1;
            }else {
                aCertainMonthComponets.month = 7;
            }
            
        }
        
    }else if (switchType == CalenderSwitchPlus) {
        flag = 1;
        
        if (contain) {
            
            if (aCertainMonthComponets.month <= 6) {
                aCertainMonthComponets.month = 0;
            }else {
                aCertainMonthComponets.month = 6;
            }
            
        } else {
            if (aCertainMonthComponets.month <= 6) {
                aCertainMonthComponets.month = 6;
            }else {
                aCertainMonthComponets.month = 12;
            }
        }
    }
    
    NSDate *certainMonthDate = [calendar dateFromComponents:aCertainMonthComponets];
    
    
    for (NSInteger i = 1; i <= 6; i++) {
        
        adjustComponets.month = i * flag;
        
        targetDate = [calendar dateByAddingComponents:adjustComponets toDate:certainMonthDate options:0];
        
        NSDateComponents *newComponets = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:targetDate];
        if (flag == 1) {
            [arr addObject:newComponets];
        } else {
            [arr insertObject:newComponets atIndex:0];
        }
    }
    
    return  arr;
}

+ (NSArray<NSDateComponents *> *)halfYearlyCompontensContainsRightMonth {
    
    NSDate *date = [NSDate newDate];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *rightMonthComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    return [self halfYearlyCompontentsWithACertainMonth:rightMonthComponents andSwitch:CalenderSwitchMinus isContainRightMonth:YES];
}

+ (NSArray<NSDateComponents *> *)oneYearCompontentsWithComponets:(NSDateComponents *)components
                                                       andSwitch:(CalenderSwitch)switchType {
    NSMutableArray *arr = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *adjustComponets = [[NSDateComponents alloc] init];
    adjustComponets.year = 0;
    adjustComponets.month = 0;
    adjustComponets.day = 0;
    NSInteger flag = 0;
    NSDate *targetDate;
    
    if (switchType == CalenderSwitchMinus) {
        
        flag = -1;
        
    }else if (switchType == CalenderSwitchPlus) {
        
        flag = 1;
    }
    
    adjustComponets.year = flag;
    
    //更改 传入
    //    NSDate *certainMonthDate = [calendar dateFromComponents:components];
    
    NSDateComponents *temComps = [NSDateComponents new];
    temComps.calendar = components.calendar;
    temComps.year   = components.year;
    temComps.month  = components.month;
    temComps.day    = components.day;
    
    NSInteger newFlag;
    if (components.month >=7) {//下半年
        temComps.year = temComps.year + flag;
        temComps.month = 13;
        temComps.day   = 1;
        newFlag = -1;
        
    }else{
        temComps.year = temComps.year + flag;
        temComps.month = 0;
        temComps.day   = 1;
        newFlag  = 1;
    }
    
    NSDate *newOperateDate = [calendar dateFromComponents:temComps];
    adjustComponets.year = 0;
    
    for (NSInteger i = 1; i <= 6; i++) {
        
        adjustComponets.month = i * newFlag;
        
        targetDate = [calendar dateByAddingComponents:adjustComponets toDate:newOperateDate options:0];
        
        NSDateComponents *newComponets = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:targetDate];
        if (newFlag == 1) {
            [arr addObject:newComponets];
        } else {
            [arr insertObject:newComponets atIndex:0];
        }
    }
    
    //
    //    components.month = 0;
    //    components.day = 1;
    
    //    targetDate  = [calendar dateByAddingComponents:adjustComponets toDate:certainMonthDate options:0];
    //
    //    for (NSInteger i = 1; i <= 6; i++) {
    //
    //        adjustComponets.month = i;
    //
    //        targetDate = [calendar dateByAddingComponents:adjustComponets toDate:certainMonthDate options:0];
    //
    //        NSDateComponents *newComponets = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:targetDate];
    //        [arr addObject:newComponets];
    //    }
    
    return  arr;
    
}

- (NSDateComponents *)earlierDateComponentsWith:(NSDateComponents *)dateComponents {
    if (self.year < dateComponents.year) {
        return self;
        
    } else if (self.year > dateComponents.year) {
        return dateComponents;
        
    } else {
        if (self.month < dateComponents.month) {
            return self;
            
        } else if (self.month > dateComponents.month) {
            return dateComponents;
            
        } else {
            if (self.day <= dateComponents.day) {
                return self;
            } else {
                return dateComponents;
            }
        }
    }
}

@end
