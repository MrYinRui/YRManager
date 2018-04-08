//
//  HMPayFootView.h
//  HotelManager
//
//  Created by YR on 2017/3/31.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMAlertBasicView.h"

@interface HMPayFootView : HMAlertBasicView

@property (nonatomic, strong) NSString          *remark;

@property (nonatomic, strong) void (^AttachmentBlock)(NSArray *imgDataArr);
@property (nonatomic, strong) void (^RemarkBlock)(NSString *remark);

- (void)insertImg:(NSArray *)imgArr;

@property (nonatomic, assign) NSInteger limit;

@end
