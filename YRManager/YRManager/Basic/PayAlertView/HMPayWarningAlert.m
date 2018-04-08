//
//  HMPayWarningAlert.m
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPayWarningAlert.h"
#import "HMAlignMentLabel.h"

@interface HMPayWarningAlert ()

@property (nonatomic, strong) UIView    *bgView;

@property (nonatomic, strong) UIButton  *closeBtn;
@property (nonatomic, strong) UIImageView   *titleImg;
@property (nonatomic, strong) HMAlignMentLabel       *titleLab;
@property (nonatomic, strong) UIButton      *cancelBtn;
@property (nonatomic, strong) UIButton      *sureBtn;

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *img;

@end

@implementation HMPayWarningAlert

- (instancetype)initWithTitle:(NSString *)title img:(NSString *)imgName
{
    if (self == [super init])
    {
        _title = title;
        _img = imgName;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = LPRectMake(30, 125, 315, 225);
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _closeBtn = [UIButton new];
    _closeBtn.b_image([UIImage imageNamed:@"close_01"],UIControlStateNormal)
    .b_frame(LPRectMake(270, 0, 45, 45)).b_moveToView(self);
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    _titleImg = [UIImageView new];
    _titleImg.contentMode = UIViewContentModeCenter;
    _titleImg.b_image([UIImage imageNamed:_img])
    .b_frame(LPRectMake(130, 30, 55, 55)).b_moveToView(self);
    
    _titleLab = [HMAlignMentLabel new];
    _titleLab.verticalAlignment = VerticalAlignmentTop;
    _titleLab.b_font(kFont(16)).b_textAlignment(NSTextAlignmentCenter)
    .b_text(_title).b_lineBreakMode(NSLineBreakByCharWrapping)
    .b_numberOfLines(0)
    .b_frame(LPRectMake(0, 100, 315, 60)).b_moveToView(self);
    
    _cancelBtn = [UIButton new];
    _cancelBtn.b_title(@"取消",UIControlStateNormal).b_font(kFont(16))
    .b_titleColor(kColor(130, 130, 130, 1),UIControlStateNormal)
    .b_frame(LPRectMake(0, 175, 157, 50)).b_moveToView(self);
    [_cancelBtn addTarget:self action:@selector(leftBtnActoin) forControlEvents:UIControlEventTouchUpInside];
    
    _sureBtn = [UIButton new];
    _sureBtn.b_title(@"确定",UIControlStateNormal).b_font(kFont(16))
    .b_titleColor(kGreenColor,UIControlStateNormal)
    .b_frame(LPRectMake(157, 175, 157, 50)).b_moveToView(self);
    [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [UIView new];
    line1.b_bgColor(kColor(230, 230, 230, 1))
    .b_frame(LPRectMake(0, 175, 315, 1)).b_moveToView(self);
    
    UIView *line2 = [UIView new];
    line2.b_bgColor(kColor(230, 230, 230, 1))
    .b_frame(LPRectMake(157, 175, 1, 50)).b_moveToView(self);
}

- (void)setBtnTitleArr:(NSArray *)btnTitleArr
{
    [_cancelBtn setTitle:btnTitleArr.firstObject forState:UIControlStateNormal];
    [_sureBtn setTitle:btnTitleArr.lastObject forState:UIControlStateNormal];
}

- (void)sureAction
{
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
    if (_RithtBtnBlock)
    {
        _RithtBtnBlock();
    }
}

- (void)leftBtnActoin
{
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
    if (_LeftBtnBlock)
    {
        _LeftBtnBlock();
    }
}

- (void)closeAction
{
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)showOnView:(UIView *)view
{
    _bgView = [UIView new];
    _bgView.b_bgColor([[UIColor blackColor] colorWithAlphaComponent:0.4])
    .b_moveToView(view);
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasRight(0);kMasTop(0);kMasBottom(0);
    }];
    
    self.layer.cornerRadius = 8;
    [_bgView addSubview:self];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.duration = 0.1;
    animation.fromValue = @(1.05);
    animation.toValue = @(1);
    animation.beginTime = 0;
    animation.removedOnCompletion = YES;
    
    [self.layer addAnimation:animation forKey:nil];
}

@end
