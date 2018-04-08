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
//  Alert.m
//  ProjectKit
//
//  Created by xun on 16/12/12.
//  Copyright © 2016年 Xun. All rights reserved.
//

#import "Alert.h"

UIAlertAction *xun_action(NSString *title, ActionBlock actionBlock)
{
    return [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:actionBlock];
}

@implementation Alert

+ (void)alertWithMsg:(NSString *)msg
{
    [Alert alertWithTitle:@"提示" msg:msg];
}

+ (void)alertWithTitle:(NSString *)title
                   msg:(NSString *)msg
{
    [Alert alertWithTitle:title msg:msg defaultAction:xun_action(@"确定", nil)];
}

+ (void)alertWithTitle:(NSString *)title
                   msg:(NSString *)msg
         defaultAction:(UIAlertAction *)defaultAction
{
    [Alert alertWithTitle:title msg:msg action:defaultAction action:nil];
}

+ (void)alertWithTitle:(NSString *)title
                   msg:(NSString *)msg
                action:(UIAlertAction *)action1
                action:(UIAlertAction *)action2
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [Alert alertWithTitle:title msg:msg action:action1 action:action2 onViewController:vc];
}

+ (void)alertWithTitle:(NSString *)title
                   msg:(NSString *)msg
                action:(UIAlertAction *)action1
                action:(UIAlertAction *)action2
      onViewController:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    !action1 ? :[alert addAction:action1];
    !action2 ? :[alert addAction:action2];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)alertSheetWithActions:(NSArray<UIAlertAction *> *)actions
                        title:(NSString *)title
                       onView:(UIView *)view
               arrowDirection:(UIPopoverArrowDirection)directions
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UIAlertAction *action in actions)
    {
        [alert addAction:action];
    }
    
    alert.popoverPresentationController.sourceView = view;
    alert.popoverPresentationController.sourceRect = view.bounds;
    alert.popoverPresentationController.permittedArrowDirections = directions;
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)alertSheetWithActions:(NSArray<UIAlertAction *> *)actions
                        title:(NSString *)title
                       onView:(UIView *)view
{
    [Alert alertSheetWithActions:actions title:title onView:view arrowDirection:UIPopoverArrowDirectionAny];
}

+ (void)alertSheetWithActions:(NSArray<UIAlertAction *> *)actions
                       onView:(UIView *)view
{
    [Alert alertSheetWithActions:actions title:nil onView:view];
}

+ (void)alertSheetWithActions:(NSArray<UIAlertAction *> *)actions
                        title:(NSString *)title
{
    [Alert alertSheetWithActions:actions title:title onViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (void)alertSheetWithActions:(NSArray<UIAlertAction *> *)actions title:(NSString *)title onViewController:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UIAlertAction *action in actions)
    {
        [alert addAction:action];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    alert.popoverPresentationController.sourceView = vc.view;
    
    
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)alertSheetWithActions:(NSArray<UIAlertAction *> *)actions
{
    [Alert alertSheetWithActions:actions title:nil];
}

@end
