//
//  HMPaySuccessVC.m
//  HotelManager
//
//  Created by YR on 2017/4/5.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPaySuccessVC.h"
#import "UILabel+NSMutableAttributedString.h"
#import "HMCancelOrderGetAPI.h"
#import "NSObject+JSONToObject.h"
#import <MJExtension/MJExtension.h>
#import "HMConfirmPayVC.h"
#import "HMMemberPayVC.h"

@interface HMPaySuccessVC ()<HTTPAPIDelegate>

@property (nonatomic, strong) UIImageView   *iconImg;
@property (nonatomic, strong) UILabel       *infoTitle;
@property (nonatomic, strong) UILabel       *shouldLab;
@property (nonatomic, strong) UILabel       *paiedLab;
@property (nonatomic, strong) UILabel       *payWayLab;

@property (nonatomic, strong) UIButton      *topBtn;
@property (nonatomic, strong) UIButton      *botBtn;

@property (nonatomic, strong) HMCancelOrderGetAPI *payResultAPI;//!<支付结果API
@property (nonatomic, copy) void(^successBlock)(HMCancelOrderGet *);
@property (nonatomic, copy) void(^failedBlock)(void);

@end

@implementation HMPaySuccessVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
}

- (void)initUI
{
    UIView *navView = [UIView new];
    navView.b_bgColor(kColor(81, 80, 73, 1))
    .b_frame(LPRectMake(0, 0, 375, 64))
    .b_moveToView(self.view);
    
    UILabel *titleLab = [UILabel new];
    titleLab.b_textColor([UIColor whiteColor]).b_font(kFont(18))
    .b_textAlignment(NSTextAlignmentCenter).b_text(@"支付结果")
    .b_frame(LPRectMake(0, 20, 375, 44)).b_moveToView(navView);
    
    _iconImg = [UIImageView new];
    _iconImg.b_image([UIImage imageNamed:@"select_02"])
    .b_frame(LPRectMake(110, 64+35, 40, 40)).b_moveToView(self.view);
    
    _infoTitle = [UILabel new];
    _infoTitle.b_text(@"支付完成!").b_textColor(kGreenColor).b_font(kFont(24))
    .b_frame(LPRectMake(155, 64+35, 150, 40)).b_moveToView(self.view);
    
    for (NSInteger i = 0; i < 3; i ++)
    {
        UIView *line = [UIView new];
        line.b_bgColor(kColor(230, 230, 230, 1))
        .b_frame(LPRectMake(30, 170+50*i, 315, 1)).b_moveToView(self.view);
    }
    
    NSString *s1;
    NSString *s2;
    NSString *s3;
    if ([_payWay isEqualToString:PayViewPaywayCashRefund])
    {
        s1 = @"应返款";
        s2 = @"实返款";
        s3 = _payWay;
    }
    else if ([_payWay isEqualToString:PayViewPaywayMember])
    {
        s1 = @"应付款";
        s2 = @"会员支付";
        s3 = _memberPayType;
    }
    else
    {
        s1 = @"应付款";
        s2 = @"实付款";
        s3 = _payWay;
    }
    
    UILabel *leftLab = [UILabel new];
    leftLab.b_textColor(kColor(130, 130, 130, 1)).b_text(s1)
    .b_font(kFont(15)).b_frame(LPRectMake(30, 170, 80, 50)).b_moveToView(self.view);
    
    _payWayLab = [UILabel new];
    _payWayLab.b_textColor(kGreenColor).b_font(kFont(15))
    .b_text([NSString stringWithFormat:@"%@(%@)",s2,s3])
    .b_frame(LPRectMake(30, 220, 150, 50)).b_moveToView(self.view);
    
    _shouldLab = [UILabel new];
    _shouldLab.b_textColor(kColor(130, 130, 130, 1)).b_font(kFont(18))
    .b_textAlignment(NSTextAlignmentRight)
    .b_text([NSString stringWithFormat:@"¥ %.02f",_shouldMoney])
    .b_frame(LPRectMake(180, 170, 165, 50)).b_moveToView(self.view);
    [_shouldLab setAttributedStringWithSubString:@"¥" font:kFont(12)];
    
    _paiedLab = [UILabel new];
    _paiedLab.b_font(kFont(18)).b_textColor(kGreenColor)
    .b_textAlignment(NSTextAlignmentRight)
    .b_text([NSString stringWithFormat:@"¥ %.02f",_paiedMoney])
    .b_frame(LPRectMake(180, 220, 165, 50)).b_moveToView(self.view);
    [_paiedLab setAttributedStringWithSubString:@"¥" font:kFont(12)];
    
    if (_topBtnTitle)
    {
        _topBtn = [UIButton new];
        _topBtn.layer.cornerRadius  = 8;
        _topBtn.layer.masksToBounds = YES;
        _topBtn.b_title(_topBtnTitle,UIControlStateNormal).b_font(kFont(17))
        .b_titleColor([UIColor whiteColor],UIControlStateNormal)
        .b_bgColor(kGreenColor).b_frame(LPRectMake(30, 667-130, 315, 45))
        .b_moveToView(self.view);
        [_topBtn addTarget:self action:@selector(topBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_botBtnTitle)
    {
        _botBtn = [UIButton new];
        _botBtn.layer.masksToBounds = YES;
        _botBtn.layer.cornerRadius  = 8;
        _botBtn.layer.borderColor   = kGreenColor.CGColor;
        _botBtn.layer.borderWidth   = 1;
        _botBtn.b_title(_botBtnTitle,UIControlStateNormal).b_font(kFont(17))
        .b_titleColor(kGreenColor,UIControlStateNormal)
        .b_bgColor([UIColor whiteColor]).b_frame(LPRectMake(30, 667-64, 315, 45))
        .b_moveToView(self.view);
        [_botBtn addTarget:self action:@selector(botBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)topBtnAction
{
    [self removePayVC];
    
    if (_TopBtnActionBlock)
    {
        _TopBtnActionBlock();
        [self removeFromParentViewController];
    }
}

- (void)botBtnAction
{
    [self removePayVC];
    if (_BotBtnActionBlock)
    {
        _BotBtnActionBlock();
    }
}

#pragma mark --- Help Methods
- (void)removePayVC{
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count >= 3) {
        UIViewController *vc = self.navigationController.viewControllers[count - 2];
        if ([vc isKindOfClass:[HMConfirmPayVC class]]
            ||
            [vc isKindOfClass:[HMMemberPayVC class]]) {
            
            [vc removeFromParentViewController];
        }
    }
}

- (HMCancelOrderGetAPI *)payResultAPI{
    if (!_payResultAPI) {
        _payResultAPI = [HMCancelOrderGetAPI apiWithDelegate:self];
    }
    return _payResultAPI;
}

#pragma mark - public methods
- (void)requestWithOrder:(HMOrder *)order
   PayResultSuccessBlock:(void (^)(HMCancelOrderGet *))successBlock
             failedBlock:(void (^)(void))failedBlock{
    
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    self.payResultAPI.guid = self.order.guid ? self.order.guid : order.guid;
    [self.payResultAPI sendRequestToServerWithActivityViewAndMask:POST];
}


#pragma mark - HTTPAPIDelegate

- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api{
    
    if (api == self.payResultAPI) {
        //        HMCancelOrderGet *payResult = [HMCancelOrderGet objectFromDataObject:data];
        HMCancelOrderGet *payResult = [HMCancelOrderGet mj_objectWithKeyValues:data];
     
        if (self.successBlock) {
            self.successBlock(payResult);
        }
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api{
    
    if (api == self.payResultAPI) {
        if (self.failedBlock) {
            self.failedBlock();
        }
    }
}

@end
