//
//  HMMemberPayVC.m
//  HotelManager
//
//  Created by YR on 2017/8/1.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMMemberPayVC.h"
#import "HMSearchMemberPayAPI.h"
#import "HMOrderDetailAPI.h"
#import "NSObject+JsonString.h"
#import "HMOrder.h"
#import "HMLodger.h"
#import "HMMember.h"
#import "HMRoom.h"
#import "HMMemberPayModel.h"
#import "HMMemberPayCell.h"
#import "HMMemberPayAlert.h"
#import "HMSavePayInfoAPI.h"
#import "HMPayInfoModel.h"
#import "HMConfirmPayInfoAPI.h"

@interface HMMemberPayVC ()<HTTPAPIDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString  *orderGuid;
@property (nonatomic, strong) HMSearchMemberPayAPI  *memberAPI;
@property (nonatomic, strong) NSMutableArray        *memberData;
@property (nonatomic, strong) HMOrderDetailAPI      *detailAPI;
//@property (nonatomic, strong) HMOrder *order;

@property (nonatomic, strong) UILabel   *tiLab;
@property (nonatomic, strong) UILabel   *priceLab;

@property (nonatomic, strong) UITableView   *table;

@property (nonatomic, assign) PayType   payType;
@property (nonatomic, strong) HMPayWayModel *payWayModel;
@property (nonatomic, strong) HMSavePayInfoAPI  *savePayInfoAPI;    //!<保存支付信息

@property (nonatomic, assign) double    price;      //!<会员支付金额
@property (nonatomic, strong) NSString  *memberType;//!<会员支付方式

@property (nonatomic, strong) HMConfirmPayInfoAPI   *payInfoAPI;
@property (nonatomic, strong) NSMutableArray    *payInfoData;
@property (nonatomic, assign) double    shouldPay;

@end

@implementation HMMemberPayVC

- (instancetype)initMemberGuids:(NSString *)orderGuid withPayType:(PayType)payType payModel:(HMPayWayModel *)payModel
{
    if (self == [super init])
    {
        _orderGuid = orderGuid;
        _payType   = payType;
        _payWayModel = payModel;
        
        self.successVC = [HMPaySuccessVC new];
        
        [self initVC:1];
    }
    return self;
}

- (instancetype)initOrderedPayGuid:(NSString *)orderGuid money:(double)money payType:(PayType)payType
{
    if (self == [super init])
    {
        _orderGuid = orderGuid;
        _payType = payType;
        _shouldPay = money;
        
        self.successVC = [HMPaySuccessVC new];
        
        [self initVC:2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)initUI
{
    [self setNavigationItemBackBBIAndTitle:@"会员支付"];
}

- (void)initVC:(NSInteger)type
{
    UIView *headView = [UIView new];
    headView.b_bgColor(kColor(255, 255, 229, 1))
    .b_moveToView(self.view);
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasTop(StatusHeight);kMasRight(0);kMasHeight(50);
    }];
    
    _tiLab = [UILabel new];
    _tiLab.b_textColor(kYellowColor)
    .b_font(kFont(14))
    .b_frame(LPRectMake(25, 0, 100, 50))
    .b_moveToView(headView);
    
    _priceLab = [UILabel new];
    _priceLab.b_font(kFont(18))
    .b_textColor(kYellowColor)
    .b_textAlignment(NSTextAlignmentRight)
    .b_frame(LPRectMake(150, 0, 200, 50))
    .b_moveToView(headView);
    
    _table = [UITableView new];
    _table.b_delegate(self).b_dataSource(self)
    .b_separatorStyle(UITableViewCellSeparatorStyleNone)
    .b_bgColor(kColor(240, 240, 240, 1))
    .b_moveToView(self.view);
    
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasTop(StatusHeight+50);kMasRight(0);kMasBottom(0);
    }];
    
    [_table registerClass:[HMMemberPayCell class] forCellReuseIdentifier:@"listCell"];
    
    //self.detailAPI.guid = _orderGuid;
    //[self.detailAPI sendRequestToServerWithActivityViewAndMask:POST];
    
    if (type == 1)
    {
        self.payInfoAPI.guid = _orderGuid;
        self.payInfoAPI.payType = @(_payType).stringValue;
        [self.payInfoAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self.view];
    }
    else
    {
        _tiLab.text = @"应付款";
        _tiLab.textColor = kYellowColor;
        _priceLab.textColor = kYellowColor;
        
        _priceLab.text = [NSString stringWithFormat:@"¥%.02f",_shouldPay];
        
        self.memberAPI.guid = _orderGuid;
        [self.memberAPI sendRequestToServerWithActivityViewAndMask:POST];
    }
}

#pragma mark - HTTPAPIDelegate
- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api
{
    if ([api isEqual:_detailAPI])
    {
        /*
        self.order = [HMOrder mj_objectWithKeyValues:data];
        
        [self setNavigationItemBackBBIAndTitle:[NSString stringWithFormat:@"%@房-会员支付",self.order.room.roomNumber]];
        
        _priceLab.text = [NSString stringWithFormat:@"¥%.02f",fabs(self.order.balance)];
        if (self.order.balance < 0)
        {
            _tiLab.text = @"应收款";
            _tiLab.textColor = kYellowColor;
            _priceLab.textColor = kYellowColor;
        }
        else
        {
            _tiLab.text = @"订单余额";
            _tiLab.textColor = kGreenColor;
            _priceLab.textColor = kGreenColor;
        }
        
        self.memberAPI.guid = _orderGuid;
        [self.memberAPI sendRequestToServerWithActivityViewAndMask:POST];
         */
    }
    else if ([api isEqual:_payInfoAPI])
    {
        [self.payInfoData removeAllObjects];
        [self.payInfoData addObjectsFromArray:(NSArray *)[HMPayInfoModel mj_objectArrayWithKeyValuesArray:data[@"info"]]];
        
        NSString *str = @"";
        if (self.payInfoData.count)
        {
            HMPayInfoModel *model = self.payInfoData.firstObject;
            str = [NSString stringWithFormat:@"%@房-",model.fh];
        }
        [self setNavigationItemBackBBIAndTitle:[NSString stringWithFormat:@"%@会员支付",str]];
        
        _tiLab.text = @"应付款";
        _tiLab.textColor = kYellowColor;
        _priceLab.textColor = kYellowColor;
        
        CGFloat pay = 0;
        for (HMPayInfoModel *model in self.payInfoData)
        {
            if (model.yk.floatValue < 0)
            {
                pay += fabs(model.yk.floatValue);
            }
        }
        
        _shouldPay = pay;
        _priceLab.text = [NSString stringWithFormat:@"¥%.02f",pay];
        
        self.memberAPI.guid = _orderGuid;
        [self.memberAPI sendRequestToServerWithActivityViewAndMask:POST];
    }
    else if ([api isEqual:_memberAPI])
    {
        [self.memberData removeAllObjects];
        [self.memberData addObjectsFromArray:[HMMemberPayModel mj_objectArrayWithKeyValuesArray:data]];
        [self.table reloadData];
    }
    else if ([api isEqual:_savePayInfoAPI])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:HMPaySuccessNotification object:nil];
        
        if (_successVC)
        {
            _successVC.shouldMoney = _shouldPay;
            _successVC.paiedMoney = _price;
            _successVC.payWay = _payWayModel.sklxMc;
            _successVC.topBtnTitle = @"查看订单";
            _successVC.memberPayType = _memberType;
            [self.navigationController pushViewController:_successVC animated:YES];
        }
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api
{

}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.memberData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScaleNum(70);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMMemberPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    [cell refreshCell:self.memberData[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMMemberPayModel *member = self.memberData[indexPath.row];
    HMMemberPayAlert *alert = [[HMMemberPayAlert alloc] initWithFrame:LPRectMake(30, 120, 315, 225)];
    [alert refreshView:member];
    [alert showOnView:self.view];
    
    WEAKSELF
    alert.SuccessBlock = ^(double price,NSString *memberPayType)
    {
        weakSelf.price = price;
        weakSelf.memberType = memberPayType;
        
        /*
        if ([memberPayType isEqualToString:@"余额"])
        {
            weakSelf.payType = 6;
        }
         
        else
        {
            weakSelf.payType = 7;
        }
         */
        
        NSMutableArray *payInfoArr = [NSMutableArray new];

        HMSavePayInfoModel *saveModel = [HMSavePayInfoModel new];
        saveModel.payType = @(weakSelf.payType).stringValue;
        saveModel.ddGuid     = weakSelf.orderGuid;
        saveModel.userId     = kUserId;
        saveModel.userName   = kUserName;
        saveModel.loginName  = kUserName;
        saveModel.cs_id      = kCsId;
        saveModel.memberId   = member.memberId;
        
        NSMutableArray *paiedList = [NSMutableArray new];
        HMPaiedDetailModel *detailModel = [HMPaiedDetailModel new];
        detailModel.skje    = price;
        if ([memberPayType isEqualToString:@"余额"])
        {
            detailModel.skfs = PayWayGuidMemberAccount;
        }
        else
        {
            detailModel.skfs = PayWayGuidMemberIntegral;
        }
        
        detailModel.sklxmc  = weakSelf.payWayModel.sklxMc;
        detailModel.yfk     = weakSelf.shouldPay;
        [paiedList addObject:detailModel];
        
        saveModel.skList     = paiedList;
        
        [payInfoArr addObject:saveModel];
        
        if (_noCallSavePayInfoApi == YES) { //不调用 保存支付订单Api
            if (_memberPayBlock) {
                _memberPayBlock(payInfoArr);
            }
            return;
        }
        
        weakSelf.savePayInfoAPI.paydata = payInfoArr;
        [weakSelf.savePayInfoAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:weakSelf.view];
    };
}

#pragma mark - LazyInit
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

- (HMSearchMemberPayAPI *)memberAPI
{
    if (!_memberAPI)
    {
        _memberAPI = [HMSearchMemberPayAPI apiWithDelegate:self];
    }
    return _memberAPI;
}

- (NSMutableArray *)memberData
{
    if (!_memberData)
    {
        _memberData = [NSMutableArray new];
    }
    return _memberData;
}

- (HMOrderDetailAPI *)detailAPI
{
    if (!_detailAPI)
    {
        _detailAPI = [HMOrderDetailAPI apiWithDelegate:self];
    }
    return _detailAPI;
}

- (HMSavePayInfoAPI *)savePayInfoAPI
{
    if (!_savePayInfoAPI)
    {
        _savePayInfoAPI = [HMSavePayInfoAPI apiWithDelegate:self];
    }
    return _savePayInfoAPI;
}

@end
