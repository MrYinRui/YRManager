//
//  UIImage+ResizeUpload.h
//  HotelManager
//
//  Created by Se7en on 25/01/2018.
//  Copyright © 2018 samsoft. All rights reserved.
//  图片压缩上传

#import <UIKit/UIKit.h>
#import "HTTPAPI.h"

typedef void (^uploadSuccess)(NSArray<NSString *> *imageFilePaths); //!< 服务器返回图片路径地址
@interface UIImage (ResizeUpload)

/**
 压缩上传图片  jpg 格式
 @param images UIImage图片 数组
 @param subPath 上传路径
 @param isToTotalSystem 是否上传到总系统
 @param width 最大图片像素宽高  eg. 1096
 @param bytesLength 压缩后 图片最大 大小 eg. 100 * 1024 (100Kb)
 @param accuracy 精度误差 1024(1Kb)
 @param uploadBlock HTTP上传成功回调
 @param failedBlock HTTP失败回调
 */
+ (void)uploadImages:(NSArray <UIImage *> *)images
             subPath:(ImageSubPath)subPath
     isToTotalSystem:(IsToTotalSystem)isToTotalSystem
         targetWidth:(CGFloat)width
   desireBytesLength:(NSInteger)bytesLength
accuracyOfBytesLength:(NSInteger)accuracy
        uploadSuccess:(uploadSuccess)uploadBlock
         failedBlock:(FailedBlock)failedBlock;


//😅 网上找的
/**
 *  压缩图片质量
 *  aimWidth:  （宽高最大值） 最大图片像素宽高  eg. 1096
 *  aimLength: 目标大小，单位：字节（b） 压缩后 图片最大 大小 eg. 100 * 1024 (100Kb)
 *  accuracyOfLength: 压缩控制误差范围(+ / -) 精度误差 1024(1Kb)
 */
+ (NSData *)compressImageWithImage:(UIImage *)image
                          aimWidth:(CGFloat)width
                         aimLength:(NSInteger)length
                  accuracyOfLength:(NSInteger)accuracy;

@end
