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
//  HMHuayuan.h
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMHuayuan : NSObject

@property (nonatomic, copy) NSString *note;         //!<备注
@property (nonatomic, copy) NSString *csId;         //!<酒店ID
@property (nonatomic, copy) NSString *guid;         //!<主键
@property (nonatomic, copy) NSString *address;      //!<地址
@property (nonatomic, copy) NSString *name;         //!<房型名称

@property (nonatomic, copy) NSString *bedType;      //!<床型
@property (nonatomic, copy) NSString *roomFaci;     //!<房内设施
@property (nonatomic, copy) NSNumber *roomCount;    //!<房间数量
@property (nonatomic, copy) NSString *huxing;       //!<户型
@property (nonatomic, copy) NSString *img;          //!<房型图

@property (nonatomic, copy) NSString *jingGuan;     //!<景观
@property (nonatomic, copy) NSString *kuanDai;      //!<宽带
@property (nonatomic, copy) NSNumber *liveCount;    //!<可住人数
@property (nonatomic, copy) NSNumber *lowPrice;     //!<价格
@property (nonatomic, copy) NSNumber *area;         //!<面积
@property (nonatomic, copy) NSString *breakfast;    //!<早餐

@end
