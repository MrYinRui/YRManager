//
//  AnimationManage.h
//  Lodger-Pad
//
//  Created by kqz on 16/9/30.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationManage : NSObject

/**
 *  从底部弹出view
 *
 *  @param popView 需要显示的view
 */
+(void)fromBottomPopView:(UIView *) popView;

/**
 *  隐藏底部的view
 *
 *  @param popView 需要显示的view
 */
+(void)fromBottomHiddenView:(UIView *) popView;

@end
