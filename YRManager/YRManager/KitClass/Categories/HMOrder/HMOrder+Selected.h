//
//  HMOrder+Selected.h
//  HotelManager
//
//  Created by Seven on 2017/5/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMOrder.h"

@interface HMOrder (Selected)

@property (nonatomic, assign) BOOL order_isSelected;
/**
 关联订单 退房能否 选
 @return 是否能选
 */
-(BOOL)interrelatedOrderCheckoutCanSelected;

@end
