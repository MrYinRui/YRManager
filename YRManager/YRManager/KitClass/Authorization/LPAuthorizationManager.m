//
//  LPAuhorizationManager.m
//  Lodger-Pad
//
//  Created by xun on 10/14/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "LPAuthorizationManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation LPAuthorizationManager

+ (void)getCameraAuthorization
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
        if (!granted)
        {
            
        }
        
    }];
}

@end
