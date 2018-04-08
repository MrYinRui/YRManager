//
//  HMActionSheetNormalCell.h
//  HotelManager
//
//  Created by r on 17/3/13.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HMActionSheetType) {
    HMActionSheetType_Tick,
    HMActionSheetType_RoundTick_Confirm,
    HMActionSheetType_GreenTitle
};

@interface HMActionSheetNormalCell : UITableViewCell

- (void)refreshCellWithContent:(id)content;// 传NSString 或NSAttributedString

- (void)selected;// 选中

// 注册cell
+ (void)registerCell:(HMActionSheetType)type forTableView:(UITableView *)tableView;

// 返回cell
+ (HMActionSheetNormalCell *)reusableCell:(HMActionSheetType)type forTableView:(UITableView *)tableView;

@end
