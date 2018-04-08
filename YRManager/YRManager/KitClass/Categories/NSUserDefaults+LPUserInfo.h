//
//  NSUserDefaults+LPUserInfo.h
//  Lodger-Pad
//
//  Created by xun on 9/24/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    LOGIN_OUT,      //!<未登录
    LOGIN_OFFLINE,  //!<离线
    LOGIN_ONLINE    //!<在线
} LPLoginStatus;

@interface NSUserDefaults (LPUserInfo)

+ (LPLoginStatus)loginStatus;
+ (void)setLoginStatus:(LPLoginStatus)status;

@end

@interface NSUserDefaults (LPHotelInfo)

+ (void)saveHotelHost:(NSString *)IP port:(NSString *)port;
+ (void)saveHotelCsId:(NSString *)csId;

/**
 获取酒店IP地址
 
 @return IP地址
 */
+ (NSString *)hotelHost;
+ (NSString *)hotelPort;
+ (NSString *)hotelCsId;

/**
 主酒店
 */
+ (void)saveMainHotelHost:(NSString *)IP port:(NSString *)port;

+ (NSString *)mainHotelHost;

+ (NSString *)mainHotelPort;

@end
