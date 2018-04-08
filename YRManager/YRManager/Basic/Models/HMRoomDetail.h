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
//  HMRoomDetail.h
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMRoom.h"

@interface HMRoomDetail : HMRoom


@property (nonatomic, copy) NSString *datetype;       //!<日期类型 0：今天之前的日期；1：今天 2：今天之后的日期 3:退房日期
@property (nonatomic, copy) NSString *lGuid;          //!<列表主键
@property (nonatomic, copy) NSString *houseGuid;      //!<房间主键
@property (nonatomic, copy) NSString *changeRoom;     //!<房间图片
@property (nonatomic, copy) NSString *continueLive;   //!<房间ID

@property (nonatomic, copy) NSString *price;          //!<房价
@property (nonatomic, copy) NSString *originalPrice;  //!<原房价
@property (nonatomic, copy) NSString *week;           //!<星期
@property (nonatomic, copy) NSString *date;           //!<日期

@property (nonatomic, copy) NSString *zbGuid;         //!<订单主键


@end
