//
//  HMAlertBasicView.m
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMAlertBasicView.h"

@interface HMAlertBasicView ()

@end

@implementation HMAlertBasicView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        _closeBtn = [UIButton new];
        _closeBtn.b_image([UIImage imageNamed:@"close_01"],UIControlStateNormal)
        .b_frame(LPRectMake(270, 0, 45, 45)).b_moveToView(self);
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)removeAction
{
    
}

- (void)closeAction
{
    [self removeAction];
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap{
    CGPoint touch = [tap locationInView:self.bgView];
    
    if (CGRectContainsPoint(self.frame, touch)) {
        
    }else {
        [self closeAction];
    }
}

- (void)showOnView:(UIView *)view
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
    self.bgView = [UIView new];
    self.bgView.b_bgColor([[UIColor blackColor] colorWithAlphaComponent:0.6])
    .b_moveToView(view);
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasRight(0);kMasTop(0);kMasBottom(0);
    }];
    
    [self.bgView addSubview:self];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.bgView addGestureRecognizer:tap];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.duration = 0.1;
    animation.fromValue = @(1.05);
    animation.toValue = @(1);
    animation.beginTime = 0;
    animation.removedOnCompletion = YES;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
