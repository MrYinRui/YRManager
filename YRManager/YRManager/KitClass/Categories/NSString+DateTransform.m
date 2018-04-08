//
//  NSString+DateTransform.m
//  HotelManager
//
//  Created by r on 17/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "NSString+DateTransform.h"

@implementation NSString (DateTransform)

// 2017-03-01 -> 03月01日
- (NSString *)formatDateString
{
    
    NSString *subStr = [self substringFromIndex:5];
    
    NSString *str1 = [subStr stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    
    NSString *str2 = [str1 stringByAppendingString:@"日"];
    
    return str2;
}

// 2017-03-01 -> 2017年03月01日
- (NSString *)formatDateStringFull {
    
    NSString *year = [self substringToIndex:5];
    NSString *newYear = [year stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    
    return  [newYear stringByAppendingString:[self formatDateString]];
}

@end
