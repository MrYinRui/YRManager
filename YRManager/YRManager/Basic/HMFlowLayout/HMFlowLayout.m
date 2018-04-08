//
//  HMFlowLayout.m
//  HotelManager
//
//  Created by xun on 16/7/20.
//  Copyright © 2016年 xun. All rights reserved.
//

#import "HMFlowLayout.h"

@implementation HMFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    UICollectionViewLayoutAttributes * attribute = [attributes firstObject];
    CGRect frame = attribute.frame;
    frame.origin = CGPointMake(0, 0);
    attribute.frame = frame;
    
    for(int i = 1; i < [attributes count]; ++i)
    {
        if (i < 7)
        {
            UICollectionViewLayoutAttributes * attribute = attributes[i];
            CGRect frame = attribute.frame;
            frame.origin.y = 0;
            attribute.frame = frame;
        }
        else
        {
            UICollectionViewLayoutAttributes *currentAttribute = attributes[i];
            UICollectionViewLayoutAttributes *previousAttribute = attributes[i - 7];
            
            CGRect frame = currentAttribute.frame;
            
            CGRect tmpFrame = previousAttribute.frame;
            
            frame.origin.y = CGRectGetMaxY(tmpFrame) + 0;
            currentAttribute.frame = frame;
        }
        
        if(i % 7)
        {
            UICollectionViewLayoutAttributes *currentAttribute = attributes[i];
            UICollectionViewLayoutAttributes *previousAttribute = attributes[i - 1];
            
            CGRect frame = currentAttribute.frame;
            
            CGRect tmpFrame = previousAttribute.frame;
            
            frame.origin.x = CGRectGetMaxX(tmpFrame) + 0;
            currentAttribute.frame = frame;
        }
        else
        {
            UICollectionViewLayoutAttributes * attribute = attributes[i];
            CGRect frame = attribute.frame;
            frame.origin.x = 0;
            attribute.frame = frame;
        }
    }
    return attributes;
}

@end
