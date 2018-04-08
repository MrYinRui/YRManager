//
//  NSString+URL.m
//  GoGoFun
//
//  Created by 塞米酒店 on 16/2/18.
//  Copyright © 2016年 GoGoFun. All rights reserved.
//

#import "NSString+URL.h"

#define kSizeJpeg @[@"-120X120.jpeg",@"-176X176.jpeg",@"-360X270.jpeg",@".jpeg",@".jpeg"]
#define kSizeJpg @[@"-120X120.jpg",@"-176X176.jpg",@"-360X270.jpg",@".jpg",@".jpg"]
#define kSizePng @[@"-120X120.png",@"-176X176.png",@"-360X270.png",@".png",@".png"]
#define kSizeGif @[@"-120X120.gif",@"-176X176.gif",@"-360X270.gif",@".gif",@".gif"]

@implementation NSString (URL)

- (NSString *) URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    
    //encodedString = [self encodeToPercentEscapeString:encodedString];
    
    return encodedString;
}

//二次转码
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

+ (NSURL *)picURLWithString:(NSString *)urlString type:(ImgSize)imgSize
{
    NSString *url = [NSString stringWithFormat:@"http://%@%@/%@", [NSUserDefaults hotelHost], [NSUserDefaults hotelPort], [self noHostPortPicAddressWithString:urlString type:imgSize]];
    
    return [NSURL URLWithString:url];
}

+ (NSString *)noHostPortPicAddressWithString:(NSString *)urlString type:(ImgSize)imgSize
{
    if (imgSize == ImgSizeEncoded)
    {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSRange range = [urlString rangeOfString:@"/WEB-INF/attachment/"];
    if (range.length == 0) {
        return nil;
    }
    
    NSString *cutStr = [urlString substringFromIndex:range.location+range.length-1];
    NSString *newStr;
    
    NSRange jpgRange = [cutStr rangeOfString:@".jpg" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
    if (jpgRange.length != 0)
    {
        cutStr = [cutStr substringToIndex:jpgRange.location];
        newStr = [NSString stringWithFormat:@"%@%@",cutStr,kSizeJpg[imgSize]];
    }
    else
    {
        NSRange pngRange = [cutStr rangeOfString:@".png" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
        if (pngRange.length != 0)
        {
            cutStr = [cutStr substringToIndex:pngRange.location];
            newStr = [NSString stringWithFormat:@"%@%@",cutStr,kSizePng[imgSize]];
        }
        else
        {
            NSRange gifRange = [cutStr rangeOfString:@".gif" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
            if (gifRange.length != 0)
            {
                cutStr = [cutStr substringToIndex:gifRange.location];
                newStr = [NSString stringWithFormat:@"%@%@",cutStr,kSizeGif[imgSize]];
            }
            else
            {
                NSRange jpegRange = [cutStr rangeOfString:@".jpeg" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
                if (jpegRange.length != 0)
                {
                    cutStr = [cutStr substringToIndex:jpegRange.location];
                    newStr = [NSString stringWithFormat:@"%@%@",cutStr,kSizeJpeg[imgSize]];
                }
            }
        }
    }
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [newStr dataUsingEncoding:gbkEncoding];
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    NSString *newBase64Encoded = [base64Encoded stringByReplacingOccurrencesOfString:@"+" withString:@"|"];
    NSString *noHostPort = [NSString stringWithFormat:@"%@%@", @"engine/showfile.jsp?t=0&f=",newBase64Encoded];
    
    return noHostPort;
}


@end
