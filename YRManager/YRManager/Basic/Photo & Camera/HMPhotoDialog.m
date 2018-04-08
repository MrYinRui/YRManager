//
//  HMPhotoDialog.m
//  HotelManager
//
//  Created by Seven on 2017/4/1.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMPhotoDialog.h"
#import "HMActionSheet.h"

@interface HMPhotoDialog()

@end

@implementation HMPhotoDialog

+ (instancetype)photoDialogWithDataSource:(NSArray<NSString *> *)dataSource{
    
    HMPhotoDialog *dialog =  [HMPhotoDialog actionSheetType:HMActionSheetType_GreenTitle dataSource:dataSource];
    
    return dialog;
}

@end
