//
//  HMChangeRoomPriceView.h
//  HotelManager-Pad
//
//  Created by kqz on 17/1/17.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import "HMBasicDialogView.h"


@interface HMChangeRoomPriceView : HMBasicDialogView

@property (nonatomic, strong) void (^submitBlock)(double price);

@property (nonatomic, assign) BOOL isRestorePrice;//!<是否开启恢复价格功能(默认NO)
@property (nonatomic, assign) BOOL onlyPositive; //!<只能输入正数(默认NO)
@property (nonatomic, strong) UIColor *styleColor; //!<设置字体和边框的颜色
@property (nonatomic, strong) NSString *tip; //!<设置输入框的提示
@property (nonatomic, assign) NSInteger limit; //!<限制小数位数，默认2位

+(instancetype)viewWithTitle:(NSString *)title AndPrice:(NSString *)price;


@end
