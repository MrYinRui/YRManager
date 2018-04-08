//
//  HMFDCalendarView.h
//  HotelManager
//
//  Created by kqz on 17/3/25.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMFDCalendarView : UIView

@property (nonatomic,strong) UILabel *intoRoom;
@property (nonatomic,strong) UILabel *outRoom;

- (instancetype)initWithCurrentDate:(NSDate *)date;

- (NSString *)getCurrentDate;

@end
