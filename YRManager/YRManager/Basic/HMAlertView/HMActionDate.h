//
//  HMActionDate.h
//  HotelManager
//
//  Created by kqz on 2017/8/7.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMActionDate : UIView

+(instancetype)initWithRoomAddress:(NSString *)address AndGuid:(NSString *)guid;
@property (nonatomic, copy) void (^selectTimeBlock)(NSString *time);
@property (nonatomic, strong) NSString *orderGuid;//!<订单guid 如果有需要请设置

@end
