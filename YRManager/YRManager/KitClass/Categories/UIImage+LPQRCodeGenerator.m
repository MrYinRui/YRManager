//
//  UIImage+LPQRCodeGenerator.m
//  Lodger-Pad
//
//  Created by xun on 10/26/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "UIImage+LPQRCodeGenerator.h"

@implementation UIImage (LPQRCodeGenerator)

+ (UIImage *)generatorQRCodeImageWithContent:(NSString *)content length:(CGFloat)length
{
    //  二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *ciImg = [filter outputImage];
    
    return [self scaleImage:ciImg length:length];
}

+ (UIImage *)compositeImage:(UIImage *)bottomImg image:(UIImage *)img
{
    float w, h, bw, bh;
    
    w = img.size.width;
    h = img.size.height;
    bw = bottomImg.size.width;
    bh = bottomImg.size.height;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bw, bh), YES, img.scale);
    [bottomImg drawInRect:CGRectMake(0, 0, bw, bh)];
    CGRect rect = CGRectMake((bw - w * kScreenScale) / 2, (bh - h * kScreenScale) / 2, w, h);
    [img drawInRect:rect];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+ (UIImage *)scaleImage:(CIImage *)img length:(int)length
{
    /*
    CGRect rect = CGRectIntegral(img.extent);
    
    CGFloat scale = length / rect.size.width;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(NULL, length, length, 8, 0, cs, kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:img fromRect:rect];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationHigh);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, rect, bitmapImage);
    
    CGImageRef scaledImg = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImg];
    */
    
    CGRect extentRect = CGRectIntegral(img.extent);
    CGFloat scale = MIN(length / CGRectGetWidth(extentRect), length / CGRectGetHeight(extentRect));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:img fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    //return [UIImage imageWithCGImage:scaledImage]; // 黑白图片
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    return newImage;
}

@end
