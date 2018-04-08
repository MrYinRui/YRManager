//
//  LPLayout.c
//  Lodger-Pad
//
//  Created by xun on 9/24/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "LPLayout.h"

CGRect LPRectMake(float x, float y, float width, float height)
{
    float scale = ScreenScale;

//    return CGRectMake(x * scale,
//                      y * scale,
//                      (width * scale) > 1 ? ceilf(width * scale):(width * scale),
//                      (height * scale) > 1 ? ceilf(height * scale):(height * scale));
    return CGRectMake((x * scale),
                      (y * scale),
                      (width * scale),
                      (height * scale));
}

CGSize LPSizeMake(float width, float height)
{
    float scale = ScreenScale;
    
//    return CGSizeMake((width * scale) > 1 ? ceilf(width * scale):(width * scale),
//                      (height * scale) > 1 ? ceilf(height * scale):(height * scale));
    return CGSizeMake((width * scale),(height * scale));
}

CGPoint LPPointMake(float x, float y)
{
    float scale = ScreenScale;
    
    return CGPointMake(x * scale, y * scale);
}
