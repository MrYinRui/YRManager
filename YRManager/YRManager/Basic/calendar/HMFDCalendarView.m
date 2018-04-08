//
//  HMFDCalendarView.m
//  HotelManager
//
//  Created by kqz on 17/3/25.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMFDCalendarView.h"
#import "HMFDCalendarItemView.h"

#define Weekdays @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]
static NSDateFormatter *dateFormattor;

@interface HMFDCalendarView () <UIScrollViewDelegate, HMFDCalendarItemDelegate>

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HMFDCalendarItemView *leftCalendarItem;
@property (strong, nonatomic) HMFDCalendarItemView *centerCalendarItem;
@property (strong, nonatomic) HMFDCalendarItemView *rightCalendarItem;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *datePickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (nonatomic) NSInteger *monthValue;
@property (nonatomic) CGFloat scrollViewOffset;

@end

@implementation HMFDCalendarView
{
    NSInteger _count;
}

- (instancetype)initWithCurrentDate:(NSDate *)date {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _count = 0;
        self.date = date;
        
        [self setupTitleBar];
        [self setupWeekView];
        [self setupWeekHeader];
        [self setupCalendarItems];
        [self setupScrollView];
        [self setUpTabbarView];
        [self setFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.scrollView.frame))];
        
        [self setCurrentDate:self.date];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame: self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePickerView)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    
    [self addSubview:_backgroundView];
    
    return _backgroundView;
}

- (UIView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.0/667.0*kScreenHeight, kScreenWidth, 0)];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.clipsToBounds = YES;
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0/375.0*kScreenWidth, 10.0/667.0*kScreenHeight, 32.0/375.0*kScreenWidth, 20.0/667.0*kScreenHeight)];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelSelectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:cancelButton];
        
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 52)/375.0*kScreenWidth, 10.0/667.0*kScreenHeight, 32.0/375.0*kScreenWidth, 20.0/667.0*kScreenHeight)];
        okButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(selectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:okButton];
        
        [_datePickerView addSubview:self.datePicker];
    }
    
    [self addSubview:_datePickerView];
    
    return _datePickerView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];
        CGRect frame = _datePicker.frame;
        frame.origin = CGPointMake(0, 32);
        _datePicker.frame = frame;
    }
    
    return _datePicker;
}

#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date {
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"yyyy-MM"];
    }
    return [dateFormattor stringFromDate:date];
}

//创建入住、离店时间
- (void)setUpTabbarView
{
    self.intoRoom = [[UILabel alloc] initWithFrame:CGRectMake(40.0/375.0*kScreenWidth, 500.0/667.0*kScreenHeight, 180.0/375.0*kScreenWidth, 17.0/667.0*kScreenHeight)];
    self.intoRoom.textColor = [UIColor colorWithRed:176.0/255.0f green:130.0/255.0f blue:46.0/255.0f alpha:1.0f];
    self.intoRoom.font = kFont(16.0);
    
    self.intoRoom.text = @"";
    
    
    [self addSubview:self.intoRoom];
    
    self.outRoom = [[UILabel alloc] initWithFrame:CGRectMake(215.0/375.0*kScreenWidth, 500.0/667.0*kScreenHeight, 180.0/375.0*kScreenWidth, 17.0/667.0*kScreenHeight)];
    self.outRoom.textColor = [UIColor colorWithRed:176.0/255.0f green:130.0/255.0f blue:46.0/255.0f alpha:1.0f];
    self.outRoom.font = kFont(16.0);
    
    self.outRoom.text = @"";
    [self addSubview:self.outRoom];
}

// 设置上层的titleBar
- (void)setupTitleBar {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0/667.0*kScreenHeight)];
    titleView.backgroundColor = [UIColor colorWithRed:69.0/255.0f green:70.0/255.0f blue:64.0/255.0f alpha:1.0f];
    [self addSubview:titleView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100.0/375.0*kScreenWidth, 20.0/667.0*kScreenHeight, 12.0/375.0*kScreenWidth, 24.0/667.0*kScreenHeight)];
    [leftButton setImage:[UIImage imageNamed:@"arrow_left_02"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(263.0/375.0*kScreenWidth, 20.0/667.0*kScreenHeight, 12.0/375*kScreenWidth, 24.0/667.0*kScreenHeight)];
    [rightButton setImage:[UIImage imageNamed:@"arrow_right_02"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setNextMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightButton];
    
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(140.0/375.0*kScreenWidth, 20.0/667.0*kScreenHeight, 100.0/375.0*kScreenWidth , 24.0/667.0*kScreenHeight)];
    titleButton.titleLabel.textColor = [UIColor whiteColor];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [titleView addSubview:titleButton];
    
    self.titleButton = titleButton;
}

- (void)setupWeekView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.0/667.0*kScreenHeight, kScreenWidth, 40.0/667.0*kScreenHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:69.0/255.0f green:70.0/255.0f blue:64.0/255.0f alpha:1.0f];
    [self addSubview:bgView];
}

// 设置星期文字的显示
- (void)setupWeekHeader {
    NSInteger count = [Weekdays count];
    CGFloat offsetX = 0;
    for (int i = 0; i < count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 60.0/667.0*kScreenHeight, kScreenWidth/7.0, 20.0/667.0*kScreenHeight)];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.text = Weekdays[i];
        weekdayLabel.textColor = [UIColor whiteColor];
        weekdayLabel.font = kFont(16.0);
        
        [self addSubview:weekdayLabel];
        
        offsetX += kScreenWidth/7.0;
    }
}

// 设置包含日历的item的scrollView
- (void)setupScrollView {
    
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setFrame:CGRectMake(0, 75.0/667.0*kScreenHeight, DeviceWidth, self.centerCalendarItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    [self addSubview:self.scrollView];
}

// 设置3个日历的item
- (void)setupCalendarItems {
    self.scrollView = [[UIScrollView alloc] init];
    
    self.leftCalendarItem = [[HMFDCalendarItemView alloc] init];
    //[self.scrollView addSubview:self.leftCalendarItem];
    
    CGRect itemFrame = self.leftCalendarItem.frame;
    itemFrame.origin.x = kScreenWidth;
    self.centerCalendarItem = [[HMFDCalendarItemView alloc] init];
    self.centerCalendarItem.frame = itemFrame;
    self.centerCalendarItem.delegate = self;
    [self.scrollView addSubview:self.centerCalendarItem];
    
    itemFrame.origin.x = kScreenWidth * 2;
    self.rightCalendarItem = [[HMFDCalendarItemView alloc] init];
    self.rightCalendarItem.frame = itemFrame;
    [self.scrollView addSubview:self.rightCalendarItem];
}

// 设置当前日期，初始化
- (void)setCurrentDate:(NSDate *)date {
    self.centerCalendarItem.date = date;
    self.leftCalendarItem.date = [self.centerCalendarItem previousMonthDate];
    self.rightCalendarItem.date = [self.centerCalendarItem nextMonthDate];
    
    [self.titleButton setTitle:[self stringFromDate:self.centerCalendarItem.date] forState:UIControlStateNormal];
}

//获取当前日期
- (NSString *)getCurrentDate
{
    NSDateFormatter *day = [NSDateFormatter new];
    [day setDateFormat:@"yyyy-MM-DD"];
    return [day stringFromDate:self.date];
}

// 重新加载日历items的数据
- (void)reloadCalendarItems {
    CGPoint offset = self.scrollView.contentOffset;
    
    if (offset.x > self.scrollView.frame.size.width) {
        _count++;
        [self setNextMonthDate];
        
    } else {
        _count--;
        [self setPreviousMonthDate];
        
    }
}

- (void)showDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0.4;
        self.datePickerView.frame = CGRectMake(0, 44.0/667.0*kScreenHeight, self.frame.size.width, 250.0/667.0*kScreenHeight);
    }];
}

- (void)hideDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
        self.datePickerView.frame = CGRectMake(0, 44.0/667.0*kScreenHeight, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
    }];
}

#pragma mark - SEL

// 跳到上一个月
- (void)setPreviousMonthDate {
    [self setCurrentDate:[self.centerCalendarItem previousMonthDate]];
}

// 跳到下一个月
- (void)setNextMonthDate {
    [self setCurrentDate:[self.centerCalendarItem nextMonthDate]];
}

- (void)showDatePicker {
    [self showDatePickerView];
}

// 选择当前日期
- (void)selectCurrentDate {
    [self setCurrentDate:self.datePicker.date];
    [self hideDatePickerView];
}

- (void)cancelSelectCurrentDate {
    [self hideDatePickerView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self reloadCalendarItems];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

#pragma mark - FDCalendarItemDelegate

- (void)calendarItem:(HMFDCalendarItemView *)item didSelectedDate:(NSDate *)date {
    self.date = date;
    [self setCurrentDate:self.date];
}

- (void)getValue:(NSString *)str
{
    self.intoRoom.text = str;
}

- (void)getOutValue:(NSString *)str
{
    self.outRoom.text = str;
}

@end
