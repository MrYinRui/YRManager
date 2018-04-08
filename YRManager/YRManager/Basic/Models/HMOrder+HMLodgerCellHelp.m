//
//  HMOrder+HMLodgerCellHelp.m
//  HotelManager
//
//  Created by r on 2018/1/5.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMOrder+HMLodgerCellHelp.h"
#import "HMHotelParameterModel.h"
#import "HMRoom.h"

@implementation HMOrder (HMLodgerCellHelp)

- (BOOL)isShowInvoiceBtn {
    
    HMHotelParameterModel *model = [HMValueManager shareManager].hotelParameter;
    BOOL isShowInvoiceBtn;
    
    if (model.invoice.integerValue == 0) {// 0:不提供发票
        isShowInvoiceBtn = NO;
    } else {
        if (self.type.integerValue == 0) {// 全日房
            if (self.getOrderStatus == WOULD_LEAVE ||
                self.getOrderStatus == WOULD_LEAVE_WITHOUT_CHECK ||
                self.getOrderStatus == FRONT_DESK_HURRY_CHECK_UP ||
                self.getOrderStatus == CUSTOMER_HURRY_CHECK_UP ||
                self.getOrderStatus == RESPONIBLE_CHECK ||
                self.getOrderStatus == OTHERS_CHECK ||
                self.getOrderStatus == CHECK_WITH_NO_PROBLEM ||
                self.getOrderStatus == CHECK_WITH_MATTER ||
                self.getOrderStatus == OVERDEU_NOT_AWAY ||
                self.getOrderStatus == CHECKED_OUT ||
                self.getOrderStatus == FORCE_CHECK_OUT) {
                
                isShowInvoiceBtn = YES;
            } else {
                isShowInvoiceBtn = NO;
            }
        } else {// 钟点房
            if (self.getOrderStatus == WENT_LIVE ||
                self.getOrderStatus == LIVING ||
                self.getOrderStatus == OVER_CLOCK ||
                self.getOrderStatus == START_ADD_CLOCK ||
                self.getOrderStatus == LIVE_ADD_CLOCK ||
                self.getOrderStatus == FRONT_DESK_HURRY_CHECK_UP ||
                self.getOrderStatus == CUSTOMER_HURRY_CHECK_UP ||
                self.getOrderStatus == RESPONIBLE_CHECK ||
                self.getOrderStatus == OTHERS_CHECK ||
                self.getOrderStatus == CHECK_WITH_NO_PROBLEM ||
                self.getOrderStatus == CHECK_WITH_MATTER ||
                self.getOrderStatus == CHECKED_OUT ||
                self.getOrderStatus == FORCE_CHECK_OUT ||
                self.getOrderStatus == OVERDEU_NOT_AWAY) {
                
                isShowInvoiceBtn = YES;
            } else {
                isShowInvoiceBtn = NO;
            }
        }
    }
    
    return isShowInvoiceBtn;
}

- (BOOL)isShowAddLodgerBtn {
    
    NSInteger lodgerCount = self.lodgerList.count;
    NSInteger limitPeople = self.room.limitPeople.integerValue;
    BOOL isShowAddLodgerBtn;
    
    if (lodgerCount < limitPeople) {
        if (self.getOrderStatus == NO_SHOW || self.getOrderStatus == WAIT_CANCEL || self.getOrderStatus == CANCEL || self.getOrderStatus == WOULD_LEAVE || self.getOrderStatus == WOULD_LEAVE_WITHOUT_CHECK || self.getOrderStatus == COMPLETED || self.getOrderStatus == CHECKED_OUT || self.getOrderStatus == FORCE_CHECK_OUT || self.getOrderStatus == CONFIRM_NO_SHOW || self.getOrderStatus == OVERDEU_NOT_AWAY || self.getOrderStatus == ABNORMAL) {
            isShowAddLodgerBtn = NO;
        } else {
            isShowAddLodgerBtn = YES;
        }
    } else {
        isShowAddLodgerBtn = NO;
    }
    return isShowAddLodgerBtn;
}

@end
