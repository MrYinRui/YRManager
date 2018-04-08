//
//  HMPaiedDetailModel.h
//  HotelManager
//
//  Created by YR on 2017/4/5.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPaiedDetailModel : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic, assign) CGFloat  skje;            //!<收款金额
@property (nonatomic, strong) NSString *skfs;           //!<收款方式（收款方式的id）
@property (nonatomic, strong) NSString *lsh;            //!<流水号（非必填）
@property (nonatomic, strong) NSString *bz;             //!<备注
@property (nonatomic, strong) NSString *fj_path;        //!<附件地址

@property (nonatomic, assign) double    payedMoney;     //!<退款后台加的字段

//会员支付相关
@property (nonatomic, strong) NSString *sklxmc;         //!<
@property (nonatomic, assign) double    yfk;            //!<


@end
