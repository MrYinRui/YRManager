//
//  NSObject+JsonString.h
//  OCDemo
//
//  Created by xun on 16/6/15.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonString)

/**
 *  将Model，Dictionary，Array，Set，String，Number转换成JSON字符串
 *
 *  @return JSON字符串
 */
- (NSString *)jsonString;

@end
