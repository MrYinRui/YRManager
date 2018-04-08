//
//  HMJumpManager.m
//  HotelManager
//
//  Created by kqz on 17/3/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMJumpManager.h"
#import "HMOrder.h"
#import "HMRoom.h"
#import "HMTodayOrderDetailVC.h"
#import "HMChangeRoomCleanStateVC.h"
#import "HMCleanStateLogVC.h"
#import "HMCancelNoShowVC.h"
#import "HMChangeRoomVC.h"
#import "HMChangeRoomFeeVC.h"
#import "HMEarlyCheckOutVC.h"
#import <objc/runtime.h>
#import "HMContinueRoomVC.h"
#import "HMChangeRoomDateVC.h"
#import "HMTodayOrderVC.h"
#import "HMQuickCleanVC.h"
#import "HMAlertView.h"
#import "HMRoomPriceCalendarVC.h"
#import "HMConfirmOrderVC.h"
#import "HMChangeRoomTypeVC.h"
#import "HMCheckOutManager.h"
#import "HMUrgeCheckVC.h"
#import "HMLockRoomDetailVC.h"
#import "HMRoomStatusBottomVC.h"
#import "HMCheckInNewLogic.h"
#import "HMRefundVC.h"

@interface HMJumpManager()

@property (nonatomic, strong) HMCheckInNewLogic *checkInLogic;//!<入主逻辑

@end

@implementation HMJumpManager

+(instancetype)initWithController:(UIViewController *)controller
{
    HMJumpManager *manager = [HMJumpManager new];
    manager.controller = controller;
    return manager;
}

-(void)pushVC:(NSString *)controllerName Animated:(BOOL)animated Data:(NSArray *)data AndBlock:(CallBack *)callBack
{
    UIViewController *pushVC;
    
    if ([controllerName isEqualToString:@"HMTodayOrderDetailVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = [[HMTodayOrderDetailVC alloc] initWithOrderGuid:order.guid];
    }
    else if ([controllerName isEqualToString:@"HMChangeCleanVC"])
    {
        NSString *className = [NSString stringWithFormat:@"%s",object_getClassName(data.firstObject)];
        HMRoom *room;
        NSString *orderGuid = @"";
        
        if ([className isEqualToString:@"HMOrder"])
        {
            room = [data.firstObject room];
            orderGuid = [data.firstObject guid];
        }
        else
        {
            room = data.firstObject;
            orderGuid = @"";
        }
        
        pushVC = [[HMChangeRoomCleanStateVC alloc] initWithOrder:room WorkType:WorkTypeConfirmClean OrderGuid:orderGuid];
    }
    else if ([controllerName isEqualToString:@"HMChangeDirtyVC"])
    {
        NSString *className = [NSString stringWithFormat:@"%s",object_getClassName(data.firstObject)];
        HMRoom *room;
        NSString *orderGuid = @"";
        
        if ([className isEqualToString:@"HMOrder"])
        {
            room = [data.firstObject room];
            orderGuid = [data.firstObject guid];
        }
        else
        {
            room = data.firstObject;
            orderGuid = @"";
        }
        
        pushVC = [[HMChangeRoomCleanStateVC alloc] initWithOrder:room WorkType:WorkTypeConfirmDirty OrderGuid:orderGuid];
    }
    else if ([controllerName isEqualToString:@"HMQuickCleanVC"])
    {
        NSString *className = [NSString stringWithFormat:@"%s",object_getClassName(data.firstObject)];
        HMRoom *room;
        NSString *orderGuid = @"";
        
        if ([className isEqualToString:@"HMOrder"])
        {
            room = [data.firstObject room];
            orderGuid = [data.firstObject guid];
        }
        else
        {
            room = data.firstObject;
            orderGuid = @"";
        }
        
        pushVC = [[HMQuickCleanVC alloc] initWithOrder:room OrderGuid:orderGuid];
    }
    else if ([controllerName isEqualToString:@"HMCleanStateLogVC"])
    {
        if (data.count > 1)
        {
            pushVC = [[HMCleanStateLogVC alloc] initWithData:data.lastObject AndTitle:data.firstObject];
        }
        else
        {
            pushVC = [[HMCleanStateLogVC alloc] initWithHouseGuid:data.firstObject];
        }
    }
    else if ([controllerName isEqualToString:@"HMChangeRoomTypeVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = [[HMChangeRoomTypeVC alloc] initWithOrder:order];
    }
    else if ([controllerName isEqualToString:@"HMCancelVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = [[HMCancelNoShowVC alloc] initWithOrder:order
                                      OrderOperationType:OrderOperationTypeCancel];
        
        HMCancelNoShowVC *vc = (HMCancelNoShowVC *)pushVC;
        __weak typeof(vc) weakVC = vc;
        WEAKSELF
        vc.SuccessBlock = ^{
            
            [weakSelf cancelOrNoShowSuccessTargetVcWithPushVc:weakVC];
        };
        
    }
    else if ([controllerName isEqualToString:@"HMNoShowVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = [[HMCancelNoShowVC alloc] initWithOrder:order
                                      OrderOperationType:OrderOperationTypeNoShow];
        
        HMCancelNoShowVC *vc = (HMCancelNoShowVC *)pushVC;
        __weak typeof(vc) weakVC = vc;
        WEAKSELF
        vc.SuccessBlock = ^{
            
            [weakSelf cancelOrNoShowSuccessTargetVcWithPushVc:weakVC];
        };
        
        BOOL showReturn = NO;
        if ([order.type isEqualToString:@"1"]) {
            
        }else {
            [[HMAlertView alertViewWithIconType:IconWarn msg:[NSString stringWithFormat:@"确定NS订单:\r\n%@?",order.Id] detailMsg:@"NS订单将归类为异常订单" letfBtnBlock:^(UIButton *leftBtn) {
                [leftBtn setTitle:@"NS订单" forState:UIControlStateNormal];
                [leftBtn setTitleColor:kGlobalTextColorBrown forState:UIControlStateNormal];
                objc_setAssociatedObject(leftBtn, "LETF_PUSH_VC_KEY", weakVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(leftBtn, "LEFT_ORDER_KEY", order, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [leftBtn addTarget:self action:@selector(goToNoShowVc:) forControlEvents:UIControlEventTouchUpInside];
                
            } rightBtnBlock:^(UIButton *rightBtn) {
                [rightBtn setTitle:@"入住" forState:UIControlStateNormal];
                objc_setAssociatedObject(rightBtn, "RIGHT_PUSH_VC_KEY", weakVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(rightBtn, "RIGHT_ORDER_KEY", order, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [rightBtn addTarget:self action:@selector(goToLiveIn:) forControlEvents:UIControlEventTouchUpInside];
                
            }] showWithAnimation];
            //return 不会立即push过去
            showReturn = YES;
            //        return;
        }
        
        if (showReturn) {
            return;
        }
    }
    else if ([controllerName isEqualToString:@"HMChangeRoomVC"])
    {
        if (data.count > 1)
        {
            HMOrder *order = data.firstObject;
            pushVC = [[HMChangeRoomVC alloc] initWithOrder:order AndCuttentDate:data.lastObject];
        }
        else
        {
            HMOrder *order = data.firstObject;
            pushVC = [[HMChangeRoomVC alloc] initWithOrder:order];
        }
    }
    else if ([controllerName isEqualToString:@"HMChangeRoomFeeVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = [[HMChangeRoomFeeVC alloc] initWithOrder:order];
        NSString *isShow = [NSString stringWithFormat:@"%@",data.lastObject];
        if ([isShow isEqualToString:@"1"])
        {
            [(HMChangeRoomFeeVC *)pushVC setNoPopAlert:YES];
        }
    }else if ([controllerName isEqualToString:@"HMCheckOut"]){
        WEAKSELF
        HMCheckOutManager *manager = [HMCheckOutManager shareManager];
        UIViewController *roomStatusVc;
        for (UIViewController *vc in self.controller.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"HMTodayRoomStatusVC")]) {
                roomStatusVc = vc;
            }
        }
        manager.ownerVC = roomStatusVc;
        manager.order = data.firstObject;
        manager.successBlock = ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:HMTodayRoomStatusNotification object:nil];//刷新当日房态
            [weakSelf.controller.navigationController popToViewController:roomStatusVc animated:YES];
        };
        return;
    }
    else if ([controllerName isEqualToString:@"HMEarlyCheckOutVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = (HMEarlyCheckOutVC *)[HMEarlyCheckOutVC new];
        ((HMEarlyCheckOutVC *)pushVC).order = order;
    }
    else if ([controllerName isEqualToString:@"HMContinueRoomVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = [[HMContinueRoomVC alloc] initWithOrder:order];
    }
    else if ([controllerName isEqualToString:@"HMChangeRoomDateVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = [[HMChangeRoomDateVC alloc] initWithOrder:order];
    }
    else if ([controllerName isEqualToString:@"HMRoomPriceCalendarVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = [[HMRoomPriceCalendarVC alloc] init];
        [(HMRoomPriceCalendarVC *)pushVC setOrder:order];
    }
    else if ([controllerName isEqualToString:@"HMConfirmOrderVC"])
    {
        NSArray *arr = data.firstObject;
        NSString *guid = arr.firstObject;
        pushVC = [[HMConfirmOrderVC alloc] initWithMarr:@[guid]];
        HMConfirmOrderVC *confirmVC = (HMConfirmOrderVC *)pushVC;
        confirmVC.sourceVC = self.controller;
    }
    else if ([controllerName isEqualToString:@"HMLockRoomDetailVC"])
    {
        HMOrder *order = data.firstObject;
        pushVC = [[HMLockRoomDetailVC alloc] initWithOrder:order];
    }
    else if ([controllerName isEqualToString:@"HMUrgeCheckVC"])
    {
        HMOrder *order = data.firstObject;
        HMUrgeCheckVC *vc = [[HMUrgeCheckVC alloc] initWithOrderGuid:order.guid room:order.room.roomNumber];
        pushVC = vc;
        
        vc.SureCheckBlock = ^(HMOrder *order)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:HMUrgeCheckSuccessNoti object:nil];
            HMAlertView *alert = [HMAlertView alertViewWithIconType:IconTick msg:[NSString stringWithFormat:@"%@房 %@%@楼\n已催查!",order.mph,order.hymc,order.louceng]];
            [alert showWithAnimation];
        };
    }else if ([controllerName isEqualToString:@"HMRefundVC"]){
        HMOrder *order = data.firstObject;
        HMRefundVC *vc = [[HMRefundVC alloc] initWithOrderGuid:order.guid];
        pushVC = vc;
    }
    else
    {
        pushVC = [[NSClassFromString(controllerName) class] new];
    }
    
    [self.controller.navigationController pushViewController:pushVC animated:animated];
}

/**处理取消订单或者NOSHOW订单成功后 跳转目标控制器*/
- (void)cancelOrNoShowSuccessTargetVcWithPushVc:(UIViewController *)pushVc{
    
    
    for (UIViewController *vc in self.controller.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"HMTodayRoomStatusVC")]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HMTodayRoomStatusNotification object:nil];
        }
    }
    
    if ([self.controller isKindOfClass:[HMTodayOrderDetailVC class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HMUpdateOrderDetailNoti object:nil];
        [pushVc.navigationController popToViewController:self.controller animated:YES];
    }
    else if ([self.controller isKindOfClass:NSClassFromString(@"HMRoomStatusBottomVC")]){
        //当日房态
        [pushVc.navigationController popToViewController:self.controller.parentViewController animated:YES];
    }
}

- (void)goToNoShowVc:(UIButton *)btn{
    
    UIViewController *pushVc = objc_getAssociatedObject(btn, "LETF_PUSH_VC_KEY");
    [self.controller.navigationController pushViewController:pushVc animated:YES];
}

- (void)goToLiveIn:(UIButton *)btn{
    if ([self.controller isKindOfClass:[HMTodayOrderDetailVC class]]) {
        [(HMTodayOrderDetailVC *)self.controller checkInAction];
    }else if ([self.controller isKindOfClass:NSClassFromString(@"HMRoomStatusBottomVC")]){
        WEAKSELF
        _checkInLogic = [HMCheckInNewLogic logicWithOrder:[HMValueManager shareManager].roomStatusOrder vc:self.controller];
        _checkInLogic.CheckinBlock = ^(BOOL success){
            [[NSNotificationCenter defaultCenter] postNotificationName:HMTodayRoomStatusNotification object:nil];
            for (UIViewController *vc in weakSelf.controller.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"HMTodayRoomStatusVC")]) {
                    [weakSelf.controller.navigationController popToViewController:vc animated:YES];
                }
            }
        };
        [_checkInLogic commonExecute];
    }
}


@end
