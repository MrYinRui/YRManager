//
//  HMActionDate.m
//  HotelManager
//
//  Created by kqz on 2017/8/7.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMActionDate.h"
#import "HMSetCleanTimeAPI.h"
#import "NSDate+HMProjectKit.h"
#import "HMAlertView.h"

@interface HMActionDate()<HTTPAPIDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *cancelBtn;//!<取消按钮
@property (nonatomic, strong) UIButton *confirmBtn;//!<确定按钮
@property (nonatomic, strong) UIView *greenLine;//!<绿色分割线

@property (nonatomic, strong) UIView *grayLine;//!<灰色分割线
@property (nonatomic, strong) UIDatePicker *datePicker;//!<时间picker
@property (nonatomic, strong) NSString *address;//!<房间地址
@property (nonatomic, strong) UILabel *addressLab;//!<房间地址lab
@property (nonatomic, strong) NSString *time;//!<选择的时间

@property (nonatomic, strong) NSDateFormatter *dateFormatter;//!<时间格式化
@property (nonatomic, strong) HMSetCleanTimeAPI *setCleanTimeAPI;//!<设置完成清洁时间
@property (nonatomic, strong) NSString *guid;//!<清洁guid

@end

@implementation HMActionDate

+(instancetype)initWithRoomAddress:(NSString *)address AndGuid:(NSString *)guid
{
    HMActionDate *view = [[HMActionDate alloc] initWithFrame:LPRectMake(0, 0, kBaseScreenWidth, kBaseScreenHeight)];
    view.address = address;
    view.guid = guid;
    [view initUI];
    return view;
}

#pragma mark - HTTPAPIDelegate
- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api
{
    if (self.setCleanTimeAPI == api)
    {
        !_selectTimeBlock ?: _selectTimeBlock(_time);
        [self cancelAction];
    }
}

- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api
{
    
}

#pragma mark - Event

- (void)cancelAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = kScaleNum(kBaseScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)confirmAction
{
    NSString *currentTime = [self.dateFormatter stringFromDate:[NSDate date]];
    
    NSArray *arr1 = [currentTime componentsSeparatedByString:@":"];
    NSArray *arr2 = [_time componentsSeparatedByString:@":"];
    
    if (arr1.count > 1 && arr2.count > 1)
    {
        if (([arr1[0] integerValue] * 60 + [arr1[1] integerValue] - [arr2[0] integerValue] * 60 - [arr2[1] integerValue]) > 0)
        {
            HMAlertView *alertView = [HMAlertView alertViewWithIconType:IconWarn msg:@"设置的时间必须大于当前时间" knowBtnBlock:^(UIButton *knowBtn) {
            }];
            [alertView showWithAnimation];
            return ;
        }
    }
    
    self.setCleanTimeAPI.guid = _guid;
    self.setCleanTimeAPI.time = _time;
    self.setCleanTimeAPI.orderGuid = _orderGuid;
    [self.setCleanTimeAPI sendRequestToServerWithType:POST showActivityIndicatorOnView:self];
}

- (void)datePickerValueChanged:(UIDatePicker *) sender
{
    _time = [self.dateFormatter stringFromDate:sender.date];
}

#pragma mark - other
- (void)clearSeparatorWithView:(UIDatePicker * )datePicker
{
    for (UIView *view in datePicker.subviews) {
        
        if ([view isKindOfClass:[UIView class]]) {
            
            for (UIView *subView in view.subviews) {
                
                if (subView.frame.size.height < 1) {
                    
                    subView.hidden = YES;//隐藏分割线
                }
            }
        }
    }
}

#pragma mark - initUI
-(void)initUI
{
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.grayLine];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.greenLine];
    
    [self.contentView addSubview:self.datePicker];
    [self clearSeparatorWithView:self.datePicker];
    [self initDatePicker];
    
    [self.contentView addSubview:self.addressLab];
    self.addressLab.text = _address;
    
    _time = [self.dateFormatter stringFromDate:[NSDate newDate]];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = kScaleNum(kBaseScreenHeight - 350);
    }];
}

-(void)initDatePicker
{
    UILabel *timeLab =
    ({
        timeLab = [[UILabel alloc] initWithFrame:LPRectMake(20, 124, 100, 31)];
        timeLab.textColor = kGlobalTextColorGray;
        timeLab.text = @"完成时间";
        timeLab.font = kFont(15);
        timeLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timeLab];
        timeLab;
    });
    
    UIView *pickerline =
    ({
        pickerline = [[UIView alloc] initWithFrame:LPRectMake(20, 124, kBaseScreenWidth - 40, 1)];
        pickerline.backgroundColor = kColor(237, 238, 240, 1);
        [self.contentView addSubview:pickerline];
        pickerline;
    });
    
    UIView *pickerline2 =
    ({
        pickerline2 = [[UIView alloc] initWithFrame:LPRectMake(20, 155, kBaseScreenWidth - 40, 1)];
        pickerline2.backgroundColor = kColor(237, 238, 240, 1);
        [self.contentView addSubview:pickerline2];
        pickerline2;
    });
    
    UILabel *hourLab =
    ({
        hourLab = [[UILabel alloc] initWithFrame:LPRectMake(152, 125, 50, 30)];
        hourLab.backgroundColor = [UIColor whiteColor];
        hourLab.textColor = kGlobalTextColorGray;
        hourLab.text = @"点";
        hourLab.font = kFont(15);
        hourLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:hourLab];
        hourLab;
    });
    
    UILabel *minuteLab =
    ({
        minuteLab = [[UILabel alloc] initWithFrame:LPRectMake(248, 125, 50, 30)];
        minuteLab.backgroundColor = [UIColor whiteColor];
        minuteLab.textColor = kGlobalTextColorGray;
        minuteLab.text = @"分";
        minuteLab.font = kFont(15);
        minuteLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:minuteLab];
        minuteLab;
    });
}

#pragma mark - Getters
- (UIView *)bgView{
    if (!_bgView){
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kColor(0, 0, 0, 0.5);
        _bgView.frame = LPRectMake(0, 0, kBaseScreenWidth, kBaseScreenHeight);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView){
        _contentView = [[UIView alloc] init];
        _contentView.frame = LPRectMake(0, kBaseScreenHeight, kBaseScreenWidth, 350);
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:kGlobalTextColorGray forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFont(18);
        _cancelBtn.frame = LPRectMake(0, 305, kBaseScreenWidth, 45);
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
        _confirmBtn.frame = LPRectMake(0, 250, kBaseScreenWidth, 45);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = [UIColor whiteColor];
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];
        _datePicker.frame = LPRectMake(105, 65, 220, 150);
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听器
        [_datePicker setDate:[NSDate newDate] animated:YES];
    }
    return _datePicker;
}

- (UIView *)grayLine{
    if (!_grayLine){
        _grayLine = [[UIView alloc] init];
        _grayLine.frame = LPRectMake(0, 295, kBaseScreenWidth, 10);
        _grayLine.backgroundColor = kColor(199, 200, 204, 1);
    }
    return _grayLine;
}

- (UIView *)greenLine{
    if (!_greenLine){
        _greenLine = [[UIView alloc] init];
        _greenLine.frame = LPRectMake(0, 249, kBaseScreenWidth, 1);
        _greenLine.backgroundColor = kGreenColor;
    }
    return _greenLine;
}

-(UILabel *)addressLab
{
    if (!_addressLab)
    {
        _addressLab = [[UILabel alloc] initWithFrame:LPRectMake(20, 0, kBaseScreenWidth - 20, 45)];
        _addressLab.textColor = kGlobalTextColorGray;
        _addressLab.font = kFont(18);
    }
    return _addressLab;
}

-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"HH:mm";
    }
    return _dateFormatter;
}

-(HMSetCleanTimeAPI *)setCleanTimeAPI
{
    if (!_setCleanTimeAPI)
    {
        _setCleanTimeAPI = [HMSetCleanTimeAPI apiWithDelegate:self];
    }
    return _setCleanTimeAPI;
}

@end
