//
//  HMConfirmPayVC.m
//  HotelManager
//
//  Created by YR on 2017/3/30.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMConfirmPayVC.h"
#import "HMConfirmWayView.h"
#import "HMConfirmPayInfoAPI.h"
#import "HMPayInfoModel.h"
#import "NSObject+JSONToObject.h"
#import "HMPayInfoCell.h"
#import "HMPayFootView.h"
#import "HMWeChatPayAPI.h"
#import "HMPayOrderModel.h"
#import "HMAliPayAPI.h"
#import "HMPayWarningAlert.h"
#import "HMPayCodeAlert.h"
#import "HMSavePayInfoAPI.h"
#import "HMSavePayInfoModel.h"
#import "HMPaySuccessVC.h"
#import "Alert.h"
#import "HMConfirmOrderVC.h"
#import "HMPayWayListAPI.h"
#import "HMPayAlertView.h"
#import "HMMemberPayVC.h"
#import "HMSaveServicePayAPI.h"
#import "NSObject+JsonString.h"
#import "HMSaveHotelServiceOrderAPI.h"

#define kBtnTag 1000

@interface HMConfirmPayVC ()<UITableViewDelegate,UITableViewDataSource,HTTPAPIDelegate>

@property (nonatomic, strong) NSArray   *guidArr;
@property (nonatomic, assign) PayType   payType;
@property (nonatomic, strong) HMPayWayModel *payModel;

@property (nonatomic, strong) NSTimer   *cutDownTimer;
@property (nonatomic, strong) UILabel   *timelab;
@property (nonatomic, strong) HMConfirmWayView    *payWayView;
@property (nonatomic, strong) UITableView   *orderTableView;
@property (nonatomic, strong) UILabel       *owePayLab;
@property (nonatomic, strong) UILabel       *shouldPayLab;

@property (nonatomic, strong) HMPayWayListAPI   *payWayAPI;     //!<支付方式列表
@property (nonatomic, strong) HMConfirmPayInfoAPI   *payInfoAPI;
@property (nonatomic, strong) NSMutableArray        *payInfoData;
@property (nonatomic, strong) NSMutableArray        *shouldPayData; //!<实付款总数
@property (nonatomic, assign) CGFloat       countPay;

@property (nonatomic, strong) NSString      *payOrderNum;       //!<支付单号
@property (nonatomic, assign) BOOL          ignorePayNum;       //!<是否填写支付单号

@property (nonatomic, strong) HMPayOrderModel   *payOrder;          //!<支付信息
@property (nonatomic, strong) HMWeChatPayAPI    *wexinPayAPI;       //!<微信支付API
@property (nonatomic, strong) HMAliPayAPI       *aliPayAPI;         //!<支付宝支付

@property (nonatomic, strong) NSMutableArray    *attachArr;         //!<附件
@property (nonatomic, strong) NSMutableArray    *attachUrlArr;      //!<附件URL
@property (nonatomic, strong) NSString          *comments;          //!<备注

@property (nonatomic, strong) NSString          *lsh;               //!<流水号
@property (nonatomic, strong) HMSavePayInfoAPI  *savePayInfoAPI;    //!<保存支付信息
@property (nonatomic, strong) HMPayInfoModel *payInfoModel;
@property (nonatomic, strong) HMSaveServicePayAPI *saveServicePayAPI;//!<外来客保存接口
@property (nonatomic, strong) HMSaveHotelServiceOrderAPI *saveHotelServiceOrderAPI;//!<保存外来客信息
@end

@implementation HMConfirmPayVC
{
    NSInteger   cutMinute;
    NSInteger   cutSeconde;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ThirdPaywaySucces:) name:LPNotiPaySuccess object:nil];
}

- (void)ThirdPaywaySucces:(NSNotification *)not
{
    _lsh = not.userInfo[LPNotiPayIdKey];
    [self saveUserPayInfo];
}

#pragma mark -- 支付成功保存支付信息
- (void)saveUserPayInfo
{
    if (self.payInfoModel.saveHotelServiceOrderAPI != nil && self.payInfoModel.guid.length == 0)
    {
        [self.saveHotelServiceOrderAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
        return;
    }
    
    //上传附件
    NSMutableArray *imgDataArr = [NSMutableArray new];
    for (UIImage *img in self.attachArr)
    {
        HMImageFile *imageFile = [HMImageFile new];
        imageFile.imageData = UIImageJPEGRepresentation(img, 0.5);
        imageFile.subPath = ImageSubPathAttachment;
        [imgDataArr addObject:imageFile];
    }
    
    if (imgDataArr.count)
    {
        WEAKSELF
        [HTTPAPI sendServerImageFiles:imgDataArr isToTotalSystem:IsToTotalSystemDefault successBlock:^(NSURLSessionDataTask *dataTask, id dataObj)
         {
             [weakSelf.attachUrlArr removeAllObjects];
             [weakSelf.attachUrlArr addObjectsFromArray:[HMImageFile imagePathFromServerWithResult:dataObj]];
             [weakSelf confirmPayResult];
             
         } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error)
         {
             
         }];
    }
    else
    {
        [self confirmPayResult];
    }
}

- (void)confirmPayResult
{
    NSMutableArray *payInfoArr = [NSMutableArray new];
    for (NSInteger i = 0; i < self.payInfoData.count; i ++)
    {
        HMPayInfoModel *model = self.payInfoData[i];
        
        HMSavePayInfoModel *payModel = [HMSavePayInfoModel new];
        payModel.payType    = @(_payType).stringValue;
        if ([self isLastViewControllerKindOf:[HMConfirmOrderVC class]])
        {
            //FIXME: 1.2.1 注释 1.2.2 打开
            //            payModel.payType = @"5";
        }
        payModel.ddGuid     = model.guid;
        payModel.userId     = kUserId;
        payModel.userName   = kUserName;
        payModel.loginName  = kUserName;
        payModel.cs_id      = kCsId;
        payModel.isTurnClean = _isTurnClean;
        
        NSMutableArray *paiedList = [NSMutableArray new];
        HMPaiedDetailModel *detailModel = [HMPaiedDetailModel new];
        detailModel.payedMoney = [self arrSumCount:self.shouldPayData];
        detailModel.skje    = [self.shouldPayData[i] floatValue];
        if ([_payModel.sklxMc isEqualToString:@"现金"]) {
            detailModel.skfs   = @"1";
        }else {
            detailModel.skfs    = _payModel.sklxGuid;
        }
        if ([_payModel.sklxGuid isEqualToString:PaywayGuidWechatScan] ||
            [_payModel.sklxGuid isEqualToString:PaywayGuidAlipayScan])
        {
            detailModel.lsh     = _lsh;
        }
        else
        {
            detailModel.lsh     = _payOrderNum;
        }
        detailModel.bz      = _comments;
        detailModel.fj_path = [self.attachUrlArr componentsJoinedByString:@","];
        [paiedList addObject:detailModel];
        
        payModel.skList     = paiedList;
        
        if (self.payInfoModel != nil)
        {
            payModel.paymentSource = @"5";
        }
        
        [payInfoArr addObject:payModel];
    }
    
    if (self.payInfoModel != nil)
    {
        self.saveServicePayAPI.paydata = [payInfoArr jsonString];
        [self.saveServicePayAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
    }
    else
    {
        self.savePayInfoAPI.paydata = payInfoArr;
        [self.savePayInfoAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
    }
    
}

- (BOOL)isLastViewControllerKindOf:(Class)class
{
    NSArray *viewControlllers = self.navigationController.viewControllers;
    NSUInteger controllersCount = viewControlllers.count;
    UIViewController *lastVC = viewControlllers[controllersCount - 2];
    
    if ([lastVC isKindOfClass:class])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (instancetype)initWithOrders:(NSArray *)orderGuids payType:(PayType)payType payModel:(HMPayWayModel *)payModel And:(HMPayInfoModel *)payInfoModel
{
    if (self == [super init])
    {
        _ignorePayNum   = NO;
        _countPay       = 0;
        _guidArr        = orderGuids;
        _payType        = payType;
        _payModel       = payModel;
        
        cutMinute   = 15;
        cutSeconde  = 0;
        
        self.successVC = [HMPaySuccessVC new];
        self.view.backgroundColor = kColor(230, 230, 230, 1);
        
        if ([payModel.sklxMc isEqualToString:PayViewPaywayCashRefund])
        {
            [self setNavigationItemBackBBIAndTitle:@"现金返回"];
        }
        else
        {
            [self setNavigationItemBackBBIAndTitle:@"支付"];
        }
        
        self.payInfoModel = payInfoModel;
        
        [self initView];
    }
    return self;
}

- (instancetype)initWithOrders:(NSArray *)orderGuids payType:(PayType)payType payModel:(HMPayWayModel *)payModel
{
    if (self == [super init])
    {
        _ignorePayNum   = NO;
        _countPay       = 0;
        _guidArr        = orderGuids;
        _payType        = payType;
        _payModel       = payModel;
        
        cutMinute   = 15;
        cutSeconde  = 0;
        
        self.successVC = [HMPaySuccessVC new];
        self.view.backgroundColor = kColor(230, 230, 230, 1);
        [self setNavigationItemBackBBIAndTitle:@"支付"];
        
        [self initView];
    }
    return self;
}

- (void)refreshPayWayOrders:(NSArray *)orderGuids payType:(PayType)payType payModel:(HMPayWayModel *)payModel
{
    _ignorePayNum   = NO;
    _countPay       = 0;
    _guidArr        = orderGuids;
    _payType        = payType;
    _payModel       = payModel;
    
    self.view.backgroundColor = kColor(230, 230, 230, 1);
    [self setNavigationItemBackBBIAndTitle:@"支付"];
    
    _owePayLab.b_text([NSString stringWithFormat:@"欠付: ¥ 0.00"])
    .b_bgColor(kColor(230, 230, 230, 1));
    
    NSString *str = nil;
    if ([_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund])
    {
        str = @"确认返款";
    }
    else
    {
        str = @"确认支付";
    }
    UIButton *btn = [self.view viewWithTag:kBtnTag];
    [btn setTitle:str forState:UIControlStateNormal];
    
    if ([_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund])
    {
        self.payWayAPI.payType = @(_payType).stringValue;
        [self.payWayAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
    }
    else
    {
        self.payInfoAPI.guid = [_guidArr componentsJoinedByString:@","];
        self.payInfoAPI.payType = @(_payType).stringValue;
        [self.payInfoAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
    }
}

- (void)backToLastVC
{
    [self.cutDownTimer invalidate];
    self.cutDownTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConfirmOrderTurnOnTimerNotification object:nil];//确认订单重新启用定时器
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView
{
    //倒计时
    UIView *timeView = [UIView new];
    timeView.b_frame(LPRectMake(0, StatusHeight, 375, 30))
    .b_moveToView(self.view);
    
    _timelab = [UILabel new];
    _timelab.b_font(kFont(14)).b_textColor([UIColor whiteColor])
    .b_textAlignment(NSTextAlignmentCenter).b_bgColor(kColor(230, 204, 133, 1))
    .b_frame(LPRectMake(0, 0, 250, 30)).b_moveToView(timeView);
    _timelab.text = [NSString stringWithFormat:@"您有%02ld分%02ld秒 确认本订单",(long)cutMinute,(long)cutSeconde];
    
    _owePayLab = [UILabel new];
    _owePayLab.b_textColor([UIColor whiteColor]).b_font(kFont(14))
    .b_textAlignment(NSTextAlignmentCenter).b_bgColor(kColor(230, 230, 230, 1))
    .b_frame(LPRectMake(250, 0, 125, 30)).b_moveToView(timeView);
    _owePayLab.text = [NSString stringWithFormat:@"欠付: ¥ 0.00"];
    
    self.cutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cutDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.cutDownTimer forMode:NSRunLoopCommonModes];
    
    UIView *bottomView = [UIView new];
    bottomView.b_bgColor(kColor(80, 80, 80, 1))
    .b_moveToView(self.view);
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasBottom(-SafeFooterHeight);kMasHeight(50);kMasRight(0);
    }];
    [self fillBottomView];
    
    NSString *str = nil;
    if ([_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund])
    {
        str = @"确认返款";
    }
    else
    {
        str = @"确认支付";
    }
    UIButton *payBtn = [UIButton new];
    payBtn.tag = kBtnTag;
    payBtn.b_title(str,UIControlStateNormal).b_font(kFont(18))
    .b_titleColor([UIColor whiteColor],UIControlStateNormal)
    .b_bgColor(kYellowColor).b_frame(LPRectMake(255, 0, 120, 50))
    .b_moveToView(bottomView);
    [payBtn addTarget:self action:@selector(surePayAction) forControlEvents:UIControlEventTouchUpInside];
    
    _shouldPayLab = [UILabel new];
    _shouldPayLab.b_font(kFont(17)).b_textColor([UIColor whiteColor])
    .b_textAlignment(NSTextAlignmentLeft)
    .b_frame(LPRectMake(20, 0, 230, 50)).b_moveToView(bottomView);
    
    _orderTableView = [UITableView new];
    _orderTableView.b_delegate(self).b_dataSource(self)
    .b_separatorStyle(UITableViewCellSeparatorStyleNone)
    .b_bgColor(kColor(230, 230, 230, 1)).b_moveToView(self.view);
    [_orderTableView registerClass:[HMPayInfoCell class] forCellReuseIdentifier:@"orderCell"];
    
    [_orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasRight(0);kMasTop(StatusHeight+30);kMasBottom(-50-SafeFooterHeight);
    }];
    
    if ([_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund])
    {
        self.payWayAPI.payType = @(_payType).stringValue;
        [self.payWayAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
    }
    else
    {
        self.payInfoAPI.guid = [_guidArr componentsJoinedByString:@","];
        self.payInfoAPI.payType = @(_payType).stringValue;
        if (self.payInfoModel != nil)
        {
            self.payInfoAPI.payType = @"1";
            [self.payInfoData removeAllObjects];
            [self.payInfoData addObject:self.payInfoModel];
            
            CGFloat pay = 0;
            for (HMPayInfoModel *model in self.payInfoData)
            {
                if (model.yk.floatValue < 0)
                {
                    [self.shouldPayData addObject:[NSString stringWithFormat:@"%.02f",fabs(model.yk.floatValue)]];
                    pay += fabs(model.yk.floatValue);
                }
                else
                {
                    [self.shouldPayData addObject:@"0"];
                }
            }
            _countPay = pay;
            NSString *ss = [_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund] ? @"实返款" : @"实付款";
            _shouldPayLab.text = [NSString stringWithFormat:@"%@  ¥ %.02f",ss,pay];
            
            [self.orderTableView reloadData];
        }
        else
        {
            [self.payInfoAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
        }
    }
}

- (void)cutDown
{
    cutSeconde--;
    if (cutSeconde < 0)
    {
        cutSeconde = 59;
        cutMinute--;
        if (cutMinute < 0)
        {
            cutMinute = 0;
            cutSeconde = 0;
            [self.cutDownTimer invalidate];
            self.cutDownTimer = nil;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [Alert alertWithTitle:@"警告" msg:@"支付超时！"];
        }
    }
    _timelab.text = [NSString stringWithFormat:@"您有%02ld分%02ld秒 确认本订单",(long)cutMinute,(long)cutSeconde];
}

#pragma mark - 确认支付
- (void)surePayAction
{
    if ([_payModel.sklxGuid isEqualToString:PaywayGuidWechatScan])
    {//微信
        /*
         if ([self confirmOrderNum])
         {
         [self orderNumAlert];
         return;
         }
         */
        
        [_wexinPayAPI.dataTask cancel];
        
        [self payMoney:self.shouldPayData withOrder:self.payInfoData.firstObject];
        
        if (_payOrder.money == 0)
        {
            [Prompt popPromptViewInScreenCenterWithMsg:@"付款金额为0不可选择此种支付方式!" duration:2.f];
            return;
        }
        
        self.wexinPayAPI.body = _payOrder.title;
        self.wexinPayAPI.totalAmount = _payOrder.money;
        [self.wexinPayAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
    }
    else if ([_payModel.sklxGuid isEqualToString:PaywayGuidAlipayScan])
    {//支付宝
        /*
         if ([self confirmOrderNum])
         {
         [self orderNumAlert];
         return;
         }
         */
        
        [_aliPayAPI.dataTask cancel];
        
        [self payMoney:self.shouldPayData withOrder:self.payInfoData.firstObject];
        
        if (_payOrder.money == 0)
        {
            [Prompt popPromptViewInScreenCenterWithMsg:@"付款金额为0不可选择此种支付方式!" duration:2.f];
            return;
        }
        
        self.aliPayAPI.body = _payOrder.descr;
        self.aliPayAPI.totalAmount = _payOrder.money;
        self.aliPayAPI.subject = _payOrder.title;
        [self.aliPayAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
    }
    else if ([_payModel.sklxGuid isEqualToString:PaywayGuidCashRefund])
    {
        [self payMoney:self.shouldPayData withOrder:self.payInfoData.firstObject];
        HMPayWarningAlert *alert = [[HMPayWarningAlert alloc] initWithTitle:[NSString stringWithFormat:@"确认返款？\n¥%.02f",_payOrder.money] img:@"warn_01"];
        [alert showOnView:self.view];
        alert.btnTitleArr = @[@"取消",@"确定"];
        
        WEAKSELF
        alert.RithtBtnBlock = ^()
        {
            [weakSelf saveUserPayInfo];
        };
    }
    else if ([_payModel.sklxGuid isEqualToString:PaywayGuidMember])
    {
        HMMemberPayVC *vc = [[HMMemberPayVC alloc] initMemberGuids:_guidArr.firstObject withPayType:_payType payModel:_payModel];
        vc.successVC = _successVC;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if (![_payModel.sklxGuid isEqualToString:PaywayGuidCash])
        {
            if ([self confirmOrderNum])
            {
                [self orderNumAlert];
                return;
            }
        }
        
        [self payMoney:self.shouldPayData withOrder:self.payInfoData.firstObject];
        
        HMPayWarningAlert *alert = [[HMPayWarningAlert alloc] initWithTitle:[NSString stringWithFormat:@"确定%@支付？\n¥%.02f",_payModel.sklxMc,_payOrder.money] img:@"warn_01"];
        [alert showOnView:self.view];
        alert.btnTitleArr = @[@"取消",@"确定"];
        
        WEAKSELF
        alert.RithtBtnBlock = ^()
        {
            [weakSelf saveUserPayInfo];
        };
    }
}

- (BOOL)confirmOrderNum
{
    if (_payOrderNum.length == 0 && !self.ignorePayNum)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)orderNumAlert
{
    HMPayWarningAlert *alert = [[HMPayWarningAlert alloc] initWithTitle:@"支付单号未填写!" img:@"warn_01"];
    [alert showOnView:self.view];
    alert.btnTitleArr = @[@"不填写",@"立即填写"];
    
    WEAKSELF
    alert.LeftBtnBlock = ^()
    {
        weakSelf.ignorePayNum = YES;
        [weakSelf surePayAction];
    };
}

- (void)payMoney:(NSArray *)payArr withOrder:(HMPayInfoModel *)model
{
    HMPayOrderModel *payModel = [HMPayOrderModel new];
    payModel.Id     = model.guid;
    payModel.title  = @"确认支付订单";
    payModel.descr  = @"支付订房费用";
    payModel.money  = [self arrSumCount:payArr];
    
    self.payOrder   = payModel;
}

#pragma mark - HTTPAPIDelegate
- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api
{
    if ([api isEqual:self.payWayAPI])
    {
        NSMutableArray *payWayModel = [NSMutableArray arrayWithArray:(NSArray *)[HMPayWayModel objectFromDataObject:data]];
        for (HMPayWayModel *model in payWayModel)
        {
            if ([model.sklxMc isEqualToString:PayViewPaywayCashRefund])
            {
                _payModel = model;
            }
        }
        
        self.payInfoAPI.guid = [_guidArr componentsJoinedByString:@","];
        self.payInfoAPI.payType = @(_payType).stringValue;
        if (self.payInfoModel != nil)
        {
            self.payInfoAPI.payType = @"1";
            [self.payInfoData removeAllObjects];
            [self.payInfoData addObject:self.payInfoModel];
            [self.shouldPayData removeAllObjects];
            
            CGFloat pay = 0;
            for (HMPayInfoModel *model in self.payInfoData)
            {
                if ([_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund])
                {
                    [self.shouldPayData addObject:[NSString stringWithFormat:@"%.02f",fabs(model.yk.floatValue)]];
                    pay += fabs(model.yk.floatValue);
                }
                else
                {
                    if (model.yk.floatValue < 0)
                    {
                        [self.shouldPayData addObject:[NSString stringWithFormat:@"%.02f",fabs(model.yk.floatValue)]];
                        pay += fabs(model.yk.floatValue);
                    }
                    else
                    {
                        [self.shouldPayData addObject:@"0"];
                    }
                }
            }
            _countPay = pay;
            NSString *ss = [_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund] ? @"实返款" : @"实付款";
            _shouldPayLab.text = [NSString stringWithFormat:@"%@  ¥ %.02f",ss,pay];
            
            [self.orderTableView reloadData];
        }
        else
        {
            [self.payInfoAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
        }
    }
    else if ([api isEqual:self.payInfoAPI])
    {
        if ([data isKindOfClass:[NSNull class]]){return;}
        [self.payInfoData removeAllObjects];
        
        if (self.payInfoModel != nil)
        {
            self.payInfoAPI.payType = @"1";
            [self.payInfoData removeAllObjects];
            [self.payInfoData addObject:self.payInfoModel];
            [self.shouldPayData removeAllObjects];
            
            CGFloat pay = 0;
            for (HMPayInfoModel *model in self.payInfoData)
            {
                if ([_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund])
                {
                    [self.shouldPayData addObject:[NSString stringWithFormat:@"%.02f",fabs(model.yk.floatValue)]];
                    pay += fabs(model.yk.floatValue);
                }
                else
                {
                    if (model.yk.floatValue < 0)
                    {
                        [self.shouldPayData addObject:[NSString stringWithFormat:@"%.02f",fabs(model.yk.floatValue)]];
                        pay += fabs(model.yk.floatValue);
                    }
                    else
                    {
                        [self.shouldPayData addObject:@"0"];
                    }
                }
            }
            _countPay = pay;
            NSString *ss = [_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund] ? @"实返款" : @"实付款";
            _shouldPayLab.text = [NSString stringWithFormat:@"%@  ¥ %.02f",ss,pay];
            
            [self.orderTableView reloadData];
        }
        else
        {
            [self.payInfoData addObjectsFromArray:(NSArray *)[HMPayInfoModel mj_objectArrayWithKeyValuesArray:data[@"info"]]];
            
            [self.shouldPayData removeAllObjects];
            CGFloat pay = 0;
            for (HMPayInfoModel *model in self.payInfoData)
            {
                if ([_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund])
                {
                    if (model.yk.floatValue >= 0)
                    {
                        [self.shouldPayData addObject:[NSString stringWithFormat:@"%.02f",model.yk.floatValue]];
                        pay += model.yk.floatValue;
                    }
                    else
                    {
                        [self.shouldPayData addObject:@"0"];
                    }
                }
                else
                {
                    if (model.yk.floatValue < 0)
                    {
                        [self.shouldPayData addObject:[NSString stringWithFormat:@"%.02f",fabs(model.yk.floatValue)]];
                        pay += fabs(model.yk.floatValue);
                    }
                    else
                    {
                        [self.shouldPayData addObject:@"0"];
                    }
                }
            }
            _countPay = pay;
            NSString *ss = [_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund] ? @"实返款" : @"实付款";
            _shouldPayLab.text = [NSString stringWithFormat:@"%@  ¥ %.02f",ss,pay];
            
            [self.orderTableView reloadData];
        }
    }
    else if ([api isEqual:self.wexinPayAPI])
    {
        _payOrder.outTradeNo = data[@"outTradeNo"];
        _payOrder.url = data[@"qrCode"];
        
        HMPayCodeAlert *codeAlert = [[HMPayCodeAlert alloc] initWith:_payOrder payType:WEIXIN_PAY];
        [codeAlert showOnView:self.view];
    }
    else if ([api isEqual:self.aliPayAPI])
    {
        _payOrder.outTradeNo = data[@"outTradeNo"];
        _payOrder.url = data[@"qrCode"];
        
        HMPayCodeAlert *codeAlert = [[HMPayCodeAlert alloc] initWith:_payOrder payType:ALI_PAY];
        [codeAlert showOnView:self.view];
    }
    else if (api == self.savePayInfoAPI || api == self.saveServicePayAPI)
    {//保存用户支付信息接口
        [self.cutDownTimer invalidate];
        self.cutDownTimer = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HMPaySuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:HMTodayRoomStatusNotification object:nil];
        if (_successVC)
        {
            _successVC.shouldMoney = _countPay;
            _successVC.paiedMoney = [self arrSumCount:self.shouldPayData];
            _successVC.payWay = _payModel.sklxMc;
            [self.navigationController pushViewController:_successVC animated:YES];
        }
    }
    else if (self.saveHotelServiceOrderAPI == api)
    {
        self.payInfoModel.guid =  [NSString stringWithFormat:@"%@",data[@"guid"]];
        [self saveUserPayInfo];
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api
{
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (![_payModel.sklxMc isEqualToString:PayViewPaywayCash] &&
        ![_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund] &&
        ![_payModel.sklxMc isEqualToString:PayViewPaywayWeChat] &&
        ![_payModel.sklxMc isEqualToString:PayViewPaywayAlipay] &&
        ![_payModel.sklxMc isEqualToString:PayViewPaywayMember])
    {
        return kScaleNum(108);
    }
    else
    {
        return kScaleNum(58);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (![_payModel.sklxMc isEqualToString:PayViewPaywayCash] &&
        ![_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund] &&
        ![_payModel.sklxMc isEqualToString:PayViewPaywayWeChat] &&
        ![_payModel.sklxMc isEqualToString:PayViewPaywayAlipay] &&
        ![_payModel.sklxMc isEqualToString:PayViewPaywayMember])
    {
        height = 108;
    }
    else
    {
        height = 58;
    }
    
    UIView *view = [UIView new];
    view.b_bgColor(kColor(200, 200, 200, 1))
    .b_frame(LPRectMake(0, 0, 375, height));
    HMConfirmWayView *payWayView = [[HMConfirmWayView alloc] initWithFrame:LPRectMake(0, 0, 375, height-8) withModel:_payModel];
    [view addSubview:payWayView];
    
    WEAKSELF
    payWayView.OrderNumChange = ^(NSString *num)
    {
        weakSelf.ignorePayNum = NO;
        weakSelf.payOrderNum = num;
    };
    
    payWayView.OrderNumChange = ^(NSString *num)
    {
        weakSelf.payOrderNum = num;
    };
    
    UIControl *headerControl = [UIControl new];
    headerControl.b_bgColor([UIColor clearColor])
    .b_frame(LPRectMake(90, 0, 285, 50))
    .b_moveToView(view);
    [headerControl addTarget:self action:@selector(changePayWay) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (void)changePayWay
{
    HMPayAlertView *payWay = [HMPayAlertView initWithGuids:_guidArr payType:_payType];
    [payWay showOnView:self.view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kScaleNum(100);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    HMPayFootView *footView = [HMPayFootView new];
    footView.limit = 5;
    footView.b_frame(LPRectMake(0, 0, 375, 100));
    
    WEAKSELF
    footView.AttachmentBlock = ^(NSArray *imgArr)
    {
        [weakSelf.attachArr removeAllObjects];
        [weakSelf.attachArr addObjectsFromArray:imgArr];
    };
    
    footView.RemarkBlock = ^(NSString *remark)
    {
        weakSelf.comments = remark;
    };
    
    return footView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payInfoData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScaleNum(158);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HMPayInfoModel *model = self.payInfoData[indexPath.row];
    cell.banPrice = self.banPrice;
    [cell refreshCell:model withPayWay:_payModel payType:_payType];
    
    WEAKSELF
    cell.ChangeShouldPayBlock = ^(NSString *price)
    {
        [weakSelf.shouldPayData replaceObjectAtIndex:indexPath.row withObject:price];
        
        NSString *title = @"";
        if ([_payModel.sklxMc isEqualToString:PayViewPaywayCashRefund])
        {
            title = @"返";
        }
        else
        {
            title = @"付";
        }
        CGFloat subValue = [weakSelf arrSumCount:weakSelf.shouldPayData] - weakSelf.countPay;
        if (subValue > 0)
        {
            weakSelf.owePayLab.text = [NSString stringWithFormat:@"超%@: ¥ %.02f",title,subValue];
            weakSelf.owePayLab.backgroundColor = kColor(152, 206, 149, 1);
        }
        else if (subValue < 0)
        {
            weakSelf.owePayLab.text = [NSString stringWithFormat:@"欠%@: ¥ %.02f",title,subValue];
            weakSelf.owePayLab.backgroundColor = kColor(232, 175, 0, 1);
        }
        else
        {
            weakSelf.owePayLab.text = [NSString stringWithFormat:@"欠%@: ¥ 0.00",title];
            weakSelf.owePayLab.backgroundColor = kColor(230, 230, 230, 1);
        }
        
        weakSelf.shouldPayLab.text = [NSString stringWithFormat:@"实%@款  ¥ %.02f",title,[weakSelf arrSumCount:weakSelf.shouldPayData]];
    };
    
    return cell;
}

- (CGFloat)arrSumCount:(NSArray *)arr
{
    CGFloat sum = 0;
    for (NSString *str in arr)
    {
        sum += str.floatValue;
    }
    return sum;
}

#pragma mark - LazyInit
- (HMPayWayListAPI *)payWayAPI
{
    if (!_payWayAPI)
    {
        _payWayAPI = [HMPayWayListAPI apiWithDelegate:self];
    }
    return _payWayAPI;
}

- (HMConfirmPayInfoAPI *)payInfoAPI
{
    if (!_payInfoAPI)
    {
        _payInfoAPI = [HMConfirmPayInfoAPI apiWithDelegate:self];
    }
    return _payInfoAPI;
}

- (NSMutableArray *)payInfoData
{
    if (!_payInfoData)
    {
        _payInfoData = [NSMutableArray new];
    }
    return _payInfoData;
}

- (NSMutableArray *)shouldPayData
{
    if (!_shouldPayData)
    {
        _shouldPayData = [NSMutableArray new];
    }
    return _shouldPayData;
}

- (HMWeChatPayAPI *)wexinPayAPI
{
    if (!_wexinPayAPI)
    {
        _wexinPayAPI = [HMWeChatPayAPI apiWithDelegate:self];
    }
    return _wexinPayAPI;
}

- (HMAliPayAPI *)aliPayAPI
{
    if (!_aliPayAPI)
    {
        _aliPayAPI = [HMAliPayAPI apiWithDelegate:self];
    }
    return _aliPayAPI;
}

- (HMSavePayInfoAPI *)savePayInfoAPI
{
    if (!_savePayInfoAPI)
    {
        _savePayInfoAPI = [HMSavePayInfoAPI apiWithDelegate:self];
    }
    return _savePayInfoAPI;
}

-(HMSaveServicePayAPI *)saveServicePayAPI
{
    if (!_saveServicePayAPI)
    {
        _saveServicePayAPI = [HMSaveServicePayAPI apiWithDelegate:self];
    }
    return _saveServicePayAPI;
}

- (NSMutableArray *)attachArr
{
    if (!_attachArr)
    {
        _attachArr = [NSMutableArray new];
    }
    return _attachArr;
}

- (NSMutableArray *)attachUrlArr
{
    if (!_attachUrlArr)
    {
        _attachUrlArr = [NSMutableArray new];
    }
    return _attachUrlArr;
}

-(HMSaveHotelServiceOrderAPI *)saveHotelServiceOrderAPI
{
    if (!_saveHotelServiceOrderAPI)
    {
        _saveHotelServiceOrderAPI = [HMSaveHotelServiceOrderAPI apiWithDelegate:self];
        _saveHotelServiceOrderAPI.hotelServiceId = self.payInfoModel.saveHotelServiceOrderAPI.hotelServiceId;
        _saveHotelServiceOrderAPI.payStyle = self.payInfoModel.saveHotelServiceOrderAPI.payStyle;
        _saveHotelServiceOrderAPI.price = self.payInfoModel.saveHotelServiceOrderAPI.price;
        _saveHotelServiceOrderAPI.num =self.payInfoModel.saveHotelServiceOrderAPI.num;
        _saveHotelServiceOrderAPI.money = self.payInfoModel.saveHotelServiceOrderAPI.money;
        
        _saveHotelServiceOrderAPI.dcount = self.payInfoModel.saveHotelServiceOrderAPI.dcount;
        _saveHotelServiceOrderAPI.hotelFile = self.payInfoModel.saveHotelServiceOrderAPI.hotelFile;
        _saveHotelServiceOrderAPI.remark = self.payInfoModel.saveHotelServiceOrderAPI.remark;
        _saveHotelServiceOrderAPI.ddrzr = self.payInfoModel.saveHotelServiceOrderAPI.ddrzr;
    }
    return _saveHotelServiceOrderAPI;
}

- (void)dealloc
{
    HMLog(@"%@ 控制器已经被释放",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
