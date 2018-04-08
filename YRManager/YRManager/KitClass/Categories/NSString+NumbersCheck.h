//
//  NSString+NumbersCheck.h
//  HotelManager
//
//  Created by Se7en on 28/02/2018.
//  Copyright © 2018 samsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NumbersCheck)

/**
 18位
 @param identityCard 二代身份证
 @return 是否是可用 身份证号
 */
+ (BOOL)isValidIdentityNumber:(NSString *)identityCard;


/**
 16~19位
 @param cardNo 银行卡
 @return 银行卡是否填写正确
 */
+ (BOOL)checkBankCardNo:(NSString *)cardNo;



/**
 正则。。
 @param telNumber 手机号
 @return 手机号 是否可用
 */
+ (BOOL)checkTelNumber:(NSString *)telNumber;


@end
