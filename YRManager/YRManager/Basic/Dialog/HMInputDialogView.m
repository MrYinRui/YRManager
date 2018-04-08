//
//  \\      //     ||          ||     ||\        ||
//   \\    //      ||          ||     ||\\       ||
//    \\  //       ||          ||     || \\      ||
//     \\//        ||          ||     ||  \\     ||
//      /\         ||          ||     ||   \\    ||
//     //\\        ||          ||     ||    \\   ||
//    //  \\       ||          ||     ||     \\  ||
//   //    \\      ||          ||     ||      \\ ||
//  //      \\      \\        //      ||       \\||
// //        \\      \\======//       ||        \||
//
//
//  HMInputDialogView.m
//  HotelManager-Pad
//
//  Created by xun on 16/12/21.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import "HMInputDialogView.h"
#import "UIButton+LPCustomBtn.h"
#import "LPTextField.h"

@interface HMInputDialogView () <UITextFieldDelegate>

@end

@implementation HMInputDialogView


#pragma mark - load data or init

+ (instancetype)viewWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kInputMobileDialogView])
    {
        return [self inputMobileDialogView];
    }
    
    return nil;
}

+ (instancetype)inputMobileDialogView
{
    HMInputDialogView *view = [[HMInputDialogView alloc] initWithFrame:kInputFrame];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"入住人手机";
    titleLab.font = kFont(24);
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.frame = LPRectMake(30, 55, 340, 40);
    [view addSubview:titleLab];
    
    LPPhoneTF *tf = [[LPPhoneTF alloc] initWithFrame:LPRectMake(30, 102, 340, 60)];
    tf.delegate = view;
    tf.keyboardType = UIKeyboardTypePhonePad;
    tf.placeholder = @"输入手机号";
    tf.font = kFont(24);
    tf.backgroundColor = kColor(248, 248, 248, 1);
    tf.layer.borderWidth = 1.f;
    tf.layer.borderColor = kColor(223, 223, 226, 1).CGColor;
    tf.rectForText = CGRectMake(12, 0, tf.width - 24, tf.height);
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:tf];
    
    UILabel *infoLab = [UILabel new];
    infoLab.textColor = kYellowColor;
    infoLab.text = @"输入手机号确定，无手机直接确定";
    infoLab.font = kFont(15);
    infoLab.frame = LPRectMake(32, 175, 338, 30);
    [view addSubview:infoLab];
    
    UIButton *cancelBtn = [UIButton greenBorderBtnWithFrame:LPRectMake(28, 225, 160, 45) title:@"取 消" ];
    [cancelBtn addTarget:view action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton greenBtnWithFrame:LPRectMake(207, 225, 160, 45) title:@"确 定"];
    
    [confirmBtn addTarget:view action:@selector(clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn addTarget:view action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmBtn];
    
    return view;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isKindOfClass:[LPTextField class]])
    {
        return [(LPTextField *)textField validString:string];
    }
    
    return YES;
}

#pragma mark - event

- (void)clickedConfirmBtn
{
    !_CallbackBlock ? : _CallbackBlock();
}

#pragma mark - help method

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.f;
        self.clipsToBounds = YES;
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"close_01"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.frame = LPRectMake(self.width / kScreenScale - 38, 2, 36, 36);
        [self addSubview:closeBtn];
    }
    return self;
}

#pragma mark - lazy init



@end
