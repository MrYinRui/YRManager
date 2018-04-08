//
//  HMPayInfoCell.m
//  HotelManager
//
//  Created by YR on 2017/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPayInfoCell.h"
#import "UILabel+NSMutableAttributedString.h"
#import "HMActualPayAlert.h"

@interface HMPayInfoCell ()

@property (nonatomic, strong) UILabel   *roomLab;
@property (nonatomic, strong) UILabel   *shouldLab;
@property (nonatomic, strong) UILabel   *hadLab;

@property (nonatomic, strong) UILabel   *shouldLeftLab;
@property (nonatomic, strong) UILabel   *hadLeftLab;

@property (nonatomic, strong) HMPayInfoModel    *model;
@property (nonatomic, strong) HMPayWayModel     *payWay;
@property (nonatomic, strong) UIButton *payBtn;

@end

@implementation HMPayInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = kColor(200, 200, 200, 1);
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    UIView *bgView = [UIView new];
    bgView.b_bgColor([UIColor whiteColor])
    .b_moveToView(self).b_frame(LPRectMake(0, 0, 375, 150));
    
    UIView *labBgView = [UIView new];
    labBgView.b_bgColor(kColor(248, 248, 248, 1))
    .b_frame(LPRectMake(0, 0, 375, 50)).b_moveToView(bgView);
    
    _roomLab = [UILabel new];
    _roomLab.b_font(kFont(14)).b_textColor(kColor(130, 130, 130, 1))
    .b_frame(LPRectMake(20, 0, 355, 50)).b_moveToView(labBgView);
    
    UIView *line = [UIView new];
    line.b_bgColor(kColor(230, 230, 230, 1))
    .b_frame(LPRectMake(20, 100, 355, 1)).b_moveToView(self);
    
    _shouldLeftLab = [UILabel new];
    _shouldLeftLab.b_text(@"应付款").b_textColor(kColor(130, 130, 130, 1))
    .b_font(kFont(15)).b_textAlignment(NSTextAlignmentRight)
    .b_frame(LPRectMake(0, 50, 70, 50)).b_moveToView(self);
    
    _hadLeftLab = [UILabel new];
    _hadLeftLab.b_text(@"实付款").b_textColor(kColor(130, 130, 130, 1))
    .b_font(kFont(15)).b_textAlignment(NSTextAlignmentRight)
    .b_frame(LPRectMake(0, 100, 70, 50)).b_moveToView(self);
    
    _shouldLab = [UILabel new];
    _shouldLab.b_font(kFont(18)).b_textAlignment(NSTextAlignmentRight)
    .b_textColor(kColor(130, 130, 130, 1))
    .b_frame(LPRectMake(100, 50, 230, 50)).b_moveToView(self);
    
    _hadLab = [UILabel new];
    _hadLab.b_font(kFont(18)).b_textAlignment(NSTextAlignmentRight)
    .b_textColor(kGreenColor)
    .b_frame(LPRectMake(100, 100, 230, 50)).b_moveToView(self);
    
    UIButton *payBtn = [UIButton new];
    payBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    payBtn.b_image([UIImage imageNamed:@"arrow_right_small"],UIControlStateNormal)
    .b_frame(LPRectMake(0, 100, 355, 50)).b_moveToView(self);
    [payBtn addTarget:self action:@selector(changePayMoney) forControlEvents:UIControlEventTouchUpInside];
    _payBtn = payBtn;
}

- (void)changePayMoney
{
    NSString *price = [_hadLab.text stringByReplacingOccurrencesOfString:@"¥ " withString:@""];
    HMActualPayAlert *alert = [[HMActualPayAlert alloc] initWithPayInfo:_model money:price.floatValue andPayWay:_payWay.sklxMc];
    [alert showOnView:self.window];
    
    WEAKSELF
    alert.SureChangePayBlock = ^(NSString *price)
    {
        weakSelf.hadLab.text = [NSString stringWithFormat:@"¥ %.02f",price.floatValue];
        [weakSelf.hadLab setAttributedStringWithSubString:@"¥" font:kFont(14)];
        if (_ChangeShouldPayBlock)
        {
            _ChangeShouldPayBlock(price);
        }
    };
}

- (void)refreshCell:(HMPayInfoModel *)model withPayWay:(HMPayWayModel *)payWay payType:(PayType)type
{
    _model = model;
    _payWay = payWay;
    
    if ([model.orderType isEqualToString:@"1"] && type != 4)
    {
        NSArray *arr = [model.rzrq componentsSeparatedByString:@"-"];
        if (arr.count == 3)
        {
            _roomLab.text = [NSString stringWithFormat:@"%@房 %@%@楼  %@月%@日  %@小时",model.fh,model.hymc,model.louceng,arr[1],arr[2],model.rzts];
        }
    }
    else if (model.tfrq.length == 0)//没有退房日期
    {
           if (model.fh.length > 0)
           {
               _roomLab.text = [NSString stringWithFormat:@"%@房 %@%@楼",model.fh,model.hymc,model.louceng];
           }
           else
           {
               _roomLab.text = @"外来客";
           }
    }
    else
    {
        _roomLab.text = [NSString stringWithFormat:@"%@房 %@%@楼  %@至%@ %@晚",model.fh,model.hymc,model.louceng,model.rzrq,model.tfrq,model.rzts];
    }
    
    if ([payWay.sklxMc isEqualToString:PayViewPaywayCashRefund])
    {
        _shouldLeftLab.text = @"应返款";
        _hadLeftLab.text = @"实返款";
        
        if (model.yk.floatValue < 0)
        {
            _shouldLab.font = kFont(12);
            _shouldLab.text = [NSString stringWithFormat:@"(应付款 ¥ %.02f)",fabs(model.yk.floatValue)];
            [_shouldLab setAttributedStringWithSubString:@"¥" font:kFont(14)];
            _hadLab.text = [NSString stringWithFormat:@"¥ 0.00"];
            [_hadLab setAttributedStringWithSubString:@"¥" font:kFont(14)];
        }
        else if (model.yk.floatValue >= 0)
        {
            _shouldLab.font = kFont(18);
            _shouldLab.text = [NSString stringWithFormat:@"¥ %.02f",fabs(model.yk.floatValue)];
            [_shouldLab setAttributedStringWithSubString:@"¥" font:kFont(14)];
            _hadLab.text = [NSString stringWithFormat:@"¥ %.02f",fabs(model.yk.floatValue)];
            [_hadLab setAttributedStringWithSubString:@"¥" font:kFont(14)];
        }
    }
    else
    {
        _shouldLeftLab.text = @"应付款";
        _hadLeftLab.text = @"实付款";
    
        //model.tfrq 针对外来客做处理
        if (model.yk.floatValue < 0 || model.tfrq.length == 0)
        {
            _shouldLab.font = kFont(18);
            _shouldLab.text = [NSString stringWithFormat:@"¥ %.02f",fabs(model.yk.floatValue)];
            [_shouldLab setAttributedStringWithSubString:@"¥" font:kFont(14)];
            _hadLab.text = [NSString stringWithFormat:@"¥ %.02f",fabs(model.yk.floatValue)];
            [_hadLab setAttributedStringWithSubString:@"¥" font:kFont(14)];
        }
        else if (model.yk.floatValue >= 0)
        {
            _shouldLab.font = kFont(12);
            _shouldLab.text = [NSString stringWithFormat:@"(订单余额 ¥ %.02f)",fabs(model.yk.floatValue)];
            _hadLab.text = [NSString stringWithFormat:@"¥ 0.00"];
            [_hadLab setAttributedStringWithSubString:@"¥" font:kFont(14)];
        }
    }
    
    if (self.banPrice == YES)
    {
        _payBtn.hidden = YES;
    }
    else
    {
        _payBtn.hidden = NO;
    }
}

@end
