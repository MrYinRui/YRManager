//
//  Prompt.m
//  gangzhi
//
//  Created by Xun on 16/1/11.
//  Copyright © 2016年 gangzhi. All rights reserved.
//

#import "Prompt.h"

@interface Prompt ()

@end

@implementation Prompt

+ (void)popPromptViewWithMsg:(NSString *)msg duration:(NSTimeInterval)duration
{
    CGPoint center = CGPointMake(kScreenWidth / 2.f, kScreenHeight - 100.f);
    
    [Prompt popPromptViewWithMsg:msg duration:duration center:center];
}

+ (void)popPromptViewWithMsg:(NSString *)msg duration:(NSTimeInterval)duration center:(CGPoint)center
{
    [Prompt popPromptOnView:[UIApplication sharedApplication].keyWindow withMsg:msg duration:duration center:center];
}

+ (void)popPromptViewInScreenCenterWithMsg:(NSString *)msg duration:(NSTimeInterval)duration
{
    [Prompt popPromptViewWithMsg:msg duration:duration center:[UIApplication sharedApplication].keyWindow.center];
}

+ (void)popPromptOnView:(UIView *)view withMsg:(NSString *)msg duration:(NSTimeInterval)duration center:(CGPoint)center
{
    Prompt *prompt = [[Prompt alloc] init];
    [prompt initPromptAndLableWithString:msg];
    [view addSubview:prompt];
    [view bringSubviewToFront:prompt];
    prompt.center = center;
    [prompt initAnimationWithDuration:duration];
}

+ (void)popPromptOnView:(UIView *)view withMsg:(NSString *)msg duration:(NSTimeInterval)duration
{
    [Prompt popPromptOnView:view withMsg:msg duration:duration center:CGPointMake(view.size.width / 2, view.size.height / 2)];
}

#pragma mark Helper Methods

- (void)initAnimationWithDuration:(NSTimeInterval)duration
{
    self.alpha = 1.f;
    [UIView animateWithDuration:duration animations:
         ^{
             self.alpha = 0.f;
         }
        completion:^(BOOL finished)
        {
             [self removeFromSuperview];
         }
     ];
}


- (void)initPromptAndLableWithString:(NSString *)str
{
    UILabel *label = [UILabel new];
    UIFont *font = [UIFont systemFontOfSize:15.f];
    
    label.numberOfLines = 0;
    label.font = font;
    label.text = str;
    label.textAlignment = NSTextAlignmentCenter;
    CGSize size = [label sizeThatFits:CGSizeMake(kScreenWidth - 100.f, CGFLOAT_MAX)];
    
    label.frame = CGRectMake(0.f, 0.f, size.width + 20.f, size.height + 20.f);
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    self.frame = label.frame;
    self.layer.cornerRadius = 5.f;
    self.backgroundColor = [UIColor blackColor];
}

@end
