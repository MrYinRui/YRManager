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
//  HMOrderConsume.h
//  HotelManager-Pad
//
//  Created by xun on 17/2/21.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMWorker.h"

@interface HMOrderConsume : NSObject

@property (nonatomic, copy) NSString *merchantId;   //!<商户ID
@property (nonatomic, assign) float price;          //!<价格
@property (nonatomic, copy) NSString *Id;           //!<消费Id
@property (nonatomic, copy) NSString *date;         //!<消费日期
@property (nonatomic, copy) NSString *orderGuid;    //!<订单guid

@property (nonatomic, assign) float count;          //!<数量
@property (nonatomic, copy) NSString *name;         //!<名称
@property (nonatomic, copy) NSString *attachmentUrl;//!<附件地址
@property (nonatomic, copy) NSString *guid;         //!<
@property (nonatomic, strong) HMWorker *worker;     //!<工作人员
@property (nonatomic, copy) NSString *operatorName; //!<操作员名字

@property (nonatomic, assign) float totalPrice;     //!<总价格
@property (nonatomic, copy) NSString *mark;         //!<备注


/*****  以下属性没卵用，你们别乱动   *******/

@property (nonatomic, assign) int typeId;           //!<类型
@property (nonatomic, assign) int ooptId;           //!<消费类型

@end
