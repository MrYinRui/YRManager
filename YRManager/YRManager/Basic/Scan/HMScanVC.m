//
//  HMScanVC.m
//  HotelManager
//
//  Created by kqz on 2018/2/1.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMScanVC.h"
#import "HMBreakfastScanQrCodeVC.h"
#import "HMBreakfastScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface HMScanVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) HMBreakfastScanView *scanView;
@property (nonatomic, assign) CGRect scanRect;

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;

@property (nonatomic, assign) BOOL isQRCodeCaptured;
@property (nonatomic, assign) BOOL isBack;//!<是否需要返回数据

@end

@implementation HMScanVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isBack = YES;
    [self.scanView startAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestCameraAuthority];
}

- (void)dealloc {
    if (self.session.isRunning) {
        [self.session stopRunning];
        [self.scanView stopAnimating];
    }
}

// 查询相机权限
- (void)requestCameraAuthority {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status != AVAuthorizationStatusAuthorized) { //未授权
        [self alertUnAuthorized];
        
    } else { // 授权
        [self setupCapture];
    }
}

- (void)setupCapture {
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    _output = [AVCaptureMetadataOutput new];
    [_output setMetadataObjectsDelegate:(self) queue:dispatch_get_main_queue()];
    
    _session = [AVCaptureSession new];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    //关联输入输出
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    //设置条码类型
    if ([_output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    
    //添加 预览层
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.scanView.frame;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    //启动会话
    [_session startRunning];
    [self.scanView startAnimating];
    
    // 要在startRuning后调用 metadataOutputRectOfInterestForRect才管用
    _output.rectOfInterest = [_previewLayer metadataOutputRectOfInterestForRect:self.scanRect]; // 如果不设置，整个屏幕都可以扫
}

- (void)alertUnAuthorized{
    WEAKSELF
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"需您授权使用相机之后才能进行" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:cancelAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"启用相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf requestOpenCamera];
    }];
    [alertVC addAction:confirmAction];
    
}

- (void)requestOpenCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusNotDetermined){
        
        if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"10."]){ //iOS 10+
            HMLog(@"iOS 10+");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                //请求 摄像头
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                    //回到主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self setupCapture];
                    });
                }];
                
            }];
        } else {
            HMLog(@"iOS 10-");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
            //请求 摄像头
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){             }];
        }
    }
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
    if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
    
        if (metadataObject.stringValue && metadataObject.stringValue.length) {
            NSArray *infoArr = [metadataObject.stringValue componentsSeparatedByString:@","];
            if (infoArr.count > 0 && _isBack == YES) {
                if (_scanDataBlock)
                {
                    _isBack = NO;
                    _scanDataBlock(infoArr);
                }
            }
        }
    }
}

#pragma mark - Private Methods

- (void)removeSelfFromNavigationControllers {
    
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[self class]]) {
            [vcs removeObject:vc];
            break;
        }
    }
    [self.navigationController setViewControllers:vcs];
}

#pragma mark - 搭建UI

- (void)initUI {
    
    [self setNavigationItemBackBBIAndTitle:@"扫描"];
    
    self.scanRect = LPRectMake(52, StatusHeight + 70, 270, 270);
    self.scanView = [[HMBreakfastScanView alloc] initWithFrame:CGRectMake(0, kScaleNum(StatusHeight), kScreenWidth, kScreenHeight - StatusHeight) scanRect:self.scanRect];
    
    [self.view addSubview:self.scanView];
}

-(void)closeVC
{
    [self removeSelfFromNavigationControllers];
}

@end

