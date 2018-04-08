//
//  NSObject+JSONToObject.h
//  OCDemo
//
//  Created by xun on 16/6/16.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonToObjectProtocol.h"

@protocol JsonToObjectProtocol;

@interface NSObject (JSONToObject) <JsonToObjectProtocol>

/**
 *  将数据对象转换为对象
 *
 *  @param dataObj 数据对象
 *
 *  @return 转换后的对象
 */
+ (instancetype)objectFromDataObject:(id)dataObj;

/**
 后台所传字段名需替换字典，如有需要，子类可以重写
 
 @return @{@"后台字段":@"iOS字段"}
 */
+ (NSDictionary *)replaceKeyDict;
+ (NSDictionary *)propertyClassDict;


@end
