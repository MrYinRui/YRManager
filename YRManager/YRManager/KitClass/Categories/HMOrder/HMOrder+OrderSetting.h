//
//  HMOrder+OrderSetting.h
//  HotelManager
//
//  Created by Seven on 2017/6/15.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMOrder.h"
#import "HMOrderSettings.h"
//#import "HMSavePayInfoModel.h"
#import "HMPaiedDetailModel.h"

@interface HMOrder (OrderSetting)

@property (nonatomic, assign) BOOL   payClear;//!<是否付清
@property (nonatomic, assign) double tempPrice;//!< 记录已分配的已付金额

@property (nonatomic, strong) NSMutableArray <HMOrderSettingsPayInfo *> *payWays;

- (NSArray <HMPaiedDetailModel *>*)fetchPaymentList:(NSString *)remark
                                             fjPath:(NSString *)path;

@end
