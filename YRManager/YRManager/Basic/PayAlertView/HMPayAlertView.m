//
//  HMPayAlertView.m
//  HotelManager
//
//  Created by YR on 2017/3/29.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPayAlertView.h"
#import "HMPayWayListAPI.h"
#import "NSObject+JSONToObject.h"
#import "HMPayWayModel.h"
#import "HMPayWayCell.h"
#import "HMConfirmPayVC.h"
#import "HMMemberPayVC.h"

@interface HMPayAlertView ()<HTTPAPIDelegate,UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>

@property (nonatomic, strong) UIView    *bgView;

@property (nonatomic, strong) UIButton  *sureBtn;
@property (nonatomic, strong) UIButton  *cancelBtn;

@property (nonatomic, strong) HMPayWayListAPI   *payWayAPI;     //!<支付方式列表
@property (nonatomic, strong) NSMutableArray    *payWayData;
@property (nonatomic, strong) NSMutableArray    *payInfoData;

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) HMPayWayCell      *oldCell;

@property (nonatomic, assign) NSInteger         selectIndex;
@property (nonatomic, strong) NSArray           *orderGuids;
@property (nonatomic, assign) PayType           payType;
@property (nonatomic, strong) HMPayWayModel     *payWayMode;//!<自定义支付模型

@end

@implementation HMPayAlertView

+ (instancetype)initWithGuids:(NSArray *)orderGuids payType:(PayType)type
{
    HMPayAlertView *payAlert = [HMPayAlertView new];
    payAlert.backgroundColor = kColor(200, 200, 200, 1);
    payAlert.b_frame(LPRectMake(0, 0, kBaseScreenWidth, kBaseScreenHeight));
    [payAlert initView];
    
    [payAlert getData:orderGuids payType:type];
    
    return payAlert;
}

+ (instancetype)initWithGuids:(NSArray *)orderGuids payType:(PayType)type AndPayWayModel:(HMPayWayModel *)payWayModel
{
    HMPayAlertView *payAlert = [HMPayAlertView new];
    payAlert.payWayMode = payWayModel;
    
    if ([payWayModel.sklxGuid isEqualToString:@"NOSHOW"])
    {
        payAlert.selectIndex = 1;
    }
    
    payAlert.backgroundColor = kColor(200, 200, 200, 1);
    payAlert.b_frame(LPRectMake(0, 0, kBaseScreenWidth, kBaseScreenHeight));
    [payAlert initView];
    
    [payAlert getData:orderGuids payType:type];
    
    return payAlert;
}

- (void)initView
{
    _sureBtn = [UIButton new];
    _sureBtn.b_title(@"确 定",UIControlStateNormal)
    .b_font(kFont(18)).b_titleColor(kGreenColor,UIControlStateNormal)
    .b_bgColor([UIColor whiteColor]).b_moveToView(self);
    [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    
    _cancelBtn = [UIButton new];
    _cancelBtn.b_title(@"取 消",UIControlStateNormal)
    .b_titleColor(kColor(130, 130, 130, 1),UIControlStateNormal).b_font(kFont(18))
    .b_bgColor([UIColor whiteColor]).b_moveToView(self);
    [_cancelBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getData:(NSArray *)orderGuids payType:(PayType)type
{
    _payType = type;
    _orderGuids = orderGuids;
    self.payWayAPI.payType = @(type).stringValue;
    if (_payType == PayTypeNoOrderPayInfo)
    {
        //外来客的支付方式与会员充值相同z
        self.payWayAPI.payType = @"memberRecharge";
    }
    [self.payWayAPI sendRequestToServerWithType:POST];
}

#pragma mark -- 确认方式
- (void)sureAction
{
    if (self.payInfoModel != nil)
    {
        if (self.payWayMode != nil && self.selectIndex == 0)
        {
            !_selectBlock ?: _selectBlock(0);
        }
        else
        {
            HMConfirmPayVC *vc = [[HMConfirmPayVC alloc] initWithOrders:_orderGuids payType:_payType payModel:self.payWayData[self.selectIndex] And:self.payInfoModel];
            vc.banPrice = self.isBanPrice;
            vc.successVC = _successVC;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        if ([[self viewController] isKindOfClass:[HMConfirmPayVC class]])
        {
            HMConfirmPayVC *vc = (HMConfirmPayVC *)[self viewController];
            vc.isTurnClean = self.isTurnClean;
            [vc refreshPayWayOrders:_orderGuids payType:_payType payModel:self.payWayData[self.selectIndex]];
        }
        else
        {
            if ([[self.payWayData[self.selectIndex] sklxMc] isEqualToString:PayViewPaywayMember])
            {//会员支付
                HMMemberPayVC *vc = [[HMMemberPayVC alloc] initMemberGuids:_orderGuids.firstObject withPayType:_payType payModel:self.payWayData[self.selectIndex]];
                vc.successVC = _successVC;
                [[self viewController].navigationController pushViewController:vc animated:YES];
            }
            else
            {
                HMConfirmPayVC *vc = [[HMConfirmPayVC alloc] initWithOrders:_orderGuids payType:_payType payModel:self.payWayData[self.selectIndex]];
                vc.successVC = _successVC;
                vc.isTurnClean = self.isTurnClean;
                [[self viewController].navigationController pushViewController:vc animated:YES];
            }
        }
    }
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark -- HTTPAPIDelegate
- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api
{
    if ([api isEqual:self.payWayAPI])
    {
        [self.payWayData removeAllObjects];
        if (self.payWayMode != nil)
        {
            [self.payWayData addObject:self.payWayMode];
        }
        [self.payWayData addObjectsFromArray:(NSArray *)[HMPayWayModel objectFromDataObject:data]];
        
        UIView *line = [UIView new];
        line.b_bgColor(kGreenColor).b_frame(LPRectMake(0, 0, kBaseScreenWidth, 1))
        .b_moveToView(_sureBtn);
        
        CGFloat height = 158+50*self.payWayData.count;
        if (height > 600)
        {
            self.tableView.scrollEnabled = YES;
            height = 558;
        }
        else
        {
            self.tableView.scrollEnabled = NO;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                kMasLeft(0);kMasBottom(0);kMasRight(0);kMasHeight(height);
            }];
            [_bgView layoutIfNeeded];
        }];
        
        _sureBtn.frame = LPRectMake(0, height-108, kBaseScreenWidth, 50);
        _cancelBtn.frame = LPRectMake(0, height-50, kBaseScreenWidth, 50);
        self.tableView.frame = LPRectMake(0, 0, kBaseScreenWidth, height - 158 + 50);
        [self addSubview:self.tableView];
        
        [self.tableView reloadData];
        
        if (self.payWayData.count)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            //[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            _oldCell = [self.tableView cellForRowAtIndexPath:indexPath];
        }
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api
{
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScaleNum(50);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView = [UIView new];
    titleView.b_bgColor([UIColor whiteColor])
    .b_frame(LPRectMake(0, 0, kBaseScreenWidth, 50));
    
    UILabel *titleLab = [UILabel new];
    titleLab.b_font(kFont(16)).b_text(@"选择支付方式")
    .b_textColor(kColor(130, 130, 130, 1)).b_textAlignment(NSTextAlignmentCenter)
    .b_frame(LPRectMake(0, 0, kBaseScreenWidth, 50)).b_moveToView(titleView);
    
    UIView *line = [UIView new];
    line.b_bgColor(kColor(230, 230, 230, 1))
    .b_frame(LPRectMake(25, 49, 325, 1)).b_moveToView(titleView);
    
    return titleView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payWayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScaleNum(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HMPayWayModel *model = self.payWayData[indexPath.row];
    [cell refreshCell:model.sklxMc];
    [cell setBtnSelected:indexPath.row == self.selectIndex ? YES : NO];
    
    if ([model.sklxGuid isEqualToString:@"NOSHOW"])
    {
        cell.wayBtn.selected = NO;
        [cell setBtnEnble:NO];
    }
    else
    {
        [cell setBtnEnble:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 && [self.payWayMode.sklxGuid isEqualToString:@"NOSHOW"])
    {
        return;
    }
    else
    {
        HMPayWayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row != self.selectIndex)
        {
            [_oldCell setBtnSelected:NO];
            [cell setBtnSelected:YES];
            _oldCell = cell;
            
            self.selectIndex = indexPath.row;
        }
    }
}

- (void)closeAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ConfirmOrderTurnOnTimerNotification object:nil];
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)showOnView:(UIView *)view
{
    _bgView = [UIView new];
    _bgView.b_bgColor([[UIColor blackColor] colorWithAlphaComponent:0.4])
    .b_moveToView(view);
    [_bgView addSubview:self];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasRight(0);kMasTop(0);kMasBottom(0);
    }];
    
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScaleNum(158));
}

#pragma mark -- LazyInit
- (HMPayWayListAPI *)payWayAPI
{
    if (!_payWayAPI)
    {
        _payWayAPI = [HMPayWayListAPI apiWithDelegate:self];
    }
    return _payWayAPI;
}

- (NSMutableArray *)payWayData
{
    if (!_payWayData)
    {
        _payWayData = [NSMutableArray new];
    }
    return _payWayData;
}

- (NSMutableArray *)payInfoData
{
    if (!_payInfoData)
    {
        _payInfoData = [NSMutableArray new];
    }
    return _payInfoData;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [UITableView new];
        _tableView.scrollEnabled = NO;
        _tableView.b_delegate(self).b_dataSource(self)
        .b_separatorStyle(UITableViewCellSeparatorStyleNone);
        
        [_tableView registerClass:[HMPayWayCell class] forCellReuseIdentifier:@"listCell"];
    }
    return _tableView;
}

@end
