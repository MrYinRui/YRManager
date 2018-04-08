//
//  HMPayWaySelectViewCell.h
//  HotelManager
//
//  Created by r on 17/9/18.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMPayWaySelectViewCell : UITableViewCell

- (void)refreshCellWithContent:(NSString *)content;

- (void)selected;// 选中

@end
