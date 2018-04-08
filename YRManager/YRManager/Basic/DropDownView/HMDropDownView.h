//
//  HMDropDownView.h
//  HotelManager
//
//  Created by kqz on 2018/1/12.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDropDownView : UIView

//imageNameArr 图片列表  TitleArr 标题  point 下拉框的起始位置(x,y)
-(instancetype)initWihtIconArr:(NSArray *)imageNameArr TitleArr:(NSArray *)titleArr AndPoint:(CGPoint)point;

//index 第一个下标是 0
@property (nonatomic, copy) void (^selectNumBlcok)(NSInteger index);

@end
