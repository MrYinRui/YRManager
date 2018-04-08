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
//  HMService.h
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMServiceDetail, HMServiceOtherInfo, HMAirportPickupDetail;

typedef NSString ServiceType;
LP_EXTERN ServiceType * const ServiceTypeAddBed;
LP_EXTERN ServiceType * const ServiceTypeBreakfast;
LP_EXTERN ServiceType * const ServiceTypeAirportPickup;

/****** HMService  (选配) ******/
@interface HMService : NSObject

//@property (nonatomic, copy)   NSString  *name;
//
@property (nonatomic, copy)   NSString  *type;          //!<类型
//@property (nonatomic, assign) NSInteger price;
//@property (nonatomic, copy)   NSString  *date;          //!<消费日期
//
//@property (nonatomic, assign) NSInteger addbed;         //!<是否可以加床
//@property (nonatomic, assign) NSInteger addbedprice;    //!<加床的价格
//@property (nonatomic, assign) NSInteger breakfast;      //!<是否可以加早餐
//@property (nonatomic, assign) NSInteger breakfastpirce; //!<早餐的价格
//@property (nonatomic, strong) NSArray<HMServiceDetail *> *serviceDetailList; //!<详细列表

@end

@compatibility_alias Service HMService;

/**Category*/
@interface HMService (LogicBusiness)

- (NSString *)serviceName;

@end

/***********  HMServiceStandard (选配标准)  **********/
@interface HMServiceStandard : NSObject

/*加床*/
@property (nonatomic, copy)   NSString   *addbed;        //!<加床  0否 1是
@property (nonatomic, assign) double     addbedprice;    //!<加床价格
/*早餐*/
@property (nonatomic, copy)   NSString   *breakfast;     //!<早餐 0否 1是
@property (nonatomic, assign) double     breakfastpirce; //!<早餐价格
/*接机*/
@property (nonatomic, copy)   NSString   *meetplane;     //!<接机 0否 1是
@property (nonatomic, assign) double     meetplaneprice; //!<接机价格
@property (nonatomic, assign) NSUInteger meetplaneBig;   //!<接机大人
@property (nonatomic, assign) NSUInteger meetplaneSmall; //!<接机小人

@property (nonatomic, strong) NSArray<HMServiceDetail *> *serviceDetailList; //!<详细列表


@end

/**********  HMServiceDetail (选配详情)  *********/
@interface HMServiceDetail : NSObject

@property (nonatomic, copy)   NSString  *ooptId;    //!<选配类型
@property (nonatomic, assign) NSInteger num;        //!<选配数量
@property (nonatomic, assign) NSInteger dcount;     //!<选配天数
@property (nonatomic, assign) float     price;      //!<选配单价
@property (nonatomic, assign) float     money;      //!<选配合计金额

@property (nonatomic, strong) HMServiceOtherInfo *otherInfo;  //!<其它信息

@property (nonatomic, strong) HMAirportPickupDetail *orderMeetplaneInfo; //!<接机信息

@end

@interface HMServiceDetail (LogicBusiness)

- (NSString *)serviceName;

@end

/******* HMServiceOtherInfo ******/

@interface HMServiceOtherInfo : NSObject

@property (nonatomic, assign) NSInteger dcount;  //!<选配天数

@end

