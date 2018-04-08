//
//  RSOrderRoomPriceCalendarCell.h
//  HotelManager-Pad
//
//  Created by Seven on 2016/10/25.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    NO_SHOW_CAL,        //!<不显示
    GRAY,           //!<灰色
    ORDER_CAL,          //!<已订
    GREEN_DEEP,     //!<深绿
    GREEN_LIGHT,    //!<浅绿
    YELLOW,         //!<黄色
    
    ADJUSTPRICE,            //!<调价cell
    ADJUSTPRICE_GRAY,       //!<
    ADJUSTPRICE_NO_SHOW     //!<调价不显示
    
} ShowStyle;

@interface RSOrderRoomPriceCalendarCell : UICollectionViewCell

@property (nonatomic, strong)   UILabel * tipsLab;//!< 入住 或 离店
@property (nonatomic, strong)   UILabel * priceLab;  //!<数量
@property (nonatomic, strong)   UILabel * dateLab;   //!<日期
@property (nonatomic, assign)   BOOL isRoom;   //!<yes 房间调价


- (void)freshCellWithModel:(id)model month:(int)month;

- (void)setShowStyle:(ShowStyle)style;

@end
