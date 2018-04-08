//
//  HMPayWayCell.m
//  HotelManager
//
//  Created by YR on 2017/3/29.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPayWayCell.h"

@interface HMPayWayCell ()

@property (nonatomic, strong) HMPayWayModel *model;

@property (nonatomic, strong) HMTallyBookPayway *payway;

@end

@implementation HMPayWayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    _wayBtn = [UIButton new];
    _wayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _wayBtn.userInteractionEnabled = NO;
    _wayBtn.b_titleColor([UIColor blackColor],UIControlStateNormal)
    .b_titleColor(kColor(133, 134, 135, 1),UIControlStateDisabled)
    .b_titleColor(kYellowColor,UIControlStateSelected).b_font(kFont(16))
    .b_image([UIImage imageNamed:@"check_02"],UIControlStateNormal)
    .b_image([UIImage imageNamed:@"check_01"],UIControlStateSelected)
    .b_image([UIImage imageNamed:@"check_03"],UIControlStateDisabled)
    .b_imageEdgeInsets(UIEdgeInsetsMake(0, kScaleNum(290), 0, 0))
    .b_titleEdgeInsets(UIEdgeInsetsMake(0, kScaleNum(-25), 0, kScaleNum(32.0)))
    .b_frame(LPRectMake(25, 0, 325, 50)).b_moveToView(self);
    
    UIView *line = [UIView new];
    line.b_bgColor(kColor(230, 230, 230, 1))
    .b_frame(LPRectMake(25, 49, 325, 1))
    .b_moveToView(self);
}

- (void)refreshCell:(NSString *)name
{
    [_wayBtn setTitle:name forState:UIControlStateNormal];
}

- (void)setBtnSelected:(BOOL)state
{
    _wayBtn.selected = state;
}

- (void)setBtnEnble:(BOOL)state
{
    _wayBtn.enabled = state;
}

- (void)refreshCellWithModel:(HMPayWayModel *)model {
     _model = model;
    [_wayBtn setTitle:model.sklxMc forState:UIControlStateNormal];
    
    if (model.hm_selected) {
        [_wayBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        [_wayBtn setImage:[UIImage imageNamed:@"check_01"] forState:UIControlStateNormal];
    }else {
        [_wayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wayBtn setImage:[UIImage imageNamed:@"check_02"] forState:UIControlStateNormal];
    }
}

- (void)refreshCellWithTallyBookPayway:(HMTallyBookPayway *)model {
    _payway = model;
    [_wayBtn setTitle:model.sklxMc forState:UIControlStateNormal];
    
    if (model.hm_selected) {
        [_wayBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        [_wayBtn setImage:[UIImage imageNamed:@"check_01"] forState:UIControlStateNormal];
    }else {
        [_wayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wayBtn setImage:[UIImage imageNamed:@"check_02"] forState:UIControlStateNormal];
    }
}

- (void)refreshCellWithFilter:(HMTallyBookFilter *)filter {
    [_wayBtn setTitle:filter.itemName forState:UIControlStateNormal];
    
    if (filter.hm_selected) {
        [_wayBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        [_wayBtn setImage:[UIImage imageNamed:@"check_01"] forState:UIControlStateNormal];
    }else {
        [_wayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wayBtn setImage:[UIImage imageNamed:@"check_02"] forState:UIControlStateNormal];
    }
}



@end
