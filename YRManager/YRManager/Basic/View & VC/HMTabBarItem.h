//
//  HMTabBarItem.h
//  HotelManager
//
//  Created by r on 17/2/21.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMTabBarItem : UIButton

+ (instancetype)tabBarItemWithTitle:(NSString *)title normalImg:(NSString *)normalImg selectImg:(NSString *)selectImg;

@end
