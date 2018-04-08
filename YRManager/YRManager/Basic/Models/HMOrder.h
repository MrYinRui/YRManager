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
//  HMOrder.h
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMLodger, HMRoom, HMCostList, HMServiceDetail, HMRoomPrice, HMOrderConsume, HMCheckingRoom, HMOrderPlatform,HMRefund,HMPlatformInfo;

typedef enum {

    UNKNOW,                     //!<未知
    
    EMPTY       = 100,          //!<空房
    RESERVATION = 110,          //!<预定
    ORDER       = 120,          //!<已订
    ARRIVED     = 210,          //!<到店
    WAIT_LIVE   = 220,          //!<待住
    
    WENT_LIVE                   = 310, //!<已入住
    LIVING                      = 320, //!<在住
    WOULD_LEAVE                 = 330, //!<预离
    WOULD_LEAVE_WITHOUT_CHECK   = 410, //!<预离未查房
    FRONT_DESK_HURRY_CHECK_UP   = 413,  //!<前台催查
    CUSTOMER_HURRY_CHECK_UP     = 411, //!<客人催查
    
    RESPONIBLE_CHECK            = 412,  //!<责任人查房
    OTHERS_CHECK                = 414,  //!<其他人查房
    CHECK_WITH_NO_PROBLEM       = 420,  //!<查房OK
    CHECK_WITH_MATTER           = 421,  //!<查房有问题
    
    OVERDEU_NOT_AWAY    = 440,      //!<逾期未离
    CHECKED_OUT         = 430,      //!<已退
    FORCE_CHECK_OUT     = 431,      //!<强退
    COMPLETED           = 510,      //!<已完成
    NO_SHOW             = 910,      //!<no_show
    
    OVERDUE_NO_SHOW     = 911,      //!<逾期no_show
    CONFIRM_NO_SHOW     = 912,      //!<确认NoShow
    ADD_CLOCK_NO_SHOW   = 913,      //!<加钟NoShow
    WAIT_CANCEL         = 919,      //!<待取消
    CANCEL              = 920,      //!<已取消
    ABNORMAL            = 930,      //!<异常
    
    START_CLOCK         = 340,      //!<起钟
    OVER_CLOCK          = 450,      //!<超钟
    START_ADD_CLOCK     = 360,      //!<起钟加钟
    LIVE_ADD_CLOCK      = 350,      //!<在住加钟
    
    LOCK_ROOM           = 620,      //!<锁房
    LOCK_DOWN           = 610,      //!<锁定
    
}OrderStatus;

@interface HMOrder : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic, copy) NSString *checkInDate;      //!<入住日期
@property (nonatomic, copy) NSString *checkOutDate;     //!<退房日期
@property (nonatomic, copy) NSString *checkInTime;      //!<入住时间
@property (nonatomic, copy) NSString *checkOutTime;     //!<退房时间
@property (nonatomic, copy) NSString *startHourDate;    //!<启钟日期

@property (nonatomic, copy) NSString *realLiveTime;     //!<确定入住时间
@property (nonatomic, copy) NSString *liveDays;         //!<入住天数
@property (nonatomic, copy) NSString *guid;             //!<订单guid
@property (nonatomic, copy) NSString *glGuid;           //!<关联guid

@property (nonatomic, copy) NSString *hymc;             //!<花园名称
@property (nonatomic, copy) NSString *louceng;          //!<楼层
@property (nonatomic, copy) NSString *mph;              //!<门牌号

@property (nonatomic, copy) NSString *ttmc;             //!<团体名称
@property (nonatomic, copy) NSString *groupOrderGuid;   //!<团体guid
@property (nonatomic, copy) NSString *type;             //!<类型（0.全日房 OR 1.钟点房）
@property (nonatomic, copy) NSString *orderCancelTime;  //!<取消时间
@property (nonatomic, assign) BOOL noRepeat;            //!<没重复

@property (nonatomic, copy) NSString *Id;               //!<订单号
@property (nonatomic, copy) NSString *peopleName;       //!<下订单人名称
@property (nonatomic, copy) NSString *remarks;          //!<备注
@property (nonatomic, assign) BOOL oweCheckin;          //!<欠款入住
@property (nonatomic, copy) NSString *attachment;       //!<附件

//@property (nonatomic, assign) double ddfj;             //!<业主房间订单需要参数
@property (nonatomic, copy) NSString *ddfj;             //!<业主房间订单需要参数
@property (nonatomic, assign) double originRoomPrice;  //!<订单原价
@property (nonatomic, assign) double currentRoomPrice; //!<订单合计金额
@property (nonatomic, assign) double deposit;          //!<订单押金
@property (nonatomic, assign) double totalPrice;       //!<订单总金额
@property (nonatomic, assign) double choosePrice;      //!<订单选配金额

// 清洁状态(0洁房 1洁疵 2洁未查 3不合格 4脏房未安排 5脏房已安排)
@property (nonatomic, copy) NSString *cleanStatus;
@property (nonatomic, assign) double paied;             //!<已收款
@property (nonatomic, assign) double balance;          //!<余额
@property (nonatomic, copy) NSString *isComing;         //!<来没来
@property (nonatomic, copy) NSString *checkStatus;      //!<查房状态

@property (nonatomic, copy) NSString *comedEarly;       //!<是否早到
@property (nonatomic, copy) NSString *breakfast;        //!<是否有早餐
@property (nonatomic, copy) NSString *lodgerNormal;     //!<入住人正常

@property (nonatomic, assign) double needPay;           //!< 应付款
@property (nonatomic, copy) NSString *status;           //!<订单状态
@property (nonatomic, copy) NSString *orderDate;        //!<订单时间
@property (nonatomic, copy) NSString *restTime;         //!<剩余时间(钟点房)
@property (nonatomic, strong) NSString *checkOutRequestTime; //!<催查时间

@property (nonatomic, strong) HMRoom *room;             //房间模型
@property (nonatomic, strong) NSMutableArray <HMLodger *> *lodgerList;

@property (nonatomic, copy) NSArray <HMRoomPrice *>*roomfeeList;
@property (nonatomic, strong) NSArray <HMServiceDetail *> *serviceList;
@property (nonatomic, strong) NSArray <HMOrderConsume *> *consumeList;
@property (nonatomic, strong) HMCheckingRoom *checkingRoom;//查房

@property (nonatomic, assign) double consumeTotalPrice; //!<消费总金额
@property (nonatomic, assign) double agreementTotalPrice;//!<协议总价
@property (nonatomic, copy) NSString *salesman;//!<业务员

@property (nonatomic, copy) NSString *platformGuid;//!<协议单位guid
@property (nonatomic, copy) NSString *platformOrderId;//!<平台单号
@property (nonatomic, assign) CGFloat platformPrice;//!<协议对账金额

//@property (nonatomic, copy) NSString *platformSource;//!<平台来源
@property (nonatomic, strong) HMOrderPlatform *platform;//!<平台
@property (nonatomic, strong) NSArray <HMOrder *> *associatedList;//!<关联列表
@property (nonatomic, copy) NSString *iscomment;  //!<留言板 0:无 1:有
@property (nonatomic, assign) NSInteger associatedOrder;//!<关联订单数
@property (nonatomic, assign) NSInteger vipDiscount;//!<会员折扣

@property (nonatomic, strong) NSString *accountCheckStauts;//!<对账状态
@property (nonatomic, strong) NSString *isHideRoomFee;//!< 是否隐藏房价

@property (nonatomic, copy) NSString *applyFrom;//!<下单的平台
@property (nonatomic, copy) NSString *intoName;//!<入住人名称
@property (nonatomic, copy) NSString *orderType;//!<订单状态(0.待住(已到店) 1.未住 2.已住 3.已退 4.完成)
@property (nonatomic, copy) NSString *realLeaveTime;//!<确定离店时间

@property (nonatomic, strong) NSArray <HMRefund *> *refundList;//!< 退款列表

@property (nonatomic, copy) NSString *invoiceStatus;//!<开票状态 0未开票 1待开票 2已开票

@property (nonatomic, strong) HMPlatformInfo *platformInfo;//!< 平台信息

//订房加入 多订单已经付款总额 退款相关
@property (nonatomic, assign) double add_payments;


@end

@interface HMOrder (BusinessLogic)

- (OrderStatus)getOrderStatus;

- (NSString *)getOrderStatusImg;

- (NSString *)getOrderStatusChineseStr;

- (NSString *)startDate:(NSString *)formatter;

- (NSString *)endDate:(NSString *)formatter;

@end
