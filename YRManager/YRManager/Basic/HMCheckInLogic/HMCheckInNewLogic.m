//
//  HMCheckInNewLogic.m
//  HotelManager
//
//  Created by YR on 2017/10/24.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMCheckInNewLogic.h"
#import "HMRecordLodgerVC.h"
#import "HMAlertView.h"
#import "HMPayAlertView.h"
#import "HMCheckInAPI.h"
#import "HMOrderDetailAPI.h"
#import "NSObject+JSONToObject.h"
#import "HMChangeRoomVC.h"
//#import "HMMakeRoomCardView.h"
#import "HTTPAPI.h"
#import "HMOrder.h"
#import "HMRoom.h"
#import "HMAction.h"
#import "HMLodger.h"
//#import "HMTodayRoomStatusManagerVC.h"
#import "HMCheckIDCardVC.h"
//#import "HMCheckCredentialsVC.h"
#import "HMNavigationController.h"
#import "HMTodayOrderVC.h"
//#import "HMCancelOrderVC.h"
//#import "HMRSOrderDetailVC.h"
#import <objc/runtime.h>
//#import "HMTodayRoomStatusManagerVC.h"
#import "MJExtension.h"
#import "HMTodayOrderDetailVC.h"
#import "HMCheckInSuccessLogic.h"
#import "HMCheckInCondition.h"

#import "HMPhoneSecurityCodeView.h"
#import "HMWritePhoneView.h"
#import "HMClearLodgerMobileAPI.h"
#import "HMUpdateSystemLodgerAPI.h"
#import "HMUpdateLodgerPhone.h"

#import "HMHotelParameterModel.h"

@interface HMCheckInNewLogic ()<HTTPAPIDelegate>

@property (nonatomic, strong) HMOrder *order;
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) HMOrderDetailAPI *detailAPI;
@property (nonatomic, strong) HMCheckInAPI *checkinAPI;
@property (nonatomic, strong) HMLodger *tmpLodger;

@property (nonatomic, strong) HMCheckInSuccessLogic *successLogic;

@property (nonatomic, strong) HMCheckInCondition    *checkCondition;    //!<入住条件

@property (nonatomic, copy) NSString *tempPhone;//!<需要校验的手机号
@property (nonatomic, strong) HMClearLodgerMobileAPI *clearLodgerMobileAPI;
@property (nonatomic, strong) HMUpdateSystemLodgerAPI *updateSystemLodgerAPI;//!<更新到主系统
@property (nonatomic, strong) HMUpdateLodgerPhoneAPI *updateLodgerPhoneAPI;//!<更新订单的入住人手机

@property (nonatomic, copy) void (^refreshOrderBlock)(HMOrder *order);

@end

@implementation HMCheckInNewLogic

+ (instancetype)logicWithOrder:(HMOrder *)order vc:(UIViewController *)vc
{
    HMCheckInNewLogic *logic = [[HMCheckInNewLogic alloc] init];
    
    logic.order = order;
    logic.vc = vc;
    
    return logic;
}

#pragma mark - Public Methods

- (void)commonExecute {
    
    [self checkIn];
}

- (void)executeWithFreshOrder:(void (^)(HMOrder *))refreshBlock {
    _refreshOrderBlock = refreshBlock;
    self.detailAPI.guid = _order.guid;
    [self.detailAPI sendRequestToServerWithActivityViewAndMask:POST];
}

#pragma mark - HTTPDelegate

- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api
{
    if (api == self.detailAPI) {
        _order = [HMOrder mj_objectWithKeyValues:data];
        [self checkIn];
        if (_refreshOrderBlock) {
            _refreshOrderBlock(_order);
        }
        
    } else if (api == self.checkinAPI) {

        self.checkCondition.isNoshow = data[@"isNoshow"];
        self.checkCondition.noShowOrder = [HMOrder mj_objectWithKeyValues:data[@"overdueOrderMap"][@"noshowOrder"]];
        
        self.checkCondition.isOverdue = data[@"isOverdue"];
        self.checkCondition.overdueOrder = [HMOrder mj_objectWithKeyValues:data[@"overdueOrderMap"][@"overdueOrder"]];
        
        self.checkCondition.isSameRoomOrder = data[@"isSameRoomOrder"];
        
        self.checkCondition.isBalance = data[@"isBalance"];
        
        self.checkCondition.isComplete = data[@"isComplete"];
        self.checkCondition.completeLoger = [HMLodger mj_objectWithKeyValues:data[@"rzrMap"][@"uncompleteRzr"]];
        
        self.checkCondition.isRepeat = data[@"isRepeat"];
        self.checkCondition.repeatLodger = [HMLodger mj_objectWithKeyValues:data[@"rzrMap"][@"repeatRzr"]];
        
        self.checkCondition.isRoomClean = data[@"isRoomClean"];
        
        self.checkCondition.isIn = data[@"isIn"];
        
        self.checkCondition.sendSuccess = data[@"sendSuccess"];
        
        [self checkLogic];
    
    } else if (api == self.clearLodgerMobileAPI) {
        [self checkIn];
        
    } else if (api == self.updateSystemLodgerAPI) {
        [self checkIn];
        
    } else if (api == self.updateLodgerPhoneAPI) {
        self.updateSystemLodgerAPI.guid = self.updateLodgerPhoneAPI.guid;
        self.updateSystemLodgerAPI.checkPhoneFlag = YES;
        [self.updateSystemLodgerAPI sendRequestToServerWithActivityViewAndMask:POST];
        
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api {
    if (api == self.checkinAPI) {
        !_CheckinBlock ?:_CheckinBlock(NO);
    }
}

#pragma mark - Private Method

- (void)checkLogic
{
    // Noshow
    if ([self.checkCondition.isNoshow boolValue])
    {
        [self handleNoshowOrder:self.checkCondition.noShowOrder];
    }
    //  逾期未离
    else if ([self.checkCondition.isOverdue boolValue])
    {
        [self handleOverdueOrder:self.checkCondition.overdueOrder];
    }
    // isSameRoomOrder 是否存在不同类型的已入住订单   1.有   0.无
    else if ([self.checkCondition.isSameRoomOrder boolValue])
    {
        [self handleSameRoomOrder];
    }
    // 欠款
    else if ([self.checkCondition.isBalance boolValue] && !self.checkinAPI.ignorePay)
    {
        [self showNeedPayView];
    }
    // 入住人信息未完善
    else if ([self.checkCondition.isComplete boolValue] && !self.checkinAPI.noMessageCheckIn)
    {
        _tmpLodger = self.checkCondition.completeLoger;
        [self showNobodyRecordInfo];
    }
    // 入住人信息重复 1.身份证重复 2.手机 3.身份证&手机 0
    else if ([self.checkCondition.isRepeat boolValue])
    {
        int type = [self.checkCondition.isRepeat intValue];
        
        _tmpLodger = self.checkCondition.repeatLodger;
        
        WEAKSELF
        
        if (1 == type)
        {
            
            HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:@"身份信息与已入住人重复,\n同一人不能重复入住!" rightBtnBlock:^(UIButton *rightBtn) {
                [rightBtn setTitle:@"重新扫描" forState:UIControlStateNormal];
                [rightBtn addTarget:weakSelf action:@selector(recordLodgerInfo) forControlEvents:UIControlEventTouchUpInside];
            }];
            [view showWithAnimation];
        }
        else if (2 == type)
        {
            [self showPhoneRepeatViewWithPhone:self.checkCondition.repeatLodger.phone];
//            HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:[NSString stringWithFormat:@"入住人：%@，手机重复，无法办理入住，是否重新修改入住人手机号？", _tmpLodger.name] rightBtnBlock:^(UIButton *rightBtn) {
//                [rightBtn setTitle:@"修改信息" forState:UIControlStateNormal];
//                [rightBtn addTarget:weakSelf action:@selector(editLodgerPhone) forControlEvents:UIControlEventTouchUpInside];
//            }];
//            [view showWithAnimation];
        }
        else if (3 == type)
        {
//            HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:[NSString stringWithFormat:@"入住人：%@，身份和手机重复，无法办理入住，是否重新修改入住人信息？", _tmpLodger.name] rightBtnBlock:^(UIButton *rightBtn) {
//                [rightBtn setTitle:@"修改信息" forState:UIControlStateNormal];
//                [rightBtn addTarget:weakSelf action:@selector(recordLodgerInfo) forControlEvents:UIControlEventTouchUpInside];
//            }];
            HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:@"身份信息与已入住人重复,\n同一人不能重复入住!" rightBtnBlock:^(UIButton *rightBtn) {
                [rightBtn setTitle:@"重新扫描" forState:UIControlStateNormal];
                [rightBtn addTarget:weakSelf action:@selector(recordLodgerInfo) forControlEvents:UIControlEventTouchUpInside];
            }];
            [view showWithAnimation];
        }
        
    }
    // 脏房
    else if ([self.checkCondition.isRoomClean boolValue] && !self.checkinAPI.ignoreUnclean)
    {
        [self showChangeRoomSelectionView];
    }
    // 入住结果
    else
    {
        int result = [self.checkCondition.isIn intValue];
        
        if (1 == result)
        {
            //            [self showCheckInMessageWithInfoArr:data[@"sendKeyList"]];
            HMCheckInSuccessLogic *successLogic = [HMCheckInSuccessLogic logicWithOrder:self.order];
            self.successLogic = successLogic;
            [successLogic showSuccessViewWithBleSendStatus:[self.checkCondition.sendSuccess boolValue]];
            
            !_CheckinBlock?:_CheckinBlock(YES);
        }
        else if (0 == result)
        {
            HMAlertView *view = [HMAlertView alertViewWithIconType:IconTick msg:[NSString stringWithFormat:@"%@ %@",self.order.room.roomNumberAddress,self.order.room.hotelAddress] detailMsg:@"等待房间清洁，待住中..." knowBtnBlock:^(UIButton *knowBtn) {
                
            }];
            [view showWithAnimation];
            
            !_CheckinBlock?:_CheckinBlock(YES);
        }
        else if (-1 == result)
        {
//            self.checkinAPI.ignoreUnclean = YES;
//            self.checkinAPI.ignorePay = YES;
            [self.checkinAPI sendRequestToServerWithActivityViewAndMask:POST];
        }
        
    }
}

// 入住人手机重复
- (void)showPhoneRepeatViewWithPhone:(NSString *)phone{
    
    _tempPhone = phone;
    HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:[NSString stringWithFormat:@"%@ 手机重复!", phone] detailMsg:@"无手机入住将无法使用蓝牙密钥一键开门，\r\n也无法享有会员专属权利。" upBtnBlock:^(UIButton *btn) {
        [btn setTitle:@"验证手机" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickCheckPhone) forControlEvents:UIControlEventTouchUpInside];
        
    } centerBtnBlock:^(UIButton *btn) {
        [btn setTitle:@"修改手机" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickModifyPhone) forControlEvents:UIControlEventTouchUpInside];
        
    } downBtnBlock:^(UIButton *btn) {
        [btn setTitle:@"无手机入住" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickNoPhoneToLive)forControlEvents:UIControlEventTouchUpInside];
        
    }];
    [view showWithAnimation];
}
// 点击验证手机
- (void)clickCheckPhone {
    
    [self showPhoneSecurityCodeViewWith:_tempPhone];
}

// 点击修改手机
- (void)clickModifyPhone {
    
    [self showWritePhoneWithTitle:PhoneViewTypeModify];
}

// 点击无手机入住
- (void)clickNoPhoneToLive{
    
    // 手机号重复后选择无手机入住，调清空入住人手机号接口
    self.clearLodgerMobileAPI.guid = self.checkCondition.repeatLodger.guid;
    [self.clearLodgerMobileAPI sendRequestToServerWithActivityViewAndMask:POST];
}
// 显示添加或修改手机号的view
- (void)showWritePhoneWithTitle:(NSString *)title {
    
    HMWritePhoneView *view =  [HMWritePhoneView writePhoneViewWithTitle:title];
    view.writeSuccessBlock = ^(NSString *phoneNum) {
        
        HMPhoneSecurityCodeView *codeView = [HMPhoneSecurityCodeView viewWithPhoneNum:phoneNum];
        codeView.checkCodeSuccess = ^{
            
            self.updateLodgerPhoneAPI.lxdh = phoneNum;
            self.updateLodgerPhoneAPI.guid = self.checkCondition.repeatLodger.guid;
            [self.updateLodgerPhoneAPI sendRequestToServerWithActivityViewAndMask:POST];
            
        };
        [codeView showWithAnimation];
        
    };
    [view showWithAnimation];
}

// 显示校验手机验证码的view
- (void)showPhoneSecurityCodeViewWith:(NSString *)phone {
    
    HMPhoneSecurityCodeView *view = [HMPhoneSecurityCodeView viewWithPhoneNum:phone];
    view.checkCodeSuccess = ^{
    
        self.updateSystemLodgerAPI.guid = self.checkCondition.repeatLodger.guid;
        self.updateSystemLodgerAPI.checkPhoneFlag = YES;
        [self.updateSystemLodgerAPI sendRequestToServerWithActivityViewAndMask:POST];// 更新到主系统要用
        
    };
    [view showWithAnimation];
}
// 判断字符串是否为空字符的方法
- (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)showNeedPayView
{
    WEAKSELF
    
    HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:[NSString stringWithFormat:@"应付款￥%.2f未支付!\r\n立即支付或欠款入住", _order.totalPrice - _order.paied] leftBtnBlock:^(UIButton *leftBtn) {
        
        [leftBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        [leftBtn setTitle:@"欠款入住" forState:UIControlStateNormal];
        [leftBtn addTarget:weakSelf action:@selector(checkinByOwe) forControlEvents:UIControlEventTouchUpInside];
        
    } rightBtnBlock:^(UIButton *rightBtn) {
        
        [rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [rightBtn addTarget:weakSelf action:@selector(showPayView) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    [view showWithAnimation];
}

- (void)checkinByOwe
{
    self.checkinAPI.ignorePay = YES;
    [self checkLogic];
}

- (void)checkInDirtyRoom
{
    self.checkinAPI.ignoreUnclean = YES;
    [self checkLogic];
}


- (void)showPayView
{
    
    HMPayAlertView *view = [HMPayAlertView initWithGuids:@[_order.guid] payType:PayTypePay];
    [view showOnView:[self vc].view];
    
    view.successVC = [HMPaySuccessVC new];
    view.successVC.botBtnTitle = @"完成";
    view.successVC.BotBtnActionBlock = ^{
        [[self vc].navigationController popToViewController:[self vc] animated:YES];
        [self updateOrderInfo];
    };
}

- (void)updateOrderInfo
{
    //    if ([_vc isKindOfClass:[HMTodayRoomStatusManagerVC class]])
    //    {
    //       !_CheckinBlock ?: _CheckinBlock(NO);
    //       return ;
    //    }
    self.detailAPI.guid = _order.guid;
    [self.detailAPI sendRequestToServerWithActivityViewAndMask:POST];
}

- (void)showNobodyRecordInfo
{
    WEAKSELF
    HMHotelParameterModel *model = [HMValueManager shareManager].hotelParameter;
    HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:@"入住人信息未完善!" leftBtnBlock:^(UIButton *leftBtn) {
        
        if (model.hotelLiveType.integerValue != 0) {// 不能无身份入住
            [leftBtn setTitleColor:kGlobalTextColorGray forState:UIControlStateNormal];
            [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
            
        } else {// 可以无身份入住
            [leftBtn setTitleColor:kGlobalTextColorBrown forState:UIControlStateNormal];
            [leftBtn setTitle:@"无信息入住" forState:UIControlStateNormal];
            [leftBtn addTarget:weakSelf action:@selector(noMessageToLive) forControlEvents:UIControlEventTouchUpInside];
        }
        
    } rightBtnBlock:^(UIButton *rightBtn) {
        [rightBtn setTitle:@"完善信息" forState:UIControlStateNormal];
        [rightBtn addTarget:weakSelf action:@selector(recordLodgerInfo) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    [view showWithAnimation];
}

- (void)noMessageToLive {
    self.checkinAPI.noMessageCheckIn = @"1";
    [self checkLogic];
}

- (void)recordLodgerInfo
{
    HMRecordLodgerVC *recordVC = nil;
    
    for (UIViewController *vc in _vc.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[HMRecordLodgerVC class]])
        {
            recordVC = (id)vc;
            break;
        }
    }
    
    [HMValueManager shareManager].lodger = [_tmpLodger copy];
    [HMValueManager shareManager].order = _order;
    [HMValueManager shareManager].addLodgerType = AddLodgerTypeUpdate;
    
    if (!recordVC)
    {
        recordVC = [HMRecordLodgerVC recordLodgerVCWithWay:RecordByIDCard];
        [_vc.navigationController pushViewController:recordVC animated:YES];
    }
    else
    {
        [_vc.navigationController popToViewController:recordVC animated:YES];
    }
}

- (void)showChangeRoomSelectionView
{
    WEAKSELF
    
    HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:[NSString stringWithFormat:@"%@ %@\n房未洁，确定入住或换房？", self.order.room.roomNumberAddress,self.order.room.hotelAddress] leftBtnBlock:^(UIButton *leftBtn) {
        
        [leftBtn setTitle:@"换房" forState:UIControlStateNormal];
        [leftBtn setTitleColor:kGlobalTextColorBrown forState:UIControlStateNormal];
        [leftBtn addTarget:weakSelf action:@selector(loadChangeRoomVC) forControlEvents:UIControlEventTouchUpInside];
        
    } rightBtnBlock:^(UIButton *rightBtn) {
        [rightBtn setTitle:@"确定入住" forState:UIControlStateNormal];
        [rightBtn addTarget:weakSelf action:@selector(checkInDirtyRoom) forControlEvents:UIControlEventTouchUpInside];
    }];
    [view showWithAnimation];
    
}

- (void)loadChangeRoomVC
{
    HMChangeRoomVC *vc = [[HMChangeRoomVC alloc] initWithOrder:self.order];
    vc.noPopAlert = YES;
    [_vc.navigationController pushViewController:vc animated:YES];
}

- (void)checkIn
{
    self.checkinAPI.guid = _order.guid;
    [self.checkinAPI sendRequestToServerWithActivityViewAndMask:POST];
}

// 入住成功后显示对应对应弹窗
- (void)showCheckInMessageWithInfoArr:(NSArray *)infoArr{
    
    NSArray *infoDicts = infoArr;
    
    NSMutableString *sendBleKeyNames = [NSMutableString string];//!<发送蓝牙密钥的住客
    NSMutableString *makeRoomCardNames = [NSMutableString string];//!<需要制房卡的住客
    for (NSInteger i = 0; i < infoDicts.count; i++) {
        NSDictionary *infoDict = infoDicts[i];
        
        NSString *name = infoDict[@"xm"];
        NSString *bluetooth = infoDict[@"sendSuccess"];
        if ([bluetooth isEqualToString:@"1"]) {
            [sendBleKeyNames appendFormat:@"%@", [NSString stringWithFormat:@"%@、",name]];
        } else {
            [makeRoomCardNames appendFormat:@"%@", [NSString stringWithFormat:@"%@、",name]];
        }
    }
    
    if ([self.order.room.bleAvaliable isEqualToString:@"1"]) {// 蓝牙房间
        
        NSString *title;
        if (![sendBleKeyNames isEqualToString:@""]) {
            title = [NSString stringWithFormat:@"%@ %@\n入住完成,蓝牙密钥已发送!", self.order.room.roomNumberAddress,self.order.room.hotelAddress];
        } else {
            title = [NSString stringWithFormat:@"%@ %@\n入住完成", self.order.room.roomNumberAddress,self.order.room.hotelAddress];
        }
        
        HMAlertView *view = [HMAlertView alertViewWithIconType:IconTick msg:title detailMsg:@"" upBtnBlock:^(UIButton *btn) {
            
            [btn setTitle:@"打印押金单" forState:UIControlStateNormal];
            
        } centerBtnBlock:^(UIButton *btn) {
            
            [btn setTitle:@"蓝牙门锁" forState:UIControlStateNormal];
            
        } downBtnBlock:^(UIButton *btn) {
            
            [btn setTitle:@"制房卡" forState:UIControlStateNormal];
        }];
        [view showWithAnimation];
        
    } else {
        HMAlertView *view = [HMAlertView alertViewWithIconType:IconTick msg:[NSString stringWithFormat:@"%@ %@\n入住完成!",self.order.room.roomNumberAddress,self.order.room.hotelAddress] leftBtnBlock:^(UIButton *leftBtn) {
            
            [leftBtn setTitle:@"打印押金单" forState:UIControlStateNormal];
            
        } rightBtnBlock:^(UIButton *rightBtn) {
            
            [rightBtn setTitle:@"制房卡" forState:UIControlStateNormal];
        }];
        
        [view showWithAnimation];
    }
    
    
    //   if (![sendBleKeyNames isEqualToString:@""]) {
    //      [sendBleKeyNames deleteCharactersInRange:NSMakeRange(sendBleKeyNames.length - 1, 1)];
    //
    //       HMAlertView *view = [HMAlertView alertViewWithIconType:IconTick msg:[NSString stringWithFormat:@"%@\n%@ %@\n蓝牙密钥已发送!",sendBleKeyNames,self.order.room.roomNumberAddress,self.order.room.hotelAddress]];
    //
    //      [view showWithAnimation];
    
    //   } else {
    
    //      HMMakeRoomCardView *makeRoomCardView = [HMMakeRoomCardView viewWithOrderGuid:self.order.guid];
    //      NSArray *viewControllers = self.vc.navigationController.viewControllers;
    //      NSUInteger count = viewControllers.count;
    //      for (int i = 0; i < count; i++) {
    //         UIViewController *vc = viewControllers[i];
    //         if ([vc isKindOfClass:[HMTodayRoomStatusManagerVC class]]) {
    //            makeRoomCardView.ownerVC = vc;
    //
    //         } else if ([vc isKindOfClass:[HMTodayOrderVC class]]) {
    //            makeRoomCardView.ownerVC = vc;
    //         }
    //      }
    //      __weak typeof(makeRoomCardView) weakView = makeRoomCardView;
    //      makeRoomCardView.showViewInTodayOrderVCBlock = ^(ShowLoading showLoading){
    //         weakView.hidden = NO;
    //         [weakView refreshView];
    //      };
    //
    //      HMAction *makeCardAction = [HMAction action:^{
    //
    //         [makeRoomCardView showWithAnimation];
    //
    //      } withTitle:@"制房卡" actionStyle:HMActionStyleGreenBackground];
    
    //      [makeRoomCardNames deleteCharactersInRange:NSMakeRange(makeRoomCardNames.length - 1, 1)];
    
    
    //   }
}

- (void)clickedMakeRoomCardBtn {
    
    //   HMMakeRoomCardView *view = [HMMakeRoomCardView viewWithOrderGuid:self.order.guid];
    //   view.ownerVC = _vc;
    //   __weak typeof(view) weakView = view;
    //   view.showViewInTodayOrderVCBlock = ^(ShowLoading showLoading){
    //      weakView.hidden = NO;
    //      [weakView refreshView];
    //   };
    //   [view showWithAnimationOnView:_vc.navigationController.view];
}

- (void)handleSameRoomOrder {
    WEAKSELF
    
    HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:[NSString stringWithFormat:@"%@ %@\n房未洁，确定入住或换房？", self.order.room.roomNumberAddress,self.order.room.hotelAddress] leftBtnBlock:^(UIButton *leftBtn) {
        
        [leftBtn setTitle:@"换房" forState:UIControlStateNormal];
        [leftBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
        [leftBtn addTarget:weakSelf action:@selector(loadChangeRoomVC) forControlEvents:UIControlEventTouchUpInside];
        
    } rightBtnBlock:^(UIButton *rightBtn) {
        [rightBtn setTitle:@"确定入住" forState:UIControlStateNormal];
        [rightBtn setTitleColor:kGlobalTextColorGray forState:UIControlStateNormal];
    }];
    
    [view showWithAnimation];
}

- (void)handleNoshowOrder:(HMOrder *)noShowOrder
{
    HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:[NSString stringWithFormat:@"%@ %@\r\n%@逾期NS!",[noShowOrder.room roomNumberAddress],[noShowOrder.room hotelAddress],[noShowOrder checkInDate]] rightBtnBlock:^(UIButton *rightBtn) {
        
        [rightBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(goToOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(rightBtn, @"operator_order", noShowOrder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
    
    [view showWithAnimation];
    
}

- (void)handleOverdueOrder:(HMOrder *)overDueOrder
{
    HMAlertView *view = [HMAlertView alertViewWithIconType:IconWarn msg:[NSString stringWithFormat:@"%@ %@\r\n%@逾期未离!",[overDueOrder.room roomNumberAddress],[overDueOrder.room hotelAddress],[overDueOrder checkInDate]] rightBtnBlock:^(UIButton *rightBtn) {
        
        [rightBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(goToOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(rightBtn, @"operator_order", overDueOrder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
    
    [view showWithAnimation];
}

- (void)goToOrderDetail:(UIButton *)btn
{
    HMOrder *operatorOrder = objc_getAssociatedObject(btn, @"operator_order");
    
    HMTodayOrderDetailVC *vc = [[HMTodayOrderDetailVC alloc] initWithOrderGuid:operatorOrder.guid];
    
    [[self vc].navigationController pushViewController:vc animated:YES];
}


- (void)editLodgerPhone
{
    //   HMValueManager *manager = [HMValueManager shareManager];
    //   manager.lodger = [_tmpLodger copy];
    //
    //   if (_tmpLodger.credentialsCode == IDCard)
    //   {
    //      HMCheckIDCardVC *vc = [HMCheckIDCardVC new];
    //
    //      vc.lodger = manager.lodger;
    //
    //      [(HMNavigationController *)self.vc.navigationController admit:NO pushSameVC:vc animated:YES];
    //   }
    //   else
    //   {
    //      HMCheckCredentialsVC *vc = [HMCheckCredentialsVC new];
    //
    //      vc.lodger = manager.lodger;
    //
    //      [(HMNavigationController *)self.vc.navigationController admit:NO pushSameVC:vc animated:YES];
    //   }
}

#pragma mark - Interface Method

- (BOOL)isAnybodyRecordInfo
{
    for (HMLodger *lodger in _order.lodgerList)
    {
        if (lodger.source.intValue > 0)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isAllLodgerRecordInfo
{
    for (HMLodger *lodger in _order.lodgerList)
    {
        if (lodger.source.intValue == 0)
        {
            _tmpLodger = lodger;
            return NO;
        }
    }
    return YES;
}

- (BOOL)isNeedPay
{
    if (_order.oweCheckin)
    {
        return NO;
    }
    
    return _order.totalPrice - _order.paied > 0;
}

- (BOOL)isRoomClean
{
    return !_order.room.cleanStatus.intValue;
}

#pragma mark - lazy init

- (HMCheckInAPI *)checkinAPI
{
    if (! _checkinAPI)
    {
        _checkinAPI = [HMCheckInAPI apiWithDelegate:self];
    }
    return _checkinAPI;
}

- (HMOrderDetailAPI *)detailAPI
{
    if (! _detailAPI)
    {
        _detailAPI = [HMOrderDetailAPI apiWithDelegate:self];
        //      _detailAPI.maxFailedAgainTimes = 3;
    }
    return _detailAPI;
}

- (HMCheckInCondition *)checkCondition
{
    if (!_checkCondition)
    {
        _checkCondition = [HMCheckInCondition new];
    }
    return _checkCondition;
}

- (HMClearLodgerMobileAPI *)clearLodgerMobileAPI {
    if (!_clearLodgerMobileAPI) {
        _clearLodgerMobileAPI = [HMClearLodgerMobileAPI apiWithDelegate:self];
    }
    return _clearLodgerMobileAPI;
}

- (HMUpdateSystemLodgerAPI *)updateSystemLodgerAPI {
    if (!_updateSystemLodgerAPI) {
        _updateSystemLodgerAPI = [HMUpdateSystemLodgerAPI apiWithDelegate:self];
    }
    return _updateSystemLodgerAPI;
}

- (HMUpdateLodgerPhoneAPI *)updateLodgerPhoneAPI {
    if (!_updateLodgerPhoneAPI) {
        _updateLodgerPhoneAPI = [HMUpdateLodgerPhoneAPI apiWithDelegate:self];
    }
    return _updateLodgerPhoneAPI;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [HMValueManager shareManager].order = nil;
    [HMValueManager shareManager].lodger = nil;
    _detailAPI.delegate = nil;
}

@end
