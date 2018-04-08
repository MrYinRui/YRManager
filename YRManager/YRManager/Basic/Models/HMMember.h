//
//  HMMember.h
//  HotelManager
//
//  Created by r on 17/6/20.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMMemberLevelInfo;
@class HMLodger;

@interface HMMember : NSObject<NSCopying>

@property (nonatomic, copy) NSString *memberGuid;//!<主键guid
@property (nonatomic, copy) NSString *memberNo;//!<会员编号
@property (nonatomic, copy) NSString *name;//!<名字
@property (nonatomic, copy) NSString *sex;//!<性别
@property (nonatomic, copy) NSString *phone;//!<手机
@property (nonatomic, copy) NSString *idCardNum;//!<证件号码
@property (nonatomic, copy) NSString *birthday;//!<出生日期
@property (nonatomic, copy) NSString *country;//!<国家
@property (nonatomic, copy) NSString *city;//!<城市
@property (nonatomic, copy) NSString *csId;//!<酒店编号
@property (nonatomic, copy) NSString *address;//!<地址
@property (nonatomic, copy) NSString *idCardImg;//!<照片
@property (nonatomic, copy) NSString *addTime;//!<创建日期
@property (nonatomic, copy) NSString *nation;//!<名族
@property (nonatomic, copy) NSString *source;//!<来源
@property (nonatomic, copy) NSString *idCardType;//!<证件类型
@property (nonatomic, copy) NSString *memberStatus;//!<1、正常2、失效3、删除4、黑名单5待核实
@property (nonatomic, copy) NSString *memberLevel;//!<会员等级
@property (nonatomic, copy) NSString *memberSource;//!<会员来源
@property (nonatomic, copy) NSString *syncStatus;//!<同步状态
@property (nonatomic, copy) NSString *remark;//!<备注
@property (nonatomic, assign) CGFloat memberFee;//!<会员费
@property (nonatomic, copy) NSString *creationMode;//!<添加方式(0:自动添加,1:手动添加-默认自动)
@property (nonatomic, assign) CGFloat rechargeAmount;//!<充值金额
@property (nonatomic, assign) CGFloat memberPoints;//!<会员积分
@property (nonatomic, assign) BOOL isLevelLock;//!<是否级别锁定(0:是,1:否)
@property (nonatomic, copy) NSString *idCardPhoto;//!<证件照全图
@property (nonatomic, copy) NSString *firstName;//!<姓
@property (nonatomic, copy) NSString *secondName;//!<名
@property (nonatomic, copy) NSString *areaCode;//!<境外手机国家区号
@property (nonatomic, copy) NSString *type;//!<境内/境外 1境内 0境外
@property (nonatomic, assign) BOOL isHotelApply;//!<是否酒店适用(0:否,1:是)
@property (nonatomic, copy) NSString *salesmanGuid;//!<业务员guid
@property (nonatomic, copy) NSString *salesmanName;//!<业务员名称

@property (nonatomic, strong) HMMemberLevelInfo *memberLevelInfo;//!<会员级别信息

@property (nonatomic, copy) NSString *payMethod;//!<成为会员时会员费的支付方式
@property (nonatomic, copy) NSString *payNumber;//!<成为会员时会员费的支付单号

@property (nonatomic, strong) NSString *operatorName;   //!<操作人

- (void)getValueFromLodger:(HMLodger *)lodger;

- (NSString *)credentialsName;

- (HMLodger *)getLodger;

@end
