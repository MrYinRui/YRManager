//
//  HMPayFootView.m
//  HotelManager
//
//  Created by YR on 2017/3/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPayFootView.h"
#import "HMPhotoDialog.h"
#import "HMPhotoLibraryVC.h"
#import "HMPhotoManager.h"
#import "HTTPAPI.h"
#import "HMRemarkTextView.h"

#define kCloseBtnTag        1000

@interface HMPayFootView ()<HMActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray    *imgData;
@property (nonatomic, strong) UIScrollView      *imgScroll;
@property (nonatomic, strong) UIButton          *remarkbtn;

@property (nonatomic, assign) NSInteger         selectCount;

@end

@implementation HMPayFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        self.selectCount = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self.imgData addObject:@"camera"];
        [self initUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectLibraryBack:) name:PhotoLibrarySelectedAssetNotification object:nil];
    }
    return self;
}

- (void)removeAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 相册选择成功返回
- (void)selectLibraryBack:(NSNotification *)not
{
    if(not.userInfo[kPhotoWantedSourceKey] != self){
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
            if (self.imgData.count + imgArr.count == _limit+1)
            {
                [self.imgData removeObjectAtIndex:0];
            }
            else if (self.imgData.count + imgArr.count > _limit+1)
            {
                [Prompt popPromptViewWithMsg:[NSString stringWithFormat:@"附件最多可添加%ld张",_limit] duration:1.5];
                return ;
            }
            [self.imgData addObjectsFromArray:imgArr];
            [self insertImg:_imgData];
        });
    });
}

- (void)initUI
{
    UIView *line = [UIView new];
    line.b_bgColor(kColor(230, 230, 230, 1))
    .b_frame(LPRectMake(20, 50, 355, 1)).b_moveToView(self);
    
    NSArray *arr = @[@"附件",@"备注"];
    for (NSInteger i = 0; i < 2; i ++)
    {
        UILabel *lab = [UILabel new];
        lab.b_text(arr[i]).b_font(kFont(15))
        .b_textAlignment(NSTextAlignmentRight).b_textColor(kColor(130, 130, 130, 1))
        .b_frame(LPRectMake(0, 50*i, 50, 50)).b_moveToView(self);
    }
    
    _imgScroll = [UIScrollView new];
    _imgScroll.b_bgColor([UIColor whiteColor])
    .b_frame(LPRectMake(50, 0, 325, 50)).b_moveToView(self);
    
    [self insertImg:_imgData];
    
    _remarkbtn = [UIButton new];
    _remarkbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _remarkbtn.b_image([UIImage imageNamed:@"arrow_right"],UIControlStateNormal)
    .b_imageEdgeInsets(UIEdgeInsetsMake(0, 0, 0, kScaleNum(20)))
    .b_frame(LPRectMake(50, 50, 325, 50)).b_moveToView(self);
    [_remarkbtn addTarget:self action:@selector(remarkAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setRemark:(NSString *)remark
{
    _remark = remark;
    
    if ([[_remark stringByReplacingOccurrencesOfString:@" " withString:@""] length])
    {
        [self.remarkbtn setImage:[UIImage imageNamed:@"msg_01"] forState:UIControlStateNormal];
    }
    else
    {
        [self.remarkbtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    }
}

//备注
- (void)remarkAction
{
    HMRemarkTextView *remarkAlert = [HMRemarkTextView remarkTextView];
    remarkAlert.remark = _remark;
    [remarkAlert showWithAnimationOnView:self.viewController.view];
    
    WEAKSELF
    remarkAlert.RemarkTextBlock = ^(NSString *str)
    {
        weakSelf.remark = str;
        if (_RemarkBlock)
        {
            _RemarkBlock(str);
        }
        if ([[str stringByReplacingOccurrencesOfString:@" " withString:@""] length])
        {
            [weakSelf.remarkbtn setImage:[UIImage imageNamed:@"msg_01"] forState:UIControlStateNormal];
        }
        else
        {
            [weakSelf.remarkbtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        }
    };
}

//附件
- (void)insertImg:(NSArray *)imgArr
{
    if(imgArr != _imgData){
        self.imgData = (NSMutableArray *)imgArr;
    }
    
    for (UIView *view in _imgScroll.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSMutableArray *blockArr = [NSMutableArray new];
    if (imgArr.count == 1)
    {
        UIImageView *img = [UIImageView new];
        
        UIImage *image = nil;
        if ([imgArr.firstObject isKindOfClass:[NSString class]])
        {
            img.contentMode = UIViewContentModeCenter;
            image = [UIImage imageNamed:imgArr.firstObject];
        }
        else if ([imgArr.firstObject isKindOfClass:[UIImage class]])
        {
            img.contentMode = UIViewContentModeScaleToFill;
            image = imgArr.firstObject;
        }
        img.b_image(image)
        .b_userInteractionEnabled(YES)
        .b_frame(LPRectMake(325-45, 2.5, 45, 45)).b_moveToView(_imgScroll);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImgTap)];
        [img addGestureRecognizer:tap];
    }
    else
    {
        for (id img in imgArr)
        {
            NSInteger i = [imgArr indexOfObject:img];
            UIImageView *imgView = [UIImageView new];
            if ([img isKindOfClass:[NSString class]])
            {
                imgView.contentMode = UIViewContentModeCenter;
                imgView.image = [UIImage imageNamed:img];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImgTap)];
                [imgView addGestureRecognizer:tap];
            }
            else if ([img isKindOfClass:[UIImage class]])
            {
                imgView.contentMode = UIViewContentModeScaleToFill;
                imgView.image = img;
                
                UIButton *closeBtn = [UIButton new];
                closeBtn.tag = kCloseBtnTag + i;
                closeBtn.b_image([UIImage imageNamed:@"btn_close_03"],UIControlStateNormal)
                .b_frame(LPRectMake(30, 0, 15, 15)).b_moveToView(imgView);
                [closeBtn addTarget:self action:@selector(closeImgAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [blockArr addObject:img];
            }
            
            CGFloat x = 50*(imgArr.count-i);
            imgView.b_userInteractionEnabled(YES)
            .b_frame(LPRectMake(325-x, 2.5, 45, 45)).b_moveToView(_imgScroll);
        }
    }

    if (_AttachmentBlock)
    {
        _selectCount = blockArr.count;
        _AttachmentBlock(blockArr);
    }
}

- (void)addImgTap
{
    HMPhotoDialog *photoDialog = [HMPhotoDialog photoDialogWithDataSource:kDefaultDataSource];
    photoDialog.delegate = self;
    
    [photoDialog show];
}

#pragma mark --- HMActionSheet Delegate
- (void)actionSheet:(HMActionSheet *)actionSheet didSelectRow:(NSInteger)row{
    
    if (row == 0)
    {//拍照
        [self takePhoto];
        [actionSheet hide];
    }
    else if (row == 1)
    {//从相册选择
        [self selectFromPhotoLibrary];
        [actionSheet hide];
    }
}

#pragma mark --- UIImagePickerViewController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *takePicture = info[UIImagePickerControllerOriginalImage];
    if (takePicture)
    {
        if (self.imgData.count > _limit)
        {
            [Prompt popPromptViewWithMsg:[NSString stringWithFormat:@"附件最多可添加%ld张",_limit-_selectCount] duration:1.5];
            return;
        }
        else if (self.imgData.count == _limit)
        {
            [self.imgData removeObjectAtIndex:0];
        }
        
        [self.imgData addObject:takePicture];
        [self insertImg:_imgData];
        
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)takePhoto
{
    //1.0 请求用户授权相机
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self.viewController.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)selectFromPhotoLibrary
{
    HMPhotoLibraryVC *vc = [HMPhotoLibraryVC new];
    vc.maxImageCount = _limit-_selectCount;
    vc.source        = self;
    
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)closeImgAction:(UIButton *)btn
{
    [self.imgData removeObjectAtIndex:btn.tag - kCloseBtnTag];
    if (![self.imgData.firstObject isKindOfClass:[NSString class]])
    {
        [self.imgData insertObject:@"camera" atIndex:0];
    }
    [self insertImg:_imgData];
}

#pragma mark -- LazyInit
- (NSMutableArray *)imgData
{
    if (!_imgData)
    {
        _imgData = [NSMutableArray new];
    }
    return _imgData;
}

@end
