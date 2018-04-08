//
//  HMRoomPayment.h
//  HotelManager
//
//  Created by kqz on 17/5/17.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRoomPayment : NSObject

@property (nonatomic, copy) NSString *beginDate;   //!<开始日期
@property (nonatomic, copy) NSString *endDate;     //!<结束日期
@property (nonatomic, assign) double gains;        //!<租金

@end
