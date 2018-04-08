//
//  HMRoomStatusInfoModel+CleanStateIcon.h
//  HotelManager
//
//  Created by Se7en on 10/01/2018.
//  Copyright © 2018 samsoft. All rights reserved.
//

#import "HMRoomStatusModel.h"

@interface HMRoomStatusInfoModel (CleanStateIcon)

/**
 根据 清洁状态 返回 清洁状态 image
 @return UIImage
 */
- (UIImage *)cleanStateIcon;

@end
