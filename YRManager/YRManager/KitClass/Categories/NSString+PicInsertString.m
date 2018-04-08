//
//  NSString+PicInsertString.m
//  GoFun
//
//  Created by YR on 16/8/27.
//  Copyright © 2016年 xun. All rights reserved.
//

#import "NSString+PicInsertString.h"

@implementation NSString (PicInsertString)

- (NSString *)insertWithSize:(NSString *)size
{
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:self];
    
    if ([mutableStr containsString:@"."])
    {
        NSRange range = [mutableStr rangeOfString:@"." options:NSBackwardsSearch];
        
        [mutableStr insertString:size atIndex:range.location];
    }

    return [NSString stringWithFormat:@"%@",mutableStr];
}

@end
