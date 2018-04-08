//
//  Prompt.h
//  gangzhi
//
//  Created by Xun on 16/1/11.
//  Copyright © 2016年 gangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Prompt : UIView

/**
 *  工厂方法，弹出消息提示框
 *
 *  @param msg      消息文本
 *  @param duration 动画时间
 */
+ (void)popPromptViewWithMsg:(NSString *)msg
                    duration:(NSTimeInterval)duration;

/**
 *  工厂方法，弹出提示框并设置位置
 *
 *  @param msg      消息文本
 *  @param duration 动画时间
 *  @param center   提示框中心位置
 */
+ (void)popPromptViewWithMsg:(NSString *)msg
                    duration:(NSTimeInterval)duration
                      center:(CGPoint)center;

/**
 *  在屏幕中央弹出提示框
 *
 *  @param msg      消息文本
 *  @param duration 动画时间
 */
+ (void)popPromptViewInScreenCenterWithMsg:(NSString *)msg
                                  duration:(NSTimeInterval)duration;

+ (void)popPromptOnView:(UIView *)view withMsg:(NSString *)msg
               duration:(NSTimeInterval)duration;

@end
