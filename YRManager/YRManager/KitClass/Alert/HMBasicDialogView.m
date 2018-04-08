//
//  HMBasicDialogView.m
//  HotelManager
//
//  Created by Seven on 2017/3/28.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMBasicDialogView.h"

@interface HMBasicDialogView ()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation HMBasicDialogView

+ (instancetype)viewWithFrame:(CGRect)frame title:(NSString *)title
{
    HMBasicDialogView *view = [[self alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.f;
    view.clipsToBounds = YES;
    UILabel *titleLab = nil;
    
    if(title && title.length)       //!<是否初始化标题
    {
        titleLab = [UILabel new];
        titleLab.text = title;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = kColor(154, 155, 156, 1);
        [view addSubview:titleLab];
    }
    
    if (CGRectEqualToRect(frame, kDefaultFrame) || CGRectEqualToRect(frame, kQRCodeFrame) || CGRectEqualToRect(frame, kMakeCardRoomFrame))    //根据不同frame设置不同子视图frame
    {
        if (title) {
            
            [view addSeparatorLineWithY:70];
        }
        titleLab.frame = LPRectMake(0, 20, 0, 30);
        titleLab.font = kFont(24);
    }
    else if(CGRectEqualToRect(frame, kInputFrame))
    {
        [view addSeparatorLineWithY:50];
        titleLab.frame = LPRectMake(0, 0, 0, 50);
        titleLab.font = kFontWithName(kBigYoungFontName, 21);
    }
    else if (CGRectEqualToRect(frame, kSearchFrame))
    {
        [view addSeparatorLineWithY:50];
        titleLab.frame = LPRectMake(0, 0, 0, 50);
        titleLab.textColor = [UIColor grayColor];
        titleLab.font = kFont(24);
    }
    
    titleLab.width = view.width;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close_01"] forState:UIControlStateNormal];
    [closeBtn addTarget:view action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = LPRectMake(view.width / kScreenScale - 38, 2, 36, 36);
    view.closeBtn = closeBtn;
    [view addSubview:closeBtn];
    
    return view;
}

+ (instancetype)viewWithFrame:(CGRect)frame
{
    return [self viewWithFrame:frame title:nil];
}

+ (instancetype)viewWithTitle:(NSString *)title
{
    HMBasicDialogView *view = [[self alloc] initWithFrame:kInputFrame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.f;
    view.clipsToBounds = YES;
    
    UILabel *titleLab;
    
    if(title && title.length)       //!<是否初始化标题
    {
        titleLab = [UILabel new];
        titleLab.text = title;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = kColor(154, 155, 156, 1);
        titleLab.frame = LPRectMake(0, 0, 0, 50);
        titleLab.font = kFont(18);
        titleLab.width = view.width;
        titleLab.backgroundColor = kColor(247, 248, 249, 1);
        [view addSubview:titleLab];
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close_01"] forState:UIControlStateNormal];
    [closeBtn addTarget:view action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(view.width - 36, 2, 36, 36);
    [view addSubview:closeBtn];
    
    return view;
}


#pragma mark - Interface Method

- (void)addSeparatorLineWithY:(CGFloat)y
{
    CALayer *line = [CALayer new];
    line.backgroundColor = kSeparatorLineColor.CGColor;
    
    if (CGRectEqualToRect(self.frame, kDefaultFrame))    //根据不同frame设置不同子视图frame
    {
        line.frame = LPRectMake(36, y, 0, 0.5f);
        line.width = self.width - 72 * kScreenScale;
    }
    else
    {
        line.frame = LPRectMake(32, y, 0, 0.5f);
        
        line.width = (int)(self.width - 64 * kScreenScale);
    }
    
    
    [self.layer addSublayer:line];
}

- (void)addSeparatorLineWithY:(CGFloat)y x:(CGFloat)x
{
    
}

- (void)addSeparatorLineWithX:(CGFloat)x
{
    CALayer *line = [CALayer new];
    line.backgroundColor = kSeparatorLineColor.CGColor;
    
    if (CGRectEqualToRect(self.frame, kDefaultFrame))    //根据不同frame设置不同子视图frame
    {
        line.frame = LPRectMake(x, 76, 0.5f, 0);
        line.height = self.height - 195 * kScreenScale;
    }
    else
    {
        
        line.frame = LPRectMake(x, 150, 0.5f , 0);
        line.height = (self.height - 193 * kScreenScale);
    }
    
    [self.layer addSublayer:line];
}
- (void)showWithAnimationOnView:(UIView *)view
{
    _coverView = [UIView new];
    _coverView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _coverView.backgroundColor = kColor(0, 0, 0, 0.4);
    [view addSubview:_coverView];
    
    [view addSubview:self];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.duration = 0.1;
    animation.fromValue = @(1.05);
    animation.toValue = @(1);
    animation.beginTime = 0;
    animation.removedOnCompletion = YES;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)showWithAnimation
{
    [self showWithAnimationOnView:[UIApplication sharedApplication].keyWindow];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)closeView
{
    if(_closeButtonEventBlock)_closeButtonEventBlock();
    [self removeFromSuperview];
}

- (void)removeFromSuperview
{
    //    CATransition *animation = [CATransition animation];
    //
    //    animation.type = @"suckEffect";
    //    animation.subtype = kCATransitionFromTop;
    //    animation.duration = 0.5f;
    //    animation.removedOnCompletion = YES;
    //    animation.delegate = self;
    //    animation.repeatCount = 0;
    //    animation.fillMode = kCAFillModeRemoved;
    //    animation.removedOnCompletion = NO;
    //
    //    [self.layer addAnimation:animation forKey:nil];
    
    [super removeFromSuperview];
    [_coverView removeFromSuperview];
    //    [_bgLayer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        if ([anim isKindOfClass:[CATransition class]])
        {
            [super removeFromSuperview];
            [_coverView removeFromSuperview];
        }
    }
}

- (UIViewController *)viewController
{
    UIResponder *responder = self;
    
    while ((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return (id)responder;
        }
    }
    
    return (id)responder;
}

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    
    _coverView.hidden = hidden;
}

-(void)hiddenCloseBtn
{
    if (self.closeBtn)
    {
        _closeBtn.hidden = YES;
    }
}

@end
