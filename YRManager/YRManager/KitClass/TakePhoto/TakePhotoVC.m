//
//  TakePhotoVC.m
//  HotelManager
//
//  Created by kqz on 17/2/23.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "TakePhotoVC.h"
#import "MBProgressHUD+GoGoFun.h"
#import "HTTPAPI.h"
#import "HMUserInfo.h"
#import <AVFoundation/AVFoundation.h>
#import "Alert.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define upLoadPhotoWayArr @[@"拍照",@"从相册选择"]

@interface TakePhotoVC ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView * editIMG;
@property (nonatomic, strong) UIView * selectPhotoView; //图片获取方式View
@property (nonatomic, assign) CGFloat scale;            //选取缩放比例
@property (nonatomic, assign) CGFloat hwScale;          //选取图片的宽高比例
@property (nonatomic, strong) UIImage *selectImage;     //拍照或相册选择的图片

@property (strong, nonatomic) MBProgressHUD *progressHUD;

@property (nonatomic, strong) HMUserInfo *userInfo;

@property (nonatomic, strong) UILabel       *warnLab;

@end

@implementation TakePhotoVC

-(void)viewWillAppear:(BOOL)animated{
    
    self.view.backgroundColor = [UIColor blackColor];
}

#pragma mark --- lazy init
- (HMUserInfo *)userInfo {
    if (!_userInfo) {
        NSData *data = [kUserDefault objectForKey:kUserInfoKey];
        _userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return _userInfo;
}

-(UIImageView *)editIMG
{
    if (_editIMG == nil) {
        _editIMG = [[UIImageView alloc]init ];
        //读取图片
        if ([self getImage]== nil) {
            _editIMG.frame = LPRectMake(20.0/375.0f*kBaseScreenWidth,( kBaseScreenHeight-kBaseScreenWidth)/2.0, kBaseScreenWidth-40, kBaseScreenWidth-40);
        }else{
            
            _editIMG.frame = LPRectMake( 20.0/375.0f*kBaseScreenWidth, (kBaseScreenHeight-self.hwScale*kBaseScreenWidth)/2.0, kBaseScreenWidth-40, self.hwScale*(kBaseScreenWidth-40));
            /*
            _editIMG.image = [self getImage];
             */
        }
        [_editIMG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@%@%@",[NSUserDefaults hotelHost],[NSUserDefaults hotelPort],self.userInfo.headImg]] placeholderImage:[UIImage imageNamed:@"user_header"]];
        [self.view addSubview: _editIMG];
        _editIMG.backgroundColor = [UIColor grayColor];
        _editIMG.layer.masksToBounds = YES;
        _editIMG.layer.cornerRadius = _editIMG.frame.size.width/2.0f;
        _editIMG.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [self.editIMG addGestureRecognizer:tap];
        [tap addTarget:self action:@selector(tap:)];
    }
    return _editIMG;
}


-(UIView *)selectPhotoView
{
    if (_selectPhotoView == nil) {
        _selectPhotoView = [UIView new];
        [self.view addSubview:_selectPhotoView];
        _selectPhotoView.backgroundColor = kColor(0, 0, 0, 0.3);
        [_selectPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@0);
            make.top.mas_equalTo(@0.0);
            make.width.mas_equalTo(@(kScreenWidth));
            make.height.mas_equalTo(@(kScreenHeight+kScaleNum(160)+SafeFooterHeight));
        }];
        
        //拍摄 从相册选择Btn
        for (int i = 0; i < 2; i++) {
            UIButton * btn = [UIButton new];
            btn.tag = i;
            [btn setTitle:upLoadPhotoWayArr[i] forState:UIControlStateNormal];
            if (btn.tag == 0||btn.tag == 1) {
                UILabel *sepLabel = [UILabel new];
                [btn addSubview:sepLabel];
                sepLabel.backgroundColor = kColor(229.0, 229.0, 229.0, 1.0f);
                [sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(@0);
                    make.top.mas_equalTo(@(kScaleNum(49)));
                    make.width.mas_equalTo(@(kScreenWidth));
                    make.height.mas_equalTo(@(1));
                }];
                if (btn.tag == 0) {
                    [btn addTarget:self action:@selector(takePictureFromCamera) forControlEvents:UIControlEventTouchUpInside];
                }
                else if (btn.tag == 1) {
                    [btn addTarget:self action:@selector(takePictureFromPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
                }
            }else{
                
            }
            btn.backgroundColor = kColor(255.0, 255.0, 255.0, 1.0);
            [btn setTitleColor:kGreenColor forState:UIControlStateNormal];
            [_selectPhotoView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(@0);
                make.bottom.mas_equalTo(kScaleNum(50*i) - kScaleNum(108) - SafeFooterHeight);
                make.width.mas_equalTo(@(kScreenWidth));
                make.height.mas_equalTo(@(kScaleNum(50)));
            }];
        }
        
        UILabel * sepLabel = [UILabel new];
        [_selectPhotoView addSubview:sepLabel];
        sepLabel.backgroundColor = kColor(229.0, 229.0, 229.0, 1.0f);
        [sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@0);
            make.bottom.mas_equalTo(@(kScaleNum(-50)-SafeFooterHeight));
            make.width.mas_equalTo(@(kScreenWidth));
            make.height.mas_equalTo(@(kScaleNum(8)));
        }];
        
        //取消按钮
        UIButton * cancelBtn = [UIButton new];
        [_selectPhotoView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@0);
            make.bottom.mas_equalTo(-SafeFooterHeight);
            make.width.mas_equalTo(@(kScreenWidth));
            make.height.mas_equalTo(@(kScaleNum(50)));
        }];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kColor(135.0, 135.0, 135.0, 1.0f) forState:UIControlStateNormal];
        cancelBtn.backgroundColor = kColor(255.0, 255.0, 255.0, 1.0);
        
        if (KIsiPhoneX) {
            UIView *fillView = [UIView new];
            fillView.backgroundColor = kColor(255.0, 255.0, 255.0, 1.0);
            [_selectPhotoView addSubview:fillView];
            [fillView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(@0);
                kMasHeight(SafeFooterHeight);
            }];
        }
        
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [self.selectPhotoView addGestureRecognizer:tap];
        [tap addTarget:self action:@selector(tap:)];
        
    }
    
    return _selectPhotoView;
}

#pragma mark --- 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemBackBBI:@"取消" AndTitle:@"编辑相片"];
    
    _warnLab = [UILabel new];
    _warnLab.b_font(kFont(18)).b_textColor(kYellowColor)
    .b_text(@"点击图片上传").b_textAlignment(NSTextAlignmentCenter)
    .b_frame(LPRectMake(0, 667-80, 375, 20)).b_moveToView(self.view);
    
    self.editIMG.hidden = NO;
    self.selectPhotoView.hidden = YES;
}

-(void)initUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    UIButton * listBtn = [UIButton new];
    listBtn.frame= LPRectMake(0, 0, 40, 44);
    [listBtn setTitle:@"确定" forState:UIControlStateNormal];
    [listBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [listBtn addTarget:self action:@selector(clickSubmitBtnItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:listBtn];
    self.navigationItem.rightBarButtonItem = btn_right;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFont(18);
    rightBtn.frame = LPRectMake(0, 0, 65, 45);
    [self addRightViews:@[rightBtn]];
    [rightBtn addTarget:self action:@selector(clickSubmitBtnItem) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    CGRect rect=[[info objectForKey:@"UIImagePickerControllerCropRect"]CGRectValue];
    if(image.imageOrientation!=UIImageOrientationUp )
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect) ;
    _selectImage = [UIImage imageWithCGImage:imageRef];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self saveImage:_selectImage withName:@"InForHeaderImage"];
    self.editIMG.image = [self getImage];
    self.editIMG.frame = LPRectMake( 20.0f/375.0f*kBaseScreenWidth, (kBaseScreenHeight-self.hwScale*kBaseScreenWidth)/2.0, kBaseScreenWidth-40, self.hwScale*(kBaseScreenWidth-40));
    self.selectPhotoView.hidden = YES;
}


#pragma mark --- 沙盒存取图片
-(UIImage *)getImage
{
    //读取图片
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"InForHeaderImage"];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:fullPath];
    self.hwScale = image.size.height/image.size.width;
    self.scale = image.size.width/kBaseScreenWidth;
    
    NSLog(@"%@",image);
    return image;
}


-(BOOL) saveImage:(UIImage*)image withName:(NSString*)fileName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [paths objectAtIndex:0];
    NSString* filePath = [path stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)];
    BOOL ret = [data writeToFile:filePath atomically:YES];
    return ret;
}

#pragma mark - event
//返回按钮
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//List按钮
-(void)clickListBtn
{
    //通过改变selectPhotoView的Y值做约束动画
    CGFloat OffsetY = self.selectPhotoView.hidden?kScaleNum(-160)-SafeFooterHeight:0.0;
    [self.selectPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(OffsetY));
    }];
    if(self.selectPhotoView.hidden == YES){
        self.selectPhotoView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.selectPhotoView.hidden = YES;
        }];
    }
}

//调用相机按钮
-(void)takePictureFromCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        [Alert alertWithTitle:@"提示" msg:@"此应用程序没有被授权访问的相机权限,是否前往设置?" action:xun_action(@"取消", nil) action:xun_action(@"设置", ^(UIAlertAction *action)
        {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        })];
    }
    
    UIImagePickerController *pc =
    [[UIImagePickerController alloc]init];
    pc.sourceType = UIImagePickerControllerSourceTypeCamera;
    pc.delegate = self;
    pc.allowsEditing = YES;
    [self presentViewController:pc animated:NO completion:nil];
    
    [self clickCancelBtn];
}

//相册选择图片按钮
- (void)takePictureFromPhotoAlbum
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied)
    {
        [Alert alertWithTitle:@"提示" msg:@"此应用程序没有被授权访问的相册权限,是否前往设置?" action:xun_action(@"取消", nil) action:xun_action(@"设置", ^(UIAlertAction *action)
        {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        })];
    }
    
    UIImagePickerController *pc =
    [[UIImagePickerController alloc]init];
    pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pc.delegate = self;
    pc.allowsEditing = YES;
    [self presentViewController:pc animated:NO completion:nil];
    
    [self clickCancelBtn];
}

//取消按钮
-(void)clickCancelBtn
{
    CGFloat OffsetY = self.selectPhotoView.hidden?kScaleNum(160):0.0;
    [self.selectPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(OffsetY));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.selectPhotoView.hidden = YES;
    }];
}

//响应手势点击方法
-(void)tap:(UITapGestureRecognizer*)tapGesture
{
    [self clickListBtn];
}



//点击确定按钮
-(void)clickSubmitBtnItem
{
    if (!_selectImage)
    {
        [Prompt popPromptViewWithMsg:@"请拍照或从相册选择图片" duration:2.0f];
        return;
    }
    
    _selectImage = [self imageWithMaxSide:400 sourceImage:_selectImage];
    HMImageFile *imageFile = [HMImageFile new];
    imageFile.fileName = [NSString stringWithFormat:@"%@.jpg",kUserId];
    imageFile.imageData = UIImageJPEGRepresentation(_selectImage, 0.05);
    imageFile.subPath = ImageSubPathHeadImage;
    
    //WEAKSELF
    [HTTPAPI sendServerImageFiles:@[imageFile] isToTotalSystem:IsToTotalSystemDefault
                     successBlock:^(NSURLSessionDataTask *dataTask, id dataObj)
     {
         [[SDImageCache sharedImageCache] clearDisk];
         [[SDImageCache sharedImageCache] clearMemory];
         
         [self.navigationController popViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:HMEditHeaderImgSuccessNot object:nil userInfo:@{@"img":_selectImage}];
     }failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error){
         
     }];
    
    /*
    _selectImage = [self imageWithMaxSide:300 sourceImage:_selectImage];
    
    NSData *imgData = [NSData dataWithData:UIImagePNGRepresentation(_selectImage)];
    if (imgData.length / 1024 > 50)
    {
        imgData = UIImageJPEGRepresentation(_selectImage, 50.f / imgData.length);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [HTTPAPI sendServerImageData:imgData successBlock:^(NSURLSessionDataTask *dataTask, id dataObj) {
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
     */
}

-(UIImage *)imageWithMaxSide:(CGFloat)length sourceImage:(UIImage *)image
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize imgSize = CWSizeReduce(image.size, length);
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, scale);  // 创建一个 bitmap context
    
    [image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)
            blendMode:kCGBlendModeNormal alpha:1.0];              // 将图片绘制到当前的 context 上
    
    img = UIGraphicsGetImageFromCurrentImageContext();            // 从当前 context 中获取刚绘制的图片
    UIGraphicsEndImageContext();
    
    return img;
}
static inline CGSize CWSizeReduce(CGSize size, CGFloat limit) // 按比例减少尺寸
{
    CGFloat max = MAX(size.width, size.height);
    if (max < limit) {
        return size;
    }
    
    CGSize imgSize;
    CGFloat ratio = size.height / size.width;
    
    if (size.width > size.height) {
        imgSize = CGSizeMake(limit, limit*ratio);
    } else {
        imgSize = CGSizeMake(limit/ratio, limit);
    }
    
    return imgSize;
}

@end
