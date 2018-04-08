//
//  ScrollImageView.h
//  ScrollImageView
//
//  Created by xun on 9/26/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollImageView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, copy) void (^scrollBlock)(NSInteger currentPage); //!<滚动回调Block

+ (instancetype)scrollViewWithFrame:(CGRect)frame
                             images:(NSArray *)images
                         autoScroll:(BOOL)autoScroll;

- (void)scrollToNextPage;
- (void)scrollToLastPage;

/**
 开始滚动
 */
- (void)start;

/**
 暂停滚动
 */
- (void)stop;

/**
 释放滚动效果
 */
- (void)end;

@end
