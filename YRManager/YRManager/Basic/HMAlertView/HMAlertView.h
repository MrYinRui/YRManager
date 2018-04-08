//
//  HMAlertView.h
//  HotelManager
//
//  Created by r on 17/2/23.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IconType) {
    IconWarn,       //!<⚠️icon
    IconTick,       //!<✅icon
    IconPhone       //!<电话图标
};

@interface HMAlertView : UIView

// 只有alertIcon、一种title的alertView
+ (instancetype)alertViewWithIconType:(IconType)iconType msg:(NSString *)msg;

// 有alertIcon、一种title、底部两个按钮（左侧为取消按钮、右侧需设置title）的alertView
+ (instancetype)alertViewWithIconType:(IconType)iconType msg:(NSString *)msg rightBtnBlock:(void(^)(UIButton *rightBtn))rightBtnBlock;

// 有alertIcon、一种title、底部一个“知道了”按钮的alertView
+ (instancetype)alertViewWithIconType:(IconType)iconType msg:(NSString *)msg knowBtnBlock:(void(^)(UIButton *knowBtn))knowBtnBlock;

// 有alertIcon、两种title、底部一个“知道了”按钮的alertView
+ (instancetype)alertViewWithIconType:(IconType)iconType msg:(NSString *)msg detailMsg:(NSString *)detailMsg knowBtnBlock:(void(^)(UIButton *knowBtn))knowBtnBlock;

// 有alertIcon、一种title、底部两个按钮（左侧学设置title、右侧需设置title）的alertView
+ (instancetype)alertViewWithIconType:(IconType)iconType
                                  msg:(NSString *)msg
                         leftBtnBlock:(void(^)(UIButton *leftBtn))leftBtnBlock
                        rightBtnBlock:(void(^)(UIButton *rightBtn))rightBtnBlock;

// 有alertIcon、两种title、底部两个按钮的alertView
+ (instancetype)alertViewWithIconType:(IconType)iconType
                                  msg:(NSString *)msg
                            detailMsg:(NSString *)detailMsg
                         letfBtnBlock:(void(^)(UIButton *leftBtn))leftBtnBlock
                        rightBtnBlock:(void(^)(UIButton *rightBtn))rightBtnBlock;

// 一种title、上中下垂直排列三个按钮
+ (instancetype)alertViewWithMsg:(NSString *)msg upBtnBlock:(void (^)(UIButton *btn))upBtnBlock centerBtnBlock:(void (^)(UIButton *btn))centerBtnBlock downBtnBlock:(void (^)(UIButton *btn))downBtnBlock;

// 两种title、上中下垂直排列三个按钮
+ (instancetype)alertViewWithIconType:(IconType)iconType
                                  msg:(NSString *)msg
                            detailMsg:(NSString *)detailMsg
                           upBtnBlock:(void (^)(UIButton *btn))upBtnBlock
                       centerBtnBlock:(void (^)(UIButton *btn))centerBtnBlock
                         downBtnBlock:(void (^)(UIButton *btn))downBtnBlock;

//换房特殊结构alert
+ (instancetype)alertViewWithChangeType:(NSString *)type
                                    msg:(NSString *)msg
                           leftBtnBlock:(void (^)(UIButton *leftBtn))leftBtnBlock
                          rightBtnBlock:(void (^)(UIButton *rightBtn))rightBtnBlock
                          cleanBtnBlock:(void (^)(UIButton *cleanBtn))cleanBtnBlock;

- (void)showWithAnimation;
- (void)showWithAnimationOnView:(UIView *)view;

- (void)setTitleString:(NSArray *)arrString Font:(UIFont *)font Color:(UIColor *)color;
- (void)setTitleLabLineSpace:(CGFloat)space;
- (void)hiddenClose;

@property (nonatomic,copy) void (^closeBlock)(void);

@end
