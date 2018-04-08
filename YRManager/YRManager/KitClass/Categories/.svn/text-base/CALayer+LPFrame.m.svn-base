//
//  CALayer+LPFrame.m
//  Lodger-Pad
//
//  Created by xun on 9/28/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "CALayer+LPFrame.h"

@implementation CALayer (LPFrame)

- (CGFloat)x
{
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

-(void)setSize:(CGSize)size{
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

-(void)setOrigin:(CGPoint)origin{
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.position.x;
}

-(void)setCenterX:(CGFloat)centerX{
    
    CGPoint center = self.position;
    center.x = centerX;
    self.position = center;
}

- (CGFloat)centerY
{
    return self.position.y;
}

-(void)setCenterY:(CGFloat)centerY{
    
    CGPoint center = self.position;
    center.y = centerY;
    self.position = center;
}

- (CGFloat)maxX
{
    return self.x + self.width;
}

-(void)setMaxX:(CGFloat)maxX{
    
    self.x += maxX;
}

- (CGFloat)maxY
{
    return self.y + self.height;
}

-(void)setMaxY:(CGFloat)maxY{
    
    self.y += maxY;
}

@end
