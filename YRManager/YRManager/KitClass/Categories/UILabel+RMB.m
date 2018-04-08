//
//  UILabel+RMB.m
//  HotelManager-Pad
//
//  Created by Seven on 2016/12/1.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import "UILabel+RMB.h"

@implementation UILabel (RMB)

- (void)largestFont:(UIFont *)initFont
        rmbMarkFont:(UIFont *)rmbFont
       dotLaterFont:(UIFont *)dotFont
{
    if (initFont)
    {
        self.font = initFont;
    }
    [self setAttributedStringWithSubString:@"￥" font:rmbFont];
    [self setAttributedStringWithSubString:@"¥" font:rmbFont]; //这两个¥ ￥不一样
    
    if ([self.text containsString:@"."])
    {
        NSRange range = [self.text rangeOfString:@"." options:0];
        [self setAttributedStringWithSubString:[self.text substringWithRange:NSMakeRange(range.location, 3)] font:dotFont];
    }
    [(NSMutableAttributedString*)self.attributedText addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(0, self.text.length)];
}

- (void)alignmentBottomSubString:(NSString *)subString
                         andFont:(UIFont *)subFont
                withDotLaterFont:(UIFont *)dotFont
{
    if (subString)
    {
        [self setAttributedStringWithSubString:subString font:subFont];
    }
    
    if ([self.text containsString:@"."])
    {
        NSRange range = [self.text rangeOfString:@"." options:0];
        [self setAttributedStringWithSubString:[self.text substringWithRange:NSMakeRange(range.location, 3)] font:dotFont];
    }
    [(NSMutableAttributedString*)self.attributedText addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(0, self.text.length)];
    
}
@end
