//
//  HMSelectCalendarView.m
//  HotelManager
//
//  Created by YR on 2017/4/10.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMSelectCalendarView.h"
#import "HMFlowLayout.h"
#import "NSDate+HMProjectKit.h"
#import <CoreText/CoreText.h>
#import "RSOrderRoomPriceCalendarCell.h"
#import "NSDate+HMProjectKit.h"

#define kCellHeight 65
#define kCellWidth  (381/7.f)
#define kSelectRoomCalendarCell     @"SELECT_ROOM_CALENDAR_CELL"
#define kDateLabTag 10086
#define kSelectedCellYellowColor  kColor(170, 130, 35, 1.0)

@interface HMSelectCalendarView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray  *dateArr;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) NSDate   *checkOutDate;
@property (nonatomic, strong) NSDate   *checkInDate;
@property (nonatomic, strong) NSMutableArray *contentArr;
//@property (nonatomic, strong) UIButton *modifyBtn;
//@property (nonatomic, strong) UILabel  *dateLab;
@property (nonatomic, strong) NSCalendar  *calendar;

@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *checkInLab;
@property (nonatomic, strong) UILabel *checkOutLab;
@property (nonatomic, strong)  NSMutableDictionary * priceDict;//!< 价格数据
@property (nonatomic, strong)  NSDate * rightDayDate;//!< 当前日期

@property (nonatomic, strong) UILabel *roomInfo;

@end

@implementation HMSelectCalendarView
{
    NSDateComponents *todayComponents;      //!<今天的
    NSDateComponents *currentComponents;    //!<当前展示的
    NSString *_checkinDateStr; //!< 入住时间
    NSString *_checkoutDateStr; //!< 离店时间
}

- (instancetype)initWithFrame:(CGRect)frame andDataSourceDic:(NSMutableDictionary *)dataSourceDic
{
    if (self = [super initWithFrame:frame])
    {
        self.priceDict = dataSourceDic;
        
        [self initUI];
        
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discardSelected) name:@"kCancelSelectedDateNotification" object:nil];
        
    }
    
    return self;
}

- (void)setDataSourceDic:(NSMutableDictionary *)dataSourceDic
{
    _dataSourceDic = dataSourceDic;
    
    self.priceDict = dataSourceDic;
    
    [self.collectionView reloadData];
    
}

- (void)setOrder:(HMOrder *)order
{
    _order = order;
    _roomInfo = [UILabel new];
    _roomInfo.b_textColor(kYellowColor).b_font(kFont(18))
    .b_textAlignment(NSTextAlignmentCenter)
    .b_text([NSString stringWithFormat:@"%@ %@ %@F",_order.room.roomNumber,_order.room.huayuan.name,_order.room.floor])
    .b_frame(LPRectMake(0, 20, 375, 20)).b_moveToView(self);
}

- (void)initUI
{
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.frame = LPRectMake(125, 60, 125, 30);
    [dateBtn setTitle:[self getDate] forState:UIControlStateNormal];
    [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dateBtn.titleLabel.font = kFont(22);
    [self addSubview:dateBtn];
    self.dateBtn = dateBtn;
    
    UIButton *lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lastMonthBtn.frame = LPRectMake(95, 60, 30, 30);
    [lastMonthBtn setImage:[UIImage imageNamed:@"arrow_left_02"] forState:UIControlStateNormal];
    [lastMonthBtn addTarget:self action:@selector(clickedLastMonthBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastMonthBtn];
    
    UIButton *nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextMonthBtn.frame = LPRectMake(250, 60, 30, 30);
    [nextMonthBtn setImage:[UIImage imageNamed:@"arrow_right_02"] forState:UIControlStateNormal];
    [nextMonthBtn addTarget:self action:@selector(clickedNextMonthBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextMonthBtn];
    
    [self initWeekLab];
    [self initCalendarView];
    
}
- (NSString *)getDate
{
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate newDate]];
    
    todayComponents = components;
    currentComponents = [components copy];
    
    return [NSString stringWithFormat:@"%zd-%zd", components.year, components.month];
}

- (void)initWeekLab
{
    UILabel *weekLab = [[UILabel alloc] initWithFrame:LPRectMake(0, 100 , 375, 20.f)];
    weekLab.font = kFont(16);
    weekLab.textColor = kColor(130, 130, 130, 1);
    weekLab.text = @"日一二三四五六";
    [self addSubview:weekLab];
    
    CGSize size = [weekLab sizeThatFits:LPSizeMake(CGFLOAT_MAX, 20)];
    CGFloat space = (weekLab.width - size.width) / 7;
    weekLab.x += space / 2;
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:weekLab.text];
    [attributeText addAttribute:(id)kCTKernAttributeName value:@(space) range:NSMakeRange(0, attributeText.string.length)];
    
    weekLab.attributedText = attributeText;
    weekLab.textAlignment = NSTextAlignmentCenter;
}

- (void)initCalendarView
{
    HMFlowLayout *layout = [HMFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//150 * 560
    _collectionView = [[UICollectionView alloc] initWithFrame:LPRectMake(0, 125 , 375, kCellHeight * 5 + 6) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.bounces = NO;
    _collectionView.allowsMultipleSelection = YES;
    [_collectionView registerClass:[RSOrderRoomPriceCalendarCell class] forCellWithReuseIdentifier:kSelectRoomCalendarCell];
    [self addSubview:_collectionView];
    
    self.dateArr = [NSDate calendarDateWithYear:0 month:0];
    
    _contentArr = [NSMutableArray new];
    
    [self setContentArrWithDateArr:self.dateArr];
    
}

#pragma mark - collectionview delegate & datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    collectionView.height = (kCellHeight + 1) * _dateArr.count / 7 * kScreenScale + 1;
    return _dateArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RSOrderRoomPriceCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSelectRoomCalendarCell forIndexPath:indexPath];
    
    //取日期
    NSDictionary *dateDict = _contentArr[indexPath.item];
    
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateDict[@"date"]];
    
    cell.dateLab.text = @(dateComponents.day).stringValue;
    
    //取价格
    self.rightDayDate = [NSDate newDate];
    NSString * key = [NSString stringWithFormat:@"%zd-%02zd-%02zd",dateComponents.year,dateComponents.month,dateComponents.day];
    NSString *price = [self.priceDict[key] valueForKey:@"price_jdt"];
    NSString *isCheckIn = [self.priceDict[key] valueForKey:@"ischeckIn"];
    //    NSString *status  = [self.priceDict[key] valueForKey:@"status"];
    
    if (price == nil)
    {
        cell.priceLab.text = nil;
    }
    else
    {
        cell.priceLab.text = [@"￥"stringByAppendingString:price];
        
    }
    
    //    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    //    NSInteger totalDaysOfMonth = [self totalDaysInMonthOfDate:self.rightDayDate];
    
    
    // 按照显示优先等级来进行判断
    
    //非当前月份不显示
    if (dateComponents.year != currentComponents.year ||
        dateComponents.month != currentComponents.month)
    {
        [cell setShowStyle:NO_SHOW_CAL];
    }
    else
    {
        if([self dateComponents:dateComponents earlierThanDateComponents:todayComponents])
        {
            [cell setShowStyle:GRAY];
        }
        else if([isCheckIn isEqualToString:@"1"])
        {
            [cell setShowStyle:ORDER_CAL];
            cell.priceLab.text = @"已订";
        }
        else if ([dateComponents isEqual:todayComponents])
        {
            [cell setShowStyle:GREEN_DEEP];
        }
        else
        {
            [cell setShowStyle:GREEN_LIGHT];
        }
        
        [self freshCell:cell withDate:dateDict[@"date"]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return LPSizeMake(kCellWidth, kCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_dateArr[indexPath.item]];
    
    //  今天之前的日期不可选，不在当前显示月份的也不可选
    if ((![self dateComponents:components earlierThanDateComponents:todayComponents]) &&
        (components.month == currentComponents.month && components.year == currentComponents.year))
    {
        if (_checkInDate)
        {
            if ([self.calendar compareDate:_checkInDate toDate:_dateArr[indexPath.item] toUnitGranularity:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear] == NSOrderedAscending)
            {
                _checkOutDate = _dateArr[indexPath.item];
                _checkoutDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)components.year, (long)components.month, (long)components.day];
                [_collectionView reloadData];
            }
            else
            {
                [Prompt popPromptViewWithMsg:@"离店日期不得早于入住日期" duration:2.f];
                return ;
            }
        }
        else
        {
            _checkInDate = _dateArr[indexPath.item];
            //            _checkInDateLab.text = [NSString stringWithFormat:@"入住：%d-%02d-%02d", components.year, components.month, components.day];
            _checkinDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)components.year, (long)components.month, (long)components.day];
            [collectionView reloadData];
        }
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        
        CGFloat totalPrice = 0;
        for(int i = 0; i < [[NSDate getSubtractValue:_checkInDate second:_checkOutDate] integerValue]; i++)
        {
            NSString * key = [formatter stringFromDate:[_checkInDate leadDay:i]];
            NSString *price = [self.priceDict[key] valueForKey:@"price"];
            totalPrice += [price floatValue];
        }
        
        if (_SelectedDateCallback)
        {
            _SelectedDateCallback(_checkinDateStr,_checkoutDateStr,totalPrice);
        }
    }
     */
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    RSOrderRoomPriceCalendarCell *cell = (RSOrderRoomPriceCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.dateLab.textColor = [UIColor blackColor];
    cell.priceLab.textColor = kGreenColor;
     */
}

#pragma mark ----Private Methods
- (void)setContentArrWithDateArr:(NSArray *)dateArr
{
    
    [_contentArr removeAllObjects];
    
    for(int i = 0; i < dateArr.count; i++)
    {
        [_contentArr addObject:@{@"date":self.dateArr[i]}];
    }
    [_collectionView reloadData];
}

- (void)freshCell:(RSOrderRoomPriceCalendarCell *)cell withDate:(NSDate *)date
{
    if (_checkInDate && _checkOutDate)
    {
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        
        if ([self.calendar compareDate:date toDate:_checkInDate toUnitGranularity:unit] != NSOrderedAscending &&
            [self.calendar compareDate:date toDate:_checkOutDate toUnitGranularity:unit] != NSOrderedDescending)
        {
            [cell setShowStyle:YELLOW];
        }
        
        if (cell.contentView == self.checkInLab.superview)
        {
            self.checkInLab.hidden = YES;
        }
        if (cell.contentView == self.checkOutLab.superview)
        {
            self.checkOutLab.hidden = YES;
        }
    }
    if ([_checkOutDate isEqual:date])
    {
        self.checkOutLab.hidden = NO;
        [cell.contentView addSubview:self.checkOutLab];
        [cell setShowStyle:YELLOW];
    }
    else if ([_checkInDate isEqual:date])
    {
        self.checkInLab.hidden = NO;
        [cell.contentView addSubview:self.checkInLab];
        [cell setShowStyle:YELLOW];
    }
}

#pragma mark - views' event

- (void)clickedLastMonthBtn
{
    if (currentComponents.month == 1)
    {
        currentComponents.month = 12;
        currentComponents.year--;
    }
    else
    {
        currentComponents.month --;
    }
    
    [_dateBtn setTitle:[NSString stringWithFormat:@"%ld-%02ld", (long)currentComponents.year, (long)currentComponents.month] forState:UIControlStateNormal];
    self.dateArr = [NSDate calendarDateWithYear:(int)currentComponents.year month:(int)currentComponents.month];
    
    [self setContentArrWithDateArr:self.dateArr];
    
    //发送通知
    [self postNotificationWithComponents:currentComponents];
}

- (void)clickedNextMonthBtn
{
    if (currentComponents.month == 12)
    {
        currentComponents.month = 1;
        currentComponents.year++;
    }
    else
    {
        currentComponents.month ++;
    }
    
    [_dateBtn setTitle:[NSString stringWithFormat:@"%ld-%02ld", (long)currentComponents.year, (long)currentComponents.month] forState:UIControlStateNormal];
    self.dateArr = [NSDate calendarDateWithYear:(int)currentComponents.year month:(int)currentComponents.month];
    
    [self setContentArrWithDateArr:self.dateArr];
    
    //发送通知
    [self postNotificationWithComponents:currentComponents];
}


/**
 发送通知
 */
- (void)postNotificationWithComponents:(NSDateComponents *)components
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HMOrderRoomPriceCalenderChangeMonthNotification object:nil userInfo:@{@"components":components}];
}



- (BOOL)selectDate:(NSDate *)date
        components:(NSDateComponents *)components
{
    if (!_checkInDate) //如果没有选中入住日期，默认选择入住日期，则选择离店日期
    {
        _checkInDate = date;
        //        _modifyBtn.backgroundColor = kGreenColor;
        _checkinDateStr = [NSString stringWithFormat:@"%zd-%zd-%zd", components.year, (long)components.month, (long)components.day];
        return YES;
    }
    else
    {
        NSComparisonResult result = [self.calendar compareDate:date toDate:_checkInDate toUnitGranularity:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];
        if (result == NSOrderedDescending)
        {
            _checkoutDateStr = [NSString stringWithFormat:@"%zd-%zd-%zd", components.year, components.month, (long)components.day];
            _checkOutDate = date;
            [_collectionView reloadData];
            
            
            return YES;
        }
        else
        {
            [Prompt popPromptOnView:self withMsg:@"离店日期得晚于入住日期哦~" duration:3.f];
        }
    }
    return NO;
}


#pragma mark - private method

- (void)handleLab:(UILabel *)lab withDate:(NSDate *)date
{
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *components = [self.calendar components:calendarUnit fromDate:date];
    
    //  日期是否显示，非当前展示月份不显示
    if (components.month != currentComponents.month ||
        components.year != currentComponents.year)
    {
        lab.hidden = YES;
    }
    else
    {
        lab.hidden = NO;
        lab.text = @(components.day).stringValue;
        
        //  早于今天的日期，显示灰色，其他显示黑色
        if([self dateComponents:components earlierThanDateComponents:todayComponents])
        {
            lab.textColor = [UIColor lightGrayColor];
        }
        else
        {
            lab.textColor = [UIColor blackColor];
        }
        
        if ([date isEqual:_checkInDate] ||
            [date isEqual:_checkOutDate])
        {
            lab.font = kBFont(12);
            lab.textColor = [UIColor whiteColor];
            lab.backgroundColor = kSelectedCellYellowColor;
            
        }
        else if ([self.calendar compareDate:date toDate:_checkInDate
                          toUnitGranularity:calendarUnit] == NSOrderedDescending &&
                 [self.calendar compareDate:date toDate:_checkOutDate
                          toUnitGranularity:calendarUnit] == NSOrderedAscending)
        {
            lab.font = kFont(12);
            lab.backgroundColor = kColor(231, 204, 133, 1);
        }
        else
        {
            lab.font = kFont(12);
            lab.backgroundColor = [UIColor clearColor];
        }
    }
}

- (BOOL)dateComponents:(NSDateComponents *)components1 earlierThanDateComponents:(NSDateComponents *)components2
{
    NSInteger timeDiff = (components1.year - components2.year) * 10000 + (components1.month - components2.month) * 100 + components1.day - components2.day;
    
    //早于今天的日期，显示灰色，其他显示黑色
    if(timeDiff < 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

- (void)setDateArr:(NSArray *)dateArr
{
    _dateArr = dateArr;
    [_collectionView reloadData];
}

- (NSCalendar *)calendar
{
    if (! _calendar)
    {
        _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

- (UILabel *)checkInLab
{
    if (! _checkInLab)
    {
        _checkInLab = [UILabel new];
        _checkInLab.text = @"入住";
        _checkInLab.textColor = [UIColor whiteColor];
        _checkInLab.textAlignment = NSTextAlignmentCenter;
        _checkInLab.frame = LPRectMake(0, 0, 55.f, 35);
        _checkInLab.font = kFont(15);
    }
    return _checkInLab;
}

- (UILabel *)checkOutLab
{
    if (! _checkOutLab)
    {
        _checkOutLab = [UILabel new];
        _checkOutLab.text = @"离店";
        _checkOutLab.textColor = [UIColor whiteColor];
        _checkOutLab.textAlignment = NSTextAlignmentCenter;
        _checkOutLab.frame = LPRectMake(0, 0, 55.f, 35);
        _checkOutLab.font = kFont(15);
    }
    return _checkOutLab;
}

- (void)dealloc
{
    //    if (_selectedBlock)
    //    {
    //        _selectedBlock(_checkInDate, _checkOutDate);
    //    }
    
}
#pragma mark --- 通知方法
- (void)discardSelected
{
    
    _checkInDate = nil;
    _checkOutDate = nil;
    [_collectionView reloadData];
    
    for (NSIndexPath *indexPath in _collectionView.indexPathsForSelectedItems)
    {
        
        [self collectionView:_collectionView didDeselectItemAtIndexPath:indexPath];
        
    }
    
}
// 获取date当前月的第一天是星期几
- (NSInteger)weekdayOfFirstDayInDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.rightDayDate];
    [components setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:components];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDate];
    return firstComponents.weekday - 1;
}

// 获取date当前月的总天数
- (NSInteger)totalDaysInMonthOfDate:(NSDate *)date
{
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

//设置入住日期
-(BOOL)setIntoDate:(NSString *)intoDate
{
    NSString *isCheckIn = [self.priceDict[intoDate] valueForKey:@"ischeckIn"];
    if([isCheckIn isEqualToString:@"1"])
    {
        _collectionView.userInteractionEnabled = NO;
        return YES;
    }
    else
    {
        _checkinDateStr = intoDate;
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        _checkInDate = [formatter dateFromString:intoDate];
        [_collectionView reloadData];
        return NO;
    }
}

@end

