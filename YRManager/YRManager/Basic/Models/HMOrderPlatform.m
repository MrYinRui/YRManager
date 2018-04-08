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
//  HMOrderPlatform.m
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMOrderPlatform.h"
#import "NSObject+JSONToObject.h"
#import "MJExtension.h"

NSString *const OrderPlatformTypeOrganization = @"PLATFORM_TYPE_ORGANIZATION"; //!<团体
NSString *const OrderPlatformTypeTravelAgency = @"PLATFORM_TYPE_TRAVEL_AGENCY"; //!<旅行社
NSString *const OrderPlatformTypeBargainUnits = @"PLATFORM_TYPE_BARGAIN_UNITS"; //!<协议单位
NSString *const OrderPlatformTypeProprietor = @"PLATFORM_TYPE_PROPRIETOR";   //!<业主

@implementation HMOrderPlatform

+(NSDictionary *)replaceKeyDict
{
        return @{
                 @"ptmc" :   @"name",
                 @"sfglyw" : @"isRelatedSalesman",
                 @"dwmc" :   @"name",
                 @"yjl" :    @"commissionRate",
                 @"xylx" :   @"type", //!< 平台类型
                 @"lb" :     @"company",
                 @"sffy" :   @"isCommission",
                 @"zk" :     @"protocolRate"
                 };

}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"name":@"ptmc",
             @"isRelatedSalesman":@"sfglyw",
//             @"name":@"dwmc",
             @"commissionRate":@"yjl",
             @"type":@"xylx", //!< 平台类型
             @"company":@"lb",
             @"isCommission":@"sffy",
             @"protocolRate":@"zk",
             @"remark":@"bz",
             };
}

-(NSString *)type
{
    if ([_type isEqualToString:@"1"])
    {
        return OrderPlatformTypeOrganization;
    }
    else if ([_type isEqualToString:@"2"])
    {
        return OrderPlatformTypeTravelAgency;
    }
    else if ([_type isEqualToString:@"3"])
    {
        return OrderPlatformTypeBargainUnits;
    }
    else if ([_type isEqualToString:@"11"])
    {
        return OrderPlatformTypeProprietor;
    }
    
    return _type;
}

- (BOOL)isProtocolType {
    if (   self.type == OrderPlatformTypeBargainUnits
        || self.type == OrderPlatformTypeOrganization
        || self.type == OrderPlatformTypeTravelAgency)
    {
        return  YES;
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"class:%@,name:%@,type:%@",[self class],self.name,self.type];
}

@end

//@implementation HMOrderPlatform (Type)


//@end
