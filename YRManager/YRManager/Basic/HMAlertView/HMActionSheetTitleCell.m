//
//  HMActionSheetTitleCell.m
//  HotelManager
//
//  Created by r on 17/3/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMActionSheetTitleCell.h"

@interface HMActionSheetTitleCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *line;

@end

@implementation HMActionSheetTitleCell

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
        self.titleLab.text = content;
    } else if ([content isKindOfClass:[NSAttributedString class]]) {
        self.titleLab.attributedText = content;
    }
}

#pragma mark - 搭建UI

- (void)initUI {
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.line];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.mas_equalTo(1.0);
    }];
}

#pragma mark - Getters

- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = kGlobalTextColorGreen;
        _titleLab.font = kFont(18);
    }
    return _titleLab;
}

- (UIView *)line{
    if (!_line){
        _line = [[UIView alloc] init];
        _line.backgroundColor = kSeparatorLineColor;
    }
    return _line;
}

@end
