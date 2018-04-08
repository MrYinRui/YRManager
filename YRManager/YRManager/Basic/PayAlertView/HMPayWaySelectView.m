//
//  HMPayWaySelectView.m
//  HotelManager
//
//  Created by r on 17/9/18.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMPayWaySelectView.h"
#import "HMPayWaySelectViewCell.h"
#import "HMPayWayListAPI.h"
#import "HMPayWayModel.h"

static CGFloat kRowHeight = 50;
static CGFloat kGap = 8;

@interface HMPayWaySelectView ()<UITableViewDataSource, UITableViewDelegate, HTTPAPIDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *cancelBtn;//!<取消按钮
@property (nonatomic, strong) UIButton *confirmBtn;//!<确定按钮
@property (nonatomic, strong) UIView *greenLine;//!<绿色分割线
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UILabel *titleLab;//!<标题

@property (nonatomic, strong) HMPayWayListAPI *payWayListAPI;
@property (nonatomic, strong) NSArray<HMPayWayModel *> *payWayArr;
@property (nonatomic, strong) NSMutableArray *payWayNameArr;

@end

@implementation HMPayWaySelectView

+ (instancetype)payWaySelectView {
    
    HMPayWaySelectView *view = [[HMPayWaySelectView alloc] initWithFrame:kScreenBounds];
    view.selectRow = -1;
    [view initUI];
    return view;
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.payWayListAPI sendRequestToServerWithActivityViewAndMask:POST];
}

- (void)hide {
    [self cancelAction];
}

#pragma mark - HTTPAPIDelegate

- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api {
    if (api == self.payWayListAPI) {
        self.payWayArr = [HMPayWayModel mj_objectArrayWithKeyValuesArray:data];
        for (HMPayWayModel *model in self.payWayArr) {
            [self.payWayNameArr addObject:model.sklxMc];
        }
        [self showView];
        [self.tableView reloadData];
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api {
    if (api == self.payWayListAPI) {
        [self showView];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.payWayNameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMPayWaySelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMPayWaySelectViewCell" forIndexPath:indexPath];
    [cell refreshCellWithContent:self.payWayNameArr[indexPath.row]];
    if (indexPath.row == _selectRow) {
        [cell selected];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectRow = indexPath.row;
    [tableView reloadData];
}

#pragma mark - Event Response

- (void)cancelAction {
    
    CGFloat height = self.contentView.height;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(height));
    }];
    
    // 动画消失
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration: 0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)confirmAction {
    if (self.confirmBlock && self.selectRow != -1) {
        HMPayWayModel *payWay = self.payWayArr[self.selectRow];
        self.confirmBlock(payWay);
    }
    [self cancelAction];
}

#pragma mark - Private Methods

- (void)showView {
    
    [self adjustUI];
    
    // 先把动画前约束布好
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    // 动画出现
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(0));
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)adjustUI {
    
    CGFloat confirmBtnHeight = kRowHeight;
    CGFloat cancelBtnHeight = kRowHeight;
    CGFloat titleLabHeight = kRowHeight;
    
    CGFloat tableViewHeight = kRowHeight * self.payWayNameArr.count;
    tableViewHeight = tableViewHeight > kRowHeight * 8 ? kRowHeight * 8 : tableViewHeight;
    CGFloat contentViewHeight = tableViewHeight + confirmBtnHeight + cancelBtnHeight + titleLabHeight + kGap;
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(kScaleNum(contentViewHeight)));// 动画准备
        make.height.mas_equalTo(kScaleNum(contentViewHeight));
    }];
    
    if (self.payWayNameArr.count == 0) {
        self.topLine.hidden = YES;
    } else {
        self.topLine.hidden = NO;
    }
}

#pragma mark - 搭建UI

- (void)initUI {
    
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.greenLine];
    [self.contentView addSubview:self.topLine];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.mas_equalTo(kScaleNum(kRowHeight + kGap));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.mas_equalTo(@(kScaleNum(kRowHeight)));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.cancelBtn.mas_top).with.offset(kScaleNum(-kGap));
        make.height.mas_equalTo(@(kScaleNum(kRowHeight)));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.confirmBtn.mas_top);
        make.top.equalTo(self.titleLab.mas_bottom);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.mas_equalTo(kScaleNum(kRowHeight));
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScaleNum(25)));
        make.right.bottom.equalTo(self.titleLab);
        make.height.mas_equalTo(1);
    }];
    
    [self.greenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.tableView);
        make.height.mas_equalTo(kScaleNum(1));
    }];
}

#pragma mark - Getters

- (UIView *)bgView{
    if (!_bgView){
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kColor(0, 0, 0, 0.5);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView){
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = kColor(222, 223, 227, 1.0);
    }
    return _contentView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(222, 223, 227, 1.0);
        _tableView.rowHeight = kScaleNum(kRowHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        
        [self.tableView registerClass:[HMPayWaySelectViewCell class] forCellReuseIdentifier:@"HMPayWaySelectViewCell"];
    }
    return _tableView;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = kLineColor;
    }
    return _topLine;
}

- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = kGlobalTextColorGray;
        _titleLab.font = kFont(13);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"选择支付方式";
        _titleLab.backgroundColor = [UIColor whiteColor];
    }
    return _titleLab;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:kGlobalTextColorGray forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFont(18);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn){
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitleColor:kGlobalTextColorGreen forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = kFont(18);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = [UIColor whiteColor];
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIView *)greenLine{
    if (!_greenLine){
        _greenLine = [[UIView alloc] init];
        _greenLine.backgroundColor = kGreenColor;
    }
    return _greenLine;
}

- (NSMutableArray *)payWayNameArr {
    if (!_payWayNameArr) {
        _payWayNameArr = [NSMutableArray array];
    }
    return _payWayNameArr;
}

- (HMPayWayListAPI *)payWayListAPI {
    if (!_payWayListAPI) {
        _payWayListAPI = [HMPayWayListAPI apiWithDelegate:self];
    }
    return _payWayListAPI;
}
@end
