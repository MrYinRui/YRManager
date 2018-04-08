//
//  HMCheckInSuccessLogic.h
//  HotelManager
//
//  Created by r on 17/6/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCheckInSuccessLogic : NSObject

+ (instancetype)logicWithOrder:(HMOrder *)order;

- (void)showSuccessViewWithBleSendStatus:(BOOL)send;

@end
