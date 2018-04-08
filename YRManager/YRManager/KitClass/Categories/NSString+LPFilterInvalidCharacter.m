//
//  NSString+LPFilterInvalidCharacter.m
//  Lodger-Pad
//
//  Created by xun on 10/6/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "NSString+LPFilterInvalidCharacter.h"

@implementation NSString (LPFilterInvalidCharacter)

- (BOOL)isPureNumberString
{
    NSString *numberStr = @"^[0-9]+$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberStr];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValiadPhoneNumber
{
    NSString *numberStr = @"^1[0-9]{10}+$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberStr];
    
    return [predicate evaluateWithObject:self];
}

//判断是否为整形：
- (BOOL)isPureInteger
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return[scan scanInteger:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
@end
