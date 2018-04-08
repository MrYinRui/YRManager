//
//  UILabel+RMB.h
//  HotelManager-Pad
//
//  Created by Seven on 2016/12/1.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+NSMutableAttributedString.h"

@interface UILabel (RMB)

/**
 设置 修改价格 后山峰显示 
 eg: ¥17.00
 @param initFont 最大字体
 @param rmbFont  @"¥"字体
 @param dotFont  @".00"字体
 */
- (void)largestFont:(UIFont *)initFont
        rmbMarkFont:(UIFont *)rmbFont
       dotLaterFont:(UIFont *)dotFont;

/**
 设置 修改价格 后山峰显示 
 eg: 实付款 ¥17.00

 @param subString @"实付款 ¥"
 @param subFont   @"实付款 ¥" 字体
 @param dotFont   @".00" 字体
 */
- (void)alignmentBottomSubString:(NSString*)subString
                         andFont:(UIFont *)subFont
                withDotLaterFont:(UIFont *)dotFont;

@end
