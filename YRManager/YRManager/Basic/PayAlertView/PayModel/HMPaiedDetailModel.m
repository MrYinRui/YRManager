//
//  HMPaiedDetailModel.m
//  HotelManager
//
//  Created by YR on 2017/4/5.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPaiedDetailModel.h"
#import <objc/runtime.h>

@implementation HMPaiedDetailModel
- (id)copyWithZone:(NSZone *)zone {
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge  void *)(copyInstance), (__bridge const void *)(self), instanceSize);
    return copyInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge  void *)(copyInstance), (__bridge const void *)(self), instanceSize);
    return copyInstance;
}

@end
