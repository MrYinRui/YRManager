//
//  HMPhotoDialog.h
//  HotelManager
//
//  Created by Seven on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMActionSheet.h"

#define kDefaultDataSource @[@"拍照",@"从相册选择"]

@interface HMPhotoDialog : HMActionSheet

//DataSource : 拍照 从相册选择 （删除...）
+ (instancetype)photoDialogWithDataSource:(NSArray <NSString *> *)dataSource;



@end
