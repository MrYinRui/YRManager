//
//  NSDate+HMTime.m
//  HotelManager
//
//  Created by kqz on 2017/7/18.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "NSDate+HMTime.h"
#import <objc/runtime.h>

@implementation NSDate (HMTime)

//+ (void)load
//{
//    /** 获取原始date方法 */
//    Method originalM = class_getClassMethod([self class], @selector(date));
//    
//    /** 获取自定义的newDate方法 */
//    Method exchangeM = class_getClassMethod([self class], @selector(newDate));
//    
//    /** 交换方法 */
//    method_exchangeImplementations(originalM, exchangeM);
//}

/** 自定义的方法 */
+(NSDate *)newDate
{
    HMValueManager *manger = [HMValueManager shareManager];
    
    if (manger.currentTime && manger.currentTime.length > 0)
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:manger.currentTime];
        NSTimeInterval date2 = [date timeIntervalSince1970]; //将后台系统时间转为秒数
        NSTimeInterval time = manger.moveTime;  //app运行的秒数
        return  [NSDate dateWithTimeIntervalSince1970:(time + date2)];
    }
    
    return [self date];
}

@end
