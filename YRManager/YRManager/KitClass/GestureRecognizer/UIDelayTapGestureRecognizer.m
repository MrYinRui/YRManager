//
//  UIDelayTapGestureRecognizer.m
//  HotelManager
//
//  Created by kqz on 2017/9/23.
//  Copyright © 2017年 samsoft. All rights reserved.
//

#import "UIDelayTapGestureRecognizer.h"
#define UISHORT_TAP_MAX_DELAY 0.3

@implementation UIDelayTapGestureRecognizer

-(instancetype)initWithTarget:(id)target action:(SEL)action{
    
    self=[super initWithTarget:target action:action];
    
    if(self){
        
        self.maxDelay = UISHORT_TAP_MAX_DELAY;
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.maxDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(self.state!=UIGestureRecognizerStateRecognized){
            
            self.state=UIGestureRecognizerStateFailed;
        }
    });
}

@end
