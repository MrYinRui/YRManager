//
//  HMSiftBasic.m
//  HotelManager
//
//  Created by YR on 2017/10/18.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMSiftBasic.h"

@implementation HMSiftBasic

- (NSArray *)guidArr
{
    NSMutableArray *newArr = [NSMutableArray new];
    
    for (NSArray *arr in self.filterList)
    {
        if (arr.count)
        {
            [newArr addObject:arr.firstObject];
        }
    }

    return newArr;
}

- (NSArray *)nameArr
{
    NSMutableArray *newArr = [NSMutableArray new];
    
    for (NSArray *arr in self.filterList)
    {
        if (arr.count)
        {
            [newArr addObject:arr.lastObject];
        }
    }
    
    return newArr;
}

@end
