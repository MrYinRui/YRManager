//
//  NSString+MD_5.m
//  GoFun
//
//  Created by Xun on 16/5/17.
//  Copyright © 2016年 Xun. All rights reserved.
//

#import "NSString+MD_5.h"
#import <CommonCrypto/CommonDigest.h>

#define kPwdLen  32

@implementation NSString (MD_5)

- (NSString *)MD_5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[kPwdLen];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md_5Str = [NSMutableString new];
    
    for (int i = 0; i < 16; i++)
    {
        [md_5Str appendFormat:@"%02x", result[i]];
    }
    
    return md_5Str;
}

@end
