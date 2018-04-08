//
//  HMActionSheetTickCell.m
//  HotelManager
//
//  Created by r on 17/3/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMActionSheetTickCell.h"

@interface HMActionSheetTickCell ()

@property (nonatomic, strong) UILabel *contentLab;//!<
@property (nonatomic, strong) UIImageView *tickIcon;//!<
@property (nonatomic, strong) UIView *line;

@end

@implementation HMActionSheetTickCell

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
        
        if ([content rangeOfString:@"（0）" options:NSBackwardsSearch].length > 0)
        {
            self.contentLab.textColor = [UIColor lightGrayColor];
        }
        else
        {
            self.contentLab.textColor = [UIColor blackColor];
        }
        
    } else if ([content isKindOfClass:[NSAttributedString class]]) {
        self.contentLab.textColor = [UIColor blackColor];
        self.contentLab.attributedText = content;
    }
    
    self.tickIcon.hidden = YES;
}

- (void)selected {
    
    self.contentLab.textColor = kGlobalTextColorBrown;
    self.tickIcon.hidden = NO;
}

#pragma mark - 搭建UI

- (void)initUI {
    
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.tickIcon];
    [self.contentView addSubview:self.line];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScaleNum(27)));
        make.centerY.equalTo(@0);
    }];
    
    [self.tickIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(kScaleNum(-20)));
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(LPSizeMake(18, 15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
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
        _tickIcon.image = [UIImage imageNamed:@"select_03"];
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
