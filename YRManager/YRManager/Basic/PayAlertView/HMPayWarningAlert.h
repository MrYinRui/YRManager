//
//  HMPayWarningAlert.h
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMPayWarningAlert : UIView

@property (nonatomic, strong) NSArray *btnTitleArr;
@property (nonatomic, strong) void  (^RithtBtnBlock)(void);
@property (nonatomic, strong) void  (^LeftBtnBlock)(void);

- (instancetype)initWithTitle:(NSString *)title img:(NSString *)imgName;
- (void)showOnView:(UIView *)view;

@end
