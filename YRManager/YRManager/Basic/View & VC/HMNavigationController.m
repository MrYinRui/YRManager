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
//  HMNavigationController.m
//  HotelManage
//
//  Created by xun on 17/2/21.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMNavigationController.h"
#import "HMConfirmOrderVC.h"
#import "HMSingleOrderConfirmVC.h"
#import "HMCashTransferBaseVC.h"
#import "HMChangePriceInfoVC.h"
#import "HMChangeRoomFeeVC.h"
#import "HMChangeRoomFeeVC2.h"
#import "HMCheckIDCardVC.h"
#import "HMConfirmPayVC.h"
#import "HMContinueSelectRoomVC.h"
#import "HMHandOverPersonVC.h"
#import "HMHotelFacilitiesIntroduceVC.h"
#import "HMHotelFacilitiesNavigationView.h"
#import "HMLockRoomInfoVC.h"
#import "HMLoginSelectNetworkVC.h"
#import "HMOrderConfigurationVC.h"
#import "HMPassportInfoVC.h"
#import "HMRecipientSelectionVC.h"
#import "HMRemarkVC.h"
#import "HMRoomSearchVC.h"
#import "HMSubDepartmentVC.h"
#import "HMTodayOrderDetailConsumeVC.h"
#import "HMTodayOrderDetailVC.h"
#import "HMTodayOrderVC.h"

@interface HMNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HMNavigationController

#pragma mark - view controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //系统侧滑功能开启
    self.interactivePopGestureRecognizer.delegate = self;
}

//侧滑实现
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1)
    {
        return NO;
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"UnGuesBackList.plist" ofType:nil];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *classArr = [NSArray arrayWithArray:dic[@"ClassName"]];
        
        NSString *classStr = NSStringFromClass([self.topViewController class]);
        if ([classArr containsObject:classStr])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}

#pragma mark - init view or data



#pragma mark - delegate call back



#pragma mark - view events



#pragma mark - help method



#pragma mark - lazy init


@end
