//
//  UIVC+ChildVC.m
//  XiaoYa
//
//  Created by Xun on 15/12/22.
//  Copyright © 2015年 xiaoya_community. All rights reserved.
//

#import "UIViewController+ChildVC.h"

@implementation UIViewController (ChildVC)

- (void)addChildVC:(UIViewController *)childController
{
    [self addChildViewController:childController];
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)addChildVC:(UIViewController *)childController withFrame:(CGRect)frame
{
    [self addChildViewController:childController];
    childController.view.frame = frame;
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)removeChildVC:(UIViewController *)childController
{
    [self removeChildVC:childController withAnimation:nil];
}

- (void)removeChildVC:(UIViewController *)childController withAnimation:(AnimationBlock)animationBlock
{
    if(animationBlock)
    {
        [UIView animateWithDuration:0.5f animations:^{
            animationBlock();
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [childController.view removeFromSuperview];
    }
    [childController willMoveToParentViewController:nil];
    [childController removeFromParentViewController];
}

@end
