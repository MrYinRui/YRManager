//
//  UIDevice+LPGetIP.m
//  Lodger-Pad
//
//  Created by xun on 11/4/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "UIDevice+LPGetIP.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation UIDevice (LPGetIP)

+ (NSString *)currentIP
{
    NSString *ip = @"Error";
    
    struct ifaddrs *interface = NULL;
    
    if (getifaddrs(&interface) == 0)    //获取IP地址成功
    {
        struct ifaddrs *pInterface = interface;//Interface游标，指向interfere列表中的任意一个
        
        while (pInterface)
        {
            if ((   (0 == strcmp(pInterface->ifa_name, "en0")) ||   //局域网
                 (0 == strcmp(pInterface->ifa_name, "pdp_ip0"))  //手机卡IP
                 ) && pInterface->ifa_addr->sa_family == AF_INET)       //网络标识为AF_INET（ipv4网络接口套接字）
            {
                ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)pInterface->ifa_addr)->sin_addr)];
                freeifaddrs(interface);
                return ip;
            }
            
            pInterface = pInterface->ifa_next;  //指向下一个interface
        }
    }
    
    freeifaddrs(interface);
    return ip;
}

@end
