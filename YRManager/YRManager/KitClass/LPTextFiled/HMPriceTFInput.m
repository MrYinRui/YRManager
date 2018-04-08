//
//  HMPriceTFInput.m
//  HotelManager
//
//  Created by YR on 2017/6/7.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPriceTFInput.h"

@implementation HMPriceTFInput

+ (BOOL)priceTextField:(UITextField *)textField range:(NSRange)range string:(NSString *)string dian:(BOOL)isHaveDian limit:(NSInteger)limit isMinus:(BOOL)isMinus
{
    if (limit == 0 && [string isEqualToString:@"."]) return NO;
    
    if (string.length >= 2) return NO;
    
    isHaveDian = [textField.text containsString:@"."];
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];
        if ((single >= '0' && single <= '9') || single == '.' || single == '-')
        {
            if([textField.text length] == 0)
            {
                if(single == '.')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '-')
                {
                    if (!isMinus)
                    {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            else
            {
                if (single == '-')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single == '.')
            {
                if(!isHaveDian)
                {
                    isHaveDian = YES;
                    return YES;
                }
                else
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                NSString *str = textField.text;
                NSInteger textLenght = [str stringByReplacingOccurrencesOfString:@"-" withString:@""].length;
                if (isHaveDian && textLenght <= 7)
                {
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= limit)
                    {
                        return YES;
                    }
                    else
                    {
                        return NO;
                    }
                }
                else
                {
                    if (textLenght <= 4)
                    {
                        return YES;
                    }
                    return NO;
                }
            }
        }
        else
        {
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


@end
