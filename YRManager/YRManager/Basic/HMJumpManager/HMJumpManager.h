//
//  HMJumpManager.h
//  HotelManager
//
//  Created by kqz on 17/3/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CallBack)(NSDictionary * dict);

@interface HMJumpManager : NSObject

@property (nonatomic, weak) UIViewController *controller;

+(instancetype)initWithController:(UIViewController *)controller;

/**
 @param controllerName 控制器名称
 @param animated 是否开启动画
 @param data 传输数据
 @param callBack 返回block的数据
 */
-(void)pushVC:(NSString *)controllerName Animated:(BOOL)animated Data:(NSArray *)data AndBlock:(CallBack *)callBack;

@end
