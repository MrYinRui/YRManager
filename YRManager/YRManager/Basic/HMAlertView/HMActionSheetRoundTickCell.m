//
//  HMActionSheetRoundTickCell.m
//  HotelManager
//
//  Created by r on 17/3/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMActionSheetRoundTickCell.h"

@interface HMActionSheetRoundTickCell ()

@property (nonatomic, strong) UILabel *contentLab;//!<
@property (nonatomic, strong) UIImageView *tickIcon;//!<
@property (nonatomic, strong) UIView *line;

@end

@implementation HMActionSheetRoundTickCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

#pragma mark - Public Methods

- (void)refreshCellWithContent:(id)content {
    
    if ([content isKindOfClass:[NSString class]]) {
        self.contentLab.text = content;
        self.contentLab.textColor = [UIColor blackColor];
        
    } else if ([content isKindOfClass:[NSAttributedString class]]) {
        self.contentLab.attributedText = content;
    }
    
    self.tickIcon.image = [UIImage imageNamed:@"check_02"];
}

- (void)selected {
    
    self.contentLab.textColor = kGlobalTextColorBrown;
    self.tickIcon.image = [UIImage imageNamed:@"check_01"];
}

#pragma mark - 搭建UI

- (void)initUI {
    
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.tickIcon];
    [self.contentView addSubview:self.line];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScaleNum(25)));
        make.centerY.equalTo(@0);
    }];
    
    [self.tickIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(kScaleNum(-14)));
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(LPSizeMake(28, 28));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScaleNum(25)));
        make.bottom.right.equalTo(@0);
        make.height.mas_equalTo(1.0);
    }];
}

#pragma mark - Getters

- (UILabel *)contentLab{
    if (!_contentLab){
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.font = kFont(16);
    }
    return _contentLab;
}

- (UIImageView *)tickIcon{
    if (!_tickIcon){
        _tickIcon = [[UIImageView alloc] init];
        _tickIcon.image = [UIImage imageNamed:@"check_02"];
    }
    return _tickIcon;
}

- (UIView *)line{
    if (!_line){
        _line = [[UIView alloc] init];
        _line.backgroundColor = kSeparatorLineColor;
    }
    return _line;
}

@end
