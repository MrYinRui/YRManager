//
//  HMOrder+OrderStateIconImage.m
//  HotelManager
//
//  Created by r on 17/8/15.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "HMOrder+OrderStateIconImage.h"

@implementation HMOrder (OrderStateIconImage)

- (NSString *)orderStateIconImageName {
    
    NSString *imageName;
    if (self.getOrderStatus == EMPTY)
    {
        imageName = @"order_list_state00";
    }
    else if (self.getOrderStatus == ARRIVED)
    {
        imageName = @"order_list_state01";
    }
    else if (self.getOrderStatus == RESERVATION)
    {
        imageName = @"order_list_state02";
    }
    else if (self.getOrderStatus == ORDER)
    {
        imageName = @"order_list_state03";
    }
    else if (self.getOrderStatus == WENT_LIVE)
    {
        imageName = @"order_list_state04";
    }
    else if (self.getOrderStatus == FRONT_DESK_HURRY_CHECK_UP)
    {
        imageName = @"order_list_state05";
    }
    else if (self.getOrderStatus == CUSTOMER_HURRY_CHECK_UP)
    {
        imageName = @"order_list_state05";
    }
    else if (self.getOrderStatus == WOULD_LEAVE ||
             self.getOrderStatus == WOULD_LEAVE_WITHOUT_CHECK)
    {
        imageName = @"order_list_state06";
    }
    else if (self.getOrderStatus == WAIT_LIVE)
    {
        imageName = @"order_list_state07";
    }
    else if (self.getOrderStatus == NO_SHOW)
    {
        imageName = @"order_list_state08";
    }
    else if (self.getOrderStatus == ADD_CLOCK_NO_SHOW)
    {
        imageName = @"order_list_state08";
    }
    else if (self.getOrderStatus == RESPONIBLE_CHECK)
    {
        imageName = @"order_list_state10";
    }
    else if (self.getOrderStatus == OTHERS_CHECK)
    {
        imageName = @"order_list_state10";
    }
    else if (self.getOrderStatus == COMPLETED)
    {
        imageName = @"order_list_state11";
    }
    else if (self.getOrderStatus == LIVING)
    {
        imageName = @"order_list_state12";
    }
    else if (self.getOrderStatus == WAIT_CANCEL)
    {
        imageName = @"order_list_state13";
    }
    else if (self.getOrderStatus == CHECK_WITH_NO_PROBLEM)
    {
        imageName = @"order_list_state14";
    }
    else if (self.getOrderStatus == CHECK_WITH_MATTER)
    {
        imageName = @"order_list_state14";
    }
    else if (self.getOrderStatus == CHECKED_OUT)
    {
        imageName = @"order_list_state15";
    }
    else if (self.getOrderStatus == FORCE_CHECK_OUT)
    {
        imageName = @"order_list_state15";
    }
      else if (self.getOrderStatus == CONFIRM_NO_SHOW)
    {
        imageName = @"order_list_state16";
        
    } else if (self.getOrderStatus == CANCEL)
    {
        imageName = @"order_list_state17";
        
    } else if (self.getOrderStatus == START_CLOCK)
    {
        imageName = @"order_list_state18";
        
    } else if (self.getOrderStatus == OVER_CLOCK)
    {
        imageName = @"order_list_state19";
        
    } else if (self.getOrderStatus == START_ADD_CLOCK)
    {
        imageName = @"order_list_state20";
        
    } else if (self.getOrderStatus == LIVE_ADD_CLOCK)
    {
        imageName = @"order_list_state21";
    }
    else if (self.getOrderStatus == OVERDEU_NOT_AWAY)
    {
        imageName = @"order_list_state22";
    }
    else if (self.getOrderStatus == LOCK_ROOM)
    {
        imageName = @"order_list_state23";
    }
    else if (self.getOrderStatus == LOCK_DOWN)
    {
        imageName = @"order_list_state24";
    }
    else
    {
        imageName = nil;
    }
    return imageName;
}

@end
