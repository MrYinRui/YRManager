//
//  HMFDCalendarItemView.h
//  HotelManager
//
//  Created by kqz on 17/3/25.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DeviceWidth [UIScreen mainScreen].bounds.size.width

@protocol HMFDCalendarItemDelegate;

@interface HMFDCalendarItemView : UIView

@property (strong, nonatomic) NSDate *date;
@property (weak, nonatomic) id<HMFDCalendarItemDelegate> delegate;

- (NSDate *)nextMonthDate;
- (NSDate *)previousMonthDate;

@end

@protocol HMFDCalendarItemDelegate <NSObject>

- (void)calendarItem:(HMFDCalendarItemView *)item didSelectedDate:(NSDate *)date;
- (void)getValue:(NSString *)str;
- (void)getOutValue:(NSString *)str;

@end
