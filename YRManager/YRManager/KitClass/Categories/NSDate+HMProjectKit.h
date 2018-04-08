//
//  NSDate+HMProjectKit.h
//  HotelManager
//
//  Created by xun on 16/7/20.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HMProjectKit)

/**
 *  获取所传月份起止日期
 *
 *  @param date 月份（yyyy-MM）
 *
 *  @return 起止日期
 */
+ (NSArray *)monthBegainAndEnd:(NSString *)date;

/**
 *  计算与当前日期相差几天的日期
 *
 *  @param day 日期距离，（单位：天）
 *
 *  @return 相差为day的日期
 */
- (NSDate *)leadDay:(NSInteger)day;

/**
 *  计算与当前日期相差1个月的日期
 *
 *  @param month 日期距离，（单位：月）
 *
 *  @return 相差为month的日期
 */
- (NSDate *)leadMonth:(NSInteger)month;

/**
 *  计算与当前日期相差1年的日期
 *
 *  @param year 日期距离，（单位：年）
 *
 *  @return 相差为year的日期
 */
- (NSDate *)leadYear:(NSInteger)year;

/**
 *  根据日期字符串、日期格式、日期距离计算出目标日期字符串
 *
 *  @param day          相差天数
 *  @param dateStr      日期字符串
 *  @param formatterStr 日期格式
 *
 *  @return 目标日期字符串
 */
+ (NSString *)dateWithLeadDay:(NSInteger)day
                 dateString:(NSString *)dateStr
            formatterString:(NSString *)formatterStr;

/**
 *  日历日期
 *
 *  @param year  年份，0表示当年
 *  @param month 月份, 0表示当月
 *
 *  @return 当年当月表格内所有日期
 */
+ (NSArray *)calendarDateWithYear:(int)year month:(int)month;

/**
 *  获取当天的星期
 *
 *  @param inputDate 当天日期
 *
 *  @return 返回星期(例如:周六)
 */
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;

/**
 *  计算两个日期相差的天数
 *
 *  @param dateOne 起始日期
 *  @param dateTwo 结束日期
 *
 *  @return 相差的天数
 */
+ (NSString *)getSubtractValue:(NSDate *)dateOne second:(NSDate *)dateTwo;

/**
 *  获取当天日期
 *
 *  @param format 日期格式
 *
 *  @return 当天日期
 */
+ (NSString *)getCurrentDateWithFormat:(NSString *)format;

/**
 *  获取明天日期
 *
 *  @param format 日期格式
 *
 *  @return 当天日期
 */
+ (NSString *)getTomorrowDateWithFormat:(NSString *)format;

/**
 转换为特定日期格式
 
 @param intoDate  进入日期
 @param leaveDate 退房日期
 
 @return 返回字符串 1月1日-1月2日 1晚
 */
+(NSString *)dateWithIntoDate:(NSString *)intoDate leaveDate:(NSString *) leaveDate;


/**
 转换为特定日期格式
 
 @param intoDate  进入日期
 @param leaveDate 退房日期
 
 @return 返回字符串 1月1日-1月2日 1晚
 */
+(NSString *)dateWithDate:(NSDate *)intoDate leaveDate:(NSDate *) leaveDate;

/**
 @return 1 晚
 */
+ (NSString *)daysIntervalWithIntoDate:(NSString *)intoDate leaveDate:(NSString *) leaveDate;

//仿照qq 微信聊天显示时间 
+ (NSString *)timeStringWithTimeInterval:(NSString *)timeInterval;
//仿照qq 微信聊天列表显示时间
+ (NSString *)timeStringWithTimeInterval2:(NSString *)timeInterval;

/**
 判断是否为今天
 */
- (BOOL)isToday;

//判断是否为当月
- (BOOL)isMonth;

//是否在同一周
- (BOOL)isSameWeek;

//是否为昨天
- (BOOL)isYesterday;

/**
 转换为特定日期

 @param intoDate 要转换的日期
 @return MM月dd日 星期  12月12日 周三
 */
+(NSString *)dateWithDate:(NSString *)intoDate;


/**
 根据日历单位比较两日期早晚（早晚为升序，只接受 年月日时分秒单位比较）

 @param date1 date1
 @param date2 date2
 @param unit  日历单位

 @return 比较结果
 */
+ (NSComparisonResult)compareDate:(NSDate *)date1
                         withDate:(NSDate *)date2
                  byCalendarUnits:(NSCalendarUnit)unit;

- (NSComparisonResult)compareWithDate:(NSDate *)date1
                      byCalendarUnits:(NSCalendarUnit)unit;

@end
