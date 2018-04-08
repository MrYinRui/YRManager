//
//  HMMemberPayAlert.h
//  HotelManager
//
//  Created by YR on 2017/8/1.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMAlertBasicView.h"
#import "HMMemberPayModel.h"

@interface HMMemberPayAlert : HMAlertBasicView

- (void)refreshView:(HMMemberPayModel *)model;

@property (nonatomic, strong) void (^SuccessBlock)(double price,NSString *type);

@end
