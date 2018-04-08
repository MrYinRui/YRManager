//
//  HMSelectCalendarView.h
//  HotelManager
//
//  Created by YR on 2017/4/10.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMBasicDialogView.h"
#import "HMOrder.h"
#import "HMRoom.h"

@interface HMSelectCalendarView : HMBasicDialogView

- (instancetype)initWithFrame:(CGRect)frame andDataSourceDic:(NSMutableDictionary *)dataSourceDic;

@property (nonatomic, copy) void(^SelectedDateCallback)(NSString *checkinDate,NSString *checkoutDate,CGFloat totalPrice);  //!<选择日期的回调
@property (nonatomic, strong)  NSMutableDictionary * dataSourceDic;//!< 数据源

-(BOOL)setIntoDate:(NSString *)intoDate;//!<设置入住日期(hzg)

@property (nonatomic, strong) HMOrder *order;

@end
