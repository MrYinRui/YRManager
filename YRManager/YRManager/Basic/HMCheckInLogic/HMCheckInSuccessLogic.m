//
//  HMCheckInSuccessLogic.m
//  HotelManager
//
//  Created by r on 17/6/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMCheckInSuccessLogic.h"
#import "HMOrder.h"
#import "HMRoom.h"
#import "HMLodger.h"
#import "HMAlertView.h"

#import "HMMakeRomCardAPI.h"
#import "HMSendBluetoothKeyAPI.h"
#import "HMPrintDepositAPI.h"

@interface HMCheckInSuccessLogic ()<HTTPAPIDelegate>

@property (nonatomic, strong) HMOrder *order;
@property (nonatomic, strong) HMMakeRomCardAPI *makeRoomCardAPI;//!<制房卡api
@property (nonatomic, strong) HMSendBluetoothKeyAPI *sendBleKeyAPI;//!<发蓝牙api
@property (nonatomic, strong) HMPrintDepositAPI *printDepositAPI;//!<打印押金api

@property (nonatomic, strong) UIView *showView;//!<记录正在展示的view

@end

@implementation HMCheckInSuccessLogic

+ (instancetype)logicWithOrder:(HMOrder *)order {
    
    HMCheckInSuccessLogic *logic = [[HMCheckInSuccessLogic alloc] init];
    logic.order = order;
    
    return logic;
}

- (void)showSuccessViewWithBleSendStatus:(BOOL)send {
    
    if ([self.order.room.bleAvaliable isEqualToString:@"1"]) {// 蓝牙房间
        
        NSString *title;
        if (send) {
            title = [NSString stringWithFormat:@"%@ %@\n入住完成,蓝牙密钥已发送!", self.order.room.roomNumberAddress,self.order.room.hotelAddress];
        } else {
            title = [NSString stringWithFormat:@"%@ %@\n入住完成", self.order.room.roomNumberAddress,self.order.room.hotelAddress];
        }
        
        WEAKSELF
        HMAlertView *view = [HMAlertView alertViewWithIconType:IconTick msg:title detailMsg:@"" upBtnBlock:^(UIButton *btn) {
            [btn setTitle:@"打印押金单" forState:UIControlStateNormal];
            [btn addTarget:weakSelf action:@selector(printDeposit) forControlEvents:UIControlEventTouchUpInside];
            
        } centerBtnBlock:^(UIButton *btn) {
            [btn setTitle:@"蓝牙门锁" forState:UIControlStateNormal];
            [btn addTarget:weakSelf action:@selector(sendBleKey) forControlEvents:UIControlEventTouchUpInside];
            
        } downBtnBlock:^(UIButton *btn) {
            [btn setTitle:@"制房卡" forState:UIControlStateNormal];
            [btn addTarget:weakSelf action:@selector(makeRoomCard) forControlEvents:UIControlEventTouchUpInside];
        }];
        [view showWithAnimation];
        self.showView = view;
        
    } else {
        WEAKSELF
        HMAlertView *view = [HMAlertView alertViewWithIconType:IconTick msg:[NSString stringWithFormat:@"%@ %@\n入住完成!",self.order.room.roomNumberAddress,self.order.room.hotelAddress] leftBtnBlock:^(UIButton *leftBtn) {
            [leftBtn setTitle:@"打印押金单" forState:UIControlStateNormal];
            [leftBtn addTarget:weakSelf action:@selector(printDeposit) forControlEvents:UIControlEventTouchUpInside];
            
        } rightBtnBlock:^(UIButton *rightBtn) {
            [rightBtn setTitle:@"制房卡" forState:UIControlStateNormal];
            [rightBtn addTarget:weakSelf action:@selector(makeRoomCard) forControlEvents:UIControlEventTouchUpInside];
        }];
        [view showWithAnimation];
        self.showView = view;
    }
    
}

#pragma mark - Event Response

- (void)makeRoomCard {
    
    self.makeRoomCardAPI.orderGuid = self.order.guid;
    self.makeRoomCardAPI.beginDate = [NSString stringWithFormat:@"%@ %@", self.order.checkInDate, self.order.checkInTime];
    self.makeRoomCardAPI.endDate = [NSString stringWithFormat:@"%@ %@", self.order.checkOutDate, self.order.checkOutTime];
    [self.makeRoomCardAPI sendRequestToServerWithType:POST];
    
    [self showTipLabelWith:@"制卡中..."];
}

- (void)sendBleKey {
    
    self.sendBleKeyAPI.beginDate = [NSString stringWithFormat:@"%@ %@", self.order.checkInDate, self.order.checkInTime];
    self.sendBleKeyAPI.endDate = [NSString stringWithFormat:@"%@ %@", self.order.checkOutDate, self.order.checkOutTime];
    self.sendBleKeyAPI.orderGuid = self.order.guid;
    self.sendBleKeyAPI.lockGuid = @"common_lock_01";//!<先写死
    
    NSMutableString *phone = [NSMutableString string];
    for (NSInteger i = 0; i < self.order.lodgerList.count; i++) {
        HMLodger *lodger = self.order.lodgerList[i];
        if (lodger.phone && ![lodger.phone isEqualToString:@""]) {
            [phone appendString:lodger.phone];
            [phone appendString:@","];
        }
    }
    if (phone.length != 0) {
        [phone deleteCharactersInRange:NSMakeRange(phone.length - 1, 1)];
        self.sendBleKeyAPI.phoneNumbers = phone;
        [self.sendBleKeyAPI sendRequestToServerWithType:POST];
        
        [self showTipLabelWith:@"蓝牙门锁发送中..."];
        
    } else {
        
        [self showTipLabelWith:@"入住人无手机"];
    }
}

- (void)printDeposit {
    
    self.printDepositAPI.orderGuid = self.order.guid;
    [self.printDepositAPI sendRequestToServerWithType:POST];
    [self showTipLabelWith:@"押金单打印中..."];
}

#pragma mark - HTTPAPIDelegate

- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api {

    if (api == self.makeRoomCardAPI) {
        
        NSInteger num = [data[@"num"] integerValue];
        [self showTipLabelWith:[NSString stringWithFormat:@"制卡成功(%zd)", num]];
    
    } else if (api == self.sendBleKeyAPI) {
        [self showTipLabelWith:@"蓝牙门锁已发送!"];
        
    } else if (api == self.printDepositAPI) {
        [self showTipLabelWith:@"押金单打印成功!"];
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api {
    
    if (api == self.makeRoomCardAPI) {
        [self showTipLabelWith:[NSString stringWithFormat:@"制卡失败!"]];
        
    } else if (api == self.sendBleKeyAPI) {
        [self showTipLabelWith:@"蓝牙门锁发送失败!"];
    
    } else if (api == self.printDepositAPI) {
        [self showTipLabelWith:@"押金单打印失败!"];
    }
}

#pragma mark - Private Methods

- (void)showTipLabelWith:(NSString*)title {
    
    __block UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    tipLabel.frame = LPRectMake(55, 85, 200, 45);
    tipLabel.layer.cornerRadius = kScaleNum(8.0);
    tipLabel.clipsToBounds = YES;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = kFont(16);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = title;
    [self.showView addSubview:tipLabel];
    
    [UIView animateWithDuration:2.0 animations:^{
        tipLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [tipLabel removeFromSuperview];
        tipLabel = nil;
    }];
}

#pragma mark - Getters

- (HMMakeRomCardAPI *)makeRoomCardAPI {
    if (!_makeRoomCardAPI) {
        _makeRoomCardAPI = [HMMakeRomCardAPI apiWithDelegate:self];
    }
    return _makeRoomCardAPI;
}

- (HMSendBluetoothKeyAPI *)sendBleKeyAPI{
    if (!_sendBleKeyAPI) {
        _sendBleKeyAPI = [HMSendBluetoothKeyAPI apiWithDelegate:self];
    }
    return _sendBleKeyAPI;
}

- (HMPrintDepositAPI *)printDepositAPI {
    if (!_printDepositAPI) {
        _printDepositAPI = [HMPrintDepositAPI apiWithDelegate:self];
    }
    return _printDepositAPI;
}

@end
