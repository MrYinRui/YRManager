//
//  NSString+CheckPhone.m
//  HotelManager
//
//  Created by r on 17/7/29.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "NSString+CheckPhone.h"

@implementation NSString (CheckPhone)

+ (BOOL)checkPhoneNum:(NSString *)phoneNum {
    
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    return isMatch;
}

@end
