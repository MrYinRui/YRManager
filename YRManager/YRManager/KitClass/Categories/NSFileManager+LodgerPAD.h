//
//  NSFileManager+LodgerPAD.h
//  Lodger-Pad
//
//  Created by xun on 10/27/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

LP_EXTERN NSString * const LPCommentCacheDataDirectory;

@interface NSFileManager (LodgerPAD)


/**
 初始化文件系统（App文件内部构造）

 @return 初始化结果
 */
+ (BOOL)initializeFileSystem;


/**
 创建用户文件夹，一般用于缓存用户数据
 
 @param userPhone 用户手机号

 @return 创建结果
 */
+ (BOOL)createDirectoryWithUser:(NSString *)userPhone;


/**
 用户评论缓存文件路径（只允许当前用户访问），如未登录则返回为空

 @return 用户评论缓存文件路径
 */
+ (NSString *)commentDirectory;


/**
 获取缓存文件路径

 @return 缓存文件路径
 */
+ (NSString *)cacheDirectory;


/**
 获取用户认证头像存储路径（必须要登录）

 @return 认证头像存储路径
 */
+ (NSString *)userAuthHeaderDirectory;


/**
 归档数据缓存地址，一般用于未完成的操作

 @return 归档数据缓存地址
 */
+ (NSString *)archiveDataDirectory;


/**
 确认订单附件图片地址 (1张)

 @return 确认订单附件图片地址
 */
+ (NSString *)confirmOrderAttachmentDirectory;

+ (BOOL)clearConfirmOrderAttachmentDirectory;



@end

@interface NSFileManager (Plist)

+ (NSDictionary *)orderOperationDictionary;

+ (NSDictionary *)orderStatusIconDictionary;

@end

@interface NSFileManager (WintonSDK)

+ (NSString *)credentialsImgPath;
+ (NSString *)credentialsHeadImgPath;

@end
