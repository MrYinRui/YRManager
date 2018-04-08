//
//  HMConfirmWayView.h
//  HotelManager
//
//  Created by YR on 2017/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMPayWayModel.h"

@interface HMConfirmWayView : UIView

@property (nonatomic, strong) void (^OrderNumChange)(NSString *num);

- (instancetype)initWithFrame:(CGRect)frame withModel:(HMPayWayModel *)model;

@end
