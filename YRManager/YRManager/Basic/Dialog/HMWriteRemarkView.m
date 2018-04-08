//
//  HMWriteRemarkView.m
//  HotelManager-Pad
//
//  Created by Seven on 2016/12/22.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import "HMWriteRemarkView.h"
#import "UITextView+Placeholder.h"

@interface HMWriteRemarkView()<UITextViewDelegate>
@property (nonatomic, copy)    NSString *mark;//!< 备注
@property (nonatomic, strong)  UITextView *textVeiw;//!< <#注释#>
@property (nonatomic, strong)  NSDictionary<NSString *,id> *attributes;//!< <#注释#>
@end

@implementation HMWriteRemarkView

+ (instancetype)remarkView {
    HMWriteRemarkView *view = [HMWriteRemarkView viewWithFrame:kInputFrame];
    return view;
}

#pragma mark ---- UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (_noEditing) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.mark = textView.text;
}


+ (instancetype)viewWithFrame:(CGRect)frame
{
    HMWriteRemarkView *markDialog = [super viewWithFrame:frame];
    [markDialog initUI];
    return markDialog;
}



- (void)initUI
{
    for (CALayer *layer in self.layer.sublayers)
    {
        if (layer.frame.size.height < 3)
        {
            [layer setHidden:YES];
        }
    }
    
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:LPRectMake(30, 20, 100, 40)];
//    titleLab.text = @"备注";
//    titleLab.textColor = kGlobalTextColorGray;
//    titleLab.font = kFont(24);
//    titleLab.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:titleLab];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:
                            LPRectMake(30, 34, 250, 120)];
    textView.backgroundColor = kColor(248, 248, 248, 1.0);
    textView.layer.borderColor = kColor(223, 222, 227, 1.0).CGColor;
    textView.layer.borderWidth = 1.0;
    textView.font = kFont(18);
    textView.delegate = self;
    
    [self addSubview:textView];
    [textView  becomeFirstResponder];
    
    self.textVeiw = textView;

    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 15 * kScreenScale;
    
    NSDictionary<NSString *,id> *attributes = @{NSFontAttributeName : kFont(18),NSParagraphStyleAttributeName : paragraphStyle};
    self.attributes = attributes;
    textView.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"输入备注内容" attributes:attributes];
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    textView.typingAttributes = attributes;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kGlobalTextColorGray forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kFont(18);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.height.mas_equalTo(kScaleNum(50));
    }];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
    okBtn.titleLabel.font = kFont(18);
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(@0);
        make.height.width.equalTo(cancelBtn);
        make.left.equalTo(cancelBtn.mas_right);
    }];
    
    UIView *horiLine = [[UIView alloc] init];
    horiLine.backgroundColor = kSeparatorLineColor;
    [self addSubview:horiLine];
    [horiLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(okBtn);
        make.height.mas_equalTo(kScaleNum(1));
    }];
    
    UIView *vertiLine = [[UIView alloc] init];
    vertiLine.backgroundColor = kSeparatorLineColor;
    [self addSubview:vertiLine];
    [vertiLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horiLine);
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.mas_equalTo(kScaleNum(1));
    }];
}

#pragma mark --- setter
-(void)setComments:(NSString *)comments
{
    _comments = [comments copy];
    
    if (_comments && _comments.length)
    {
        self.textVeiw.attributedText = [[NSAttributedString alloc] initWithString:_comments attributes:self.attributes];
    }
    
    self.mark = _comments;
}

#pragma mark ---- UI  Events
- (void)cancelBtnClick
{
    [self removeFromSuperview];
}

- (void)okBtnClick
{
    [self endEditing:YES];
    
    if (_confirmMarkBlock)
    {
        _confirmMarkBlock(self.mark);
    }
    
    [self removeFromSuperview];
}


@end
