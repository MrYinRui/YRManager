//
//  NSString+PicInsertString.h
//  GoFun
//
//  Created by YR on 16/8/27.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PicInsertString)

/**
 *  图片路径插入尺寸
 *
 *  @param size 尺寸
 *
 *  @return 返回
 */
- (NSString *)insertWithSize:(NSString *)size;

@end
