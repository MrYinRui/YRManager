//
//  CALayer+LPFrame.h
//  Lodger-Pad
//
//  Created by xun on 9/28/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (LPFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@end
