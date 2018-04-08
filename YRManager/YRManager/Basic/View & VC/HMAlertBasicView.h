//
//  HMAlertBasicView.h
//  HotelManager
//
//  Created by YR on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMAlertBasicView : UIView

@property (nonatomic, strong) UIButton  *closeBtn;
@property (nonatomic, strong) UIView    *bgView;

- (void)showOnView:(UIView *)view;
- (void)removeAction;
- (void)closeAction;
- (UIViewController *)viewController;

@end
