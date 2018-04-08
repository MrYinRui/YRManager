//
//  RSOrderRoomPriceCalendarCell.m
//  HotelManager-Pad
//
//  Created by Seven on 2016/10/25.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import "RSOrderRoomPriceCalendarCell.h"

#define  kGreenBGColor   kColor(238, 255, 237, 1.0)
#define  kSelectedCellYellowColor  kColor(170, 130, 35, 1.0)

@implementation RSOrderRoomPriceCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CALayer *layer = [CALayer new];
        layer.frame = self.contentView.bounds;
        layer.borderColor = kSeparatorLineColor.CGColor;
        layer.borderWidth = 0.5;
        [self.contentView.layer addSublayer:layer];

        [self initLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
}

- (void)freshCellWithModel:(id)model month:(int)month
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd"];
    _dateLab.text = [formatter stringFromDate:model];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    if ([calendar isDateInToday:model])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _dateLab.textColor = [UIColor blackColor];
        
    }
    else if (month == [calendar component:NSCalendarUnitMonth fromDate:model])
    {
        self.contentView.backgroundColor = kColor(240, 240, 240, 1.f);
    }
    else
    {
        self.contentView.backgroundColor = kColor(252, 252, 252, 1.f);
    }
    _priceLab.text = [NSString stringWithFormat:@"%d", 30 + arc4random_uniform(1000) % 120];
}

- (void)initLabel
{
    _tipsLab = [UILabel new];
    _tipsLab.textColor = [UIColor whiteColor];
    _tipsLab.font = kFont(12);
    _tipsLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_tipsLab];
    
    _dateLab = [UILabel new];
    _dateLab.textColor = [UIColor blackColor];
    _dateLab.font = kFont(10);
    _dateLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_dateLab];
    
    _priceLab = [UILabel new];
    _priceLab.textColor = kGreenColor;
    _priceLab.font = kFont(12);
    _priceLab.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_priceLab];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.contentView.width / kScreenScale;
    CGFloat height = self.contentView.height / kScreenScale;
    _tipsLab.frame = LPRectMake(12.f, 8, 36, 24.f);
    _dateLab.frame = LPRectMake(30, 5, 15, 15);
    _priceLab.frame = LPRectMake(0, height - 20 , width, 20);
}

- (void)setShowStyle:(ShowStyle)style
{
    UIColor *color = kYellowColor;
    if (_isRoom)
    {
        color = kGreenColor;
    }
    switch (style)
    {
        case NO_SHOW_CAL:
            
            self.contentView.backgroundColor = [UIColor whiteColor];
            _dateLab.hidden = YES;
            _priceLab.hidden = YES;
            break;
        case GRAY:
            
            self.contentView.backgroundColor = [UIColor whiteColor];
            _dateLab.hidden = NO;
            _dateLab.textColor = [UIColor lightGrayColor];
            _priceLab.hidden = NO;
            _priceLab.textColor = [UIColor lightGrayColor];
            break;
        case ORDER_CAL:
            
            self.contentView.backgroundColor = [UIColor whiteColor];
            _dateLab.hidden = NO;
            _dateLab.textColor = [UIColor blackColor];
            _priceLab.hidden = NO;
            _priceLab.textColor = [UIColor lightGrayColor];
            break;
            
        case GREEN_DEEP:
            
            self.contentView.backgroundColor = kColor(152, 205, 149, 1);
            _dateLab.hidden = NO;
            _dateLab.textColor = [UIColor whiteColor];
            _priceLab.hidden = NO;
            _priceLab.textColor = [UIColor whiteColor];
            break;
            
        case GREEN_LIGHT:
            
            self.contentView.backgroundColor = kColor(238, 255, 237, 1);
            _dateLab.hidden = NO;
            _dateLab.textColor = [UIColor blackColor];
            _priceLab.hidden = NO;
            _priceLab.textColor = color;
            break;
            
        case YELLOW:
            
            self.contentView.backgroundColor = kSelectedCellYellowColor;
            _dateLab.hidden = NO;
            _dateLab.textColor = [UIColor whiteColor];
            _priceLab.hidden = NO;
            _priceLab.textColor = [UIColor whiteColor];
            break;
            
        case ADJUSTPRICE:
            
            self.contentView.backgroundColor = [UIColor whiteColor];
            _dateLab.hidden = NO;
            _dateLab.textColor = [UIColor blackColor];
            _priceLab.hidden = NO;
            _priceLab.textColor = color;
            break;
            
        case ADJUSTPRICE_GRAY:
            
            self.contentView.backgroundColor = kColor(242, 242, 242, 1);
            _dateLab.hidden = NO;
            _dateLab.textColor = [UIColor lightGrayColor];
            _priceLab.hidden = NO;
            _priceLab.textColor = [UIColor lightGrayColor];
            break;
            
        case ADJUSTPRICE_NO_SHOW:
            
            self.contentView.backgroundColor = [UIColor whiteColor];
            _dateLab.hidden = YES;
            _priceLab.hidden = YES;
            
            break;
            
        default:
            break;
    }
}
@end
