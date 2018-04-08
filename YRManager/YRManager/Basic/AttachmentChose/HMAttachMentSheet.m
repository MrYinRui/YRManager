//
//  HMAttachMentSheet.m
//  HotelManager
//
//  Created by YR on 2017/6/21.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMAttachMentSheet.h"
#import "HMPhotoLibraryVC.h"
#import "HMPhotoManager.h"
#import "Alert.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface HMAttachMentSheet ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIView    *bgView;

@property (nonatomic, strong) UIButton  *takeBtn;
@property (nonatomic, strong) UIButton  *choseBtn;
@property (nonatomic, strong) UIButton  *cancelBtn;

@property (nonatomic, assign) NSInteger limit;

@end

@implementation HMAttachMentSheet

- (instancetype)initWithLimit:(NSInteger)limit
{
    if (self == [super init])
    {
        _limit = limit;
        self.frame = LPRectMake(0, 667, 375, 144);
        self.backgroundColor = kColor(200, 200, 200, 1);
        
        UIView *line = [UIView new];
        line.b_bgColor(kLineColor)
        .b_frame(LPRectMake(0, 45, 375, 1))
        .b_moveToView(self);
        
        [self addSubview:self.takeBtn];
        [self addSubview:self.choseBtn];
        [self addSubview:self.cancelBtn];
        
        //相册选择图片通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectLibraryBack:) name:PhotoLibrarySelectedAssetNotification object:nil];
    }
    return self;
}

#pragma mark -- 相册选择成功返回
- (void)selectLibraryBack:(NSNotification *)not
{
    if (not.userInfo[kPhotoWantedSourceKey] != self) {
        return;
    }
    NSArray *arr = not.userInfo[kPhotoAssetKey];
    NSMutableArray *imgArr = [NSMutableArray new];
    
    //多线程处理拿取图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        dispatch_group_t downloadGroup = dispatch_group_create(); // 2
        
        PHAsset *asset = nil;
        for (NSInteger i = 0; i < arr.count; i ++)
        {
            dispatch_group_enter(downloadGroup); // 3
            asset = arr[i];
            
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [imgArr addObject:result];
                dispatch_group_leave(downloadGroup);
            }];
        }
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER); // 5
        dispatch_async(dispatch_get_main_queue(), ^{ // 6
            //刷新
            [self removeAction];
            _ChosePhotoBlock?_ChosePhotoBlock(imgArr):nil;
        });
    });
}

- (void)showOnView:(UIView *)view
{
    _bgView = [UIView new];
    _bgView.userInteractionEnabled = YES;
    _bgView.b_bgColor([[UIColor blackColor] colorWithAlphaComponent:0.4])
    .b_frame(LPRectMake(0, 0, 375, 667)).b_moveToView(view);
    [_bgView addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
    [_bgView addGestureRecognizer:tap];

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = LPRectMake(0, 667-143, 375, 144);
    }];
}

- (void)removeAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)cancelAction
{
    [self removeAction];
}

- (void)takePhotoAction
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        [Alert alertWithTitle:@"提示" msg:@"此应用程序没有被授权访问的相机权限,是否前往设置?" action:xun_action(@"取消", nil) action:xun_action(@"设置", ^(UIAlertAction *action){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        })];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self.viewController.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)choseAction
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied)
    {
        [Alert alertWithTitle:@"提示" msg:@"此应用程序没有被授权访问的相册权限,是否前往设置?" action:xun_action(@"取消", nil) action:xun_action(@"设置", ^(UIAlertAction *action){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        })];
    }
    
    HMPhotoLibraryVC *vc = [HMPhotoLibraryVC new];
    vc.maxImageCount = _limit;
    vc.source        = self;
    
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- UIImagePickerViewController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *takePicture = info[UIImagePickerControllerOriginalImage];
    if (takePicture)
    {
        NSMutableArray *imgArr = [NSMutableArray new];
        [imgArr addObject:[self fixOrientation:takePicture]];
        _ChosePhotoBlock ? _ChosePhotoBlock(imgArr):nil;
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        [self removeAction];
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage
{
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform =CGAffineTransformIdentity;
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark -- LazyInit
- (UIButton *)takeBtn
{
    if (!_takeBtn)
    {
        _takeBtn = [UIButton new];
        _takeBtn.b_title(@"拍照",UIControlStateNormal)
        .b_font(kFont(16))
        .b_titleColor(kGreenColor,UIControlStateNormal)
        .b_frame(LPRectMake(0, 0, 375, 45))
        .b_bgColor([UIColor whiteColor]);
        [_takeBtn addTarget:self action:@selector(takePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takeBtn;
}

- (UIButton *)choseBtn
{
    if (!_choseBtn)
    {
        _choseBtn = [UIButton new];
        _choseBtn.b_titleColor(kGreenColor,UIControlStateNormal)
        .b_font(kFont(16)).b_title(@"从相册选择",UIControlStateNormal)
        .b_frame(LPRectMake(0, 46, 375, 45))
        .b_bgColor([UIColor whiteColor]);
        [_choseBtn addTarget:self action:@selector(choseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choseBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn)
    {
        _cancelBtn = [UIButton new];
        _cancelBtn.b_title(@"取消",UIControlStateNormal).b_font(kFont(16))
        .b_titleColor(kColor(130, 130, 130, 1),UIControlStateNormal)
        .b_frame(LPRectMake(0, 99, 375, 45))
        .b_bgColor([UIColor whiteColor]);
        
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
