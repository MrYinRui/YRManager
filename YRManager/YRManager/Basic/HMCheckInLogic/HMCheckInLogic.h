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
//  HMCheckInLogic.h
//  HotelManager-Pad
//
//  Created by xun on 17/3/2.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMOrder;

/// 入住逻辑
@interface HMCheckInLogic : NSObject

@property (nonatomic, copy) void (^CheckinBlock)(BOOL success); //!<入住回调

+ (instancetype)logicWithOrder:(HMOrder *)order vc:(UIViewController *)vc;


/**
 刷新订单信息再办理入住
 */
- (void)executeWithFreshOrder;

/**
 执行入住逻辑
 */
//- (void)execute;
- (void)commonExecute;

/**
 换房后入住
 */
- (void)executeAfterChangeRoom;

/**
 判断是否有入住人登记信息

 @return 是否有人登记
 */
//- (BOOL)isAnybodyRecordInfo;

- (BOOL)isNeedPay;

- (BOOL)isRoomClean;

@end
