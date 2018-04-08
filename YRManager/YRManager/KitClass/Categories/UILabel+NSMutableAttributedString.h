//
//  UILabel+NSMutableAttributedString.h
//  GoFun
//
//  Created by xun on 16/4/11.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NSMutableAttributedString)

/**
 *  设置label内字符串某些字符串的字体以及颜色
 *
 *  @param subString 子字符串
 *  @param color     期望颜色
 *  @param font      期望字体
 */
- (void)setAttributedStringWithSubString:(NSString *)subString color:(UIColor *)color font:(UIFont *)font;

/**
 *  设置label内字符串某些字符串的颜色
 *
 *  @param subString 子字符串
 *  @param color     期望颜色
 */
- (void)setAttributedStringWithSubString:(NSString *)subString color:(UIColor *)color;

/**
 *  设置label内字符串某些字符串的字体
 *
 *  @param subString 子字符串
 *  @param font      期望字体
 */
- (void)setAttributedStringWithSubString:(NSString *)subString font:(UIFont *)font;

/**
 *  设置label行间距
 *
 *  @param lineSpace 行间距
 */
- (void)setLineSpace:(CGFloat)lineSpace;

- (void)setLineSpace:(CGFloat)lineSpace paragraphSpace:(CGFloat)paragraphSpace;

/**
 *  设置label内字符串多串子字符串的颜色
 *
 *  @param subStringArr 子字符串数组
 *  @param font         期望字体
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr font:(UIFont *)font;

/**
 *  设置label内字符串多串子字符串的颜色
 *
 *  @param subStringArr 子字符串数组
 *  @param color        期望颜色
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr color:(UIColor *)color;

/**
 *  设置label内字符串多串子字符串的颜色和字体
 *
 *  @param subStringArr 子字符串数组
 *  @param font         期望字体
 *  @param color        期望颜色
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr font:(UIFont *)font color:(UIColor *)color;

/**
 *  设置label内字符串多串子字符串各自的颜色以及字体
 *
 *  @param subStringArr 子字符串数组
 *  @param fontArr      期望字体数组
 *  @param colorArr     期望颜色数组
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr fonts:(NSArray *)fontArr colors:(NSArray *)colorArr;

/**
 *  设置label内字符串多串子字符串各自的字体
 *
 *  @param subStringArr 子字符串数组
 *  @param fontArr      期望字体数组
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr fonts:(NSArray *)fontArr;

/**
 *  设置label内字符串多串子字符串各自的颜色
 *
 *  @param subStringArr 子字符串数组
 *  @param colorArr     期望颜色数组
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr colors:(NSArray *)colorArr;

/**
 *  设置字体间距
 *
 *  @param space 间距
 */
- (void)setWordSpace:(CGFloat)space;

/**
 *  为Label内字字符串添加中间划线
 *
 *  @param subString    子字符串
 */
- (void)addMiddleLineWithSubString:(NSString *)subString;
- (void)addMiddleLineWithSubString:(NSString *)subString
                           options:(NSStringCompareOptions)options;

/**
 *  设置相同的子字符串字体颜色
 *
 *  @param substring 子字符串
 *  @param color    颜色
 */
- (void)setAllSameSubString:(NSString *)substring color:(UIColor *)color;

- (void)setAllSameSubString:(NSString *)substring font:(UIFont *)font;

/**
 *  获取所有子字符串的范围
 *
 *  @param substring 子字符串
 *
 *  @return 范围数组
 */
- (NSArray *)getSubstringRanegdArr:(NSString *)substring;

@end
