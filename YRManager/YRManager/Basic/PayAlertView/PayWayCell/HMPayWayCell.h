//
//  HMPayWayCell.h
//  HotelManager
//
//  Created by YR on 2017/3/29.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMPayWayModel.h"
#import "HMTallyBookFilter.h"
#import "HMTallyBookPayway.h"


@interface HMPayWayCell : UITableViewCell

@property (nonatomic, strong) UIButton *wayBtn;

- (void)refreshCell:(NSString *)name;
- (void)setBtnSelected:(BOOL)state;
- (void)setBtnEnble:(BOOL)state;

- (void)refreshCellWithModel:(HMPayWayModel *)model;

- (void)refreshCellWithTallyBookPayway:(HMTallyBookPayway *)model;

- (void)refreshCellWithFilter:(HMTallyBookFilter *)filter;

@end
