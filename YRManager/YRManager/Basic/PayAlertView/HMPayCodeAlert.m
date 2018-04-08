//
//  HMWeChatCodeAlert.m
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPayCodeAlert.h"
#import "UIImage+LPQRCodeGenerator.h"
#import "HMHotel.h"
#import "UILabel+NSMutableAttributedString.h"
#import "HTTPAPI.h"
#import "HMSegmentView.h"
#import "HMAliPayAPI.h"
#import "HMWeChatPayAPI.h"
#import "HMScanCodeVC.h"

@interface HMPayCodeAlert ()<HTTPAPIDelegate>

@property (nonatomic, strong) NSTimer   *timer;

@property (nonatomic, strong) UILabel   *payWayLab;
@property (nonatomic, strong) UILabel   *moneyLab;
@property (nonatomic, strong) UIImageView   *codeImg;

@property (nonatomic, strong) UILabel   *hourLab;
@property (nonatomic, strong) UILabel   *mintLab;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) NSTimer   *closeTimer;

@property (nonatomic, strong) HMPayOrderModel   *orderModel;
@property (nonatomic, strong) UIImage           *logoImg;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *warnStr;

@property (nonatomic, assign) PayWay    payType;

@property (nonatomic, strong) HMAliPayAPI       *alipayAPI;
@property (nonatomic, strong) HMWeChatPayAPI    *wechatPayAPI;
@property (nonatomic, strong) NSString          *describe;
@property (nonatomic, assign) double            totalMoney;

@end

@implementation HMPayCodeAlert

- (instancetype)initWith:(HMPayOrderModel *)orderModel payType:(PayWay)type
{
    if (self == [super init])
    {
        _describe = orderModel.descr;
        _totalMoney = orderModel.money;
        _payType = type;
        _orderModel = orderModel;
        self.frame = LPRectMake(30, 80, 315, 470);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        
        if (type == WEIXIN_PAY)
        {
            _title = @"微信支付";
            _warnStr = @"请用手机微信扫描二维码支付";
            _logoImg = [UIImage imageNamed:@"weixin_pay_logo"];
        }
        else if (type == ALI_PAY)
        {
            _title = @"支付宝支付";
            _warnStr = @"请用手机支付宝扫描二维码支付";
            _logoImg = [UIImage imageNamed:@"ali_pay_logo"];
        }
        
        [self initUI];
    }
    return self;
}

- (instancetype)initWithPayWay:(PayWay)payWay title:(NSString *)title totalMoney:(double)money
{
    if (self == [super init])
    {
        _orderModel = [HMPayOrderModel new];
        _orderModel.money = money;
        _describe = title;
        _totalMoney = money;
        _payType = payWay;
        self.frame = LPRectMake(30, 80, 315, 470);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        
        if (_payType == WEIXIN_PAY)
        {
            _title = @"微信支付";
            _warnStr = @"请用手机微信扫描二维码支付";
            _logoImg = [UIImage imageNamed:@"weixin_pay_logo"];
        }
        else if (_payType == ALI_PAY)
        {
            _title = @"支付宝支付";
            _warnStr = @"请用手机支付宝扫描二维码支付";
            _logoImg = [UIImage imageNamed:@"ali_pay_logo"];
        }
        
        [self getPayInfo];
    }
    return self;
}

- (void)getPayInfo
{
    if (_payType == WEIXIN_PAY)
    {
        self.wechatPayAPI.body = _describe;
        self.wechatPayAPI.totalAmount = _totalMoney;
        [self.wechatPayAPI sendRequestToServerWithActivityViewAndMask:POST];
    }
    else if (_payType == ALI_PAY)
    {
        self.alipayAPI.body = _describe;
        self.alipayAPI.totalAmount = _totalMoney;
        self.alipayAPI.subject = _describe;
        [self.alipayAPI sendRequestToServerWithActivityViewAndMask:POST];
    }
}

- (void)initUI
{
    _timeCount = 0;

    HMSegmentView *segView = [[HMSegmentView alloc] initWithFrame:LPRectMake(40, 20, 235, 25) title:@[@"收款",@"扫一扫"] width:kScaleNum(117.5)];
    [self addSubview:segView];
    
    WEAKSELF
    segView.BtnClickBlock = ^(NSInteger index) {
        if (index == 1)
        {
            HMScanCodeVC *vc = [[HMScanCodeVC alloc] initWithWay:_payType title:_title totalMoney:_totalMoney];
            [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
            [weakSelf closeAction];
        }
    };
    
    _payWayLab = [UILabel new];
    _payWayLab.b_font(kFont(14)).b_textColor(kColor(130, 130, 130, 1))
    .b_text(_title)
    .b_frame(LPRectMake(30, 55, 255, 20)).b_moveToView(self);
    
    UILabel *lab1 = [UILabel new];
    lab1.b_font(kFont(14)).b_textColor(kColor(130, 130, 130, 1))
    .b_text(@"实付款")
    .b_frame(LPRectMake(30, 80, 80, 20)).b_moveToView(self);
    
    _moneyLab = [UILabel new];
    _moneyLab.b_font(kFont(22)).b_textColor(kYellowColor)
    .b_textAlignment(NSTextAlignmentRight)
    .b_text([NSString stringWithFormat:@"¥ %.02f",_orderModel.money])
    .b_frame(LPRectMake(120, 75, 165, 25)).b_moveToView(self);
    [_moneyLab setAttributedStringWithSubString:@"¥" font:kFont(16)];
    
    UILabel *lab2 = [UILabel new];
    lab2.b_font(kFont(13)).b_textColor(kColor(130, 130, 130, 1))
    .b_textAlignment(NSTextAlignmentCenter).b_text(_warnStr)
    .b_frame(LPRectMake(30, 395, 255, 20)).b_moveToView(self);
    
    UILabel *lab3 = [UILabel new];
    lab3.b_font(kFont(13)).b_text(@"支付倒计时")
    .b_textColor(kColor(230, 204, 133, 1))
    .b_textAlignment(NSTextAlignmentCenter)
    .b_frame(LPRectMake(0, 175, 315, 10))
    .b_moveToView(self);
    
    _hourLab = [UILabel new];
    _hourLab.layer.cornerRadius = kScaleNum(5);
    _hourLab.layer.masksToBounds = YES;
    _hourLab.b_font(kBFont(38)).b_text(@"5")
    .b_textAlignment(NSTextAlignmentCenter)
    .b_textColor([UIColor whiteColor])
    .b_bgColor(kColor(230, 204, 133, 1))
    .b_frame(LPRectMake(115, 125, 40, 40))
    .b_moveToView(self);
    
    _mintLab = [UILabel new];
    _mintLab.layer.cornerRadius = kScaleNum(5);
    _mintLab.layer.masksToBounds = YES;
    _mintLab.b_font(kBFont(38)).b_text(@"9")
    .b_textAlignment(NSTextAlignmentCenter)
    .b_textColor([UIColor whiteColor])
    .b_bgColor(kColor(230, 204, 133, 1))
    .b_frame(LPRectMake(160, 125, 40, 40))
    .b_moveToView(self);
    
    UIImage *qrCode = [UIImage generatorQRCodeImageWithContent:_orderModel.url length:kScaleNum(200)];
    _codeImg = [UIImageView new];
    _codeImg.userInteractionEnabled = YES;
    _codeImg.layer.borderColor = kYellowColor.CGColor;
    _codeImg.layer.borderWidth = kScaleNum(1);
    _codeImg.b_image([UIImage compositeImage:qrCode image:_logoImg])
    .b_frame(LPRectMake(57.5, 195, 200, 200)).b_moveToView(self);
    
    HMHotel *hotel = [HMHotel localHotel];
    
    UILabel *hotelLab = [UILabel new];
    hotelLab.b_font(kFont(14)).b_textColor(kGreenColor)
    .b_textAlignment(NSTextAlignmentCenter).b_text(hotel.name)
    .b_frame(LPRectMake(30, 435, 255, 20)).b_moveToView(self);
    
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.f];
    self.closeTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.f];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] addTimer:self.closeTimer forMode:NSRunLoopCommonModes];
    
    for (UIView *view in _codeImg.subviews)
    {
        [view removeFromSuperview];
    }
}

- (void)removeAction
{
    [self cancelPay];
    [_timer invalidate];
    [_closeTimer invalidate];
}

#pragma mark - HTTPAPIDelegate
- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api
{
    if ([api isEqual:self.wechatPayAPI])
    {
        _orderModel.Id         = @"";
        _orderModel.outTradeNo = data[@"outTradeNo"];
        _orderModel.url = data[@"qrCode"];
        
        [self initUI];
    }
    else if ([api isEqual:self.alipayAPI])
    {
        _orderModel.Id         = @"";
        _orderModel.outTradeNo = data[@"outTradeNo"];
        _orderModel.url = data[@"qrCode"];
        
        [self initUI];
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api
{
    
}

#pragma mark -- 取消支付
- (void)cancelPay
{
    NSString *method = nil;
    
    if (_payType == ALI_PAY)
    {
        method = @"spring/pay/alipay/alipayCancel";
    }
    else if (_payType == WEIXIN_PAY)
    {
        method = @"spring/pay/wechat/wechatCloseorder";
    }
    
    [HTTPAPI requestWithRequestType:POST method:method parameters:@{@"outTradeNo":_orderModel.outTradeNo} successBlock:^(NSURLSessionDataTask *dataTask, id dataObj)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:PayViewCancelPayProcessNotification object:nil userInfo:@{@"PayWay" : @(_payType)}];
         
     } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error)
     {
         
     }];
}

#pragma mark -- 倒计时
- (void)closeTime
{
    _timeCount++;
    self.hourLab.text = [NSString stringWithFormat:@"%ld",(59-_timeCount)/10];
    self.mintLab.text = [NSString stringWithFormat:@"%ld",(59-_timeCount)%10];
    
    if (_timeCount == 59)
    {
        [self cancelPay];
        [self.closeTimer invalidate];
        self.closeTimer = nil;
        
        //[self closeAction];
        
        _codeImg.image = nil;
        _codeImg.backgroundColor = kCellSelectionYellow;
        
        UILabel *lab = [UILabel new];
        lab.b_textColor(kYellowColor).b_font(kFont(15))
        .b_textAlignment(NSTextAlignmentCenter)
        .b_text(@"支付倒计时结束")
        .b_moveToView(_codeImg);
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            kMasTop(70);kMasLeft(20);kMasHeight(20);kMasRight(-20);
        }];
        
        UIButton *btn = [UIButton new];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = kScaleNum(3);
        btn.b_title(@"点击刷新",UIControlStateNormal)
        .b_titleColor([UIColor whiteColor],UIControlStateNormal)
        .b_font(kFont(15)).b_bgColor(kYellowColor)
        .b_moveToView(_codeImg);
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            kMasLeft(55);kMasRight(-55);kMasTop(100);kMasHeight(25);
        }];
        
        [btn addTarget:self action:@selector(refreshCode) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -- 刷新二维码
- (void)refreshCode
{
    [self getPayInfo];
}

#pragma mark -- 检查支付结果
- (void)checkPayResult
{
    NSString *method = nil;
    
    if (_payType == ALI_PAY)
    {
        method = @"spring/pay/alipay/alipayQuery";
    }
    else if (_payType == WEIXIN_PAY)
    {
        method = @"spring/pay/wechat/wechatOrderquery";
    }
    
    [HTTPAPI requestWithRequestType:POST method:method parameters:@{@"outTradeNo":_orderModel.outTradeNo,@"relatedGuid" : _orderModel.Id} successBlock:^(NSURLSessionDataTask *dataTask, id dataObj) {
        
        NSString *status = dataObj[@"tradeStatus"];
        
        if ([status isEqualToString:AliPayTradeSuccess] ||
            [status isEqualToString:WXPayTradeSuccess])
        {
            [self.timer invalidate];
            [self.closeTimer invalidate];
            self.timer = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:LPNotiPaySuccess object:nil userInfo:@{LPNotiPayWayKey:dataObj[@"payTypeGuid"], LPNotiPayIdKey:dataObj[@"tradeNo"]}];
//            [self closeAction];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
}

- (NSTimer *)timer
{
    if (! _timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(checkPayResult) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSTimer *)closeTimer
{
    if (!_closeTimer)
    {
        _closeTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(closeTime) userInfo:nil repeats:YES];
    }
    return _closeTimer;
}

- (HMAliPayAPI *)alipayAPI
{
    if (!_alipayAPI)
    {
        _alipayAPI = [HMAliPayAPI apiWithDelegate:self];
    }
    return _alipayAPI;
}

- (HMWeChatPayAPI *)wechatPayAPI
{
    if (!_wechatPayAPI)
    {
        _wechatPayAPI = [HMWeChatPayAPI apiWithDelegate:self];
    }
    return _wechatPayAPI;
}

@end
