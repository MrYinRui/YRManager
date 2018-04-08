//
//  HMTimeDateVC.m
//  HotelManager
//
//  Created by kqz on 17/3/25.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMTimeDateVC.h"
#import "HMFDCalendarView.h"

#ifndef HotelManagerMacro_h
#define HotelManagerMacro_h

#define kAlreadyAddBtnBack          @"ALREADY_ADD_BTN_BACK"
#define kAddBtnNotifi               @"ADD_BTN_NOTIFI"
#define kWorkVCModelArray           @"WORKVC_MODEL_ARRAY"
#define kGetStayTimes               @"GET_STAY_TIMES"
#define kupShopCarNum               @"UP_SHOPCAR_NUM"

#define kGetCustomerFrom            @"GET_CUSTOMER_FROM"
#define kUpShoppingCarVC            @"UP_SHOPPINGCAR_VC"
#define kDeletPayTypeCell           @"DELET_PAY_TYPE_CELL"

#endif /* HotelManagerMacro_h */

@interface HMTimeDateVC ()

@property (nonatomic, strong) NSString *intoTime;
@property (nonatomic, strong) NSString *outTime;

@end

@implementation HMTimeDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationItemBackBBI:@"" AndTitle:@"日期"];
    [self createCalender];
}

- (void)createCalender{
    HMFDCalendarView *calendar = [[HMFDCalendarView alloc] initWithCurrentDate:[NSDate newDate]];
    
    CGRect frame = calendar.frame;
    frame.origin.y = kScaleNum(StatusHeight);
    calendar.frame = frame;
    [self.view addSubview:calendar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBack:) name:@"getBack" object:nil];
}

- (void)getBack:(NSNotification *)not
{
    self.intoStr = [not.userInfo objectForKey:@"intoDate"];
    self.outStr = [not.userInfo objectForKey:@"outDate"];
    self.nightCount = [not.userInfo objectForKey:@"nightCount"];
    self.intoTime = [not.userInfo objectForKey:@"searchInto"];
    self.outTime = [not.userInfo objectForKey:@"searchOut"];
    
    NSDate *currDate = [NSDate newDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:currDate];
    
    NSString *isToday = [[NSString alloc]init];
    
    if ([dateStr isEqualToString:self.intoTime]) {
        isToday = @"1";
    }else{
        isToday = @"2";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetSelectDateNotification object:nil userInfo:@{@"intoTime":self.intoStr,@"outTime":self.outStr,@"count":self.nightCount,@"searchInto":self.intoTime,@"searchOut":self.outTime,@"isToday":isToday}];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI{
    self.title = @"日期";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
}

#pragma mark - 返回按钮实现
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

