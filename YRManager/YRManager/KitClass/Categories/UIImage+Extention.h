//
//  UIImage+Extention.h
//  Lodger-Pad
//
//  Created by kqz on 16/10/20.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extention)

//抗锯齿
- (UIImage *)antiAlias;

//缩放
- (UIImage *)scaleToSize:(CGSize)size;

//倒影
- (UIImage *)reflectionWithHeight:(int)height;
- (UIImage *)reflectionWithAlpha:(float)pcnt;
- (UIImage *)reflectionRotatedWithAlpha:(float)pcnt;

//处理酒店详情倒影定制图片
+(UIImage *)mergeReflectionImage:(UIImage *) originalImage;

@property (nonatomic, strong) NSString *sign;  //!<标记符号


/**根据 颜色 生成对应 尺寸 的图片*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//创建颜色背景
+(UIImage*) createImageWithColor:(UIColor*) color;
@end

