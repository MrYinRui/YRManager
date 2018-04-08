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
//  HMService.m
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMService.h"
#import "MJExtension.h"
#import "HMAirportPickupDetail.h"

ServiceType * const ServiceTypeAddBed           = @"5";
ServiceType * const ServiceTypeBreakfast        = @"8";
ServiceType * const ServiceTypeAirportPickup    = @"11";

/******* HMService (选配)  ******/
@implementation HMService

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"price":@"money",
             @"type":@"ooptId",
             @"date":@"payTime",
             };
}

@end

/**Category*/
@implementation HMService (LogicBusiness)

- (NSString *)serviceName {
    if ([self.type isEqualToString:ServiceTypeAddBed]) {
        return @"加床";
        
    } else if ([self.type isEqualToString:ServiceTypeBreakfast]) {
        return @"早餐";
        
    } else if ([self.type isEqualToString:ServiceTypeAirportPickup]) {
        return @"接机";
    }
    
    return @"";
}

@end

/***********  HMServiceStandard (选配标准)  **********/
@implementation HMServiceStandard

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"serviceDetailList":@"selectionList"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"serviceDetailList" : [HMServiceDetail class],
             };
}

@end

/**********  HMServiceDetail (选配详情)  *********/
@implementation HMServiceDetail

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"otherInfo" : [HMServiceOtherInfo class],
             @"orderMeetplaneInfo" : [HMAirportPickupDetail class]
             };
}

-(NSInteger)dcount {
    return _otherInfo.dcount;
}

@end

@implementation HMServiceDetail (LogicBusiness)

- (NSString *)serviceName {
    if ([self.ooptId isEqualToString:@"5"]) {
        return @"加床";
    } else if ([self.ooptId isEqualToString:@"8"]) {
        return @"早餐";
    } else if ([self.ooptId isEqualToString:@"11"]) {
        return @"接机";
    }
    
    return @"";
}

@end


/******* HMServiceOtherInfo ******/
@implementation HMServiceOtherInfo



@end
