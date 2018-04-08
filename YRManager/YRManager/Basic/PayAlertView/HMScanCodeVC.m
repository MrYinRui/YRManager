//
//  HMScanCodeVC.m
//  HotelManager
//
//  Created by YR on 2018/3/14.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMScanCodeVC.h"
#import <ZXingObjC.h>
#import "HMWeChatScanAPI.h"
#import "HMAlipayScanAPI.h"
#import "HMScanReturnModel.h"
#import "HMScanWaitAlert.h"

@interface HMScanCodeVC ()<ZXCaptureDelegate,HTTPAPIDelegate>

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) UIView    *bgView;

@property (nonatomic, assign) PayWay    payWay;
@property (nonatomic, assign) double    money;
@property (nonatomic, strong) NSString  *descri;

@property (nonatomic, assign) BOOL      isSending;
@property (nonatomic, strong) HMWeChatScanAPI   *wechatAPI;
@property (nonatomic, strong) HMAlipayScanAPI   *alipayAPI;

@end

@implementation HMScanCodeVC
{
    CGAffineTransform _captureSizeTransform;
}

- (instancetype)initWithWay:(PayWay)payWay title:(NSString *)title totalMoney:(double)money
{
    if (self == [super init])
    {
        _isSending = NO;
        _payWay = payWay;
        _descri = title;
        _money = money;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.capture.delegate = self;
    [self applyOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initUI
{
    [self setNavigationItemBackBBIAndTitle:@"扫一扫"];
    
    self.bgView = [UIView new];
    _bgView.b_moveToView(self.view);
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasTop(StatusHeight);kMasRight(0);kMasBottom(0);
    }];
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    [self.bgView.layer addSublayer:self.capture.layer];
    
    [self drawMaskLayer];
}

#pragma mark -- HTTPAPIDelegate
- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api
{
    if ([api isEqual:self.wechatAPI])
    {
        HMScanReturnModel *model = [HMScanReturnModel mj_objectWithKeyValues:data];
        if ([model.returnCode isEqualToString:@"SUCCESS"])
        {
            if ([model.resultCode isEqualToString:@"SUCCESS"])
            {//支付成功
                [self.navigationController popViewControllerAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:LPNotiPaySuccess object:nil userInfo:@{LPNotiPayWayKey:@"", LPNotiPayIdKey:model.tranId}];
                });
            }
            else
            {
                if ([model.errCode isEqualToString:@"AUTH_CODE_INVALID"])
                {//支付码错误
                    [Prompt popPromptViewWithMsg:@"支付失败!" duration:2.f];
                }
                else if ([model.errCode isEqualToString:@"USERPAYING"])
                {//支付中
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    HMScanWaitAlert *alert = [[HMScanWaitAlert alloc] initOutTradeNo:model.outTradeNo tradeNo:model.tranId relateGuid:@"" payWay:_payWay];
                    [alert showOnView:[UIApplication sharedApplication].keyWindow];
                    
                    [alert mas_makeConstraints:^(MASConstraintMaker *make) {
                        kMasLeft(30);kMasRight(-30);kMasTop(StatusHeight+40);kMasHeight(225);
                    }];
                }
            }
        }
        else
        {
            [Prompt popPromptViewWithMsg:@"支付失败!" duration:2.f];
        }
    }
    else if ([api isEqual:self.alipayAPI])
    {
        if ([data[@"code"] isEqualToString:@"1003"])
        {//支付中
            [self.navigationController popViewControllerAnimated:YES];
            
            HMScanWaitAlert *alert = [[HMScanWaitAlert alloc] initOutTradeNo:data[@"outTradeNo"] tradeNo:data[@"tradeNo"] relateGuid:@"" payWay:_payWay];
            [alert showOnView:[UIApplication sharedApplication].keyWindow];
            
            [alert mas_makeConstraints:^(MASConstraintMaker *make) {
                kMasLeft(30);kMasRight(-30);kMasTop(StatusHeight+40);kMasHeight(225);
            }];
        }
        else
        {//支付完成
            [self.navigationController popViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:LPNotiPaySuccess object:nil userInfo:@{LPNotiPayWayKey:@"", LPNotiPayIdKey:data[@"tradeNo"]}];
            });
        }
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Methods
- (void)drawMaskLayer
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, nil, LPRectMake(0, 0 , kBaseScreenWidth ,kBaseScreenHeight-StatusHeight));
    CGPathAddRect(path, nil, LPRectMake(50, 130, 275, 275));
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = path;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.fillColor = kColor(0, 0, 0, 0.4f).CGColor;
    
    [self.bgView.layer insertSublayer:shapeLayer above:self.capture.layer];
    
    CGPathRelease(path);
    
    // 四个角
    CAShapeLayer  *cornerLayer = [CAShapeLayer new];
    CGMutablePathRef cornerPath = CGPathCreateMutable();
    
    //  左上
    CGPathMoveToPoint(cornerPath, nil, 45 * ScreenScale, 150 * ScreenScale);
    CGPathAddLineToPoint(cornerPath, nil, 45 * ScreenScale, 125 * ScreenScale);
    CGPathAddLineToPoint(cornerPath, nil, 70 * ScreenScale, 125 * ScreenScale);
    
    //  右上
    CGPathMoveToPoint(cornerPath, nil, 305 * ScreenScale, 125 * ScreenScale);
    CGPathAddLineToPoint(cornerPath, nil, 330 * ScreenScale, 125 * ScreenScale);
    CGPathAddLineToPoint(cornerPath, nil, 330 * ScreenScale, 150 * ScreenScale);
    
    //  左下
    CGPathMoveToPoint(cornerPath, nil, 70 * ScreenScale, 410 * ScreenScale);
    CGPathAddLineToPoint(cornerPath, nil, 45 * ScreenScale, 410 * ScreenScale);
    CGPathAddLineToPoint(cornerPath, nil, 45 * ScreenScale, 385 * ScreenScale);
    
    //  右下
    CGPathMoveToPoint(cornerPath, nil, 305 * ScreenScale, 410 * ScreenScale);
    CGPathAddLineToPoint(cornerPath, nil, 330 * ScreenScale, 410 * ScreenScale);
    CGPathAddLineToPoint(cornerPath, nil, 330 * ScreenScale, 385 * ScreenScale);
    
    cornerLayer.path = cornerPath;
    cornerLayer.strokeColor = kYellowColor.CGColor;
    cornerLayer.lineWidth = 2.f;
    cornerLayer.fillColor = [UIColor clearColor].CGColor;
    
    CGPathRelease(cornerPath);
    
    [self.bgView.layer addSublayer:cornerLayer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self applyOrientation];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self applyOrientation];
     }];
}

#pragma mark - Private
- (void)applyOrientation
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
        case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    [self applyRectOfInterest:orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
    [self.capture setTransform:transform];
    [self.capture setRotation:scanRectRotation];
    self.capture.layer.frame = self.view.frame;
}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation
{
    CGFloat scaleVideo, scaleVideoX, scaleVideoY;
    CGFloat videoSizeX, videoSizeY;
    CGRect transformedVideoRect = LPRectMake(50, 130, 275, 275);
    if([self.capture.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080])
    {
        videoSizeX = 1080;
        videoSizeY = 1920;
    }
    else
    {
        videoSizeX = 720;
        videoSizeY = 1280;
    }
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        scaleVideoX = self.view.frame.size.width / videoSizeX;
        scaleVideoY = self.view.frame.size.height / videoSizeY;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
        }
    } else {
        scaleVideoX = self.view.frame.size.width / videoSizeY;
        scaleVideoY = self.view.frame.size.height / videoSizeX;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
        }
    }
    _captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
    self.capture.scanRect = CGRectApplyAffineTransform(transformedVideoRect, _captureSizeTransform);
}

#pragma mark - Private Methods
- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
{
    if (!result) return;
    
    if (_payWay == WEIXIN_PAY && _isSending == NO)
    {
        self.wechatAPI.totalAmount = _money;
        self.wechatAPI.body = _descri;
        self.wechatAPI.authCode = result.text;
        _isSending = YES;
        [self.wechatAPI sendRequestToServerWithActivityViewAndMask:POST];
    }
    else if (_payWay == ALI_PAY && _isSending == NO)
    {
        self.alipayAPI.subject = _descri;
        self.alipayAPI.body = _descri;
        self.alipayAPI.totalAmount = [NSString stringWithFormat:@"%.02f",_money];
        self.alipayAPI.authCode = result.text;
        _isSending = YES;
        [self.alipayAPI sendRequestToServerWithActivityViewAndMask:POST];
    }
}

#pragma mark -- LazyInit
- (HMWeChatScanAPI *)wechatAPI
{
    if (!_wechatAPI)
    {
        _wechatAPI = [HMWeChatScanAPI apiWithDelegate:self];
    }
    return _wechatAPI;
}

- (HMAlipayScanAPI *)alipayAPI
{
    if (!_alipayAPI)
    {
        _alipayAPI = [HMAlipayScanAPI apiWithDelegate:self];
    }
    return _alipayAPI;
}

- (void)dealloc
{
    [self.capture.layer removeFromSuperlayer];
}

@end
