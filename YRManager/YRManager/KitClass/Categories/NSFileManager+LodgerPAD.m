//
//  NSFileManager+LodgerPAD.m
//  Lodger-Pad
//
//  Created by xun on 10/27/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "NSFileManager+LodgerPAD.h"

@implementation NSFileManager (LodgerPAD)

+ (BOOL)initializeFileSystem
{
    NSString *dir = [[self cacheDirectory] stringByAppendingString:@"/hotel"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:dir])
    {
       return [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return YES;
}

+ (NSString *)cacheDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (BOOL)createDirectoryWithUser:(NSString *)userPhone
{
    NSString *dir = [[self cacheDirectory] stringByAppendingPathComponent:userPhone];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:dir])
    {
        NSError *error = nil;
        BOOL success;
        success = [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success)
        {
            HMLog(@"%@", error.localizedDescription);
            return NO;
        }
        
        NSArray *dirArr = @[[self commentDirectory], [self userAuthHeaderDirectory], [self archiveDataDirectory]];
        
        for (NSString *dir in dirArr)
        {
            success = [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
            
            if (!success)
            {
                HMLog(@"%@", error.localizedDescription);
                return NO;
            }
        }
    }
    
    return YES;
}

+ (NSString *)commentDirectory
{
    if ([NSUserDefaults loginStatus] == LOGIN_OUT)
    {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@/%@/comment", [self cacheDirectory], kMobilephone];
}

+ (NSString *)userAuthHeaderDirectory
{
    if ([NSUserDefaults loginStatus] == LOGIN_OUT)
    {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@/%@/authHead", [self cacheDirectory], kMobilephone];
}

+ (NSString *)archiveDataDirectory
{
    if ([NSUserDefaults loginStatus] == LOGIN_OUT)
    {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@/%@/archive", [self cacheDirectory], kMobilephone];
}

+ (NSString *)confirmOrderAttachmentDirectory
{
    NSString *imagePath = @"confirmOrderAttachmentImage.jpg";
    
    return [NSTemporaryDirectory() stringByAppendingPathComponent:imagePath];
}

+ (BOOL)clearConfirmOrderAttachmentDirectory
{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    BOOL exist = [fileManage fileExistsAtPath:[self confirmOrderAttachmentDirectory]];
    
    if (exist)
    {
        NSError *error;
      
     return  [fileManage removeItemAtPath:[self confirmOrderAttachmentDirectory] error:&error];
    }
    
    return NO;
}


@end

@implementation NSFileManager (Plist)

+ (NSDictionary *)orderOperationDictionary
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WorkList" ofType:@"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return dict[@"OrderOperation"];
}

+ (NSDictionary *)orderStatusIconDictionary
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WorkList" ofType:@"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return dict[@"OrderStatusIcon"];
}

@end

@implementation NSFileManager (WintonSDK)

+ (NSString *)credentialsImgPath
{
    return [[self cacheDirectory] stringByAppendingString:@"credentials.jpg"];
}

+ (NSString *)credentialsHeadImgPath
{
    return [[self cacheDirectory] stringByAppendingString:@"head.jpg"];
}

@end
