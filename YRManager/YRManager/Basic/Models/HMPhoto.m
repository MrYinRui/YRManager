//
//  HMPhoto.m
//  HotelManager
//
//  Created by YR on 2017/4/26.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPhoto.h"

@implementation HMPhoto

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"path"        : @"bigpath",
             @"upTime"      : @"times",
             @"picSize"     : @"size",
             @"picNum"      : @"pno",
             @"connectGuid" : @"fid",
             @"hotelId"     : @"cs_id",
             @"picSeq"      : @"picseq",
             @"path"        : @"pic_path"
             };
}

@end
