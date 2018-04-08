//
//  NSString+URL.h
//  GoGoFun
//
//  Created by 塞米酒店 on 16/2/18.
//  Copyright © 2016年 GoGoFun. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(short, ImgSize)
{
     ImgSize_120_120,
     ImgSize_176_176,
     ImgSize_360_270,
     ImgSize_750_563,
     ImgSizeEncoded,//相片解码
     ImgSize_Default = ImgSize_750_563
};

@interface NSString (URL)

- (NSString *)URLEncodedString;

+ (NSURL *)picURLWithString:(NSString *)urlString type:(ImgSize)imgSize;

+ (NSString *)noHostPortPicAddressWithString:(NSString *)urlString type:(ImgSize)imgSize;


@end
