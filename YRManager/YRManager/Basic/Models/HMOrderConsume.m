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
//  HMOrderConsume.m
//  HotelManager-Pad
//
//  Created by xun on 17/2/21.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import "HMOrderConsume.h"
#import "NSObject+JSONToObject.h"
#import "MJExtension.h"

@implementation HMOrderConsume

+ (NSDictionary *)replaceKeyDict
{
    return @{@"cshopId":@"merchantId",
             @"money":@"totalPrice",
             @"payTime":@"date",
             @"zbguid":@"orderGuid",
             @"oopId":@"Id",
             
             @"num":@"count",
             @"oopName":@"name",
             @"remark":@"mark",
             @"attachmentPath":@"attachmentUrl"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"merchantId":@"cshopId",
             @"totalPrice":@"money",
             @"date":@"payTime",
             @"orderGuid":@"zbguid",
             @"Id":@"oopId",
             
             @"count":@"num",
             @"name":@"oopName",
             @"mark":@"remark",
             @"attachmentUrl":@"attachmentPath"
             };
}

//- (void)setValue:(id)value forKey:(NSString *)key
//{
//    if ([key isEqualToString:@"otherInfo"])
//    {
//        self.count = [[value valueForKey:@"ocount"] floatValue];
//    }
//    else if ([key isEqualToString:@"loginId"])
//    {
//        self.worker.Id = value;
//    }
//    else if ([key isEqualToString:@"operatorName"])
//    {
//        self.worker.name = value;
//    }
//    else
//    {
//        [super setValue:value forKey:key];
//    }
//}

//- (NSString *)name
//{
//    return [HMOrderConsume nameDictionary][@(_typeId * 10 + _ooptId).stringValue];
//}

+ (NSDictionary *)nameDictionary
{
    return @{@"15":@"加床",
             @"18":@"早餐",
             @"21":@"餐费",
             @"22":@"赔偿费",
             @"23":@"Mini吧消费",
             @"24":@"房价调整",
             @"25":@"其他消费",
             @"31":@"取消订单补偿",
             @"32":@"提前退房补偿",
             @"33":@"Noshow补偿",};
}

- (HMWorker *)worker
{
    if (! _worker)
    {
        _worker = [HMWorker new];
    }
    return _worker;
}

@end
