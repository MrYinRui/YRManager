//
//  \\      //     ||          ||     ||\        ||
//   \\    //      ||          ||     ||\\       ||
//    \\  //       ||          ||     || \\      ||
//     \\//        ||          ||     ||  \\     ||
//      /\         ||          ||     ||   \\    ||
//     //\\        ||          ||     ||    \\   ||
//    //  \\       ||          ||     ||     \\  ||
//   //    \\      ||          ||     ||      \\ ||
//  //      \\      \\        //      ||       \\||
// //        \\      \\======//       ||        \||
//
//
//  LPActivityIndicatorView.m
//  Lodger-Pad
//
//  Created by xun on 11/7/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "LPActivityIndicatorView.h"
#import <objc/runtime.h>

#define kMaskAssociateKey "MSAK_ASSOCIATRE_KEY"

static UIImageView *icon = nil;

@interface LPWeakObject : NSProxy

@property (weak, nonatomic) id weakObj;

- (instancetype)initWithObj:(id)obj;

@end

@implementation LPWeakObject

- (instancetype)initWithObj:(id)obj
{
    _weakObj = obj;
    
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL select = [invocation selector];
    
    if ([_weakObj respondsToSelector:select])
    {
        [invocation invokeWithTarget:_weakObj];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_weakObj methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [_weakObj respondsToSelector:aSelector];
}

@end

@implementation LPActivityIndicatorView


#pragma mark - load data or init

+ (void)show
{
    [self showOnView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showOnView:(UIView *)view
{
    NSLock *lock = [NSLock new];
    [lock lock];
    
    //  初始化活动指示器
    if (icon == nil)
    {
        icon = [UIImageView new];
    }
    
    icon.frame = LPRectMake(0, 0, 100, 100);
    icon.image = [UIImage imageNamed:@"loading_01"];
    icon.center = CGPointMake(view.width / 2, view.height / 2);
    [view addSubview:icon];
    
    //  初始化动画
    CABasicAnimation *basicAnimation = [CABasicAnimation new];
    basicAnimation.keyPath = @"transform.rotation.z";
    basicAnimation.repeatCount = CGFLOAT_MAX;
    basicAnimation.fromValue = @0;
    basicAnimation.toValue = @(M_PI * 2);
    basicAnimation.duration = 1.f;
    
    [icon.layer addAnimation:basicAnimation forKey:nil];
    
    UIView *maskView = objc_getAssociatedObject(icon, kMaskAssociateKey);
    
    if(!maskView)
    {
        //  初始化蒙板
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        maskView.backgroundColor = [UIColor clearColor];
        maskView.userInteractionEnabled = YES;
    } else {
        maskView.frame = view.frame;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    
    objc_setAssociatedObject(icon, kMaskAssociateKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [view bringSubviewToFront:icon];
    
    [lock unlock];
}

+ (void)showWithMask
{
    [self show];
    
    UIView *maskView = objc_getAssociatedObject(icon, kMaskAssociateKey);
    maskView.backgroundColor = kColor(0, 0, 0, 0.5f);
}

+ (void)hide
{
    UIView *maskView = objc_getAssociatedObject(icon, kMaskAssociateKey);
    [maskView removeFromSuperview];
    maskView = nil;
    objc_removeAssociatedObjects(icon);
    
    [icon stopAnimating];
    [icon removeFromSuperview];
    icon = nil;
}

+ (void)hideWithCustomView:(UIView *)customView
{
    [self hide];
    
    if (customView)
    {
        CGAffineTransform origin = customView.transform;
        
        customView.transform = CGAffineTransformScale(origin, 0.6f, 0.6f);
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        customView.center = window.center;
        
        [window addSubview:customView];
        
        [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:0.2f initialSpringVelocity:0.01f options:0 animations:^{
            
            customView.transform = CGAffineTransformScale(origin, 1.0, 1.0);
            
        } completion:^(BOOL finished) {
            
            [customView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3.f];
        }];
    }
}

#pragma mark - lazy init



@end
