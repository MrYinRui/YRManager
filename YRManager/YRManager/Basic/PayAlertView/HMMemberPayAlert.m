//
//  HMMemberPayAlert.m
//  HotelManager
//
//  Created by YR on 2017/8/1.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMMemberPayAlert.h"
#import "UILabel+NSMutableAttributedString.h"
#import "HMPriceTFInput.h"
#import "HMPhoneSecurityCodeView.h"

@interface HMMemberPayAlert ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel   *titleLab;
@property (nonatomic, strong) UITextField   *priceTF;
@property (nonatomic, strong) UITextField   *interTF;

@property (nonatomic, strong) UIButton  *cancleBtn;
@property (nonatomic, strong) UIButton  *sureBtn;

@property (nonatomic, strong) HMMemberPayModel *model;
@property (nonatomic, assign) double   price;
@property (nonatomic, strong) NSString *payType;

@end

@implementation HMMemberPayAlert
{
    BOOL isDian;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kScaleNum(8);
        [self initView];
    }
    return self;
}

- (void)initView
{
    _titleLab = [UILabel new];
    _titleLab.b_font(kFont(14))
    .b_textColor(kGlobalTextColorGray)
    .b_numberOfLines(0)
    .b_lineBreakMode(NSLineBreakByCharWrapping)
    .b_frame(LPRectMake(35, 20, 245, 50))
    .b_moveToView(self);
    
    UIImageView *img1 = [UIImageView new];
    img1.b_image([UIImage imageNamed:@"cavels-g"])
    .b_contentMode(UIViewContentModeCenter)
    .b_tag(100)
    .b_frame(LPRectMake(0, 0, 30, 45));
    
    _priceTF = [UITextField new];
    _priceTF.layer.cornerRadius = kScaleNum(5);
    _priceTF.layer.borderColor = kGlobalTextColorGray.CGColor;
    _priceTF.layer.borderWidth = kScaleNum(1);
    _priceTF.b_font(kFont(16))
    //.b_placeholder(@"输入支付金额")
    .b_keyboardType(UIKeyboardTypeNumbersAndPunctuation)
    .b_delegate(self).b_leftView(img1)
    .b_leftViewMode(UITextFieldViewModeAlways)
    .b_frame(LPRectMake(35, 75, 245, 45))
    .b_moveToView(self);
    [_priceTF addTarget:self action:@selector(editChange:) forControlEvents:UIControlEventEditingDidBegin | UIControlEventEditingDidEnd];
    [_priceTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView *img2 = [UIImageView new];
    img2.b_image([UIImage imageNamed:@"fens-g"])
    .b_contentMode(UIViewContentModeCenter)
    .b_tag(200)
    .b_frame(LPRectMake(0, 0, 30, 45));
    
    _interTF = [UITextField new];
    _interTF.layer.cornerRadius = kScaleNum(5);
    _interTF.layer.borderColor = kGlobalTextColorGray.CGColor;
    _interTF.layer.borderWidth = kScaleNum(1);
    _interTF.b_font(kFont(16))
    // .b_placeholder(@"输入积分金额")
    .b_keyboardType(UIKeyboardTypeNumberPad)
    .b_delegate(self).b_leftView(img2)
    .b_leftViewMode(UITextFieldViewModeAlways)
    .b_frame(LPRectMake(35, 125, 245, 45))
    .b_moveToView(self);
    [_interTF addTarget:self action:@selector(editChange:) forControlEvents:UIControlEventEditingDidBegin | UIControlEventEditingDidEnd];
    [_interTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *line1 = [UIView new];
    line1.b_bgColor(kLineColor)
    .b_frame(LPRectMake(0, 175, 315, 1))
    .b_moveToView(self);
    
    UIView *line2 = [UIView new];
    line2.b_bgColor(kLineColor)
    .b_frame(LPRectMake(156, 175, 1, 50))
    .b_moveToView(self);
    
    _cancleBtn = [UIButton new];
    _cancleBtn.b_title(@"取消",UIControlStateNormal)
    .b_font(kFont(15))
    .b_titleColor(kGlobalTextColorGray,UIControlStateNormal)
    .b_frame(LPRectMake(0, 175, 156, 50))
    .b_moveToView(self);
    [_cancleBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    _sureBtn = [UIButton new];
    _sureBtn.b_title(@"下一步",UIControlStateNormal)
    .b_font(kFont(15))
    .b_titleColor(kColor(230, 230, 230, 1),UIControlStateNormal)
    .b_frame(LPRectMake(157, 175, 156, 50))
    .b_moveToView(self);
    _sureBtn.enabled = NO;
    
    [_sureBtn addTarget:self action:@selector(surePayAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editChange:(UITextField *)textField
{
    UIImageView *img1 = [self viewWithTag:100];
    UIImageView *img2 = [self viewWithTag:200];
    
    if (!_priceTF.editing && !_interTF.editing)
    {
        if (!_priceTF.text.length)
        {
            img1.image = [UIImage imageNamed:@"cavels-g"];
            _priceTF.layer.borderColor = kGlobalTextColorGray.CGColor;
            _priceTF.placeholder = @"";
        }
        
        if (!_interTF.text.length)
        {
            img2.image = [UIImage imageNamed:@"fens-g"];
            _interTF.layer.borderColor = kGlobalTextColorGray.CGColor;
            _interTF.placeholder = @"";
        }
        
        return;
    }
    
    if ([textField isEqual:_priceTF])
    {
        img1.image = [UIImage imageNamed:@"cavel-G"];
        _priceTF.layer.borderColor = kGreenColor.CGColor;
        _priceTF.placeholder = @"输入支付金额";
        
        img2.image = [UIImage imageNamed:@"fens-g"];
        _interTF.layer.borderColor = kGlobalTextColorGray.CGColor;
        _interTF.text = @"";
        _interTF.placeholder = @"";
    }
    else
    {
        img1.image = [UIImage imageNamed:@"cavels-g"];
        _priceTF.layer.borderColor = kGlobalTextColorGray.CGColor;
        _priceTF.text = @"";
        _priceTF.placeholder = @"";
        
        img2.image = [UIImage imageNamed:@"fen-G"];
        _interTF.layer.borderColor = kGreenColor.CGColor;
        _interTF.placeholder = @"输入积分数额";
    }
}

- (void)valueChange:(UITextField *)textField
{
    if (textField.text.floatValue)
    {
        [_sureBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
        _sureBtn.enabled = YES;
    }
    else
    {
        [_sureBtn setTitleColor:kColor(230, 230, 230, 1) forState:UIControlStateNormal];
        _sureBtn.enabled = NO;
    }
}

#pragma mark - 确认下一步
- (void)surePayAction
{
    [_priceTF resignFirstResponder];
    [_interTF resignFirstResponder];
    
    if (_priceTF.text.length)
    {
        _payType = @"余额";
        _price = _priceTF.text.floatValue;
    }
    else
    {
        _payType = @"积分";
        _price = _interTF.text.floatValue;
    }
    
    if (_priceTF.text.floatValue > _model.rechargeAmount.floatValue)
    {
        [Prompt popPromptViewInScreenCenterWithMsg:@"账户余额不足！" duration:2.0f];
        return;
    }
    else if (_interTF.text.floatValue > _model.integral.floatValue)
    {
        [Prompt popPromptViewInScreenCenterWithMsg:@"账户积分余额不足！" duration:2.0f];
        return;
    }
    else if (!_model.mobile.length)
    {
        [Prompt popPromptViewWithMsg:@"该会员手机信息不完整，无法发送验证码！" duration:2.0f];
        return;
    }
    
    HMPhoneSecurityCodeView *phoneView = [HMPhoneSecurityCodeView viewWithPhoneNum:_model.mobile];
    [phoneView showWithAnimation];
    
    WEAKSELF
    phoneView.checkCodeSuccess = ^(void)
    {
        [weakSelf closeAction];
        weakSelf.SuccessBlock?weakSelf.SuccessBlock(weakSelf.price,weakSelf.payType):nil;
    };
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_priceTF])
    {
        return [HMPriceTFInput priceTextField:textField range:range string:string dian:isDian limit:2 isMinus:NO];
    }
    else
    {
        return [HMPriceTFInput priceTextField:textField range:range string:string dian:isDian limit:0 isMinus:NO];
    }
}

- (void)closeClick
{
    [self closeAction];
}

- (void)refreshView:(HMMemberPayModel *)model
{
    _model = model;
    
    NSString *phone = @"";
    if (model.mobile.length)
    {
        phone = [NSString stringWithFormat:@"/ %@",model.mobile];
    }
    
    _titleLab.text = [NSString stringWithFormat:@"%@ %@\r\n账户余额: ¥%.02f  积分余额: %@",model.name,phone,model.rechargeAmount.floatValue,model.integral];
    [_titleLab setLineSpace:5.0f];
}

@end
