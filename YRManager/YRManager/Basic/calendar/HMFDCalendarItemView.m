//
//  HMFDCalendarItemView.m
//  HotelManager
//
//  Created by kqz on 17/3/25.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMFDCalendarItemView.h"
#import "HMFDCalendarView.h"

@interface FDCalendarCell : UICollectionViewCell

- (UILabel *)dayLabel;
- (UILabel *)chineseDayLabel;
- (UILabel *)statesLabel;
- (UIView *)lineView;
@end

@implementation FDCalendarCell {
    UILabel *_dayLabel;
    UILabel *_chineseDayLabel;
    UILabel *_statesLabel;
    UIView *_lineView;
}

- (UILabel *)statesLabel
{
    if (_statesLabel == nil) {
        _statesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0/375.0*kScreenWidth, 20.0/667.0*kScreenHeight)];
        _statesLabel.textAlignment = NSTextAlignmentCenter;
        _statesLabel.font = kFont(10);
        CGPoint point = _dayLabel.center;
        point.y -= 15;
        _statesLabel.center = point;
        [self addSubview:_statesLabel];
    }
    
    return _statesLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0/375.0*kScreenWidth, 20.0/667.0*kScreenHeight)];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = kFont(15.0);
        _dayLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 3);
        [self addSubview:_dayLabel];
    }
    return _dayLabel;
}

- (UILabel *)chineseDayLabel {
    if (!_chineseDayLabel) {
        _chineseDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0/375.0*kScreenWidth, 10.0/667.0*kScreenHeight)];
        _chineseDayLabel.textAlignment = NSTextAlignmentCenter;
        _chineseDayLabel.font = kFont(9.0);
        
        CGPoint point = _dayLabel.center;
        point.y += 15;
        _chineseDayLabel.center = point;
        [self addSubview:_chineseDayLabel];
    }
    return _chineseDayLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(-5,  kScreenWidth/7-10, kScreenWidth/7, 1)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end

#define CollectionViewHorizonMargin 5
#define CollectionViewVerticalMargin 5

#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

typedef NS_ENUM(NSUInteger, FDCalendarMonth) {
    FDCalendarMonthPrevious = 0,
    FDCalendarMonthCurrent = 1,
    FDCalendarMonthNext = 2,
};

@interface HMFDCalendarItemView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic)FDCalendarCell *cell1;
@property (strong, nonatomic)FDCalendarCell *cell2;

@property (strong, nonatomic)NSString *intoStr;
@property (strong, nonatomic)NSString *outStr;

@property (strong, nonatomic) NSString *intoDate;
@property (strong, nonatomic) NSString *outDate;

@end

@implementation HMFDCalendarItemView
{
    NSInteger _indexCount;
    NSDate *_oldSelectedDate;
    NSString *_scrollDirection;
    NSInteger _count;
    NSDateFormatter *dateFormatter_ymd;
}

- (instancetype)init {
    if (self = [super init]) {
        _indexCount = 0;
        self.backgroundColor = [UIColor clearColor];
        [self setupCollectionView];
        [self setFrame:CGRectMake(0, 0, kScreenWidth, self.collectionView.frame.size.height + CollectionViewVerticalMargin * 2)];
         dateFormatter_ymd = [NSDateFormatter new];
        [dateFormatter_ymd setDateFormat:@"yyyy-MM-dd"];
    }
    return self;
}


#pragma mark - Custom Accessors

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.collectionView reloadData];
}

#pragma mark - Public

// 获取date的下个月日期
- (NSDate *)nextMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return nextMonthDate;
}

// 获取date的上个月日期
- (NSDate *)previousMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *previousMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return previousMonthDate;
}

#pragma mark - Private

// collectionView显示日期单元，设置其属性
- (void)setupCollectionView {
    CGFloat itemWidth = (kScreenWidth - CollectionViewHorizonMargin * 2) / 7;
    CGFloat itemHeight = itemWidth;
    
    UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
    flowLayot.sectionInset = UIEdgeInsetsZero;
    flowLayot.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayot.minimumLineSpacing = 0;
    flowLayot.minimumInteritemSpacing = 0;
    
    CGRect collectionViewFrame = CGRectMake(CollectionViewHorizonMargin, CollectionViewVerticalMargin+5, kScreenWidth - CollectionViewHorizonMargin * 2, itemHeight * 6);
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayot];
    [self addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[FDCalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
}

// 获取date当前月的第一天是星期几
- (NSInteger)weekdayOfFirstDayInDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    [components setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:components];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDate];
    return firstComponents.weekday - 1;
}

// 获取date当前月的总天数
- (NSInteger)totalDaysInMonthOfDate:(NSDate *)date {
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

// 获取某月day的日期
- (NSDate *)dateOfMonth:(FDCalendarMonth)calendarMonth WithDay:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date;
    
    switch (calendarMonth) {
        case FDCalendarMonthPrevious:
            date = [self previousMonthDate];
            break;
            
        case FDCalendarMonthCurrent:
            date = self.date;
            break;
            
        case FDCalendarMonthNext:
            date = [self nextMonthDate];
            break;
        default:
            break;
    }
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:day];
    NSDate *dateOfDay = [calendar dateFromComponents:components];
    return dateOfDay;
}

// 获取date当天的农历
- (NSString *)chineseCalendarOfDate:(NSDate *)date {
    NSString *day;
    NSCalendar *chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [chineseCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    if (components.day == 1) {
        day = ChineseMonths[components.month - 1];
    } else {
        day = ChineseDays[components.day - 1];
    }
    
    return day;
}

#pragma mark - UICollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CalendarCell";
    FDCalendarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (cell != nil) {
        cell.userInteractionEnabled = YES;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.dayLabel.textColor = [UIColor blackColor];
    cell.chineseDayLabel.textColor = [UIColor grayColor];
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    NSInteger totalDaysOfMonth = [self totalDaysInMonthOfDate:self.date];
    
   NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    
    if (indexPath.row < firstWeekday) {    // 小于这个月的第一天
        cell.dayLabel.text = nil;
        cell.chineseDayLabel.text= nil;
        cell.userInteractionEnabled = NO;
    } else if (indexPath.row >= totalDaysOfMonth + firstWeekday) {    // 大于这个月的最后一天
        cell.dayLabel.text = nil;
        cell.chineseDayLabel.text= nil;
        cell.userInteractionEnabled = NO;
    }else {    // 属于这个月
        NSInteger day = indexPath.row - firstWeekday + 1;
        cell.dayLabel.text= [NSString stringWithFormat:@"%ld", (long)day];
        
        if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self.date])
        {
            cell.layer.cornerRadius = cell.frame.size.height / 2;
        }
        
        cell.chineseDayLabel.text = [self chineseCalendarOfDate:[self dateOfMonth:FDCalendarMonthCurrent WithDay:day]];
        
        //cell单元格中的日期
        NSString *dateStr = [NSString stringWithFormat:@"%zd-%0.2zd-%0.2zd",components.year,components.month,day];
        //当日日期先转成年月日
        NSString *dateStr2 = [dateFormatter_ymd stringFromDate:[NSDate newDate]];
        
        if ([[dateFormatter_ymd dateFromString:dateStr] compare:[dateFormatter_ymd dateFromString:dateStr2]] != NSOrderedAscending)
        {
            cell.dayLabel.textColor = [UIColor blackColor];
            cell.chineseDayLabel.textColor = [UIColor blackColor];
            cell.userInteractionEnabled = YES;
        }
        else
        {
            cell.dayLabel.textColor = kColor(200.0, 199.0, 204.0, 1.0);
            cell.chineseDayLabel.textColor = kColor(200.0, 199.0, 204.0, 1.0);
            cell.userInteractionEnabled = NO;
        }
    }
    
    [components setDay:indexPath.row - firstWeekday + 1];
    NSString *curStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day];
    if ([curStr isEqualToString:self.intoDate] ||
        [curStr isEqualToString:self.outDate])
    {
        cell.layer.cornerRadius = self.cell1.frame.size.height / 2;
        cell.dayLabel.textColor = [UIColor whiteColor];
        cell.chineseDayLabel.textColor = [UIColor whiteColor];
        cell.statesLabel.text = [curStr isEqualToString:self.intoDate]?@"入住":@"离店";
        cell.statesLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:176.0/255.0f green:130.0/255.0f blue:46.0/255.0f alpha:1.0f];
        
        if ([curStr isEqualToString:self.intoDate])
        {
            self.cell1=cell;
        }
        else
        {
            self.cell2 = cell;
        }
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_indexCount == 0) {
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
        NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
        [components setDay:indexPath.row+1 - firstWeekday + 1];
        
        self.cell1 = (FDCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath ];
        _oldSelectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        self.cell1.backgroundColor = [UIColor colorWithRed:176.0/255.0f green:130.0/255.0f blue:46.0/255.0f alpha:1.0f];
        
        self.cell1.layer.cornerRadius = self.cell1.frame.size.height / 2;
        self.cell1.dayLabel.textColor = [UIColor whiteColor];
        self.cell1.chineseDayLabel.textColor = [UIColor whiteColor];
        self.cell1.statesLabel.text = @"入住";
        self.cell1.statesLabel.textColor = [UIColor whiteColor];
        
        [self.delegate getValue:[NSString stringWithFormat:@"入住: %ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day-1]];
        
        NSString *week = [self getWeekDay:components];
        
        self.intoStr = [NSString stringWithFormat:@"%ld月%ld日  %@",(long)components.month,(long)components.day,week];
        
        self.intoDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day];
        
        _indexCount ++;
        
    }else if(_indexCount == 1)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
        NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
        [components setDay:indexPath.row+1 - firstWeekday + 1];
        NSDate *selectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        self.cell2 = (FDCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath ];
        if ([selectedDate compare:_oldSelectedDate] ==  NSOrderedDescending) {
            
            self.cell2.backgroundColor = [UIColor colorWithRed:176.0/255.0f green:130.0/255.0f blue:46.0/255.0f alpha:1.0f];
            self.cell2.layer.cornerRadius = self.cell2.frame.size.height / 2;
            self.cell2.dayLabel.textColor = [UIColor whiteColor];
            self.cell2.chineseDayLabel.textColor = [UIColor whiteColor];
            self.cell2.statesLabel.text = @"离店";
            self.cell2.statesLabel.textColor = [UIColor whiteColor];
            
            //self.userInteractionEnabled = NO;
            
            [self.delegate getOutValue:[NSString stringWithFormat:@"离店: %ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day-1]];
            
            NSString *str = [self getSubtractValue:_oldSelectedDate second:selectedDate];
            
            NSString *weekDay = [self getWeekDay:components];
            
            self.outStr = [NSString stringWithFormat:@"%ld月%ld日  %@",(long)components.month,(long)components.day,weekDay];
            
            self.outDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day];
            
            _indexCount++;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 2秒后异步执行这里的代码...
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getBack" object:nil userInfo:@{@"nightCount":str,@"intoDate":self.intoStr,@"outDate":self.outStr,@"searchInto":self.intoDate,@"searchOut":self.outDate}];
                
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                
            });
            
        }else if ([selectedDate compare:_oldSelectedDate] ==  NSOrderedAscending)
        {
            
            self.cell1.backgroundColor = [UIColor clearColor];
            self.cell1.dayLabel.textColor = [UIColor blackColor];
            self.cell1.chineseDayLabel.textColor = [UIColor grayColor];
            
            
            self.cell2.backgroundColor = [UIColor colorWithRed:176.0/255.0f green:130.0/255.0f blue:46.0/255.0f alpha:1.0f];
            self.cell2.layer.cornerRadius = self.cell2.frame.size.height / 2;
            self.cell2.dayLabel.textColor = [UIColor whiteColor];
            self.cell2.chineseDayLabel.textColor = [UIColor whiteColor];
            self.cell2.statesLabel.text = @"入住";
            self.cell2.statesLabel.textColor = [UIColor whiteColor];
            
            [self.delegate getValue:[NSString stringWithFormat:@"入住: %ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day-1]];
            
            NSString *weekDay = [self getWeekDay:components];
            
            self.intoStr = [NSString stringWithFormat:@"%ld月%ld日  %@",(long)components.month,(long)components.day,weekDay];
            
            self.intoDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day];
            
            self.cell1 = self.cell2;
            _oldSelectedDate = selectedDate;
            _indexCount = 1;
            
        }
    }
    else if (_indexCount == 2)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
        NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
        [components setDay:indexPath.row+1 - firstWeekday + 1];
        NSDate *selectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        if ([selectedDate compare:_oldSelectedDate] ==  NSOrderedDescending)
        {
            self.cell2.backgroundColor = [UIColor clearColor];
            self.cell2.dayLabel.textColor = [UIColor blackColor];
            self.cell2.chineseDayLabel.textColor = [UIColor grayColor];
            
            self.cell2 = (FDCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath ];
            self.cell2.backgroundColor = [UIColor colorWithRed:176.0/255.0f green:130.0/255.0f blue:46.0/255.0f alpha:1.0f];
            self.cell2.layer.cornerRadius = self.cell2.frame.size.height / 2;
            self.cell2.dayLabel.textColor = [UIColor whiteColor];
            self.cell2.chineseDayLabel.textColor = [UIColor whiteColor];
            self.cell2.statesLabel.text = @"离店";
            self.cell2.statesLabel.textColor = [UIColor whiteColor];

            [self.delegate getOutValue:[NSString stringWithFormat:@"离店: %ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day-1]];
            
            NSString *str = [self getSubtractValue:_oldSelectedDate second:selectedDate];
            
            NSString *weekDay = [self getWeekDay:components];
            
            self.outStr = [NSString stringWithFormat:@"%ld月%ld日  %@",(long)components.month,(long)components.day,weekDay];
            
            self.outDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 2秒后异步执行这里的代码...
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getBack" object:nil userInfo:@{@"nightCount":str,@"intoDate":self.intoStr,@"outDate":self.outStr,@"searchInto":self.intoDate,@"searchOut":self.outDate}];
                
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                
            });
        }
    }
}

- (NSString *)getWeekDay:(NSDateComponents *)component{
    
    [component setDay:component.day - 1];
    
    NSString *weekDay = [self weekdayStringFromDate:[[NSCalendar currentCalendar] dateFromComponents:component]];
    
    return weekDay;
    
}

//获取星期
-(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

//计算时间差值
- (NSString *)getSubtractValue:(NSDate *)dateOne second:(NSDate *)dateTwo
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:dateOne];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:dateTwo];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return [NSString stringWithFormat:@"%ld",(long)dayComponents.day];
}

@end
