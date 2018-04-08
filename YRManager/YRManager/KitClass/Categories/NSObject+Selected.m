//
//  NSObject+Selected.m
//  HotelManager
//
//  Created by Seven on 2017/6/30.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "NSObject+Selected.h"
#import <objc/runtime.h>

@implementation NSObject (Selected)

- (BOOL)hm_selected {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHm_selected:(BOOL)hm_selected {
    objc_setAssociatedObject(self, @selector(hm_selected), @(hm_selected), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)hm_changed{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setHm_changed:(BOOL)hm_changed {
    objc_setAssociatedObject(self, @selector(hm_changed), @(hm_changed), OBJC_ASSOCIATION_RETAIN);
}


@end
