//
//  UIDelayTapGestureRecognizer.h
//  HotelManager
//
//  Created by kqz on 2017/9/23.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface UIDelayTapGestureRecognizer : UITapGestureRecognizer

@property(nonatomic,assign) CGFloat maxDelay;

@end
