//
//  HMTextFieldInputView.m
//  HotelManager
//
//  Created by r on 2018/1/18.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMTextFieldInputView.h"

@interface HMTextFieldInputView () <UITextFieldDelegate>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation HMTextFieldInputView

+ (instancetype)viewWithTitle:(NSString *)title {
    
    HMTextFieldInputView *view = [HMTextFieldInputView viewWithFrame:kDefaultFrame];
    
    view.title = title;
    view.maxLength = 50;
    [view initUI];
    
    return view;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= self.maxLength && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

#pragma mark - Event Response

// 点击验证按钮
- (void)clickedConfirmBtn {
    
//    if (self.textField.text && self.textField.text.length) {
//        if (self.writeSuccessBlock) {
//            self.writeSuccessBlock(self.textField.text);
//        }
//        [self removeFromSuperview];
//
//    } else {
//        [self popPromptViewWithMsg:@"内容不能为空"];
//    }
    
    if (self.writeSuccessBlock) {
        self.writeSuccessBlock(self.textField.text);
    }
    [self removeFromSuperview];
}

#pragma mark - Private Methods

- (void)popPromptViewWithMsg:(NSString *)msg{
    [Prompt popPromptViewWithMsg:msg duration:3.f center:CGPointMake(kScreenWidth / 2, 250)];
}

#pragma mark - 搭建UI

- (void)initUI {
    
    [self addSubview:self.titleLab];
    [self addSubview:self.textField];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kScaleNum(43)));
        make.left.equalTo(self.textField);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kScaleNum(70)));
        make.centerX.equalTo(@0);
        make.size.mas_equalTo(LPSizeMake(250, 50));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.height.mas_equalTo(kScaleNum(50));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(@0);
        make.width.height.equalTo(self.cancelBtn);
        make.left.equalTo(self.cancelBtn.mas_right);
    }];
    
    UIView *horiLine = [[UIView alloc] init];
    horiLine.backgroundColor = kSeparatorLineColor;
    [self addSubview:horiLine];
    [horiLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.cancelBtn);
    }];
    
    UIView *vertiLine = [[UIView alloc] init];
    vertiLine.backgroundColor = kSeparatorLineColor;
    [self addSubview:vertiLine];
    [vertiLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.width.mas_equalTo(1);
        make.top.left.equalTo(self.confirmBtn);
    }];
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLab.text = title;
    self.textField.placeholder = [NSString stringWithFormat:@"输入%@", title];
}

#pragma mark - Getters

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = kFont(13);
    }
    return _titleLab;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.layer.borderWidth = 1.0;
        _textField.layer.borderColor = kShitYellow.CGColor;
        _textField.font = kFont(18);
        _textField.delegate = self;
        
        UIView *leftView = [[UIView alloc] initWithFrame:LPRectMake(0, 0, 10, 50)];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:kGlobalTextColorGray forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFont(18);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = kFont(18);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end

