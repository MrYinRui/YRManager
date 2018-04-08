
//
//  HMRoomStatusInfoModel+CleanStateIconName.m
//  HotelManager
//
//  Created by Se7en on 10/01/2018.
//  Copyright © 2018 samsoft. All rights reserved.
//

#import "HMRoomStatusInfoModel+CleanStateIcon.h"

@implementation HMRoomStatusInfoModel (CleanStateIcon)

- (UIImage *)cleanStateIcon{
    switch (self.cleanState.integerValue) {
        case RoomCleanStateHide: //隐藏
        {
            return nil;
        }
            break;
        case RoomCleanStateCleanEntire://洁房
        {
            return [UIImage imageNamed:@"state_12"];
        }
            break;
        case RoomCleanStateCleanPartial://洁疵
        {
            return [UIImage imageNamed:@"state_14"];
        }
            break;
        case RoomCleanStateNotCheck://洁未查
        {
            return [UIImage imageNamed:@"state_13"];
        }
            break;
        case RoomCleanStateDisqualification://不合格
        {
            return [UIImage imageNamed:@"state_15"];
        }
            break;
        case RoomCleanStateDirtyRegard://脏房 (已安排)
        {
            return [UIImage imageNamed:@"state_16"];
        }
            break;
        case RoomCleanStateDirtyRegardless://脏房 (未安排)
        {
//            [self opacityForever_Animation:AnimationDur withView:_topImgV]; //闪烁
            return [UIImage imageNamed:@"state_17"];
        }
            break;
        default:
            //异常 RoomCleanStateAbnormal
            break;
    }
    return nil;
}


@end
