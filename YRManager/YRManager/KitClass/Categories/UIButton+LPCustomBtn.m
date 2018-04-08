//
//  UIButton+LPCustomBtn.m
//  Lodger-Pad
//
//  Created by xun on 9/29/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "UIButton+LPCustomBtn.h"

@implementation UIButton (LPCustomBtn)

+ (instancetype)greenBorderBtnWithFrame:(CGRect)frame
                                  title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kGreenColor forState:UIControlStateNormal];
    [btn setTitleColor:kColor(0, 136, 66, 1.f) forState:UIControlStateHighlighted];
    btn.titleLabel.font = kFont(18);
    btn.layer.cornerRadius = 5.f;
    btn.layer.masksToBounds = YES;
    btn.frame = frame;
    btn.layer.borderColor = kGreenColor.CGColor;
    btn.layer.borderWidth = 1.f;
    
    return btn;
}

+ (instancetype)greenBtnWithFrame:(CGRect)frame
                            title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(18);
    btn.layer.cornerRadius = 5.f;
    btn.layer.masksToBounds = YES;
    btn.frame = frame;
    btn.backgroundColor = kGreenColor;
    return btn;
}

+ (instancetype)grayBtnWithFrame:(CGRect)frame
                           title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(18);
    btn.layer.cornerRadius = 5.f;
    btn.layer.masksToBounds = YES;
    btn.frame = frame;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = kColor(222, 223, 227, 1);
    return btn;
}

+ (instancetype)buttonWithFrame:(CGRect)frame
                          title:(NSString *)title color:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(24);
    btn.layer.cornerRadius = 5.f;
    btn.layer.masksToBounds = YES;
    btn.frame = frame;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = color;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return btn;
}

#pragma mark -交换title和image的位置
//设置Button的title在image中间
-(UIButton*)titleInImageCurrent{
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake( 0.0,-self.imageView.bounds.size.width, 0.0,0.0)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -self.titleLabel.bounds.size.width)];
    
    return self;
}

/**
 *  设置Button的title在image上方或下方，根据正负值进行控制
 */
-(UIButton*(^)(CGFloat distance))titleInIconBelow{
    
    return ^(CGFloat distance){
        [self setTitleEdgeInsets:UIEdgeInsetsMake( distance,-self.imageView.bounds.size.width, 0.0,0.0)];
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -self.titleLabel.bounds.size.width)];
        
        return self;
    };
}


/**
 *  设置Button的title在image左边(左文右图)
 */
-(UIButton*)titleChangeImagePosition{
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width, 0, self.imageView.bounds.size.width)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
    
    return self;
}



@end
