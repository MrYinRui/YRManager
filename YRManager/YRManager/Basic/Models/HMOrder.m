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
//  HMOrder.m
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMOrder.h"
#import "HMRoom.h"
#import "HMLodger.h"
#import "HMRoomPrice.h"
#import "HMService.h"
#import "HMCheckingRoom.h"
#import "HMOrderConsume.h"
#import "MJExtension.h"
#import "HMOrderPlatform.h"
#import "HMMessageBoard.h"
#import "HMRefund.h"
#import "HMPlatformInfo.h"

@interface HMOrder ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation HMOrder

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"checkInDate" : @"rzrq",
             @"checkOutDate" : @"tfrq",
             @"checkInTime" : @"rzrqTime",
             @"checkOutTime" : @"tfrqTime",
             @"startHourDate":@"rzsjqj",
             @"liveDays" : @"rzts",
             @"totalPrice"  : @"zje",
             @"choosePrice" : @"xpje",
             
             @"originRoomPrice" : @"ffyj",
             @"currentRoomPrice" : @"ffxj",
             @"deposit"   : @"yj",
             @"room":@"house",
             
             @"lodgerList":@"ddrzrList",
             @"balance":@"yk",
             @"paied":@"ysk",
             @"checkStatus":@"cfzt",
             @"comedEarly":@"sfzd",
             
             @"isComming":@"laifou",
             @"status":@"orderStatus",
//             @"liveDays":@"day",
             @"restTime":@"remaining_time",
             @"Id":@"sqdh",
             
             @"remarks":@"bz",
             @"oweCheckin":@"arrearslive",
             @"attachment":@"fj",
             @"attachment":@"attachment",

             @"checkInTime" : @"rzrqTime",
             @"checkOutTime" : @"tfrqTime",
             @"cleanStatus":@"house.cleanstatus",
             
             @"roomfeeList":@"ddfjxxList",
             @"consumeList":@"orderPayList",
             @"serviceList":@"orderOtherPayList",
             @"checkingRoom":@"tfcf",
             @"consumeTotalPrice":@"qtfy",
             @"agreementTotalPrice":@"xyffxj",
             @"orderCancelTime":@"zdqxsj",
             @"salesman":@"ywy",
             @"peopleName":@"sqr",
             @"orderDate":@"sqsj",
             @"platformGuid":@"xydwGuid",
             @"platformOrderId":@"ptdh",
//             @"platformSource":@"ptmc",
             @"platform":@"orderSource",
             @"associatedList" :@"associatedOrderList",
             @"type":@"orderType",
             @"platformName":@"ttmc",
             @"platformPrice":@"xydzje",
             @"accountCheckStauts":@"duizhangzt",
             @"isHideRoomFee" : @"sfycfj",
             @"intoName" : @"xm",
             @"orderType" : @"ddzt",
             @"platformInfo" : @"ptxx",
             };
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"lodgerList": [HMLodger class],
             @"room": [HMRoom class],
             
             @"roomfeeList":[HMRoomPrice class],
             @"consumeList": [HMOrderConsume class],
             @"serviceList":[HMServiceDetail class],
             @"checkingRoom":[HMCheckingRoom class],
             @"platform":[HMOrderPlatform class],
             @"associatedList" : [HMOrder class],
             @"messageList" : [HMMessageBoard class],
             @"refundList"  : [HMRefund class],
             @"platformInfo" : [HMPlatformInfo class],
             };
}

- (id)copyWithZone:(NSZone *)zone {
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge  void *)(copyInstance), (__bridge const void *)(self), instanceSize);
    return copyInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge  void *)(copyInstance), (__bridge const void *)(self), instanceSize);
    return copyInstance;
}


@end

@implementation HMOrder (BusinessLogic)

- (OrderStatus)getOrderStatus
{
    return self.status.intValue;
}

- (NSString *)getOrderStatusChineseStr {
    
    NSString *orderStatus = @"";
    OrderStatus status = [self getOrderStatus];
    switch (status) {
        case RESERVATION:
            orderStatus = @"预订";
            break;
        case ORDER:
            orderStatus = @"已订";
            break;
        case ARRIVED:
            orderStatus = @"到底";
            break;
        case WAIT_LIVE:
            orderStatus = @"待住";
            break;
        case WENT_LIVE:
            orderStatus = @"已住";
            break;
        case LIVING:
            orderStatus = @"在住";
            break;
        case WOULD_LEAVE:
            orderStatus = @"预离";
            break;
        case WOULD_LEAVE_WITHOUT_CHECK:
            orderStatus = @"预离";
            break;
        case FRONT_DESK_HURRY_CHECK_UP:
            orderStatus = @"催查";
            break;
        case CUSTOMER_HURRY_CHECK_UP:
            orderStatus = @"催查";
            break;
        case RESPONIBLE_CHECK:
            orderStatus = @"查房";
            break;
        case OTHERS_CHECK:
            orderStatus = @"查房";
            break;
        case CHECK_WITH_NO_PROBLEM:
            orderStatus = @"已查";
            break;
        case CHECK_WITH_MATTER:
            orderStatus = @"已查";
            break;
        case OVERDEU_NOT_AWAY:
            orderStatus = @"逾期未离";
            break;
        case CHECKED_OUT:
            orderStatus = @"已退";
            break;
        case FORCE_CHECK_OUT:
            orderStatus = @"强退";
            break;
        case COMPLETED:
            orderStatus = @"已完成";
            break;
        case NO_SHOW:
            orderStatus = @"NoShow";
            break;
        case CONFIRM_NO_SHOW:
            orderStatus = @"确认NoShow";
            break;
        case ADD_CLOCK_NO_SHOW:
            orderStatus = @"加钟NoShow";
            break;
        case OVERDUE_NO_SHOW:
            orderStatus = @"逾期NoShow";
            break;
        case CANCEL:
            orderStatus = @"已取消";
            break;
        case WAIT_CANCEL:
            orderStatus = @"待取消";
            break;
            
        case START_CLOCK:
            orderStatus = @"起钟";
            break;
        case OVER_CLOCK:
            orderStatus = @"超钟";
            break;
        case START_ADD_CLOCK:
            orderStatus = @"起钟加钟";
            break;
        case LIVE_ADD_CLOCK:
            orderStatus = @"在住加钟";
            break;
        default:
            break;
    }
    
    return orderStatus;
}

- (NSString *)getOrderStatusImg
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WorkList.plist" ofType:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *statusImg = dic[@"OrderStatusIcon"][self.status];
    
    return statusImg;
}

- (NSString *)startDate:(NSString *)formatter
{
    NSString *str;
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [self.dateFormatter dateFromString:self.checkInDate];
    [self.dateFormatter setDateFormat:formatter];
    str = [self.dateFormatter stringFromDate:date];
    
    return str;
}

- (NSString *)endDate:(NSString *)formatter
{
    NSString *str;
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [self.dateFormatter dateFromString:self.checkOutDate];
    [self.dateFormatter setDateFormat:formatter];
    str = [self.dateFormatter stringFromDate:date];
    
    return str;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [NSDateFormatter new];
    }
    return _dateFormatter;
}

@end
