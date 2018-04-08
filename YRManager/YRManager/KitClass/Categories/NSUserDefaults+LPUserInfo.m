//
//  NSUserDefaults+LPUserInfo.m
//  Lodger-Pad
//
//  Created by xun on 9/24/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "NSUserDefaults+LPUserInfo.h"

#define kLoginStatusKey @"LOGIN_STATUS_KEY"

#define kServerInfoKey  @"SERVER_INFO_KEY"
#define kHotelHostKey   @"HOTEL_HOST_KEY"
#define kHotelPortKey   @"HOTEL_PORT_KEY"
#define kHotelCsIdKey   @"HOTEL_CSID_KEY"

#define kHotelMainHostKey @"HOTEL_MAIN_HOST_KEY"
#define kHotelMainPortKey @"HOTEL_MAIN_PORT_KEY"

@implementation NSUserDefaults (LPUserInfo)

+ (LPLoginStatus)loginStatus
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kLoginStatusKey] intValue];
}

+ (void)setLoginStatus:(LPLoginStatus)status
{
    if (status != [NSUserDefaults loginStatus])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:LPNotiLoginStatusChanged
//                                                                object:nil
//                                                              userInfo:@{LPNotiLoginStatusKey:@(status)}];
        });
        
        [[NSUserDefaults standardUserDefaults] setValue:@(status) forKey:kLoginStatusKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end

@implementation NSUserDefaults (LPHotelInfo)

+ (void)saveHotelHost:(NSString *)IP port:(NSString *)port
{
    NSDictionary *dict = @{kHotelHostKey:IP, kHotelPortKey:port};
    
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:kServerInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveHotelCsId:(NSString *)csId
{
    [[NSUserDefaults standardUserDefaults] setValue:csId forKey:kHotelCsIdKey];
}

+ (NSString *)hotelHost
{
    return [[kUserDefault valueForKey:kServerInfoKey] valueForKey:kHotelHostKey];
//    return @"192.168.1.66";
}

+ (NSString *)hotelPort
{
    NSString *port = [[kUserDefault valueForKey:kServerInfoKey] valueForKey:kHotelPortKey];
    port = [NSString stringWithFormat:@"%@",port];
    if ([port isEqualToString:@"80"])
    {
        return @"";
    }
    return [NSString stringWithFormat:@":%@",port];
//    return @"8888";
}

+ (NSString *)hotelCsId
{
    return [kUserDefault valueForKey:kHotelCsIdKey];
//    return nil;
}


+ (void)saveMainHotelHost:(NSString *)IP port:(NSString *)port
{
    [kUserDefault setValue:IP forKey:kHotelMainHostKey];
    [kUserDefault setValue:port forKey:kHotelMainPortKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)mainHotelHost
{
    return [kUserDefault valueForKey:kHotelMainHostKey];
    //    return @"192.168.1.66";
}

+ (NSString *)mainHotelPort
{
    NSString *port = [kUserDefault valueForKey:kHotelMainPortKey];
    port = [NSString stringWithFormat:@"%@",port];
    if ([port isEqualToString:@"80"])
    {
        return @"";
    }
    return [NSString stringWithFormat:@":%@",port];
    //    return @"8888";
}

@end
