//
//  HMActualPayAlert.m
//  HotelManager
//
//  Created by YR on 2017/3/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMActualPayAlert.h"
#import "HMPriceTFInput.h"

@interface HMActualPayAlert ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton  *closeBtn;
@property (nonatomic, strong) UILabel   *titleLab;
@property (nonatomic, strong) UITextField   *priceTF;
@property (nonatomic, strong) UIButton  *cancelBtn;
@property (nonatomic, strong) UIButton  *sureBtn;

@property (nonatomic, assign) BOOL      payWay;

@property (nonatomic, strong) HMPayInfoModel *model;
@property (nonatomic, assign) CGFloat   price;

@property (nonatomic, strong) NSString  *payType;

@end

@implementation HMActualPayAlert
{
    BOOL isHaveDian;
}

- (instancetype)initWithPayInfo:(HMPayInfoModel *)payInfo money:(CGFloat)price andPayWay:(NSString *)payWay
{
    if (self == [super init])
    {
        _model = payInfo;
        _price = price;
        _payType = payWay;
        
        if ([payWay isEqualToString:PayViewPaywayCash] ||
            [payWay isEqualToString:PayViewPaywayCashRefund] ||
            [payWay isEqualToString:PayViewPaywayAuthorizing] ||
            [payWay isEqualToString:PayViewPaywayAuthorizingUndo])
        {
            _payWay = NO;
        }
        else
        {
            _payWay = YES;
        }
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = LPRectMake(32.5, 115, 310, 225);
        [self initAlert];
    }
    return self;
}

- (void)initAlert
{
    _closeBtn = [UIButton new];
    _closeBtn.b_image([UIImage imageNamed:@"close_01"],UIControlStateNormal)
    .b_frame(LPRectMake(270, 0, 40, 40)).b_moveToView(self);
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *way = @"实付款";
    if ([_payType isEqualToString:PayViewPaywayCashRefund])
    {
        way = @"实返款";
    }
    
    NSString *roomNum = @"外来客";
    if (_model.fh.length > 0)
    {
        roomNum = [NSString stringWithFormat:@"%@房",_model.fh];
    }
    _titleLab = [UILabel new];
    _titleLab.b_font(kFont(16)).b_text([NSString stringWithFormat:@"%@ %@",roomNum,way])
    .b_frame(LPRectMake(32, 50, 246, 20)).b_moveToView(self);
    
    UIView *leftView = [UIView new];
    leftView.b_bgColor([UIColor clearColor]).b_frame(LPRectMake(0, 0, 10, 50));
    
    _priceTF = [UITextField new];
    _priceTF.layer.borderColor = kGreenColor.CGColor;
    _priceTF.layer.borderWidth = 1;
    _priceTF.clearButtonMode = UITextFieldViewModeAlways;
    _priceTF.b_font(kFont(20)).b_textColor(kGreenColor)
    .b_delegate(self)
    .b_leftView(leftView).b_leftViewMode(UITextFieldViewModeAlways)
    .b_text([NSString stringWithFormat:@"%.02f",_price])
    .b_frame(LPRectMake(32, 80, 246, 50)).b_moveToView(self);
    
    _cancelBtn = [UIButton new];
    _cancelBtn.b_title(@"取消",UIControlStateNormal).b_font(kFont(15))
    .b_titleColor(kColor(130, 130, 130, 1),UIControlStateNormal)
    .b_frame(LPRectMake(0, 175, 155, 50)).b_moveToView(self);
    [_cancelBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    _sureBtn = [UIButton new];
    _sureBtn.b_title(@"确定",UIControlStateNormal).b_font(kFont(15))
    .b_titleColor(kGreenColor,UIControlStateNormal)
    .b_frame(LPRectMake(155, 175, 155, 50)).b_moveToView(self);
    [_sureBtn addTarget:self action:@selector(sureChangePay) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [UIView new];
    line1.b_bgColor(kColor(230, 230, 230, 1))
    .b_frame(LPRectMake(0, 175, 310, 1)).b_moveToView(self);
    
    UIView *line2 = [UIView new];
    line2.b_bgColor(kColor(230, 230, 230, 1))
    .b_frame(LPRectMake(155, 175, 1, 50)).b_moveToView(self);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [HMPriceTFInput priceTextField:textField range:range string:string dian:isHaveDian limit:2 isMinus:_payWay];
}

- (void)closeAction
{
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)sureChangePay
{
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
    if (_SureChangePayBlock)
    {
        _SureChangePayBlock(_priceTF.text);
    }
}

- (void)showOnView:(UIView *)view
{
    _bgView = [UIView new];
    _bgView.b_bgColor([[UIColor blackColor] colorWithAlphaComponent:0.4])
    .b_frame(LPRectMake(0, 0, 375, 667)).b_moveToView(view);
    
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
