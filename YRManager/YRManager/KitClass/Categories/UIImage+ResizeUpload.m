//
//  UIImage+ResizeUpload.m
//  HotelManager
//
//  Created by Se7en on 25/01/2018.
//  Copyright © 2018 samsoft. All rights reserved.
//

#import "UIImage+ResizeUpload.h"


@implementation UIImage (ResizeUpload)

+ (void)uploadImages:(NSArray <UIImage *> *)images
             subPath:(ImageSubPath)subPath
     isToTotalSystem:(IsToTotalSystem)isToTotalSystem
         targetWidth:(CGFloat)width
   desireBytesLength:(NSInteger)bytesLength
accuracyOfBytesLength:(NSInteger)accuracy
       uploadSuccess:(uploadSuccess)uploadBlock
         failedBlock:(FailedBlock)failedBlock
{
    
    if(images.count > 0){
        
        NSMutableArray<HMImageFile *> *marr = [NSMutableArray array];
        
        [Prompt popPromptViewWithMsg:@"图片处理中,请稍等..." duration:1.0 center:[UIApplication sharedApplication].keyWindow.center];
        //多线程处理图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            dispatch_group_t downloadGroup = dispatch_group_create(); // 2
            
            for (NSInteger i = 0; i < images.count; i ++)
            {
                dispatch_group_enter(downloadGroup); // 3
                
                HMImageFile *imageFile = [HMImageFile new];
                //            UIImage *scaleImage = [self imageTo576x432Scale:img];
                //            imageFile.imageData = UIImageJPEGRepresentation(scaleImage, 0.001f);
                NSData *imageData = [self compressImageWithImage:images[i] aimWidth:1024 aimLength:100 * 1024 accuracyOfLength:1024];
                imageFile.imageData = imageData;
                
                imageFile.subPath = subPath;
                [marr addObject:imageFile];
                
                dispatch_group_leave(downloadGroup);
                
            }
            dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER); // 5
            dispatch_async(dispatch_get_main_queue(), ^{ // 6
                //刷新
                [HTTPAPI sendServerImageFiles:marr isToTotalSystem:isToTotalSystem successBlock:^(NSURLSessionDataTask *dataTask, id dataObj) {
                    NSMutableArray <NSString *>*urlMarr = [NSMutableArray array];
                    for (int i = 0; i < images.count; i++) {
                        NSString *key = [NSString stringWithFormat:@"files[%d].type",i];
                        [urlMarr addObject:dataObj[key]];
                    };
                    
                    uploadBlock(urlMarr);
                    
                } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
                    failedBlock(dataTask,error);
                }];
            });
        });
    }
}

//😅 网上找的
/**
 *  压缩图片质量
 *  aimWidth:  （宽高最大值）
 *  aimLength: 目标大小，单位：字节（b）
 *  accuracyOfLength: 压缩控制误差范围(+ / -)
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimWidth:(CGFloat)width aimLength:(NSInteger)length accuracyOfLength:(NSInteger)accuracy{
    if (!image) {
        return nil;
    }
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    CGSize  aimSize;
    if (width >= imgWidth) {
        aimSize = image.size;
    }else{
        aimSize = CGSizeMake(width, width*imgHeight/imgWidth);
    }
    UIImage * newImage = [self imageWithImage:image scaledToSize:aimSize];
    
    NSData  * data = UIImageJPEGRepresentation(newImage, 1);
    NSInteger imageDataLen = [data length];
    
    if (imageDataLen <= length + accuracy) {
        return data;
    }else{
        NSData * imageData = UIImageJPEGRepresentation( newImage, 0.99);
        if (imageData.length < length + accuracy) {
            return imageData;
        }
        
        CGFloat maxQuality = 1.0;
        CGFloat minQuality = 0.0;
        int flag = 0;
        
        while (1) {
            @autoreleasepool {
                CGFloat midQuality = (maxQuality + minQuality)/2;
                
                if (flag >= 6) {
                    NSData * data = UIImageJPEGRepresentation(newImage, minQuality);
                    return data;
                }
                flag ++;
                
                NSData * imageData = UIImageJPEGRepresentation(newImage, midQuality);
                NSInteger len = imageData.length;
                
                if (len > length+accuracy) {
                    maxQuality = midQuality;
                    continue;
                }else if (len < length-accuracy){
                    minQuality = midQuality;
                    continue;
                }else{
                    return imageData;
                    break;
                }
            }
        }
    }
}

//指定压缩尺寸
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    if (!image) {
        return nil;
    }
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)imageTo576x432Scale:(UIImage *)originImage{
    CGSize originSize = originImage.size;
    CGFloat scale = 0.0;
    
    UIImage *scaleImage;
    if (originSize.height  > 576.0) {
        scale = 576.0 / originSize.height;
    }else{
        scale  = originSize.height / 576.0;
    }
    scaleImage = [UIImage imageWithCGImage:[originImage CGImage] scale:scale orientation:originImage.imageOrientation];
    return scaleImage;
}



@end
