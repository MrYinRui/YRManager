//
//  HMPaySuccessVC.h
//  HotelManager
//
//  Created by YR on 2017/4/5.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMBasicVC.h"
#import "HMPayWayModel.h"
#import "HMCancelOrderGet.h"

@interface HMPaySuccessVC : UIViewController

@property (nonatomic, strong) NSString  *payWay;
@property (nonatomic, assign) CGFloat   shouldMoney;
@property (nonatomic, assign) CGFloat   paiedMoney;
@property (nonatomic, strong) NSString  *topBtnTitle;
@property (nonatomic, strong) NSString  *botBtnTitle;

@property (nonatomic, strong) void(^TopBtnActionBlock)(void);
@property (nonatomic, strong) void(^BotBtnActionBlock)(void);
@property (nonatomic, strong) HMOrder *order;

@property (nonatomic, strong) NSString *memberPayType;  //!<会员支付用途


/**
 请求支付结果
 
 @param successBlock 请求成功回调
 @param failedBlock  请求失败回调
 */
- (void)requestWithOrder:(HMOrder *)order
   PayResultSuccessBlock:(void(^)(HMCancelOrderGet *))successBlock
             failedBlock:(void(^)(void))failedBlock;

@end
