//
//  HMPriceTFInput.h
//  HotelManager
//
//  Created by YR on 2017/6/7.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPriceTFInput : NSObject

/**
校验是否价格输入
 
 textField      输入框
 range          范围
 string         字符串
 isHaveDian     是否已包含点(当前类全局变量)
 limit          小数点后几位
 isMinus        是否可以输入负数
 
 */
+ (BOOL)priceTextField:(UITextField *)textField
                 range:(NSRange)range
                string:(NSString *)string
                  dian:(BOOL)isHaveDian
                 limit:(NSInteger)limit
               isMinus:(BOOL)isMinus;


/**
 yes 没有输入长度限制

 @param limit limit 是什么
 @return      返回   什么
 */



@end
