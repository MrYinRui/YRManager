//
//  HMSearchMemberPayAPI.h
//  HotelManager
//
//  Created by YR on 2017/8/1.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HTTPAPI.h"

@interface HMSearchMemberPayAPI : HTTPAPI

@property (nonatomic, strong) NSString *guid;   //!<会员guid数组json

@end
