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
//  HMOrderPlatform.h
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const OrderPlatformTypeOrganization; //!<团体
extern NSString *const OrderPlatformTypeTravelAgency; //!<旅行社
extern NSString *const OrderPlatformTypeBargainUnits; //!<协议单位
extern NSString *const OrderPlatformTypeProprietor;   //!<业主

@interface HMOrderPlatform : NSObject

@property (nonatomic, copy) NSString * guid;            //!<订单来源
@property (nonatomic, copy) NSString * name;            //!<平台名称
@property (nonatomic, copy) NSString * isRelatedSalesman;//!<是否关联业务员 0否 1是
@property (nonatomic, copy) NSString * isCommission;    //!<是否付佣  0 不付 1付佣
@property (nonatomic, copy) NSString * commissionRate;  //!<佣金率

@property (nonatomic, copy) NSString * orderId;     //!<平台单号
@property (nonatomic, copy) NSString * type;        //!<1团体 2旅行社 3协议单位 11业主
@property (nonatomic, assign) double protocolRate;//!<协议比率
@property (nonatomic, copy) NSString * company;     //!<公司，旅行社
@property (nonatomic, copy) NSString * arrearslive; //!< Int (0 全款入住 1 欠款入住)
//arrearslive
@property (nonatomic, strong) NSString *hzfs;//!< 合作方式 0：自定义 1：折扣

@property (nonatomic, copy) NSString * remark;//!<备注

@property (nonatomic, copy) NSString * sqsj;//!<申请时间
@property (nonatomic, copy) NSString * lrsj;//!<时间
@property (nonatomic, copy) NSString * sfyx;//!<


//自己加的 判断用
@property (nonatomic, copy) NSString *topGuid;//!< 协议类上层guid

/**是否是协议类型*/
- (BOOL)isProtocolType;

@end

