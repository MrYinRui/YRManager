//
//  HMTextFieldInputView.h
//  HotelManager
//
//  Created by r on 2018/1/18.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMBasicDialogView.h"

@interface HMTextFieldInputView : HMBasicDialogView

+ (instancetype)viewWithTitle:(NSString *)title;

@property (nonatomic, copy) void (^writeSuccessBlock)(NSString *str);

@property (nonatomic, assign) NSInteger maxLength;//默认50

@end
