//
//  \\      //     ||          ||     ||\        ||
//   \\    //      ||          ||     ||\\       ||
//    \\  //       ||          ||     || \\      ||
//     \\//        ||          ||     ||  \\     ||
//      /\         ||          ||     ||   \\    ||
//     //\\        ||          ||     ||    \\   ||
//    //  \\       ||          ||     ||     \\  ||
//   //    \\      ||          ||     ||      \\ ||
//  //      \\      \\        //      ||       \\||
// //        \\      \\======//       ||        \||
//
//
//  HMTBC.m
//  HotelManage
//
//  Created by xun on 17/2/21.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMTBC.h"
#import "HMWorkMainVC.h"
#import "HMSystemMainVC.h"
#import "HMMessageMainVC.h"
#import "HMMineMainVC.h"
#import "HMTabBarItem.h"

#define kTabBarTitle @[@"工作",@"系统",@"信息",@"我的"]

@interface HMTBC ()

@property (nonatomic, strong) NSMutableArray <HMTabBarItem *> *tabBarItems;
@property (nonatomic, strong) HMTabBarItem *lastSelectItem;

@end

@implementation HMTBC

#pragma mark - view controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBar.hidden = YES;
    
    self.view.frame = LPRectMake(0, StatusHeight-44, kBaseScreenWidth, kBaseScreenHeight-StatusHeight+44);
    
    HMWorkMainVC *workVC = [[HMWorkMainVC alloc] init];
    HMSystemMainVC *systemVC = [[HMSystemMainVC alloc] init];
    HMMessageMainVC *messageVC = [[HMMessageMainVC alloc] init];
    HMMineMainVC *mineVC = [[HMMineMainVC alloc] init];
    
    self.viewControllers = @[workVC, systemVC, messageVC, mineVC];

    [self.tabBar removeFromSuperview];
    [self initTabBar];
}

#pragma mark - init view or data

- (void)initTabBar{
    
    _tabBarItems = [NSMutableArray array];
    
    CGFloat itemWidth, itemHieght;
    
    itemWidth = self.view.width / self.viewControllers.count;
    itemHieght = 60;
    
    UIView *customBar = [[UIView alloc] init];
    [self.view addSubview:customBar];
    
    if (KIsiPhoneX)
    {
        itemHieght = 94;
        customBar.backgroundColor = kGreenColor;
    }
    
    [customBar mas_makeConstraints:^(MASConstraintMaker *make) {
        kMasLeft(0);kMasBottom(0);kMasWidth(kBaseScreenWidth);kMasHeight(itemHieght);
    }];
    
    for (int i = 0; i < self.viewControllers.count; i++)
    {
        HMTabBarItem *item = [HMTabBarItem tabBarItemWithTitle:kTabBarTitle[i] normalImg:[NSString stringWithFormat:@"tabbar_normal_%d",i+1] selectImg:[NSString stringWithFormat:@"tabbar_select_%d",i+1]];
        [item addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        item.frame = CGRectMake(itemWidth * i, 0, itemWidth, kScaleNum(60));
        [_tabBarItems addObject:item];
        [customBar addSubview:item];
        
    }
    
    [self selectedItem:_tabBarItems[0]];

}

#pragma mark - view events

- (void)selectedItem:(HMTabBarItem *)item {
    
    _lastSelectItem.selected = NO;
    _lastSelectItem.backgroundColor = kGreenColor;
    
    [item setBackgroundColor:kColor(250, 250, 250, 1)];
    item.selected = YES;
    
    self.selectedIndex = [self.tabBarItems indexOfObject:item];
    
    _lastSelectItem = item;
}

- (void)setSelectIndex:(NSInteger)index
{
    _lastSelectItem.selected = NO;
    _lastSelectItem.backgroundColor = kGreenColor;
    
    HMTabBarItem *item = self.tabBarItems[index];
    [item setBackgroundColor:kColor(250, 250, 250, 1)];
    item.selected = YES;
    
    self.selectedIndex = [self.tabBarItems indexOfObject:item];
    
    _lastSelectItem = item;
}

@end
