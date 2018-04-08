//
//  HMAlignMentLabel.h
//  HotelManager-Pad
//
//  Created by YR on 17/3/9.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface HMAlignMentLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
