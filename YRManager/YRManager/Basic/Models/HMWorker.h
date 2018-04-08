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
//  HMWorker.h
//  HotelManager-Pad
//
//  Created by xun on 17/2/21.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 工作人员
 */
@interface HMWorker : NSObject

@property (nonatomic, copy) NSString *name;     //!<姓名
@property (nonatomic, copy) NSString *phone;    //!<手机
@property (nonatomic, copy) NSString *guid;     //!<guid
@property (nonatomic, copy) NSString *Id;       //!<

@end
