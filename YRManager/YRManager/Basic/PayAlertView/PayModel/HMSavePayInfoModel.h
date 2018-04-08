//
//  HMSavePayInfoModel.h
//  HotelManager
//
//  Created by YR on 2017/4/5.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMPaiedDetailModel.h"

@interface HMSavePayInfoModel : NSObject

@property (nonatomic, strong) NSString *payType;        //!<
@property (nonatomic, strong) NSString *ddGuid;         //!<订单主键
@property (nonatomic, strong) NSString *userId;         //!<登录人id
@property (nonatomic, strong) NSString *userName;       //!<登录人姓名
@property (nonatomic, strong) NSString *loginName;      //!<登录人的登录名

@property (nonatomic, strong) NSString *cs_id;          //!<酒店唯一标识
@property (nonatomic, strong) NSArray <HMPaiedDetailModel *> *skList; //!<收款明细列表
@property (nonatomic, strong) NSString *memberId;       //!<会员支付会员id
@property (nonatomic, strong) NSString *isTurnClean;    //!<房间是否转洁
@property (nonatomic, strong) NSString *paymentSource;  //!<5(早餐，运动健身) 6(餐厅)

@end
