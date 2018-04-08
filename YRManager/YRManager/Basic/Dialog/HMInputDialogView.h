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
//  HMInputDialogView.h
//  HotelManager-Pad
//
//  Created by xun on 16/12/21.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import "HMBasicDialogView.h"

#define kInputMobileDialogView  @"INPUT_MOBILE_DIALOG_VIEW"

/**
 *  工厂模式类，根据指导器生成相应对象
 */

@interface HMInputDialogView : HMBasicDialogView

@property (nonatomic, copy) void (^CallbackBlock)(void);    //!<回调

+ (instancetype)viewWithIdentifier:(NSString *)identifier;

@end
