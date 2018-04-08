//
//  HMChangeRoomPriceView.m
//  HotelManager-Pad
//
//  Created by kqz on 17/1/17.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import "HMChangeRoomPriceView.h"
#import "LPTextField.h"
#import "HMPriceTFInput.h"

@interface HMChangeRoomPriceView()<UITextFieldDelegate>

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) UITextField *priceTf;
@property (nonatomic, strong) UILabel *warnLab;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *leftLab;

@end

@implementation HMChangeRoomPriceView
{
    BOOL    isHaveDian;
}

+(instancetype)viewWithTitle:(NSString *)title AndPrice:(NSString *)price
{
    HMChangeRoomPriceView *view = [HMChangeRoomPriceView viewWithFrame:LPRectMake(31, 115, 315, 225)];
    view.price = price;
    view.limit = 2;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:LPRectMake(30, 37, 250, 18)];
    titleLab.text = title;
    titleLab.textColor = kGrayColor;
    titleLab.font = kFont(16);
    [view addSubview:titleLab];
    
    UITextField *priceTf = [[UITextField alloc] initWithFrame:LPRectMake(30, 67, 250, 50)];
    priceTf.text = price;
    priceTf.layer.borderWidth = 1.0 * kScreenScale;
    priceTf.layer.borderColor = kSeparatorLineColor.CGColor;
    priceTf.font = kFont(20);
    priceTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    priceTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    priceTf.textColor = kGreenColor;
    priceTf.backgroundColor = kColor(247, 248, 249, 1);
    priceTf.tintColor = kGreenColor;
    [priceTf addTarget:view action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
    priceTf.delegate = view;
    [priceTf becomeFirstResponder];
    view.priceTf = priceTf;
    [view addSubview:priceTf];
    
    UIView *labView = [[UILabel alloc] initWithFrame:LPRectMake(0, 0, 25, 50)];
    labView.backgroundColor = [UIColor clearColor];
    UILabel *leftLab = [[UILabel alloc] initWithFrame:LPRectMake(0, 12, 25, 25)];
    view.leftLab = leftLab;
    leftLab.text = @"￥";
    leftLab.font = kFont(16);
    leftLab.textColor = kGreenColor;
    leftLab.textAlignment = NSTextAlignmentRight;
    [labView addSubview:leftLab];
    priceTf.leftView = labView;
    priceTf.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = LPRectMake(0, 0, 50, 60);
    [closeBtn setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:view action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.adjustsImageWhenHighlighted = NO;
    priceTf.rightView = closeBtn;
    view.closeBtn = closeBtn;
    priceTf.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *warnLab = [[UILabel alloc] initWithFrame:LPRectMake(100, 100, 200, 30)];
    warnLab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    warnLab.text = @"请输入有效数字";
    warnLab.textAlignment = NSTextAlignmentCenter;
    warnLab.textColor = [UIColor whiteColor];
    warnLab.font = kFont(18);
    warnLab.alpha = 0;
    view.warnLab = warnLab;
    [view addSubview:warnLab];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:kGlobalTextColorGray forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kFont(18);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.frame = LPRectMake(0, 175, 157, 50);
    [view addSubview:cancelBtn];
    [cancelBtn addTarget:view action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    view.leftBtn = cancelBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFont(18);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.frame = LPRectMake(158, 175, 157, 50);
    [view addSubview:rightBtn];
    [rightBtn addTarget:view action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *horiLine = [[UIView alloc] init];
    horiLine.backgroundColor = kSeparatorLineColor;
    horiLine.frame = LPRectMake(0, 175, 315, 1);
    [view addSubview:horiLine];
    
    UIView *vertiLine = [[UIView alloc] init];
    vertiLine.backgroundColor = kSeparatorLineColor;
    vertiLine.frame = LPRectMake(157, 175, 1, 50);
    [view addSubview:vertiLine];
    
    return view;
}

#pragma mark -setData
-(void)setStyleColor:(UIColor *)styleColor
{
    _styleColor = styleColor;
    self.priceTf.textColor = styleColor;
    self.priceTf.layer.borderColor = styleColor.CGColor;
    self.priceTf.tintColor = styleColor;
    self.leftLab.textColor = styleColor;
}

-(void)setTip:(NSString *)tip
{
    _tip = tip;
    self.priceTf.placeholder = tip;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
    //判断是否允许输入负数
    if (_onlyNSInteger != YES && textField.text.length == 0 && [string isEqualToString:@"-"])
    {
        return YES;
    }
    
    //不允许输入空格
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem])
    {
        return NO;
    }
    
    NSString *newStr =[textField.text stringByAppendingString:string];

    if ([textField.text isEqualToString:@"0"] || [textField.text isEqualToString:@"-0"])
    {
        if ([self isPureDouble:string])
        {
            return NO;
        }
    }
    
    return [self isPureDouble:newStr];
     */
    
    return [HMPriceTFInput priceTextField:textField range:range string:string dian:isHaveDian limit:self.limit isMinus:!_onlyPositive];
}

#pragma mark -click
-(void)clickLeftBtn:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"取消"])
    {
        [self removeFromSuperview];
    }
    else
    {
        _priceTf.text = _price;
        [sender setTitle:@"取消" forState:UIControlStateNormal];
    }
}

-(void)clickRightBtn:(UIButton *)sender
{
    if ([self isPureDouble:_priceTf.text])
    {
        !_submitBlock ?: _submitBlock([_priceTf.text doubleValue]);
        [self removeFromSuperview];
    }
    else
    {
        _warnLab.alpha = 1;
        [UIView animateWithDuration:1.5 animations:^{
            
            _warnLab.alpha = 0;
        }];
    }
}

-(void)clickCloseBtn:(UIButton *)sender
{
    _priceTf.text = @"";
    sender.hidden = YES;
}

#pragma mark - UITextField
-(void)changeTextField:(UITextField *)sender
{
    if (_priceTf.hasText)
    {
        self.closeBtn.hidden = NO;
    }
    else
    {
        self.closeBtn.hidden = YES;
    }
    
    if([_priceTf.text doubleValue] != [_price doubleValue] && _isRestorePrice == YES)
    {
        [_leftBtn setTitle:@"还原金额" forState:UIControlStateNormal];
    }
    else
    {
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
}

#pragma mark - other
//判断字符串能否转成Double类型
- (BOOL)isPureDouble:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    double val;
    return[scan scanDouble:&val] && [scan isAtEnd];
}

@end
