//
//  HMActionSheetNormalCell.m
//  HotelManager
//
//  Created by r on 17/3/13.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMActionSheetNormalCell.h"
#import "HMActionSheetTickCell.h"
#import "HMActionSheetRoundTickCell.h"
#import "HMActionSheetTitleCell.h"

@interface HMActionSheetNormalCell ()

@end

@implementation HMActionSheetNormalCell

- (void)refreshCellWithContent:(NSString *)content {
    
}

- (void)selected {
    
}

// 注册cell
+ (void)registerCell:(HMActionSheetType)type forTableView:(UITableView *)tableView {
    
    switch (type) {
        case HMActionSheetType_Tick:
            [tableView registerClass:[HMActionSheetTickCell class] forCellReuseIdentifier:@"HMActionSheetTickCell"];
            break;
        case HMActionSheetType_RoundTick_Confirm:
            [tableView registerClass:[HMActionSheetRoundTickCell class] forCellReuseIdentifier:@"HMActionSheetRoundTickCell"];
            break;
        case HMActionSheetType_GreenTitle:
            [tableView registerClass:[HMActionSheetTitleCell class] forCellReuseIdentifier:@"HMActionSheetTitleCell"];
            break;
        default:
            break;
    }
}

// 返回cell
+ (HMActionSheetNormalCell *)reusableCell:(HMActionSheetType)type forTableView:(UITableView *)tableView  {
    
    if (type == HMActionSheetType_Tick) {
        HMActionSheetTickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMActionSheetTickCell"];
        return cell;
        
    } else if (type == HMActionSheetType_RoundTick_Confirm) {
        HMActionSheetRoundTickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMActionSheetRoundTickCell"];
        return cell;
        
    }else if (type == HMActionSheetType_GreenTitle) {
        HMActionSheetTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMActionSheetTitleCell"];
        return cell;
        
    }
    return nil;
}
@end
