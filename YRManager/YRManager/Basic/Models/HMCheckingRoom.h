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
//  HMCheckingRoom.h
//  HotelManager-Pad
//
//  Created by xun on 17/2/21.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMWorker.h"

typedef NS_ENUM(int, CheckingRoomStatus) {

    CheckingRoomStatus_
};

@class HMCheckingRoomCost;

@interface HMCheckingRoom : NSObject

@property (nonatomic, copy) NSString *urgeCheckingMan;     //!<催查人
@property (nonatomic, copy) NSString *urgeCheckingDate;    //!<催查时间
@property (nonatomic, strong) HMWorker *checkinMan;        //!<查房的人
@property (nonatomic, copy) NSString *date;                //!<查房时间
@property (nonatomic, copy) NSString *status;              //!<状态

@property (nonatomic, copy) NSString *guid;             //!<guid
@property (nonatomic, copy) NSString *orderGuid;        //!<订单guid
@property (nonatomic, copy) NSString *roomGuid;         //!<房间guid
@property (nonatomic, assign) float totalPrice;         //!<总金额
@property (nonatomic, strong) NSArray <HMCheckingRoomCost *> *costList;        //!<消费清单

@property (nonatomic, assign) BOOL isCompleteDamage;    //!<是否全损
@property (nonatomic, assign) BOOL isCheckingDamage;    //!<是否核损
@property (nonatomic, assign) BOOL isConsume;           //!<是否消费

@property (nonatomic, copy) NSString *checkManName;     //!<查房人名字

@end

typedef NS_ENUM(NSUInteger, HMCheckingRoomCostType) {
    HMCheckingRoomCostTypeMinibar,
    HMCheckingRoomCostTypeLosing,
    HMCheckingRoomCostTypeDamage,
};

@interface HMCheckingRoomCost : NSObject

@property (nonatomic, copy) NSString *name;     //!<名称
@property (nonatomic, assign) float money;      //!<金额
@property (nonatomic, assign) NSInteger total;      //!<总数
@property (nonatomic, copy) NSString *type;     //!<类型

- (HMCheckingRoomCostType)costType;

@end
