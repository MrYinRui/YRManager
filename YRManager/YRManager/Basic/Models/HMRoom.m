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
//  HMRoom.m
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMRoom.h"
#import <MJExtension/MJExtension.h>

@implementation HMRoom

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"picUrl" : @"houseImg",
             @"roomNumber" : @"mph",
             @"floor" : @"louceng",
             @"breakfast" : @"zaocan",
             @"limitPeople" : @"rsxz",
             
             @"currentPrice" : @"price",
             @"direction":@"chaoxiang",
             @"deposit":@"yajin",
             
             @"limitPeople":@"rsxz",
             @"roomArea":@"fwmj",
             
             @"originPrice":@"yuanjia",
             @"bleAvaliable":@"isBluetoothDoor",
             @"houseAddress":@"hymc",
             @"facility":@"flss",
             
             @"doorModel":@"fx",
             @"bedModel":@"chuangxing",
             
             @"score":@"avgScore",
             @"cleanStatus":@"cleanstatus",
             @"features":@"teshe",
             @"roomPic":@"houseImg",
             
             @"houseType":@"fangxing",
             @"roomTypeGuid":@"fxGuid",
             @"checkInDate" : @"rzrq",
             @"checkOutDate" : @"tfrq",
             @"liveDays" : @"rzts",
             
             @"changeRoomOrderGuid":@"orderGuid",
             @"doorNumber":@"fjh",
             @"agreementDate" : @"djsts",
             @"agreementType" : @"htms",
             @"agreementDivide" : @"fcbl",
             
             @"payDate"   : @"fkrq",
             @"payHour"   : @"fkxs",
             @"payMinute" : @"fkfz",
             @"roomPaymentList" : @"payCycleList",
             @"remark" : @"bz",
             @"isClockRoom" : @"zhongdian",
             @"isRepair" : @"weixiu",
             };
}

//字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"roomPriceList"   : [HMRoomPrice class],
             @"roomPaymentList" : [HMRoomPayment class],
             @"hotelOwner"      : [HMOwner class],
             @"payCycleList"    : [HMOMPayCycle class],
             @"hotelFile"       : [HMOMHotelFile class],
             };
}

@end

@implementation HMRoom (BusinessLogic)

- (NSString *)roomNumberAddress
{
    return [_roomNumber stringByAppendingString:@"房"];
}

- (NSString *)hotelAddress
{
    if(_huayuan && _huayuan.name.length > 0){
        return [NSString stringWithFormat:@"%@%d楼", _huayuan.name, _floor.intValue];
    }else if(_houseAddress && _houseAddress.length > 0){
        return [NSString stringWithFormat:@"%@%d楼", _houseAddress, _floor.intValue];
    }
    return [NSString stringWithFormat:@"%@%d楼", _huayuan.name, _floor.intValue];
}


- (NSString *)hotelCharacteristic{
    
    NSString *breakfast;
    if([_breakfast isEqualToString:@"0"]){
        breakfast = @"无早";
    }else{
        breakfast = @"含早";
    }
    return [NSString stringWithFormat:@"%@ / %@ / %@ / %@人 / %@㎡",breakfast,_doorModel,_bedModel,_limitPeople,_roomArea];
}

- (NSString *)getCleanStatusStirng
{
    if ([_cleanStatus isEqualToString:@"0"])
    {
        return @"洁房";
    }
    else if ([_cleanStatus isEqualToString:@"1"])
    {
        return @"洁疵";
    }
    else if ([_cleanStatus isEqualToString:@"2"])
    {
        return @"洁未查";
    }
    else if ([_cleanStatus isEqualToString:@"3"])
    {
        return @"不合格";
    }
    else if ([_cleanStatus isEqualToString:@"4"])
    {
        return @"脏房未安排";
    }
    else if ([_cleanStatus isEqualToString:@"5"])
    {
        return @"脏房已安排";
    }
    else if ([_cleanStatus isEqualToString:@"-1"]) //不显示
    {
        return @"";
    }
    return _cleanStatus;
}

@end

