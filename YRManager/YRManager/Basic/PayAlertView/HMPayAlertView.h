//
//  HMPayAlertView.h
//  HotelManager
//
//  Created by YR on 2017/3/29.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMPaySuccessVC.h"
@class HMPayInfoModel,HMPayWayModel;

@interface HMPayAlertView : UIView

@property (nonatomic, strong) HMPaySuccessVC *successVC;
@property (nonatomic, strong) NSString *isTurnClean;
@property (nonatomic, strong) HMPayInfoModel *payInfoModel;
@property (nonatomic, assign) BOOL isBanPrice;
@property (nonatomic, copy) void (^selectBlock)(NSInteger index);

+ (instancetype)initWithGuids:(NSArray *)orderGuids payType:(PayType)type;
+ (instancetype)initWithGuids:(NSArray *)orderGuids payType:(PayType)type AndPayWayModel:(HMPayWayModel *)payWayModel;
- (void)showOnView:(UIView *)view;

@end
