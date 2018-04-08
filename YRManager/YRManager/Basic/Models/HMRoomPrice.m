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
//  HMRoomPrice.m
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMRoomPrice.h"
#import "JsonToObjectProtocol.h"
#import "NSObject+JSONToObject.h"
#import "MJExtension.h"

@implementation HMRoomPrice

+ (id)objectFromJsonObj:(id)jsonObj
              originObj:(id)obj
{
    NSString * key = [jsonObj allKeys].firstObject;
    
    NSString *regularStr = @"^[{][0-9A-Z]{8}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{12}[}]$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    
    if ([predicate evaluateWithObject:key])
    {
        return [super arrayFromJsonObj:[jsonObj allObjects]
                           originArray:obj];
    }
    return [super objectFromJsonObj:jsonObj
                          originObj:obj];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"discountProtocolPrice":@"qrxyj",
             @"discountRoomPrice":@"qrfj",
//             @"discountRoomPrice":@"price",
             @"protocolRate":@"xyzk",
//             @"rate":@"zk",
             @"rate":@"djzk",
//             @"rate":@"discount",
             @"isExchangeRoom":@"ishuanfang",
             @"isLiveMore":@"isxuzhu",
             @"originRoomPrice":@"yfj",
//             @"originRoomPrice":@"yuanjia",
             @"beforeRoomPrice":@"yzqrfj",
             @"beforeOriginRoomPrice":@"yzyfj",
             @"date":@"rq",
             @"houseguid":@"houseGuids",
             @"originRate":@"yzdjzk"
             };
}

+(NSDictionary *)replaceKeyDict
{
    return @{
             @"qrxyj"  :      @"discountProtocolPrice",
             @"qrfj"  :       @"discountRoomPrice",
             @"price"   :     @"discountRoomPrice",
             @"xyzk"  :       @"protocolRate",
             @"zk"  :         @"rate",
             @"djzk"  :       @"rate",
             @"discount"    : @"rate",
             @"ishuanfang"  : @"isExchangeRoom",
             @"isxuzhu"  :    @"isLiveMore",
             @"yfj"  :        @"originRoomPrice",
             @"yuanjia" :     @"originRoomPrice",
             @"yzqrfj"  :     @"beforeRoomPrice",
             @"yzyfj" :       @"beforeOriginRoomPrice",
             @"rq"      :     @"date",
             @"houseGuids" :  @"houseguid",
             @"yzdjzk"  :     @"originRate"
             };
}

- (id)copyWithZone:(NSZone *)zone
{
    HMRoomPrice *roomPrice = [[[self class] allocWithZone:zone] init];
    
    roomPrice.guid = self.guid;
    roomPrice.date = self.date;
    roomPrice.discountProtocolPrice = self.discountProtocolPrice;
    roomPrice.discountRoomPrice = self.discountRoomPrice;
    roomPrice.protocolRate = self.protocolRate;
    roomPrice.originRoomPrice = self.originRoomPrice;
    roomPrice.rate = self.rate;
    roomPrice.isExchangeRoom = self.isExchangeRoom;
    roomPrice.isLiveMore = self.isLiveMore;
    roomPrice.ts  = self.ts;
    roomPrice.zt  = self.zt;
    
    roomPrice.changed  = self.changed;
    roomPrice.selected = self.selected;
    
    return roomPrice;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    HMRoomPrice *roomPrice = [[[self class] allocWithZone:zone] init];
    
    roomPrice.guid = self.guid;
    roomPrice.date = self.date;
    roomPrice.discountProtocolPrice = self.discountProtocolPrice;
    roomPrice.discountRoomPrice = self.discountRoomPrice;
    roomPrice.protocolRate = self.protocolRate;
    roomPrice.originRoomPrice = self.originRoomPrice;
    roomPrice.rate = self.rate;
    roomPrice.isExchangeRoom = self.isExchangeRoom;
    roomPrice.isLiveMore = self.isLiveMore;
    roomPrice.ts  = self.ts;
    roomPrice.zt  = self.zt;
    
    roomPrice.changed  = self.changed;
    roomPrice.selected = self.selected;
    
    return roomPrice;

}

@end
