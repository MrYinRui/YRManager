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
//  HMCheckInAPI.h
//  HotelManager-Pad
//
//  Created by xun on 17/1/5.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import "HTTPAPI.h"

@interface HMCheckInAPI : HTTPAPI

@property (nonatomic, copy) NSString *guid;     //!<订单
@property (nonatomic, readonly) int forceCheckIn;

@property (nonatomic, copy) NSString *noMessageCheckIn;//!<无信息入住(无信息入住  1是，其他否（根据酒店后台设定）)

#pragma mark - 以下属性非后台所需

@property (nonatomic, assign) BOOL ignorePay;       //!<忽略支付、即欠款入住
@property (nonatomic, assign) BOOL ignoreUnclean;   //!<忽略脏房、即不换房入住

@end
