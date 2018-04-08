//
//  LPSelectRoomCalendarView.m
//  Lodger-Pad
//
//  Created by xun on 10/9/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "LPSelectRoomCalendarView.h"
#import "HMFlowLayout.h"
#import "NSDate+HMProjectKit.h"
#import <CoreText/CoreText.h>

#define kCellHeight 59
#define kCellWidth  ((375/7.f) - 1)
#define kSelectRoomCalendarCell     @"SELECT_ROOM_CALENDAR_CELL"
#define kDateLabTag 10086

@interface LPSelectRoomCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dateArr;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) NSDate *checkOutDate;
@property (nonatomic, strong) NSDate *checkInDate;

@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation LPSelectRoomCalendarView
{
    NSDateComponents *todayComponents;      //!<今天的
    NSDateComponents *currentComponents;    //!<当前展示的
}

+ (instancetype)calendarView
{
    return [LPSelectRoomCalendarView calendarViewWithDate:[NSDate newDate] Select:NO withSelectDate:nil];
}

+ (instancetype)calendarViewWithDate:(NSDate *)date Select:(BOOL)isSelect withSelectDate:(NSDate *)selectDate
{
    LPSelectRoomCalendarView *view = [[LPSelectRoomCalendarView alloc] initWithFrame:CGRectMake(0, kScaleNum(StatusHeight + 20), kScreenWidth, kScreenHeight-kScaleNum(StatusHeight + 20))];
    //LPSelectRoomCalendarView *view = [LPSelectRoomCalendarView viewWithFrame:LPRectMake(0, 64, 375, 667-64)];
    
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.frame = LPRectMake(125, 20, 125, 30);
    [dateBtn setTitle:[view getDateWith:date] forState:UIControlStateNormal];
    [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dateBtn.titleLabel.font = kFont(24);
    [view addSubview:dateBtn];
    view.dateBtn = dateBtn;
    
    UIButton *lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lastMonthBtn.frame = LPRectMake(95, 20, 30, 30);
    [lastMonthBtn setImage:[UIImage imageNamed:@"arrow_left_02"] forState:UIControlStateNormal];
    [lastMonthBtn addTarget:view action:@selector(clickedLastMonthBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:lastMonthBtn];
    
    UIButton *nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextMonthBtn.frame = LPRectMake(250, 20, 30, 30);
    [nextMonthBtn setImage:[UIImage imageNamed:@"arrow_right_02"] forState:UIControlStateNormal];
    [nextMonthBtn addTarget:view action:@selector(clickedNextMonthBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextMonthBtn];
    
    UILabel *checkInLab = [UILabel new];
    checkInLab.textColor = kYellowColor;
    checkInLab.font = kFont(18);
    checkInLab.frame = LPRectMake(40, 667-64-50, 295, 20);
    [view addSubview:checkInLab];
    view.dateLab = checkInLab;
    
    [view initWeekLab];
    [view initCalendarView];
    
    if(isSelect)
    {
        NSDateComponents *components = [view.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:selectDate];
        [view selectDate:selectDate components:components];
    }
    
    return view;
}

+ (instancetype)calendarViewWithDate:(NSDate *)date Select:(BOOL)isSelect withSelectDate:(NSDate *)selectDate AndHiddenTip:(BOOL)hiddenTip
{
    LPSelectRoomCalendarView *view = [[LPSelectRoomCalendarView alloc] initWithFrame:CGRectMake(0, kScaleNum(StatusHeight), kScreenWidth, kScreenHeight-kScaleNum(StatusHeight))];
    //LPSelectRoomCalendarView *view = [LPSelectRoomCalendarView viewWithFrame:LPRectMake(0, 64, 375, 667-64)];
    view.hiddenTip = hiddenTip;
    
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.frame = LPRectMake(125, 20, 125, 30);
    [dateBtn setTitle:[view getDateWith:date] forState:UIControlStateNormal];
    [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dateBtn.titleLabel.font = kFont(24);
    [view addSubview:dateBtn];
    view.dateBtn = dateBtn;
    
    UIButton *lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lastMonthBtn.frame = LPRectMake(95, 20, 30, 30);
    [lastMonthBtn setImage:[UIImage imageNamed:@"arrow_left_02"] forState:UIControlStateNormal];
    [lastMonthBtn addTarget:view action:@selector(clickedLastMonthBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:lastMonthBtn];
    
    UIButton *nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextMonthBtn.frame = LPRectMake(250, 20, 30, 30);
    [nextMonthBtn setImage:[UIImage imageNamed:@"arrow_right_02"] forState:UIControlStateNormal];
    [nextMonthBtn addTarget:view action:@selector(clickedNextMonthBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextMonthBtn];
    
    UILabel *checkInLab = [UILabel new];
    checkInLab.textColor = kYellowColor;
    checkInLab.font = kFont(18);
    checkInLab.frame = LPRectMake(40, 667-64-50, 295, 20);
    [view addSubview:checkInLab];
    view.dateLab = checkInLab;
    
    [view initWeekLab];
    [view initCalendarView];
    
    if(isSelect)
    {
        NSDateComponents *components = [view.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:selectDate];
        [view selectDate:selectDate components:components];
    }
    
    return view;
}

- (NSString *)getDateWith:(NSDate *)date
{
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    todayComponents = components;
    currentComponents = [components copy];
    
    return [NSString stringWithFormat:@"%zd-%02zd", components.year, components.month];
}

- (void)initWeekLab
{
    UILabel *weekLab = [[UILabel alloc] initWithFrame:LPRectMake(0, 70 , 375, 20.f)];
    weekLab.font = kFont(18);
    weekLab.textColor = kColor(179, 131, 35, 1);
    weekLab.text = @"日一二三四五六";
    [self addSubview:weekLab];
    
    CGSize size = [weekLab sizeThatFits:CGSizeMake(CGFLOAT_MAX, 20)];
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
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:LPRectMake(0, 95 , 375, kCellHeight * 5 + 6) collectionViewLayout:layout];
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kSelectRoomCalendarCell];
    [self addSubview:_collectionView];
    
    for (int i = 0; i < 7; i++)
    {
        CALayer *line = [CALayer new];
        line.backgroundColor = kSeparatorLineColor.CGColor;
        line.frame = LPRectMake(0, 60 * i + 95, 0, 0.5f);
        line.width = kScaleNum(375);
        [self.layer addSublayer:line];
    }
    
    self.dateArr = [NSDate calendarDateWithYear:0 month:0];
}

#pragma mark - collectionview delegate & datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    collectionView.height = ((kCellHeight + 1) * _dateArr.count / 7 + 1) *kScreenScale;
    return _dateArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSelectRoomCalendarCell forIndexPath:indexPath];
    
    UILabel *lab = [cell.contentView viewWithTag:kDateLabTag];
    UILabel *titleLab = [cell.contentView viewWithTag:kDateLabTag+1000];
    
    if(!lab)
    {
        lab = [UILabel new];
        lab.tag = kDateLabTag;
        lab.font = kFont(16);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.frame = LPRectMake(kCellWidth / 2 - 24, 6, 48, 48);
        lab.layer.cornerRadius = kScaleNum(24);
        lab.clipsToBounds = YES;
        [cell.contentView addSubview:lab];
        
        titleLab = [UILabel new];
        titleLab.tag = kDateLabTag + 1000;
        titleLab.font = kFont(12);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.frame = LPRectMake(0, 10, kCellWidth, 10);
        titleLab.clipsToBounds = YES;
        titleLab.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLab];
    }
    
    [self handleLab:lab withTitle:titleLab withDate:_dateArr[indexPath.item]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCellWidth * kScreenScale, kCellHeight* kScreenScale);
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
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_dateArr[indexPath.item]];
    
    //  今天之前的日期不可选
    if (![self dateComponents:components earlierThanDateComponents:todayComponents])
    {
        if ([self selectDate:_dateArr[indexPath.row] components:components])
        {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            
            UILabel *lab = [cell.contentView viewWithTag:kDateLabTag];
            //UILabel *titleLab = [cell.contentView viewWithTag:kDateLabTag+1000];
            
            lab.backgroundColor = kYellowColor;
            lab.textColor = [UIColor whiteColor];
            lab.font = kBFont(16);
        }
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
}

- (BOOL)selectDate:(NSDate *)date
        components:(NSDateComponents *)components
{
    if (!_checkInDate) //如果没有选中入住日期，默认选择入住日期，则选择离店日期
    {
        _checkInDate = date;
        _modifyBtn.backgroundColor = kGreenColor;
        _dateLab.text = [NSString stringWithFormat:@"续住 %zd-%02zd-%02zd", components.year, components.month, components.day];
        
        if (_hiddenTip == YES) _dateLab.hidden = YES;
        
        if (_onceClick == YES)
        {
            _checkOutDate = date;
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
        }
        return YES;
    }
    else
    {
        NSComparisonResult result = [self.calendar compareDate:date toDate:_checkInDate toUnitGranularity:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];
        if (result == NSOrderedDescending)
        {
            _dateLab.text = [_dateLab.text stringByAppendingString:[NSString stringWithFormat:@"   离店 %zd-%zd-%zd", components.year, components.month, components.day]];
            if (_hiddenTip == YES) _dateLab.hidden = YES;
            _checkOutDate = date;
            [_collectionView reloadData];
            
            [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
            
            return YES;
        }
        else
        {
            if (_hiddenTip != YES)
            [Prompt popPromptOnView:self withMsg:@"离店日期得晚于续住日期哦~" duration:3.f];
        }
    }
    return NO;
}

#pragma mark - private method
- (void)handleLab:(UILabel *)lab withTitle:(UILabel *)titleLab withDate:(NSDate *)date
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
            lab.font = kBFont(16);
            lab.textColor = [UIColor whiteColor];
            
            if ([date isEqual:_checkInDate])
            {
                lab.backgroundColor = kColor(200, 200, 200, 1);
                titleLab.text = @"续住";
            }
            else
            {
                lab.backgroundColor = kYellowColor;
                titleLab.text = @"离店";
            }
            
            if (_hiddenTip == YES) titleLab.text = @"";
        }
        else if ([self.calendar compareDate:date toDate:_checkInDate
                          toUnitGranularity:calendarUnit] == NSOrderedDescending &&
                 [self.calendar compareDate:date toDate:_checkOutDate
                          toUnitGranularity:calendarUnit] == NSOrderedAscending)
        {
            lab.font = kFont(16);
            lab.backgroundColor = kColor(231, 204, 133, 1);
            titleLab.text = @"";
        }
        else
        {
            lab.font = kFont(16);
            lab.backgroundColor = [UIColor clearColor];
            titleLab.text = @"";
        }
    }
}

- (BOOL)dateComponents:(NSDateComponents *)components1 earlierThanDateComponents:(NSDateComponents *)components2
{
    NSInteger timeDiff = (components1.year - components2.year) * 10000 + (components1.month - components2.month) * 100 + components1.day - components2.day;
    
    //  早于今天的日期，显示灰色，其他显示黑色
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

-(void)removeFromSuperview{
    
    if (_selectedBlock && _checkInDate != nil && _checkOutDate !=nil)
    {
        _selectedBlock(_checkInDate, _checkOutDate);
    }
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

- (UIViewController *)viewController
{
    UIResponder *responder = self;
    
    while ((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return (id)responder;
        }
    }
    
    return (id)responder;
}

@end
