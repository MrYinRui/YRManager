//
//  HMSavePayInfoAPI.h
//  HotelManager
//
//  Created by YR on 2017/4/5.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HTTPAPI.h"
#import "HMSavePayInfoModel.h"

@interface HMSavePayInfoAPI : HTTPAPI

@property (nonatomic, strong) NSArray <HMSavePayInfoModel *> *paydata;

@end
