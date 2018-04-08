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
//  HMRoom.h
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMRoomPrice.h"
#import "HMHuayuan.h"
#import "HMRoomPayment.h"
#import "HMOwner.h"
#import "HMOMPayCycle.h"
#import "HMOMHotelFile.h"

@interface HMRoom : NSObject

@property (nonatomic, strong) HMHuayuan *huayuan;
@property (nonatomic, strong) HMHuayuan *fangxingInfo;      //!<房间详情需要用到
@property (nonatomic, strong) HMRoomPrice *housePrice;
@property (nonatomic, strong) NSArray <HMRoomPrice *> *roomPriceList;
@property (nonatomic, strong) NSArray <HMRoomPayment *> *roomPaymentList;

@property (nonatomic, copy) NSString *guid;           //!<主键
@property (nonatomic, copy) NSString *picUrl;         //!<房间图片
@property (nonatomic, copy) NSString *csId;           //!<房间ID
@property (nonatomic, copy) NSString *direction;      //!<朝向
@property (nonatomic, copy) NSString *phone;          //!<房间电话

@property (nonatomic, assign) double currentPrice;    //!<当前价格
@property (nonatomic, assign) double originPrice;     //!<原价格
@property (nonatomic, assign) double deposit;         //!<押金
@property (nonatomic, assign) double balance;         //!<换房差额
@property (nonatomic, copy) NSString *bleAvaliable;   //!<蓝牙锁是否可用

@property (nonatomic, copy) NSString *features;       //!<特色房间
@property (nonatomic, copy) NSString *cleanStatus;    //!<洁房状态 0洁房
@property (nonatomic, copy) NSString *isCleanRoom;    //!<0 洁房 1脏房
@property (nonatomic, copy) NSString *score;          //!<房间评分
@property (nonatomic, copy) NSString *roomNumber;     //!<楼层和房间号
@property (nonatomic, copy) NSString *houseType;      //!<房型

@property (nonatomic, copy) NSString *floor;          //!<楼层
@property (nonatomic, copy) NSString *doorNumber;     //!<门牌号
@property (nonatomic, copy) NSString *breakfast;      //!<早餐
@property (nonatomic, copy) NSString *doorModel;      //!<户型
@property (nonatomic, copy) NSString *bedModel;       //!<床型

@property (nonatomic, copy) NSString *roomArea;       //!<房间面积
@property (nonatomic, copy) NSString *limitPeople;    //!<入住最大人数
@property (nonatomic, copy) NSString *facility;       //!<房间设施
@property (nonatomic, copy) NSString *houseAddress;   //!<花园地址
@property (nonatomic, copy) NSString *issale;         //!<购物车是否已添加 0是 1否

@property (nonatomic, copy) NSString *remark;         //!<备注
@property (nonatomic, copy) NSString *isClockRoom;    //!<是否钟点房 1代码钟点房
@property (nonatomic, copy) NSString *isRepair; //!<是否维修房 1是维修房 0 不是

//快速换房 接口字段
@property (nonatomic, copy) NSString *checkInDate;//!<入住日期
@property (nonatomic, copy) NSString *checkOutDate;//!<退房日期
@property (nonatomic, copy) NSString *liveDays;//!<入住天数
@property (nonatomic, copy) NSString *changeRoomOrderGuid; //!<换房时的临时订单

//业主房态 接口字段
@property (nonatomic, copy) NSString *agreementDate; //!<合同倒计时
@property (nonatomic, copy) NSString *agreementType; //!<1包租房 2分成房 3业主房 4管家房 5其他
@property (nonatomic, assign) CGFloat agreementDivide; //!<分成或者租金
@property (nonatomic, strong) NSString *payDate; //!<付款日期
@property (nonatomic, strong) NSString *payMinute;//!< 付款分钟
@property (nonatomic, strong) NSString *payHour;//!< 付款小时
@property (nonatomic, strong) NSString *yzguid; //!<业主guid

@property (nonatomic, strong) NSString *contractBegin; //!<合同开始时间
@property (nonatomic, strong) NSString *contractEnd; //!<合同结束时间

//记录订房房间被选中使用
@property (nonatomic, assign) BOOL isSelect;    //!<是否被选中

@property (nonatomic, strong) HMOwner *hotelOwner;//!< 房间业主

@property (nonatomic, strong) NSArray *hotelFile;//!< 业主费用附件

@property (nonatomic, strong) NSArray <HMOMPayCycle *> *payCycleList;


@end


@interface HMRoom (BusinessLogic)

/**
 返回房间号地址：如2508房
 
 @return 房间号地址
 */
- (NSString *)roomNumberAddress;

/**
 获取酒店所在地址：如海云天8栋
 
 @return 酒店所在地址
 */
- (NSString *)hotelAddress;

/**
 获取房间附属信息：含早/一房/双床/2人/25㎡
 
 @return 房间附属信息
 */
- (NSString *)hotelCharacteristic;
/**
0：洁房 1：洁疵 2：洁未查 3：不合格 4：脏房未安排 5:脏房已安排, -1 不显示
 @return eg.洁房
 */
- (NSString *)getCleanStatusStirng;

@end
