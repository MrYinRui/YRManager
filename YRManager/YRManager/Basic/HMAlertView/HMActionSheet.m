//
//  HMActionSheet.m
//  HotelManager
//
//  Created by r on 17/3/13.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMActionSheet.h"
#import "HMActionSheetNormalCell.h"
#import <objc/runtime.h>

#define kRowHeight 50
#define kGap 8

@interface HMActionSheet ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLab;//!<标题
@property (nonatomic, strong) UIView *titleLine;//!<标题下面的分割线
@property (nonatomic, strong) UIButton *cancelBtn;//!<取消按钮
@property (nonatomic, strong) UIButton *confirmBtn;//!<确定按钮
@property (nonatomic, strong) UIView *greenLine;//!<绿色分割线
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;//!<数据源
@property (nonatomic, assign) HMActionSheetType actionSheetType;//!<类型
@property (nonatomic, copy) NSString *title;

@property (nonatomic, readwrite, strong) NSMutableArray <NSNumber *>*selectionRows;

@property (nonatomic, strong) NSArray *editNames;
@property (nonatomic, strong) NSArray *editBlocks;

@end

@implementation HMActionSheet

+ (instancetype)actionSheetType:(HMActionSheetType)type dataSource:(NSArray *)dataSource {
    
    HMActionSheet *actionSheet = [[HMActionSheet alloc] initWithFrame:kScreenBounds];
    actionSheet.dataArray = dataSource;
    actionSheet.actionSheetType = type;
    
    [actionSheet initData];
    [actionSheet initUI];
    return actionSheet;
}

+ (instancetype)actionSheetType:(HMActionSheetType)type title:(NSString *)title dataSource:(NSArray *)dataSource {
    HMActionSheet *actionSheet = [[HMActionSheet alloc] initWithFrame:kScreenBounds];
    actionSheet.dataArray = dataSource;
    actionSheet.actionSheetType = type;
    actionSheet.title = title;
    
    [actionSheet initData];
    [actionSheet initUI];
    return actionSheet;
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
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

- (void)hide {
    [self cancelAction];
}

- (void)initData {
    _selectRow = -1;
}

- (void)editCellWithEditNames:(NSArray *)editNames editBlocks:(NSArray *)editBlocks {
    self.editNames = editNames;
    self.editBlocks = editBlocks;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMActionSheetNormalCell *cell = [HMActionSheetNormalCell reusableCell:self.actionSheetType forTableView:tableView];
    [cell refreshCellWithContent:self.dataArray[indexPath.row]];
    
    if (_isMutiSelection) {
        [_selectionRows enumerateObjectsUsingBlock:^(NSNumber * _Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
            if (number.integerValue == indexPath.row) {
                [cell selected];
            }
        }];
        
    }else {
        
        if (indexPath.row == _selectRow) {
            [cell selected];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *content = self.dataArray[indexPath.row];
    if ([content isKindOfClass:[NSString class]] && [content rangeOfString:@"（0）" options:NSBackwardsSearch].length > 0)
    {
        return;
    }

    if (_isMutiSelection) {
        if ([_selectionRows containsObject:@(indexPath.row)]) {
            [_selectionRows removeObject:@(indexPath.row)];
        }else {
            [_selectionRows addObject:@(indexPath.row)];
        }
    }else {
        _selectRow = indexPath.row;
    }
    
    [tableView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:didSelectRow:)]) {
        [self.delegate actionSheet:self didSelectRow:indexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.editNames || self.editNames.count == 0) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.editNames || self.editNames.count == 0) {
        return nil;
    }
    NSMutableArray *actions = [NSMutableArray array];
    for (NSInteger i = 0; i < self.editNames.count; i++) {
        NSString *title = self.editNames[i];
        editBlock block = self.editBlocks[i];
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            block(indexPath.row);
        }];
        action.backgroundColor = kBackgroundDeepGray;
        [actions addObject:action];
    }
    return actions;
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
    if (self.selectRow == -1)
    {
        CGPoint center = CGPointMake(kScreenWidth / 2.f, kScreenHeight / 2.f);
        [Prompt popPromptViewWithMsg:@"请至少选择一个选项" duration:3.f center:center];
    }
    else
    {
        !self.confirmBlock ?: self.confirmBlock(self.selectRow);
    }
}

#pragma mark - Private Methods

- (void)adjustUI {
    
    CGFloat confirmBtnHeight = kRowHeight;
    CGFloat cancelBtnHeight = kRowHeight;
    if (self.actionSheetType == HMActionSheetType_Tick || self.actionSheetType == HMActionSheetType_GreenTitle) {
        
        [self.confirmBtn removeFromSuperview];
        [self.greenLine removeFromSuperview];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cancelBtn.mas_top).with.offset(kScaleNum(-kGap));
        }];
        
        confirmBtnHeight = 0;
    }
    
    CGFloat titleLabelHeight = kRowHeight;
    if (!self.title) {
        [self.titleLab removeFromSuperview];
        [self.titleLine removeFromSuperview];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
        }];
        
        titleLabelHeight = 0;
    } else {
        // 根据type调整titleLine左边的边距，谁用谁来写
    }
    
    CGFloat tableViewHeight = kRowHeight * self.dataArray.count;
    tableViewHeight = tableViewHeight > kRowHeight * 10 ? kRowHeight * 10 : tableViewHeight;
    CGFloat contentViewHeight = tableViewHeight + confirmBtnHeight + cancelBtnHeight + titleLabelHeight + kGap + SafeFooterHeight;
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(kScaleNum(contentViewHeight)));// 动画准备
        make.height.mas_equalTo(kScaleNum(contentViewHeight));
    }];
    
}

#pragma mark - 搭建UI

- (void)initUI {
    
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.mas_equalTo(kScaleNum(kRowHeight + kGap) + SafeFooterHeight);
    }];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.titleLine];
    [self.contentView addSubview:self.greenLine];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(@(kScaleNum(kRowHeight)));
        make.bottom.mas_equalTo(-SafeFooterHeight);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.cancelBtn.mas_top).with.offset(kScaleNum(-kGap));
        make.height.mas_equalTo(@(kScaleNum(kRowHeight)));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kScaleNum(kRowHeight)));
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.confirmBtn.mas_top);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.mas_equalTo(kScaleNum(kRowHeight));
    }];
    
    [self.titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScaleNum(25)));
        make.right.equalTo(@0);
        make.bottom.equalTo(self.titleLab);
        make.height.mas_equalTo(1.0);
    }];
    
    [self.greenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.tableView);
        make.height.mas_equalTo(kScaleNum(1));
    }];
    
    if (KIsiPhoneX) {
        UIView *fillView = [UIView new];
        fillView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:fillView];
        [fillView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(34);
        }];
    }
    
    // 根据 actionSheetType 调整UI
    [self adjustUI];
}

#pragma mark - Setters

- (void)setIsMutiSelection:(BOOL)isMutiSelection {
    _isMutiSelection = isMutiSelection;
    if (_isMutiSelection) {
        if(!_isSelectAll) {_selectionRows = @[].mutableCopy;}
    }
}

- (void)setIsSelectAll:(BOOL)isSelectAll {
    _isSelectAll  = isSelectAll;
    if(!_isSelectAll) {_selectionRows = @[].mutableCopy;}
    else {
        for (int i = 0; i < _dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLab.text = title;
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

- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] init];
        _titleLab.backgroundColor = [UIColor whiteColor];
        _titleLab.textColor = kGlobalTextColorGray;
        _titleLab.font = kFont(12);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIView *)titleLine {
    if (!_titleLine) {
        _titleLine = [[UIView alloc] init];
        _titleLine.backgroundColor = kLineColor;
    }
    return _titleLine;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(222, 223, 227, 1.0);
        _tableView.rowHeight = ceilf(kScaleNum(kRowHeight));
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        
        // 注册cell
        [HMActionSheetNormalCell registerCell:self.actionSheetType forTableView:self.tableView];
    }
    return _tableView;
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

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end


