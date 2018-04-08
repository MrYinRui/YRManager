//
//  \\      //     ||          ||     ||\        ||
//   \\    //      ||          ||     ||\\       ||
//    \\  //       ||          ||     || \\      ||
//     \\//        ||          ||     ||  \\     ||
//      /\         ||          ||     ||   \\    ||
//     //\\        ||          ||     ||    \\   ||
//    //  \\       ||          ||     ||     \\  ||
//   //    \\      ||          ||     ||      \\ ||
//  //      \\      \\        //      ||       \\||
// //        \\      \\======//       ||        \||
//
//
//  HMHuayuan.m
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMHuayuan.h"
#import "MJExtension.h"

@implementation HMHuayuan

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"note":@"bz",
             @"address":@"hydz",
             @"name":@"hymc",
             @"bedType":@"chuangxing",
             
             @"roomFaci":@"fnss",
             @"guid":@"fxGuid",
             @"roomCount":@"houseNumber",
             @"jingGuan":@"jg",
             @"jingGuan":@"jingguan",
             
             @"kuanDai":@"kuandai",
             @"liveCount":@"kzrs",
             @"area":@"mianji",
             @"breakfast":@"zaocan",
             };
}


@end
