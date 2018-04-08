//
//  HMMemberPayCell.m
//  HotelManager
//
//  Created by YR on 2017/8/1.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMMemberPayCell.h"
#import "NSString+URL.h"

@interface HMMemberPayCell ()

@property (nonatomic, strong) UIImageView   *headerImg;
@property (nonatomic, strong) UIImageView   *vipCore;
@property (nonatomic, strong) UIImageView   *isVIP;
@property (nonatomic, strong) UILabel       *nameLab;
@property (nonatomic, strong) UILabel       *phoneLab;
@property (nonatomic, strong) UILabel       *numLab;
@property (nonatomic, strong) UIImageView   *rightImg;

@end

@implementation HMMemberPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    _headerImg = [UIImageView new];
    _headerImg.layer.masksToBounds = YES;
    _headerImg.layer.cornerRadius = kScaleNum(25);
    _headerImg.b_frame(LPRectMake(20, 10, 50, 50))
    .b_moveToView(self);
    
    _vipCore = [UIImageView new];
    _vipCore.layer.masksToBounds = YES;
    _vipCore.layer.borderWidth = kScaleNum(0.5);
    _vipCore.layer.borderColor = kGreenColor.CGColor;
    _vipCore.layer.cornerRadius = kScaleNum(30);
    _vipCore.b_bgColor([UIColor clearColor])
    .b_frame(LPRectMake(15, 5, 60, 60))
    .b_moveToView(self);
    
    _isVIP = [UIImageView new];
    _isVIP.b_image([UIImage imageNamed:@"members-w-Gb"])
    .b_frame(LPRectMake(60, 5, 15, 15))
    .b_moveToView(self);
    
    _nameLab = [UILabel new];
    _nameLab.b_font(kFont(14))
    .b_lineBreakMode(NSLineBreakByTruncatingMiddle)
    .b_textColor(kColor(130, 130, 130, 1))
    .b_frame(LPRectMake(80, 15, 250, 15))
    .b_moveToView(self);
    
    _phoneLab = [UILabel new];
    _phoneLab.b_font(kFont(12))
    .b_textColor(kColor(130, 130, 130, 1))
    .b_frame(LPRectMake(80, 35, 180, 10))
    .b_moveToView(self);
    
    _numLab = [UILabel new];
    _numLab.b_font(kFont(12))
    .b_textColor(kGreenColor)
    .b_frame(LPRectMake(80, 50, 250, 10))
    .b_moveToView(self);
    
    _rightImg = [UIImageView new];
    _rightImg.b_image([UIImage imageNamed:@"arrow_right"])
    .b_contentMode(UIViewContentModeCenter)
    .b_frame(LPRectMake(330, 0, 45, 70))
    .b_moveToView(self);
    
    UIView *line = [UIView new];
    line.b_bgColor(kLineColor)
    .b_frame(LPRectMake(80, 69, 295, 1))
    .b_moveToView(self);
}

- (void)refreshCell:(HMMemberPayModel *)model
{
    [_headerImg sd_setImageWithURL:[NSString picURLWithString:model.idcardImg type:ImgSize_Default] placeholderImage:[UIImage imageNamed:@"user_header"]];
    
    NSString *phone = @"";
    if (model.mobile.length)
    {
        phone = [NSString stringWithFormat:@"/ %@",model.mobile];
    }
    _nameLab.text = [NSString stringWithFormat:@"%@ %@",model.name,phone];
    
    _phoneLab.text = model.levelName;
    
    _numLab.text = [NSString stringWithFormat:@"账户余额: ¥%.02f  积分余额: %@",model.rechargeAmount.floatValue,model.integral];
}

@end
