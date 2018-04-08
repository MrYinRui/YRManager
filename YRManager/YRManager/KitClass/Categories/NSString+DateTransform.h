//
//  NSString+DateTransform.h
//  HotelManager
//
//  Created by r on 17/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateTransform)

// 2017-03-01 -> 03月01日
- (NSString *)formatDateString;

// 2017-03-01 -> 2017年03月01日
- (NSString *)formatDateStringFull;


@end
