//
//  InputNumberView.h
//  HotelManager-Pad
//
//  Created by kqz on 17/2/16.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputNumberView : UIView

+(instancetype)inputNumberWithFrame:(CGRect)frame;
@property (nonatomic, copy) void (^changeNumberBlock)(NSInteger number);
@property (nonatomic, copy) void (^overMaxNumberBlock)(void);
@property (nonatomic, copy) void (^underMinNumberBlock)(void);

//以下是可配置选项
@property (nonatomic, assign) NSInteger setNumber;  //!<设置TextField的值(默认0)
@property (nonatomic, assign) NSInteger maxNumber;  //!<默认99
@property (nonatomic, assign) NSInteger minNumber;  //!<默认0
@property (nonatomic, assign) BOOL isEnabled;       //!<是否可以输入数字(默认YES)

@end
