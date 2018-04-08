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
//  HMRoomDetail.m
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMRoomDetail.h"


@implementation HMRoomDetail


+(NSDictionary *)replaceKeyDict
{
    
    return @{
             @"guid" : @"lGuid",
             @"ishuanfang" : @"changeRoom",
             @"isxuzhu" : @"continueLive",
             @"qrfj" : @"price",
             @"yfj" : @"originalPrice",
             @"rq" : @"date",
             };
}

@end
