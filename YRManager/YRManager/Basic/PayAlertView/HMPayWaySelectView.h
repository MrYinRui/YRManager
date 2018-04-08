//
//  HMPayWaySelectView.h
//  HotelManager
//
//  Created by r on 17/9/18.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMPayWayModel;

@interface HMPayWaySelectView : UIView

+ (instancetype)payWaySelectView;

- (void)show;

@property (nonatomic, assign) NSInteger selectRow;//!<选中行号

@property (nonatomic, copy) void (^confirmBlock)(HMPayWayModel *payWay);

@end
