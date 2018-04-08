//
//  HMPayInfoCell.h
//  HotelManager
//
//  Created by YR on 2017/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMPayInfoModel.h"
#import "HMPayWayModel.h"

@interface HMPayInfoCell : UITableViewCell

@property (nonatomic, strong) void (^ChangeShouldPayBlock)(NSString *price);
@property (nonatomic, assign) BOOL banPrice;

- (void)refreshCell:(HMPayInfoModel *)model withPayWay:(HMPayWayModel *)payWay payType:(PayType)type;

@end
