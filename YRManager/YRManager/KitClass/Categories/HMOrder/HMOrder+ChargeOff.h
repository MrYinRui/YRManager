//
//  HMOrder+ChargeOff.h
//  HotelManager
//
//  Created by Seven on 2017/6/20.
//  Copyright © 2017年 Xun. All rights reserved.
//  订单核销 弹框 判断

#import "HMOrder.h"

@interface HMOrder (ChargeOff)
/**
 服务器 算法: E = 订单总金额（zje） - 订单目前小计（ffxj）- 押金（已住押金 应该置为零了）
 服务器 算法: N = 订单已收款 (ysk) - E - 协议房费（xyffxj）
 */
@property (nonatomic, assign) double e;//!< E = 选配+消费+查房
@property (nonatomic, assign) double n;//!< N = 已收款 - E - 协议房费
/**
 首先, 必须是协议单位,由后端xydwGuid字段判断, 然后走以下流程
 if: E <= 0    不弹出消费提示框	(不是欠/余款提示框）
 if: E > 0     N >= 0 	不弹出消费提示框
 if: E > 0     N < 0 	弹出消费提示框
 */
- (BOOL)isShowChargeOffView NS_DEPRECATED(10_0, 10_12, 2_0, 4_0);//!< 是否显示

- (BOOL)newest_isShowChangeOffView NS_DEPRECATED_IOS(10_0, 11_0);

/**
 手动 赋值 E
 */
- (void)manuallySetE;
/**
 多订单 核销 不考虑 是否是协议单位
 @return 是否 弹核销框
 */
- (BOOL)multiOrders_isShowChangeOffView;

/**
 单个订单 核销 考虑 是否是协议单位
 @return 是否 弹核销框
 */
- (BOOL)singleOrder_isShowChangeOffView;

@end
