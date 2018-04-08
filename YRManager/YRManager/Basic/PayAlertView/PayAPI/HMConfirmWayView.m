//
//  HMConfirmWayView.m
//  HotelManager
//
//  Created by YR on 2017/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMConfirmWayView.h"

@interface HMConfirmWayView ()

@property (nonatomic, strong) UILabel   *wayLab;
@property (nonatomic, strong) UITextField   *orderNumTF;

@end

@implementation HMConfirmWayView

- (instancetype)initWithFrame:(CGRect)frame withModel:(HMPayWayModel *)model
{
    if (self == [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initView:model];
    }
    return self;
}

- (void)initView:(HMPayWayModel *)model
{
    _wayLab = [UILabel new];
    _wayLab.b_font(kFont(17)).b_text(model.sklxMc)
    .b_frame(LPRectMake(90, 0, 240, 50)).b_moveToView(self);
    
    NSArray *arr = @[@"支付方式",@""];
    NSArray *imgArr = @[@"arrow_right_small",@""];
    if (![model.sklxMc isEqualToString:PayViewPaywayCash] &&
        ![model.sklxMc isEqualToString:PayViewPaywayCashRefund] &&
        ![model.sklxMc isEqualToString:PayViewPaywayWeChat] &&
        ![model.sklxMc isEqualToString:PayViewPaywayAlipay] &&
        ![model.sklxMc isEqualToString:PayViewPaywayMember])
    {
        
        arr = @[@"支付方式",@"支付单号"];
        _orderNumTF = [UITextField new];
        _orderNumTF.b_placeholder(@"输入支付单号").b_font(kFont(17))
        .b_frame(LPRectMake(90, 50, 240, 50)).b_moveToView(self);
        [_orderNumTF addTarget:self action:@selector(orderNumChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *line = [UIView new];
        line.b_bgColor(kColor(230, 230, 230, 1))
        .b_frame(LPRectMake(20, 50, 355, 1)).b_moveToView(self);
    }
    
    for (NSInteger i = 0; i < 2; i ++)
    {
        UILabel *lab = [UILabel new];
        lab.b_textColor(kColor(130, 130, 130, 1)).b_font(kFont(15))
        .b_textAlignment(NSTextAlignmentRight).b_text(arr[i])
        .b_frame(LPRectMake(0, 50*i, 80, 50)).b_moveToView(self);
        
        UIImageView *rightImg = [UIImageView new];
        rightImg.contentMode = UIViewContentModeCenter;
        rightImg.b_image([UIImage imageNamed:imgArr[i]])
        .b_frame(LPRectMake(330, 50*i, 45, 50)).b_moveToView(self);
    }
}

- (void)orderNumChange:(UITextField *)textField
{
    if (_OrderNumChange)
    {
        _OrderNumChange([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    }
}

@end
