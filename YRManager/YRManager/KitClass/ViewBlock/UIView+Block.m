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
//  UIView+Block.m
//  HotelManager-Pad
//
//  Created by xun on 11/15/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "UIView+Block.h"

@implementation CALayer (Block)

- (CALayer *(^)(UIColor *))b_bgColor
{
    return ^(UIColor *color){
        
        self.backgroundColor = color.CGColor;
        return self;
    };
}

- (CALayer *(^)(CGRect))b_frame
{
    return ^(CGRect frame_){
        
        self.frame = frame_;
        return self;
    };
}

- (CALayer *(^)(CGFloat))b_borderWidth
{
    return ^(CGFloat w){
    
        self.borderWidth = w;
        return self;
    };
}

- (CALayer *(^)(CGFloat))b_cornerRadius
{
    return ^(CGFloat radius){
    
        self.cornerRadius = radius;
        return self;
    };
}

- (CALayer *(^)(UIColor *))b_borderColor
{
    return ^(UIColor *color){
    
        self.borderColor = color.CGColor;
        return self;
    };
}

- (CALayer *(^)(BOOL))b_makesToBounds
{
    return ^(BOOL make){
    
        self.masksToBounds = make;
        return self;
    };
}

- (CALayer *(^)(CALayer *))b_moveToLayer
{
    return ^(CALayer *layer){
        
        __weak CALayer *weakLayer = layer;
        
        [weakLayer addSublayer:self];
        
        return self;
    };
}

@end

@implementation UIView (Block)

- (UIView *(^)(BOOL))b_clipsToBounds
{
    return ^(BOOL clip){
        
        self.clipsToBounds = clip;
        return self;
    };
}

- (UIView *(^)(CGRect))b_frame
{
    return ^(CGRect frame_){
    
        self.frame = frame_;
        return self;
    };
}

- (UIView *(^)(UIColor *))b_bgColor
{
    return ^(UIColor *color_){
    
        self.backgroundColor = color_;
        return self;
    };
}

- (UIView *(^)(UIGestureRecognizer *))b_addGesture
{
    return ^(UIGestureRecognizer *ges){
    
        [self addGestureRecognizer:ges];
        return self;
    };
}

- (UIView *(^)(BOOL))b_userInteractionEnabled
{
    return ^(BOOL userInteraction){
        
        self.userInteractionEnabled = userInteraction;
        return self;
    };
}

- (UIView *(^)(UIViewContentMode))b_contentMode
{
    return ^(UIViewContentMode mode){
    
        self.contentMode = mode;
        
        return self;
    };
}

- (UIView *(^)(NSInteger))b_tag
{
    return ^(NSInteger tag){
    
        self.tag = tag;
        return self;
    };
}

- (UIView *(^)(UIView *))b_moveToView
{
    return ^(UIView *view){
        
        __weak UIView *weakView = view;
        
        [weakView addSubview:self];
        
        return self;
    };
}

@end

@implementation UIButton (Block)

- (UIButton *(^)(NSString *, UIControlState))b_title
{
    return ^(NSString *title, UIControlState state){
    
        [self setTitle:title forState:state];
        return self;
    };
}

- (UIButton *(^)(UIColor *, UIControlState))b_titleColor
{
    return ^(UIColor *color, UIControlState state){
    
        [self setTitleColor:color forState:state];
        return self;
    };
}

- (UIButton *(^)(UIFont *))b_font
{
    return ^(UIFont *font){
    
        self.titleLabel.font = font;
        return self;
    };
}

- (UIButton *(^)(UIImage *, UIControlState))b_image
{
    return ^(UIImage *img, UIControlState state){
    
        [self setImage:img forState:state];
        return self;
    };
}

- (UIButton *(^)(UIEdgeInsets))b_titleEdgeInsets
{
    return ^(UIEdgeInsets insets){
        
        self.titleEdgeInsets = insets;
        return self;
    };
}

- (UIButton *(^)(UIEdgeInsets))b_imageEdgeInsets
{
    return ^(UIEdgeInsets insets){
        
        self.imageEdgeInsets = insets;
        return self;
    };
}

- (UIButton *(^)(UIEdgeInsets))b_contentEdgeInsets
{
    return ^(UIEdgeInsets insets){
        
        self.contentEdgeInsets = insets;
        return self;
    };
}

@end

@implementation UIControl (Block)

- (UIControl *(^)(id, SEL, UIControlEvents))b_addAction
{
    return ^(id obj, SEL selector, UIControlEvents event){
        
        [self addTarget:obj action:selector forControlEvents:event];
        
        return self;
    };
}

- (UIControl *(^)(id, SEL, UIControlEvents))b_removeAction
{
    return ^(id obj, SEL selector, UIControlEvents event){
    
        [self removeTarget:obj action:selector forControlEvents:event];
        return self;
    };
}

- (UIControl *(^)(BOOL))b_enable
{
    return ^(BOOL enable){
    
        self.enabled = enable;
        return self;
    };
}

- (UIControl *(^)(BOOL))b_selected
{
    return ^(BOOL select){
    
        self.selected = select;
        return self;
    };
}

@end

@implementation UILabel (Block)

- (UILabel *(^)(NSString *))b_text
{
    return ^(NSString *text){
    
        self.text = text;
        return self;
    };
}

- (UILabel *(^)(UIFont *))b_font
{
    return ^(UIFont *font){
    
        self.font = font;
        return self;
    };
}

- (UILabel *(^)(UIColor *))b_textColor
{
    return ^(UIColor *color){
    
        self.textColor = color;
        return self;
    };
}

- (UILabel *(^)(NSAttributedString *))b_attributeText
{
    return ^(NSAttributedString *attString){
    
        self.attributedText = attString;
        
        return self;
    };
}

- (UILabel *(^)(NSInteger))b_numberOfLines
{
    return ^(NSInteger lines){
    
        self.numberOfLines = lines;
        return self;
    };
}

- (UILabel *(^)(NSTextAlignment))b_textAlignment
{
    return ^(NSTextAlignment alignment){
    
        self.textAlignment = alignment;
        return self;
    };
}

- (UILabel *(^)(NSLineBreakMode))b_lineBreakMode
{
    return ^(NSLineBreakMode mode){
        
        self.lineBreakMode = mode;
        return self;
    };
}

@end

@implementation UIImageView (Block)

- (UIImageView *(^)(UIImage *))b_image
{
    return ^(UIImage *img){
    
        self.image = img;
        
        return self;
    };
}

- (UIImageView *(^)(UIImage *))b_highlightedImage
{
    return ^(UIImage *img){
        
        self.highlightedImage = img;
        
        return self;
    };
}

@end

@implementation UITextField (Block)

- (UITextField *(^)(UIKeyboardAppearance))b_keyboardAppearance
{   
    return ^(UIKeyboardAppearance appearance){
    
        self.keyboardAppearance = appearance;
        return self;
    };
}

- (UITextField *(^)(UIKeyboardType))b_keyboardType
{
    return ^(UIKeyboardType type){
        
        self.keyboardType = type;
        return self;
    };
}

- (UITextField *(^)(id<UITextFieldDelegate>))b_delegate
{
    return ^(id <UITextFieldDelegate> delegate){
    
        self.delegate = delegate;
        return self;
    };
}

- (UITextField *(^)(UIFont *))b_font
{
    return ^(UIFont *font){
        
        self.font = font;
        return self;
    };
}

- (UITextField *(^)(NSString *))b_text
{
    return ^(NSString *text){
    
        self.text = text;
        return self;
    };
}

- (UITextField *(^)(UIImage *))b_bgImage
{
    return ^(UIImage *img){
    
        self.background = img;
        return self;
    };
}

- (UITextField *(^)(UIImage *))b_disableBgImage
{
    return ^(UIImage *img){
    
        self.disabledBackground = img;
        return self;
    };
}

- (UITextField *(^)(NSTextAlignment))b_textAlignment
{
    return ^(NSTextAlignment aligment){
    
        self.textAlignment = aligment;
        return self;
    };
}

- (UITextField *(^)(BOOL))b_clearsOnBeginEditing
{
    return ^(BOOL clear){
    
        self.clearsOnBeginEditing = clear;
        return self;
    };
}

- (UITextField *(^)(UITextFieldViewMode))b_leftViewMode
{
    return ^(UITextFieldViewMode mode){
        
        self.leftViewMode = mode;
        return self;
    };
}

- (UITextField *(^)(UITextFieldViewMode))b_rightViewMode
{
    return ^(UITextFieldViewMode mode){
        
        self.rightViewMode = mode;
        return self;
    };
}

- (UITextField *(^)(UIView *))b_rightView
{
    return ^(UIView *view){
        
        self.rightView = view;
        return self;
    };
}

- (UITextField *(^)(UIView *))b_leftView
{
    return ^(UIView *view){
        
        self.leftView = view;
        return self;
    };
}

- (UITextField *(^)(UITextBorderStyle))b_borderStyle
{
    return ^(UITextBorderStyle style){
        
        self.borderStyle = style;
        return self;
    };
}

- (UITextField *(^)(UIReturnKeyType))b_returnKeyType
{
    return ^(UIReturnKeyType type){
        
        self.returnKeyType = type;
        return self;
    };
}

- (UITextField *(^)(NSString *))b_placeholder
{
    return ^(NSString *text){
        
        self.placeholder = text;
        return self;
    };
}

- (UITextField *(^)(NSAttributedString *))b_attributedPlaceholder
{
    return ^(NSAttributedString *attStr){
        
        self.attributedPlaceholder = attStr;
        return self;
    };
}

- (UITextField *(^)(BOOL))b_secureTextEntry
{
    return ^(BOOL secure){
        
        self.secureTextEntry = secure;
        return self;
    };
}

- (UITextField *(^)(UITextFieldViewMode))b_clearBtnMode
{
    return ^(UITextFieldViewMode mode){
        
        self.clearButtonMode = mode;
        return self;
    };
}

- (UITextField *(^)(UIColor *))b_textColor
{
    return ^(UIColor *color){
    
        self.textColor = color;
        return self;
    };
}

@end

@implementation UITableView (Block)

- (UITableView *(^)(id<UITableViewDelegate>))b_delegate
{
    return ^(id <UITableViewDelegate> delegate){
        
        self.delegate = delegate;
        return self;
    };
}

- (UITableView *(^)(id<UITableViewDataSource>))b_dataSource
{
    return ^(id <UITableViewDataSource> dataSource){
        
        self.dataSource = dataSource;
        return self;
    };
}

- (UITableView *(^)(__unsafe_unretained Class))b_registClass
{
    return ^(Class class){
    
        [self registerClass:class forCellReuseIdentifier:NSStringFromClass(class).uppercaseString];
        return self;
    };
}

- (UITableView *(^)(NSString *))b_registNib
{
    return ^(NSString *nibName){
        
        [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName.uppercaseString];
        return self;
    };
}

- (UITableView *(^)(__unsafe_unretained Class, NSString *))b_registClassWithIdentifier
{
    return ^(Class class, NSString *str){
    
        [self registerClass:class forCellReuseIdentifier:str];
        return self;
    };
}

- (UITableView *(^)(NSString *, NSString *))b_registNibWithIdentifier
{
    return ^(NSString *nibName, NSString *str){
    
        [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:str];
        return self;
    };
}

- (UITableView *(^)(CGFloat))b_estimatedRowHeight
{
    return ^(CGFloat height){
    
        self.estimatedRowHeight = height;
        return self;
    };
}

- (UITableView *(^)(UIEdgeInsets))b_separatorInset
{
    return ^(UIEdgeInsets edgeInsets){
        
        self.separatorInset = edgeInsets;
        return self;
    };
}

- (UITableView *(^)(UIView *))b_footerView
{
    return ^(UIView *view){
    
        self.tableFooterView = view;
        return self;
    };
}

- (UITableView *(^)(UIView *))b_bgView
{
    return ^(UIView *view){
        
        self.backgroundView = view;
        return self;
    };
}

- (UITableView *(^)(UITableViewCellSeparatorStyle))b_separatorStyle
{
    return ^(UITableViewCellSeparatorStyle separatorStyle){
    
        self.separatorStyle = separatorStyle;
        return self;
    };
}

@end

@implementation UICollectionView (Block)

- (UICollectionView *(^)(id<UICollectionViewDelegate>))b_delegate
{
    return ^(id <UICollectionViewDelegate> delegate){
        
        self.delegate = delegate;
        return self;
    };
}

- (UICollectionView *(^)(id<UICollectionViewDataSource>))b_dataSource
{
    return ^(id <UICollectionViewDataSource> dataSource){
        
        self.dataSource = dataSource;
        return self;
    };
}

- (UICollectionView *(^)(__unsafe_unretained Class, NSString *))b_registClass
{
    return ^(Class class, NSString *str){
        
        [self registerClass:class forCellWithReuseIdentifier:str];
        return self;
    };
}

- (UICollectionView *(^)(NSString *, NSString *))b_registNib
{
    return ^(NSString *nibName, NSString *str){
        
        [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:str];
        return self;
    };
}

- (UICollectionView *(^)(UICollectionViewLayout *))b_collectionViewLayout
{
    return ^(UICollectionViewLayout *layout){
    
        self.collectionViewLayout = layout;
        return self;
    };
}

@end

@implementation UITextView (Block)

- (UITextView *(^)(id<UITextViewDelegate>))b_delegate
{
    return ^(id <UITextViewDelegate> delegate){
        
        self.delegate = delegate;
        return self;
    };
}

- (UITextView *(^)(UIColor *))b_textColor
{
    return ^(UIColor *color){
    
        self.textColor = color;
        return self;
    };
}

- (UITextView *(^)(UIFont *))b_font
{
    return ^(UIFont *font){
        
        self.font = font;
        return self;
    };
}

- (UITextView *(^)(NSString *))b_text
{
    return ^(NSString *text){
        
        self.text = text;
        return self;
    };
}

- (UITextView *(^)(NSTextAlignment))b_textAlignment
{
    return ^(NSTextAlignment aligment){
        
        self.textAlignment = aligment;
        return self;
    };
}

- (UITextView *(^)(UIReturnKeyType))b_returnKeyType
{
    return ^(UIReturnKeyType type){
        
        self.returnKeyType = type;
        return self;
    };
}

- (UITextView *(^)(UIKeyboardAppearance))b_keyboardAppearance
{
    return ^(UIKeyboardAppearance appearance){
    
        self.keyboardAppearance = YES;
        return self;
    };
}

- (UITextView *(^)(UIKeyboardType))b_keyboardType
{
    return ^(UIKeyboardType type){
    
        self.keyboardType = type;
        return self;
    };
}

@end

@implementation UIScrollView (Block)

- (UIScrollView *(^)(id<UIScrollViewDelegate>))b_delegate
{
    return ^(id<UIScrollViewDelegate> delegate){
        
        self.delegate = delegate;
        return self;
    };
}

- (UIScrollView *(^)(CGSize))b_contentSize
{
    return ^(CGSize size){
        
        self.contentSize = size;
        return self;
    };
}

- (UIScrollView *(^)(CGPoint))b_contentOffset
{
    return ^(CGPoint point){
        
        self.contentOffset = point;
        return self;
    };
}

- (UIScrollView *(^)(UIEdgeInsets))b_contentInset
{
    return ^(UIEdgeInsets insets){
        
        self.contentInset = insets;
        return self;
    };
}

- (UIScrollView *(^)(BOOL))b_pagingEnabled
{
    return ^(BOOL isBool){
        
        self.pagingEnabled = isBool;
        return self;
    };
}

- (UIScrollView *(^)(BOOL))b_showsHorizontalScrollIndicator
{
    return ^(BOOL isBool){
        
        self.showsHorizontalScrollIndicator = isBool;
        return self;
    };
}

- (UIScrollView *(^)(BOOL))b_showsVerticalScrollIndicator
{
    return ^(BOOL isBool){
        
        self.showsVerticalScrollIndicator = isBool;
        return self;
    };
}

- (UIScrollView *(^)(BOOL))b_bounces
{
    return ^(BOOL bounces){
    
        self.bounces = bounces;
        return self;
    };
}

@end
