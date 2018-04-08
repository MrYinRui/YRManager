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
//  HMRoomPrice.h
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRoomPrice : NSObject<NSMutableCopying,NSCopying>

@property (nonatomic, copy) NSString *bz;             //!<备注
@property (nonatomic, copy) NSString *changehouseday; //!<换房天数
@property (nonatomic, copy) NSString *csId;           //!<00001
@property (nonatomic, copy) NSString * guid;          //!<房价信息Guid
@property (nonatomic, copy) NSString *houseguid;      //!<房间主键
@property (nonatomic, assign) CGFloat pricesum; //!<房间合计价格

@property (nonatomic, copy) NSString * date;      //!<日期 yyyy-MM-dd
@property (assign,nonatomic) double discountRoomPrice;      //!<确认房价
@property (assign,nonatomic) double discountProtocolPrice;  //!<确认协议价格
@property (assign,nonatomic) double protocolRate;           //!<协议折扣（小数）
@property (assign,nonatomic) double rate;//!<折扣(小数)  (0.80)代表8折  无折扣 1 , 自定义为 0
@property (nonatomic, copy) NSString *syncStatus; //!<同步状态

@property (nonatomic, assign) double beforeRoomPrice;//!<换房之前房间价格
@property (nonatomic, assign) double beforeOriginRoomPrice;//!<换房之前房间原价格
@property (assign) double originRoomPrice;//!<130 原房价
@property (nonatomic, copy) NSString *zbguid;//!<订单主键

@property (nonatomic, copy) NSString * isExchangeRoom;//!<是否换房（0否1是）
@property (nonatomic, copy) NSString * isLiveMore;    //!<是否续住（0否1是）
@property (nonatomic, assign) double  differencePrice;//!<换房差额(自定义的参数)
@property (nonatomic, assign) double balance;//!<后台新接口(换房差额)
@property (assign) double ts;             //!<1
@property (nonatomic, copy) NSString * zt;//!<“0”

@property (nonatomic, assign) double originRate; //!<原房价折扣

//以后属性只有特定的类拥有,使用的时候注意
@property (nonatomic, assign) double price; //!<房间价格
@property (nonatomic, assign) double yuanjia; //!<房间原价

// 以下属性为修改房费转字典使用
@property (nonatomic, assign) double qrfj;  //!<确认房价(需要转字典所以暂时不改名)
@property (nonatomic, assign) double djzk;  //单价折扣
@property (nonatomic, assign) double xyzk;  //!<协议折扣
@property (nonatomic, assign) double qrxyj; //!<确认协议价

//订单设置用
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL changed;

@end
