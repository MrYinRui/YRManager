//
//  HMWriteRemarkView.h
//  HotelManager-Pad
//
//  Created by Seven on 2016/12/22.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import "HMBasicDialogView.h"

@interface HMWriteRemarkView : HMBasicDialogView

+ (instancetype)remarkView;

@property (nonatomic, copy) void(^confirmMarkBlock)(NSString * mark);

@property (nonatomic, copy) NSString *comments;//!<<#注释#>

@property (nonatomic, assign) BOOL noEditing;//!<能否编辑

@end
