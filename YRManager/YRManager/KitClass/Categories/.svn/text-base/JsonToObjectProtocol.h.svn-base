//
//  JsonToObjectProtocol.h
//  HotelManager-Pad
//
//  Created by xun on 11/30/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JsonToObjectProtocol <NSObject>

/**
 将Json对象转换为以模型为元素的数组，如果在arr不为空，则在arr内部添加元素

 @param jsonObj json对象
 @param arr     可能为空的数组

 @return 包含Json对象转换后模型的数组
 */
+ (NSArray *)arrayFromJsonObj:(id)jsonObj
                  originArray:(NSMutableArray *)arr;


/**
 将Json对象转换为模型，如果obj不为空，则在obj的基础上进行KVC赋值

 @param jsonObj json对象
 @prama obj     模型对象
 
 @return 转换后对象
 */
+ (id)objectFromJsonObj:(id)jsonObj
              originObj:(id)obj;

@end
