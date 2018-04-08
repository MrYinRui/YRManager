//
//  UITableView+DisableiOS11Estimate.m
//  HotelManager
//
//  Created by Se7en on 16/01/2018.
//  Copyright © 2018 samsoft. All rights reserved.
//

#import "UITableView+DisableiOS11Estimate.h"

@implementation UITableView (DisableiOS11Estimate)

- (void)disableiOS11Estimate {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        self.estimatedRowHeight           = 0.0;
        self.estimatedSectionFooterHeight = 0.0;
        self.estimatedSectionHeaderHeight = 0.0;
    }
}

@end
