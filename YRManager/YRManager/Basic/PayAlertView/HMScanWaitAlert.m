//
//  HMScanWaitAlert.m
//  HotelManager
//
//  Created by YR on 2018/3/23.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMScanWaitAlert.h"
#import "HTTPAPI.h"

@interface HMScanWaitAlert ()

@property (nonatomic, strong) NSString  *outTradeNo;
@property (nonatomic, strong) NSString  *tradeNo;
@property (nonatomic, strong) NSString  *relateGuid;
@property (nonatomic, assign) PayWay    payWay;

@property (nonatomic, strong) NSTimer   *timer;

@property (nonatomic, strong) UILabel   *infoLab;
@property (nonatomic, strong) UIButton  *closePayBtn;

@property (nonatomic, strong) UIImageView   *warnImg;
@property (nonatomic, strong) UIButton      *reCloseBtn;
@property (nonatomic, strong) UIButton      *suCloseBtn;
@property (nonatomic, strong) UIView        *hLine;

@end

@implementation HMScanWaitAlert

- (instancetype)initOutTradeNo:(NSString *)outTradeNo tradeNo:(NSString *)tradeNo relateGuid:(NSString *)relateGuid payWay:(PayWay)payWay
{
    if (self == [super init])
    {
        _outTradeNo = outTradeNo;
        _tradeNo = tradeNo;
        _relateGuid = relateGuid;
        _payWay = payWay;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kScaleNum(8);
        
        [self initAlert];
    }
    return self;
}

- (void)initAlert
{
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(20);kMasRight(-20);kMasTop(60);kMasBottom(-60);
    }];
    
    [self.closePayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasRight(0);kMasBottom(0);kMasHeight(50);
    }];
    
    UIView *line = [UIView new];
    line.b_bgColor(kLineColor)
    .b_moveToView(self);
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasRight(0);kMasBottom(-50);kMasHeight(1);
    }];
    
    [self.warnImg mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(135);kMasRight(-135);kMasTop(20);kMasHeight(45);
    }];
    
    [self.reCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasBottom(0);kMasHeight(50);kMasWidth(157.5);
    }];
    
    [self.suCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasRight(0);kMasBottom(0);kMasHeight(50);kMasWidth(157.5);
    }];
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasBottom(0);kMasHeight(50);kMasWidth(1);kMasLeft(157.5);
    }];
    
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.f];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)sureCloseAction
{
    [self.timer invalidate];
    self.timer = nil;
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)closeAction
{
    [self cancelSureAction:YES];
}

- (void)reCloseAction
{
    [self cancelSureAction:NO];
}

- (void)cancelSureAction:(BOOL)status
{
    if (status)
    {
        self.infoLab.text = @"关闭支付，将导致支付操作失败\n是否关闭支付？";
    }
    else
    {
        self.infoLab.text = @"支付待确认，请稍候......";
    }
    
    self.closePayBtn.hidden = status;
    self.warnImg.hidden = !status;
    self.reCloseBtn.hidden = !status;
    self.suCloseBtn.hidden = !status;
    self.hLine.hidden = !status;
}

#pragma mark -- 检查支付结果
- (void)checkPayResult
{
    NSString *method = nil;
    
    if (_payWay == ALI_PAY)
    {
        method = @"spring/pay/alipay/alipayQuery";
    }
    else if (_payWay == WEIXIN_PAY)
    {
        method = @"spring/pay/wechat/wechatOrderquery";
    }
    
    WEAKSELF
    [HTTPAPI requestWithRequestType:POST method:method parameters:@{@"outTradeNo":_outTradeNo,@"relatedGuid" : _relateGuid} successBlock:^(NSURLSessionDataTask *dataTask, id dataObj) {
        
        NSString *status = dataObj[@"tradeStatus"];
        
        if ([status isEqualToString:AliPayTradeSuccess] ||
            [status isEqualToString:WXPayTradeSuccess])
        {
            [weakSelf sureCloseAction];
            [[NSNotificationCenter defaultCenter] postNotificationName:LPNotiPaySuccess object:nil userInfo:@{LPNotiPayWayKey:dataObj[@"payTypeGuid"], LPNotiPayIdKey:dataObj[@"tradeNo"]}];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
}

#pragma mark -- 关闭支付
- (void)suCloseAction
{
    NSString *method = nil;
    NSDictionary *va = nil;
    if (_payWay == ALI_PAY)
    {
        method = @"spring/pay/alipay/alipayCancel";
        va = @{@"outTradeNo":_outTradeNo};
    }
    else if (_payWay == WEIXIN_PAY)
    {
        method = @"spring/pay/wechat/wechatCloseorder";
        va = @{@"outTradeNo":_outTradeNo,@"tradeType":@"1"};
    }
    
    WEAKSELF
    [HTTPAPI requestWithRequestType:POST method:method parameters:va successBlock:^(NSURLSessionDataTask *dataTask, id dataObj)
     {
         [weakSelf sureCloseAction];
         [[NSNotificationCenter defaultCenter] postNotificationName:PayViewCancelPayProcessNotification object:nil userInfo:@{@"PayWay" : @(weakSelf.payWay)}];
         
     } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error)
     {
         
     }];
}

#pragma mark -- LazyInit
- (UILabel *)infoLab
{
    if (!_infoLab)
    {
        _infoLab = [UILabel new];
        _infoLab.b_font(kFont(16))
        .b_textAlignment(NSTextAlignmentCenter)
        .b_lineBreakMode(NSLineBreakByCharWrapping)
        .b_numberOfLines(0)
        .b_text(@"支付待确认，请稍候......")
        .b_moveToView(self);
    }
    return _infoLab;
}

- (UIButton *)closePayBtn
{
    if (!_closePayBtn)
    {
        _closePayBtn = [UIButton new];
        _closePayBtn.b_font(kFont(15))
        .b_title(@"关闭支付",UIControlStateNormal)
        .b_titleColor(kGlobalTextColorGray,UIControlStateNormal)
        .b_moveToView(self);
        
        [_closePayBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closePayBtn;
}

- (UIImageView *)warnImg
{
    if (!_warnImg)
    {
        _warnImg = [UIImageView new];
        _warnImg.hidden = YES;
        _warnImg.b_image([UIImage imageNamed:@"warn_01"])
        .b_moveToView(self);
    }
    return _warnImg;
}

- (UIButton *)reCloseBtn
{
    if (!_reCloseBtn)
    {
        _reCloseBtn = [UIButton new];
        _reCloseBtn.hidden = YES;
        _reCloseBtn.b_font(kFont(15))
        .b_title(@"取消",UIControlStateNormal)
        .b_titleColor(kGlobalTextColorGray,UIControlStateNormal)
        .b_moveToView(self);
        
        [_reCloseBtn addTarget:self action:@selector(reCloseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reCloseBtn;
}

- (UIButton *)suCloseBtn
{
    if (!_suCloseBtn)
    {
        _suCloseBtn = [UIButton new];
        _suCloseBtn.hidden = YES;
        _suCloseBtn.b_font(kFont(15))
        .b_title(@"关闭",UIControlStateNormal)
        .b_titleColor(kGreenColor,UIControlStateNormal)
        .b_moveToView(self);
        
        [_suCloseBtn addTarget:self action:@selector(suCloseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _suCloseBtn;
}

- (UIView *)hLine
{
    if (!_hLine)
    {
        _hLine = [UIView new];
        _hLine.hidden = YES;
        _hLine.b_bgColor(kLineColor)
        .b_moveToView(self);
    }
    return _hLine;
}

- (NSTimer *)timer
{
    if (! _timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(checkPayResult) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
