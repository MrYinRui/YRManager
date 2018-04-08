//
//  LPSelectRoomCalendarView.h
//  Lodger-Pad
//
//  Created by xun on 10/9/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "HMBasicDialogView.h"

@interface LPSelectRoomCalendarView : UIView

@property (nonatomic, copy) void (^selectedBlock)(NSDate *checkInDate, NSDate *checkOutDate);

+ (instancetype)calendarView;

/**
 @param date 指定日期（之前的日期不可选）
 @param isSelect 选中入住日期（默认不选中）
 @return LPSelectRoomCalendarView
 */
+ (instancetype)calendarViewWithDate:(NSDate *)date Select:(BOOL)isSelect withSelectDate:(NSDate *)selectDate;


+ (instancetype)calendarViewWithDate:(NSDate *)date Select:(BOOL)isSelect withSelectDate:(NSDate *)selectDate AndHiddenTip:(BOOL)hiddenTip;

@property (nonatomic, assign) BOOL  hiddenTip; //!<单选隐藏提示和下方的日期
@property (nonatomic, assign) BOOL  onceClick; //!<单次选择

@end
