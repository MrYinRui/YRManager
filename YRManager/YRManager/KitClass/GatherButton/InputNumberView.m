//
//  InputNumberView.m
//  HotelManager-Pad
//
//  Created by kqz on 17/2/16.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import "InputNumberView.h"
//#define kScreenScale    (kScreenWidth / kBaseScreenWidth) //屏幕缩放比例
//#define kColor(R, G, B, A) [UIColor colorWithRed:(R)/255.f green:(G)/255.f blue:(B)/255.f alpha:(A)]

@interface InputNumberView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *numberTf;//!<默认值是1

@end

@implementation InputNumberView

+(instancetype)inputNumberWithFrame:(CGRect)frame
{
    InputNumberView *view = [[InputNumberView alloc] initWithFrame:frame];
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    view.maxNumber = 99;
    view.minNumber = 0;
    view.setNumber = 0;
    
    UIButton * minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.backgroundColor = kColor(222, 223, 227, 1);
    minusBtn.frame = CGRectMake(0, 0, width * 0.3, height);
    [minusBtn addTarget:view action:@selector(clickedMinusBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:minusBtn];
    
    UITextField *numberTf = [[UITextField alloc] initWithFrame:CGRectMake(width * 0.3, 0, width * 0.4, height)];
    numberTf.text = @(view.setNumber).stringValue;
    numberTf.textAlignment = NSTextAlignmentCenter;
    numberTf.font =  [UIFont systemFontOfSize:18 * kScreenScale];
    numberTf.backgroundColor = [UIColor whiteColor];
    numberTf.textColor = [UIColor blackColor];
    numberTf.layer.borderColor = kColor(237, 238, 240, 1).CGColor;
    numberTf.layer.borderWidth = 1 * kScreenScale;
    numberTf.delegate = view;
    numberTf.keyboardType = UIKeyboardTypeNumberPad;
    view.numberTf = numberTf;
    
    [view addSubview:numberTf];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = kColor(222, 223, 227, 1);
    addBtn.frame = CGRectMake(width * 0.7, 0, width * 0.3, height);
    [addBtn addTarget:view action:@selector(clickedAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    
    CGRect lineArr[3] = {CGRectMake(width * 0.1, height * 0.5 - 1, width * 0.1, 2),CGRectMake(width * 0.8, height * 0.5 - 1, width * 0.1, 2),CGRectMake(width * 0.85 - 1, (height - width * 0.1) * 0.5, 2, width * 0.1)};
    
    for (int i = 0; i < 3; i++)
    {
        UIView *line = [[UIView alloc] initWithFrame:lineArr[i]];
        line.backgroundColor = [UIColor whiteColor];
        line.userInteractionEnabled = NO;
        [view addSubview:line];
    }
    
    return view;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""])  {
        textField.text = @(self.minNumber).stringValue;
        if (self.changeNumberBlock) {
            self.changeNumberBlock(textField.text.integerValue);
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![self validateNumber:string]) {// 不能输入非数字
        return NO;
    }
    
    if ([string isEqualToString:@""]) {// 删除
        NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        newStr = [newStr isEqualToString:@""] ? @"0" : newStr;
        if (newStr.integerValue < self.minNumber) {
            if (self.underMinNumberBlock) {
                self.underMinNumberBlock();
            } else {
                [Prompt popPromptViewInScreenCenterWithMsg:[NSString stringWithFormat:@"不能低于%zd", self.minNumber] duration:3.f];
            }
            return NO;
        } else {
            if (self.changeNumberBlock) {
                self.changeNumberBlock(newStr.integerValue);
            }
            return YES;
        }
        
    } else {
        NSString *newStr = [textField.text stringByAppendingString:string];
        if (newStr.integerValue > self.maxNumber) {
            if (self.overMaxNumberBlock) {
                self.overMaxNumberBlock();
            } else {
                [Prompt popPromptViewInScreenCenterWithMsg:[NSString stringWithFormat:@"不能超过%zd", self.maxNumber] duration:3.f];
            }
            return NO;
        } else {
            if (self.changeNumberBlock) {
                self.changeNumberBlock(newStr.integerValue);
            }
            return YES;
        }
    }
    
    
    //不允许输入空格
//    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
//    if (![string isEqualToString:tem])
//    {
//        return NO;
//    }
//
//
//
//    NSString *newStr =[textField.text stringByAppendingString:string];
//
//    if (newStr.length == textField.text.length)
//    {
//        return YES;
//    }
//
//    if ([textField.text isEqualToString:@"0"] && newStr.length > 1)
//    {
//        return NO;
//    }
//
//    if ([self isPureInteger:string])
//    {
//        if (newStr.integerValue > self.maxNumber)
//        {
//            textField.text = @(self.maxNumber).stringValue;
//            [textField endEditing:YES];
////            [Prompt popPromptViewWithMsg:@"输入的数超过了最大值😜~~~" duration:3.f];
//            if (self.overMaxNumberBlock) {
//                self.overMaxNumberBlock();
//            }
//            !_changeNumberBlock ?: _changeNumberBlock(@(self.maxNumber).stringValue);
//            return NO;
//        }
//        else if (newStr.integerValue < self.minNumber)
//        {
//            textField.text = @(self.minNumber).stringValue;
//            [textField endEditing:YES];
////            [Prompt popPromptViewWithMsg:@"输入的数小于最小值😒~~~" duration:3.f];
//            return NO;
//        }
//        !_changeNumberBlock ?: _changeNumberBlock(newStr.integerValue);
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    
//    return NO;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


#pragma mark - event
- (void)clickedMinusBtn:(UIButton *)sender
{
    [_numberTf endEditing:YES];
    NSInteger count = _numberTf.text.intValue;
    
    if (count > self.maxNumber)
    {
        _numberTf.text = @(self.maxNumber).stringValue;
    }
    else if (count > self.minNumber && count <= self.maxNumber)
    {
        _numberTf.text = @(count - 1).stringValue;
    }
    else
    {
        if (self.underMinNumberBlock) {
            self.underMinNumberBlock();
        } else {
            [Prompt popPromptViewInScreenCenterWithMsg:[NSString stringWithFormat:@"不能低于%zd", self.minNumber] duration:3.f];
        }
//        [Prompt popPromptViewWithMsg:@"不能再少了😒~~~" duration:3.f];
    }
    !_changeNumberBlock ?: _changeNumberBlock(_numberTf.text.integerValue);
}

- (void)clickedAddBtn:(UIButton *)sender
{
    [_numberTf endEditing:YES];
    NSInteger count = _numberTf.text.intValue;
    
    if (count < self.maxNumber)
    {
        _numberTf.text = @(count + 1).stringValue;
    }
    else
    {
        if (self.overMaxNumberBlock) {
            self.overMaxNumberBlock();
        } else {
            [Prompt popPromptViewInScreenCenterWithMsg:[NSString stringWithFormat:@"不能超过%zd", self.maxNumber] duration:3.f];
        }
//        [Prompt popPromptViewWithMsg:@"不能再多了😜~~~" duration:3.f];
    }
    !_changeNumberBlock ?: _changeNumberBlock(_numberTf.text.integerValue);
}

#pragma mark - other
//判断字符串能否转成Double类型
- (BOOL)isPureInteger:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    NSInteger val;
    return[scan scanInteger:&val] && [scan isAtEnd];
}

//设置UITextField的值
-(void)setSetNumber:(NSInteger)setNumber
{
    _setNumber = setNumber;
    _numberTf.text = @(setNumber).stringValue;
}

-(void)setIsEnabled:(BOOL)isEnabled
{
    _isEnabled = isEnabled;
    _numberTf.userInteractionEnabled = isEnabled;
}


@end
