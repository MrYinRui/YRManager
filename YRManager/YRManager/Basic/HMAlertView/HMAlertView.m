//
//  HMAlertView.m
//  HotelManager
//
//  Created by r on 17/2/23.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMAlertView.h"
#import "UILabel+NSMutableAttributedString.h"

#define kAlertWidth 315
#define kAlertHeight 225

@interface HMAlertView ()

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIImageView *alertIcon;
@property (nonatomic, strong) UIImageView *closeImg;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation HMAlertView

#pragma mark - Private Methods

+ (instancetype)initAlertView {
    
    HMAlertView *alertView = [[HMAlertView alloc] initWithFrame:LPRectMake(30, StatusHeight + 50, kAlertWidth, kAlertHeight)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = kScaleNum(10.0);
    
    UIImageView *closeImg = [[UIImageView alloc] initWithFrame:LPRectMake(kAlertWidth - 30, 0, 30, 30)];
    closeImg.image = [UIImage imageNamed:@"close_01"];
    closeImg.contentMode = UIViewContentModeCenter;
    [alertView addSubview:closeImg];
    alertView.closeImg = closeImg;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:alertView action:@selector(tapGesture)];
    closeImg.userInteractionEnabled = YES;
    [closeImg addGestureRecognizer:tap];
    
    return alertView;
}

#pragma mark - 各种类型的alertView

+ (instancetype)alertViewWithIconType:(IconType)iconType msg:(NSString *)msg {
    
    HMAlertView *alertView = [HMAlertView initAlertView];
    
    UIImageView *alertIcon = [[UIImageView alloc] initWithFrame:LPRectMake((kAlertWidth-40)/2.0, 55, 40, 40)];
    if (iconType == IconWarn) {
        alertIcon.image = [UIImage imageNamed:@"warn_01"];
    } else if (iconType == IconTick) {
        alertIcon.image = [UIImage imageNamed:@"select_02"];
    } else if (iconType == IconPhone) {
        alertIcon.image = [UIImage imageNamed:@"icon_phone"];
    }
    
    [alertView addSubview:alertIcon];
    alertView.alertIcon = alertIcon;
    
    UILabel *lab = [UILabel new];
    lab.text = msg;
    lab.font = kFont(16);
    lab.frame = LPRectMake(20, 115, kAlertWidth - 40, 0);
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setLineSpace:8];
    lab.height = [lab sizeThatFits:CGSizeMake(kAlertWidth - 40, CGFLOAT_MAX)].height;
    [alertView addSubview:lab];
    alertView.titleLab = lab;
    
    return alertView;
}

+ (instancetype)alertViewWithIconType:(IconType)iconType msg:(NSString *)msg rightBtnBlock:(void (^)(UIButton *))rightBtnBlock {
    
    HMAlertView *alertView = [HMAlertView alertViewWithIconType:iconType msg:msg];
    
    if (!rightBtnBlock) {
        return alertView;
    }
    
    alertView.alertIcon.y = kScaleNum(35);
    NSArray *line = [msg componentsSeparatedByString:@"\r\n"];
    if (line.count == 2) {
        alertView.alertIcon.y = kScaleNum(25);
        alertView.titleLab.y = kScaleNum(80);
    } else if (line.count >= 3) {
        alertView.alertIcon.y = kScaleNum(25);
        alertView.titleLab.y = kScaleNum(75);
    } else{
        alertView.titleLab.y = kScaleNum(100);
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:kGlobalTextColorGray forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kFont(18);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.frame = LPRectMake(0, kAlertHeight - 50, kAlertWidth/2.0, 50);
    [alertView addSubview:cancelBtn];
    [cancelBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFont(18);
    rightBtn.frame = LPRectMake(kAlertWidth/2.0, kAlertHeight - 50, kAlertWidth/2.0, 50);
    [alertView addSubview:rightBtn];
    [rightBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    rightBtnBlock(rightBtn);
    
    UIView *horiLine = [[UIView alloc] init];
    horiLine.backgroundColor = kSeparatorLineColor;
    horiLine.frame = LPRectMake(0, kAlertHeight - 50, kAlertWidth, 1);
    [alertView addSubview:horiLine];
    
    UIView *vertiLine = [[UIView alloc] init];
    vertiLine.backgroundColor = kSeparatorLineColor;
    vertiLine.frame = LPRectMake(kAlertWidth/2.0, kAlertHeight - 50, 1, 50);
    [alertView addSubview:vertiLine];
    
    return alertView;
}

+ (instancetype)alertViewWithIconType:(IconType)iconType msg:(NSString *)msg knowBtnBlock:(void (^)(UIButton *))knowBtnBlock {
    
    HMAlertView *alertView = [HMAlertView alertViewWithIconType:iconType msg:msg];
    
    alertView.alertIcon.y = kScaleNum(35);
    alertView.titleLab.y = kScaleNum(100);
    alertView.closeImg.hidden = YES;
    
    UIButton *knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [knowBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
    knowBtn.titleLabel.font = kFont(18);
    [knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
    knowBtn.frame = LPRectMake(0, kAlertHeight - 50, kAlertWidth, 50);
    [alertView addSubview:knowBtn];
    [knowBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    if (knowBtnBlock) {
        knowBtnBlock(knowBtn);
    }
    
    UIView *horiLine = [[UIView alloc] init];
    horiLine.backgroundColor = kSeparatorLineColor;
    horiLine.frame = LPRectMake(0, kAlertHeight - 50, kAlertWidth, 1);
    [alertView addSubview:horiLine];
    
    return alertView;
}

+ (instancetype)alertViewWithIconType:(IconType)iconType msg:(NSString *)msg detailMsg:(NSString *)detailMsg knowBtnBlock:(void (^)(UIButton *))knowBtnBlock {
    
    HMAlertView *alertView = [HMAlertView alertViewWithIconType:iconType msg:msg knowBtnBlock:knowBtnBlock];
    
    UILabel *detailLab = [UILabel new];
    detailLab.text = detailMsg;
    detailLab.textColor = kGlobalTextColorGray;
    detailLab.font = kFont(12);
    detailLab.numberOfLines = 0;
    detailLab.textAlignment = NSTextAlignmentCenter;
    [detailLab setLineSpace:6];
    [alertView addSubview:detailLab];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScaleNum(50)));
        make.right.equalTo(@(kScaleNum(-50)));
        make.top.equalTo(alertView.titleLab.mas_bottom).with.offset(kScaleNum(8));
    }];
    alertView.detailLab = detailLab;
    
    return alertView;
}

+ (instancetype)alertViewWithIconType:(IconType)iconType
                                  msg:(NSString *)msg
                         leftBtnBlock:(void (^)(UIButton *))leftBtnBlock
                        rightBtnBlock:(void (^)(UIButton *))rightBtnBlock{
    
    HMAlertView *alertView = [HMAlertView alertViewWithIconType:iconType msg:msg];
    
    alertView.alertIcon.y = kScaleNum(35);
    NSArray *line = [msg componentsSeparatedByString:@"\r\n"];
    if (line.count >= 3) {
        alertView.alertIcon.y = kScaleNum(25);
        alertView.titleLab.y = kScaleNum(75);
    } else{
        alertView.titleLab.y = kScaleNum(100);
    }
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
    leftBtn.titleLabel.font = kFont(18);
    leftBtn.frame = LPRectMake(0, kAlertHeight - 50, kAlertWidth/2.0, 50);
    [alertView addSubview:leftBtn];
    [leftBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFont(18);
    rightBtn.frame = LPRectMake(kAlertWidth/2.0, kAlertHeight - 50, kAlertWidth/2.0, 50);
    [alertView addSubview:rightBtn];
    [rightBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *horiLine = [[UIView alloc] init];
    horiLine.backgroundColor = kSeparatorLineColor;
    horiLine.frame = LPRectMake(0, kAlertHeight - 50, kAlertWidth, 1);
    [alertView addSubview:horiLine];
    
    UIView *vertiLine = [[UIView alloc] init];
    vertiLine.backgroundColor = kSeparatorLineColor;
    vertiLine.frame = LPRectMake(kAlertWidth/2.0, kAlertHeight - 50, 1, 50);
    [alertView addSubview:vertiLine];
    
    if (leftBtnBlock) {
        leftBtnBlock(leftBtn);
    }
    if (rightBtnBlock) {
        rightBtnBlock(rightBtn);
    }
    
    return alertView;
}

+ (instancetype)alertViewWithChangeType:(NSString *)type
                                  msg:(NSString *)msg
                         leftBtnBlock:(void (^)(UIButton *leftBtn))leftBtnBlock
                        rightBtnBlock:(void (^)(UIButton *rightBtn))rightBtnBlock
                       cleanBtnBlock:(void (^)(UIButton *cleanBtn))cleanBtnBlock{
    
    HMAlertView *alertView = [HMAlertView alertViewWithIconType:IconWarn msg:msg];
    
    alertView.alertIcon.y = kScaleNum(35);
    NSArray *line = [msg componentsSeparatedByString:@"\r\n"];
    if (line.count >= 3) {
        alertView.titleLab.y = kScaleNum(85);
    }else{
        alertView.titleLab.y = kScaleNum(100);
    }
    
    alertView.height += kScaleNum(40);
    
    CGFloat height = 0;
    if (![type isEqualToString:@""])
    {
        height = kScaleNum(30);
        alertView.height += height;
        UIButton *cleanBtn =
        ({
            cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cleanBtn.frame = LPRectMake(20, kAlertHeight - 20, kAlertWidth - 30, 30);
            [cleanBtn setTitle:type forState:UIControlStateNormal];
            [cleanBtn setTitleColor:kColor(133, 134, 135, 1) forState:UIControlStateNormal];
            cleanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            cleanBtn.titleEdgeInsets = kEdgeInsetsMake(0, 5, 0, 0);
            [cleanBtn setImage:[UIImage imageNamed:@"check-G-nor"] forState:UIControlStateNormal];
            [cleanBtn setImage:[UIImage imageNamed:@"check-g-sel"] forState:UIControlStateSelected];
            cleanBtn.titleLabel.font = kFont(13);
            [alertView addSubview:cleanBtn];
            cleanBtn;
        });
        
        if (cleanBtnBlock) {
            cleanBtnBlock(cleanBtn);
        }
    }
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
    leftBtn.titleLabel.font = kFont(18);
    leftBtn.frame = LPRectMake(0, kAlertHeight - 10 + height, kAlertWidth/2.0, 50);
    [alertView addSubview:leftBtn];
    [leftBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFont(18);
    rightBtn.frame = LPRectMake(kAlertWidth/2.0, kAlertHeight - 10 + height, kAlertWidth/2.0, 50);
    [alertView addSubview:rightBtn];
    [rightBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *horiLine = [[UIView alloc] init];
    horiLine.backgroundColor = kSeparatorLineColor;
    horiLine.frame = LPRectMake(0, kAlertHeight - 10 + height, kAlertWidth, 1);
    [alertView addSubview:horiLine];
    
    UIView *vertiLine = [[UIView alloc] init];
    vertiLine.backgroundColor = kSeparatorLineColor;
    vertiLine.frame = LPRectMake(kAlertWidth/2.0, kAlertHeight - 10 + height, 1, 50);
    [alertView addSubview:vertiLine];
    
    if (leftBtnBlock) {
        leftBtnBlock(leftBtn);
    }
    if (rightBtnBlock) {
        rightBtnBlock(rightBtn);
    }
    
    return alertView;
}

+ (instancetype)alertViewWithIconType:(IconType)iconType
                                  msg:(NSString *)msg
                            detailMsg:(NSString *)detailMsg
                         letfBtnBlock:(void(^)(UIButton *leftBtn))leftBtnBlock
                        rightBtnBlock:(void(^)(UIButton *rightBtn))rightBtnBlock{
    
    HMAlertView *alertView = [HMAlertView alertViewWithIconType:iconType msg:msg leftBtnBlock:leftBtnBlock rightBtnBlock:rightBtnBlock];
    NSArray *line = [msg componentsSeparatedByString:@"\r\n"];
    if (line.count >= 2) {
        alertView.titleLab.y = kScaleNum(85);
    }else if (line.count >= 1){
        alertView.titleLab.y = kScaleNum(90);
    }else{
        alertView.titleLab.y = kScaleNum(100);
    }
    
    UILabel *detailLab = [UILabel new];
    detailLab.text = detailMsg;
    detailLab.textColor = kGlobalTextColorGray;
    detailLab.font = kFont(12);
    detailLab.numberOfLines = 0;
    detailLab.textAlignment = NSTextAlignmentCenter;
    [detailLab setLineSpace:6];
    [alertView addSubview:detailLab];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScaleNum(40)));
        make.right.equalTo(@(kScaleNum(-40)));
        make.top.equalTo(alertView.titleLab.mas_bottom).with.offset(kScaleNum(8));
    }];
    alertView.detailLab = detailLab;
    
    return alertView;
    
    
}

+ (instancetype)alertViewWithMsg:(NSString *)msg upBtnBlock:(void (^)(UIButton *btn))upBtnBlock centerBtnBlock:(void (^)(UIButton *btn))centerBtnBlock downBtnBlock:(void (^)(UIButton *btn))downBtnBlock{
    
    HMAlertView *alertView = [[HMAlertView alloc] initWithFrame:LPRectMake(30, 115, kAlertWidth, 280)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = kScaleNum(10.0);
    
    UIImageView *closeImg = [[UIImageView alloc] initWithFrame:LPRectMake(kAlertWidth - 30, 0, 30, 30)];
    closeImg.image = [UIImage imageNamed:@"close_01"];
    closeImg.contentMode = UIViewContentModeCenter;
    [alertView addSubview:closeImg];
    alertView.closeImg = closeImg;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:alertView action:@selector(removeFromSuperview)];
    closeImg.userInteractionEnabled = YES;
    [closeImg addGestureRecognizer:tap];
    
    UILabel *titleLab =
    ({
        titleLab = [[UILabel alloc] initWithFrame:LPRectMake(50, 45, kAlertWidth - 100, 50)];
        titleLab.text = msg;
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = kFont(16);
        titleLab.numberOfLines = 0;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [titleLab setLineSpace:8];
        titleLab.height = [titleLab sizeThatFits:CGSizeMake(kAlertWidth - 100, CGFLOAT_MAX)].height;
        [alertView addSubview:titleLab];
        alertView.titleLab = titleLab;
        titleLab;
    });
    
    if (upBtnBlock)
    {
        UIButton *upBtn =
        ({
            upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            upBtn.backgroundColor = kGreenColor;
            [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            upBtn.titleLabel.font = kFont(15);
            upBtn.frame = LPRectMake(45, 105, kAlertWidth - 90, 30);
            upBtn.layer.cornerRadius = kScaleNum(5);
            upBtn.layer.masksToBounds = YES;
            [alertView addSubview:upBtn];
            [upBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
            upBtnBlock(upBtn);
            upBtn;
        });
    }
    
    if (centerBtnBlock)
    {
        UIButton *centerBtn =
        ({
            centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            centerBtn.backgroundColor = kYellowColor;
            [centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            centerBtn.titleLabel.font = kFont(15);
            centerBtn.frame = LPRectMake(45, 160, kAlertWidth - 90, 30);
            centerBtn.layer.cornerRadius = kScaleNum(5);
            centerBtn.layer.masksToBounds = YES;
            [alertView addSubview:centerBtn];
            [centerBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
            centerBtnBlock(centerBtn);
            centerBtn;
        });
    }
    
    if (downBtnBlock)
    {
        UIButton *downBtn =
        ({
            downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            downBtn.backgroundColor = [UIColor whiteColor];
            [downBtn setTitleColor:kColor(159, 160, 181, 1) forState:UIControlStateNormal];
            downBtn.layer.borderWidth = kScaleNum(1);
            downBtn.layer.borderColor = kColor(159, 160, 181, 1).CGColor;
            downBtn.titleLabel.font = kFont(15);
            downBtn.frame = LPRectMake(45, 215, kAlertWidth - 90, 30);
            downBtn.layer.cornerRadius = kScaleNum(5);
            downBtn.layer.masksToBounds = YES;
            [alertView addSubview:downBtn];
            [downBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
            downBtnBlock(downBtn);
            downBtn;
        });
    }
    
    return alertView;
}

+ (instancetype)alertViewWithIconType:(IconType)iconType
                                  msg:(NSString *)msg
                            detailMsg:(NSString *)detailMsg
                           upBtnBlock:(void (^)(UIButton *))upBtnBlock
                       centerBtnBlock:(void (^)(UIButton *))centerBtnBlock
                         downBtnBlock:(void (^)(UIButton *))downBtnBlock {
    
    HMAlertView *alertView = [HMAlertView alertViewWithIconType:iconType msg:msg];
    alertView.height = kScaleNum(310);
    alertView.alertIcon.y = kScaleNum(25);
    alertView.titleLab.y = kScaleNum(80);
    alertView.clipsToBounds = YES;
    
    UILabel *detailLab = [UILabel new];
    detailLab.text = detailMsg;
    detailLab.textColor = kGlobalTextColorGray;
    detailLab.font = kFont(12);
    detailLab.numberOfLines = 0;
    detailLab.textAlignment = NSTextAlignmentCenter;
    [detailLab setLineSpace:6];
    [alertView addSubview:detailLab];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScaleNum(40)));
        make.right.equalTo(@(kScaleNum(-40)));
        make.top.equalTo(alertView.titleLab.mas_bottom).with.offset(kScaleNum(8));
    }];
    alertView.detailLab = detailLab;
    
    
    if (downBtnBlock) {
        UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        downBtn.backgroundColor = [UIColor whiteColor];
        [downBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
        downBtn.titleLabel.font = kFont(16);
        [alertView addSubview:downBtn];
        [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(@0);
            make.height.mas_equalTo(kScaleNum(45));
        }];
        [downBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        downBtnBlock(downBtn);
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kSeparatorLineColor;
        [alertView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(downBtn);
            make.height.mas_equalTo(1);
        }];
    }
    
    if (centerBtnBlock) {
        UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        centerBtn.backgroundColor = [UIColor whiteColor];
        [centerBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
        centerBtn.titleLabel.font = kFont(16);
        [alertView addSubview:centerBtn];
        [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@(kScaleNum(-45)));
            make.height.mas_equalTo(kScaleNum(45));
        }];
        [centerBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        centerBtnBlock(centerBtn);
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kSeparatorLineColor;
        [alertView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(centerBtn);
            make.height.mas_equalTo(1);
        }];
    }
    
    if (upBtnBlock) {
        UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upBtn.backgroundColor = [UIColor whiteColor];
        [upBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
        upBtn.titleLabel.font = kFont(16);
        [alertView addSubview:upBtn];
        [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@(kScaleNum(-90)));
            make.height.mas_equalTo(kScaleNum(45));
        }];
        [upBtn addTarget:alertView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        upBtnBlock(upBtn);
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kSeparatorLineColor;
        [alertView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(upBtn);
            make.height.mas_equalTo(1);
        }];
    }
    
    return alertView;
}

#pragma mark - 显示相关

- (void)showWithAnimationOnView:(UIView *)view
{
    _coverView = [UIView new];
    _coverView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _coverView.backgroundColor = kColor(0, 0, 0, 0.4);
    [view addSubview:_coverView];
    
    [view addSubview:self];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.duration = 0.1;
    animation.fromValue = @(1.05);
    animation.toValue = @(1);
    animation.beginTime = 0;
    animation.removedOnCompletion = YES;
    
    [self.layer addAnimation:animation forKey:nil];
}

-(void)hiddenClose
{
    _closeImg.hidden = YES;
}

- (void)showWithAnimation
{
    [self showWithAnimationOnView:[UIApplication sharedApplication].keyWindow];
}

-(void)setTitleString:(NSArray *)arrString Font:(UIFont *)font Color:(UIColor *)color;
{
    
    if (arrString.count == 0) return;
    
    NSMutableAttributedString *attributedText;
    if (self.titleLab.attributedText.length) {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleLab.attributedText];
        
    } else {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.titleLab.text];
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (font)
    {
        [dict setValue:font forKey:NSFontAttributeName];
        [dict setValue:@0 forKey:NSBaselineOffsetAttributeName];
    }
    if (color)
    {
        [dict setValue:color forKey:NSForegroundColorAttributeName];
    }
    
    for (NSString *string in arrString)
    {
        [attributedText addAttributes:dict range:[self.titleLab.text rangeOfString:string options:NSBackwardsSearch]];
    }
    [self.titleLab setAttributedText:attributedText];
}

- (void)setTitleLabLineSpace:(CGFloat)space {
    if (space < 0.01) return;
    
    NSMutableAttributedString *attributedText;
    if (self.titleLab.attributedText.length) {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleLab.attributedText];
        
    } else {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.titleLab.text];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedText length])];

    [self.titleLab setAttributedText:attributedText];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
}

-(void)tapGesture
{
   !_closeBlock ?: _closeBlock();
   [self removeFromSuperview];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [_coverView removeFromSuperview];
}



@end
