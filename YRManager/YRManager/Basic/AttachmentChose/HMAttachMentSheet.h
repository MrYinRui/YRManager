//
//  HMAttachMentSheet.h
//  HotelManager
//
//  Created by YR on 2017/6/21.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMAttachMentSheet : UIView

- (instancetype)initWithLimit:(NSInteger)limit; //!<limit 图片限制数量
- (void)showOnView:(UIView *)view;

@property (nonatomic, strong) void (^ChosePhotoBlock)(NSArray *imgArr);

@end
