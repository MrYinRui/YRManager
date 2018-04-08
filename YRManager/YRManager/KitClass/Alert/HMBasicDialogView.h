//
//  HMBasicDialogView.h
//  HotelManager
//
//  Created by Seven on 2017/3/28.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+NSMutableAttributedString.h"
#import "UIButton+LPCustomBtn.h"

#define kDefaultFrame       LPRectMake(30, 117, 315, 225) //(287, 76, 450, 624)
#define kInputFrame         LPRectMake(30, 115, 315, 225)
#define kQRCodeFrame        LPRectMake(286.5, 71.25, 450, 625)
#define kSearchFrame        LPRectMake(200,72, 624, 624)
#define kTimeSettingFrame   LPRectMake(312, 150, 400, 300)
#define kMakeCardRoomFrame  LPRectMake(199.5, 71.25, 625, 625)
#define kWritePhoneFrame    LPRectMake(312, 65, 400, 300)
#define kPayInfoDetailFrame LPRectMake(30, 80, 315, 470)
//(315,225);//(315,270);//(315,320);
@interface HMBasicDialogView : UIView

@property (nonatomic, copy) void(^closeButtonEventBlock)(void);//!<自定义关闭按钮事件

+ (instancetype)viewWithFrame:(CGRect)frame title:(NSString *)title;
+ (instancetype)viewWithFrame:(CGRect)frame;
+ (instancetype)viewWithTitle:(NSString *)title; //no top line, you ought to hold this.😄

- (void)addSeparatorLineWithY:(CGFloat)y;
- (void)addSeparatorLineWithX:(CGFloat)x;
- (void)showWithAnimation;
- (void)showWithAnimationOnView:(UIView *)view;

/**
 获取视图所在控制器，如果视图是直接加在Window上，则返回空值
 
 @return 视图控制器
 */
- (UIViewController *)viewController;
-(void)hiddenCloseBtn;




@end
