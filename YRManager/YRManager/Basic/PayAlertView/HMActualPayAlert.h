//
//  HMActualPayAlert.h
//  HotelManager
//
//  Created by YR on 2017/3/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMPayInfoModel.h"

@interface HMActualPayAlert : UIView

@property (nonatomic, strong) void (^SureChangePayBlock)(NSString *price);

- (instancetype)initWithPayInfo:(HMPayInfoModel *)payInfo money:(CGFloat)price andPayWay:(NSString *)payWay;
- (void)showOnView:(UIView *)view;

@end
