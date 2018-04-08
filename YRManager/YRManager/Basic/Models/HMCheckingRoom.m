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
//  HMCheckingRoom.m
//  HotelManager-Pad
//
//  Created by xun on 17/2/21.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import "HMCheckingRoom.h"
#import "NSObject+JSONToObject.h"
#import "MJExtension.h"

@implementation HMCheckingRoom

+ (NSDictionary *)replaceKeyDict
{
    return @{@"ccr":@"urgeCheckingMan",
             @"ccsj":@"urgeCheckingDate",
             @"cfsj":@"date",
             @"cfzt":@"status",
             @"fwguid":@"roomGuid",
             
             @"sfhs":@"isCheckingDamage",
             @"sfqs":@"isCheckingDamage",
             @"sfxf":@"isConsume",
             @"tfcfStatisticsList":@"costList",
             @"zbguid":@"orderGuid",
             
             @"totalMoney":@"totalPrice"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"urgeCheckingMan":@"ccr",
             @"urgeCheckingDate":@"ccsj",
             @"date":@"cfsj",
             @"status":@"cfzt",
             @"roomGuid":@"fwguid",
             
             @"isCheckingDamage":@"sfhs",
             @"isCheckingDamage":@"sfqs",
             @"isConsume":@"sfxf",
             @"costList":@"tfcfStatisticsList",
             @"orderGuid":@"zbguid",
             
             @"totalPrice":@"totalMoney",
             @"checkManName":@"cfr"
             };
}

+ (NSDictionary *)propertyClassDict
{
    return @{@"costList":[HMCheckingRoomCost class]};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"costList":[HMCheckingRoomCost class]};
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"cfrdh"])
    {
        self.checkinMan.phone = value;
    }
    else if ([key isEqualToString:@"cfr"])
    {
        self.checkinMan.name = value;
    }
    else if ([key isEqualToString:@"cfrid"])
    {
        self.checkinMan.guid = value;
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

- (HMWorker *)checkinMan
{
    if (! _checkinMan)
    {
        _checkinMan = [HMWorker new];
    }
    return _checkinMan;
}
@end

@implementation HMCheckingRoomCost

+ (NSDictionary *)replaceKeyDict
{
    return @{@"totalCount":@"total"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"total":@"totalCount"};
}

- (HMCheckingRoomCostType)costType
{
    if ([_type isEqualToString:@"krxfmx"])
    {
        return HMCheckingRoomCostTypeMinibar;
    }
    else if ([_type isEqualToString:@"krshmx"])
    {
        return HMCheckingRoomCostTypeDamage;
    }
    else
    {
        return HMCheckingRoomCostTypeLosing;
    }
}

@end
