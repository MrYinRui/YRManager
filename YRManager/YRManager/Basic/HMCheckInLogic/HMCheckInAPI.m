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
//  HMCheckInAPI.m
//  HotelManager-Pad
//
//  Created by xun on 17/1/5.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import "HMCheckInAPI.h"


@implementation HMCheckInAPI

- (NSDictionary *)parameters
{
    return @{@"guid":_guid,
             @"forceCheckIn":@(self.forceCheckIn),
             @"noMessageCheckIn":_noMessageCheckIn ? _noMessageCheckIn : @"0",};
}

- (int)forceCheckIn
{
    return _ignorePay || _ignoreUnclean;
}

- (NSString *)methodName
{
    return @"spring/order/fwddzb/checkIn";
}

@end
