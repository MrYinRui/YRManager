//
//  HMMemberPayModel.h
//  HotelManager
//
//  Created by YR on 2017/8/1.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMMemberPayModel : NSObject

@property (nonatomic, strong) NSString *idcardImg;          //!<会员图片
@property (nonatomic, strong) NSString *integral;           //!<积分
@property (nonatomic, strong) NSString *levelName;          //!<会员等级
@property (nonatomic, strong) NSString *memberId;           //!<会员id
@property (nonatomic, strong) NSString *mobile;             //!<会员电话
@property (nonatomic, strong) NSString *name;               //!<会员名
@property (nonatomic, strong) NSString *rechargeAmount;     //!<余额

@end
