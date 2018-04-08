//
//  HMSiftBasic.h
//  HotelManager
//
//  Created by YR on 2017/10/18.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMSiftBasic : NSObject

@property (nonatomic, copy) NSArray <NSArray *> *filterList;
@property (nonatomic, copy) NSString *name;

- (NSArray *)guidArr;

- (NSArray *)nameArr;

@end
