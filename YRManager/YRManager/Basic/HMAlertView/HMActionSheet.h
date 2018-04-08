//
//  HMActionSheet.h
//  HotelManager
//
//  Created by r on 17/3/13.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMActionSheetNormalCell.h"

typedef void(^editBlock)(NSInteger index);

@class HMActionSheet;

@protocol HMActionSheetDelegate <NSObject>

- (void)actionSheet:(HMActionSheet *)actionSheet didSelectRow:(NSInteger)row;

@end


@interface HMActionSheet : UIView

@property (nonatomic, weak) id<HMActionSheetDelegate>delegate;
@property (nonatomic, copy) void (^confirmBlock)(NSInteger selectRow);//!<点击确定按钮回调
@property (nonatomic, readonly, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectRow;//!<选中行号
/**多选 Added on 17/6/5*/
@property (nonatomic, assign) BOOL     isMutiSelection; //!<是否多选
@property (nonatomic, assign) BOOL     isSelectAll;      //!<全选
@property (nonatomic, readonly, strong) NSMutableArray <NSNumber *>*selectionRows;

/**左滑删除 Added on 17/9/4*/
- (void)editCellWithEditNames:(NSArray *)editNames editBlocks:(NSArray *)editBlocks;

/** dataSource可以为NSString数组 或者 NSAttributedString数组 **/
+ (instancetype)actionSheetType:(HMActionSheetType)type dataSource:(NSArray *)dataSource;

/** 带title的actionSheet dataSource可以为NSString数组 或者 NSAttributedString数组 **/
+ (instancetype)actionSheetType:(HMActionSheetType)type title:(NSString *)title dataSource:(NSArray *)dataSource;

- (void)show;
- (void)hide;

@end




