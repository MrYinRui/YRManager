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
//  UIView+Block.h
//  HotelManager-Pad
//
//  Created by xun on 11/15/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  为了代码简洁，尝试使用链式编程方式
 *  为了区别系统自带方法，统一在该分类方法内部添加b_
 */

@interface CALayer (Block)

- (CALayer *(^)(CGRect))b_frame;
- (CALayer *(^)(UIColor *))b_bgColor;
- (CALayer *(^)(CGFloat))b_cornerRadius;
- (CALayer *(^)(CGFloat))b_borderWidth;
- (CALayer *(^)(UIColor *))b_borderColor;

- (CALayer *(^)(BOOL))b_makesToBounds;
- (CALayer *(^)(CALayer *))b_moveToLayer;

@end

@interface UIView (Block)

- (UIView *(^)(UIColor *))b_bgColor;
- (UIView *(^)(UIGestureRecognizer *))b_addGesture;
- (UIView *(^)(CGRect))b_frame;
- (UIView *(^)(BOOL))b_userInteractionEnabled;
- (UIView *(^)(UIViewContentMode))b_contentMode;

- (UIView *(^)(NSInteger))b_tag;
- (UIView *(^)(BOOL))b_clipsToBounds;
- (UIView *(^)(UIView *))b_moveToView;

@end

@interface UIButton (Block)

- (UIButton *(^)(NSString *, UIControlState))b_title;
- (UIButton *(^)(UIImage *, UIControlState))b_image;
- (UIButton *(^)(UIFont *))b_font;
- (UIButton *(^)(UIColor *, UIControlState))b_titleColor;
- (UIButton *(^)(UIEdgeInsets))b_imageEdgeInsets;
- (UIButton *(^)(UIEdgeInsets))b_titleEdgeInsets;
- (UIButton *(^)(UIEdgeInsets))b_contentEdgeInsets;

@end

@interface UIControl (Block)

- (UIControl *(^)(BOOL))b_selected;
- (UIControl *(^)(BOOL))b_enable;
- (UIControl *(^)(id, SEL, UIControlEvents))b_addAction;
- (UIControl *(^)(id, SEL, UIControlEvents))b_removeAction;

@end

@interface UILabel (Block)

- (UILabel *(^)(NSString *))b_text;
- (UILabel *(^)(UIFont *))b_font;
- (UILabel *(^)(UIColor *))b_textColor;
- (UILabel *(^)(NSAttributedString *))b_attributeText;
- (UILabel *(^)(NSInteger))b_numberOfLines;

- (UILabel *(^)(NSTextAlignment))b_textAlignment;
- (UILabel *(^)(NSLineBreakMode))b_lineBreakMode;

@end

@interface UIImageView (Block)

- (UIImageView *(^)(UIImage *))b_image;
- (UIImageView *(^)(UIImage *))b_highlightedImage;

@end

@interface UITextField (Block)

- (UITextField *(^)(id <UITextFieldDelegate>))b_delegate;
- (UITextField *(^)(UIColor *))b_textColor;
- (UITextField *(^)(UIFont *))b_font;
- (UITextField *(^)(NSString *))b_placeholder;
- (UITextField *(^)(NSString *))b_text;

- (UITextField *(^)(NSTextAlignment))b_textAlignment;
- (UITextField *(^)(UITextBorderStyle))b_borderStyle;
- (UITextField *(^)(UIImage *))b_bgImage;
- (UITextField *(^)(UIImage *))b_disableBgImage;
- (UITextField *(^)(UITextFieldViewMode))b_leftViewMode;

- (UITextField *(^)(UITextFieldViewMode))b_rightViewMode;
- (UITextField *(^)(UITextFieldViewMode))b_clearBtnMode;
- (UITextField *(^)(NSAttributedString *))b_attributedPlaceholder;
- (UITextField *(^)(BOOL))b_clearsOnBeginEditing;
- (UITextField *(^)(UIKeyboardType))b_keyboardType;

- (UITextField *(^)(UIKeyboardAppearance))b_keyboardAppearance;
- (UITextField *(^)(UIReturnKeyType))b_returnKeyType;
- (UITextField *(^)(BOOL))b_secureTextEntry;
- (UITextField *(^)(UIView *))b_leftView;
- (UITextField *(^)(UIView *))b_rightView;

@end

@interface UITableView (Block)

- (UITableView *(^)(id <UITableViewDelegate>))b_delegate;
- (UITableView *(^)(id <UITableViewDataSource>))b_dataSource;
- (UITableView *(^)(Class))b_registClass;
- (UITableView *(^)(NSString *))b_registNib;
- (UITableView *(^)(CGFloat))b_estimatedRowHeight;

- (UITableView *(^)(UIView *))b_bgView;
- (UITableView *(^)(UIView *))b_footerView;
- (UITableView *(^)(UIEdgeInsets))b_separatorInset;
- (UITableView *(^)(Class, NSString *))b_registClassWithIdentifier;
- (UITableView *(^)(NSString *, NSString *))b_registNibWithIdentifier;

- (UITableView *(^)(UITableViewCellSeparatorStyle))b_separatorStyle;


@end

@interface UICollectionView (Block)

- (UICollectionView *(^)(id <UICollectionViewDelegate>))b_delegate;
- (UICollectionView *(^)(id <UICollectionViewDataSource>))b_dataSource;
- (UICollectionView *(^)(UICollectionViewLayout *))b_collectionViewLayout;
- (UICollectionView *(^)(Class, NSString *))b_registClass;
- (UICollectionView *(^)(NSString *, NSString *))b_registNib;

@end

@interface UITextView (Block)

- (UITextView *(^)(id <UITextViewDelegate>))b_delegate;
- (UITextView *(^)(UIColor *))b_textColor;
- (UITextView *(^)(UIFont *))b_font;
- (UITextView *(^)(NSString *))b_text;
- (UITextView *(^)(NSTextAlignment))b_textAlignment;

- (UITextView *(^)(UIKeyboardType))b_keyboardType;
- (UITextView *(^)(UIKeyboardAppearance))b_keyboardAppearance;
- (UITextView *(^)(UIReturnKeyType))b_returnKeyType;

@end

@interface UIScrollView (Block)

- (UIScrollView *(^)(id<UIScrollViewDelegate>))b_delegate;
- (UIScrollView *(^)(CGSize))b_contentSize;
- (UIScrollView *(^)(CGPoint))b_contentOffset;
- (UIScrollView *(^)(UIEdgeInsets))b_contentInset;
- (UIScrollView *(^)(BOOL))b_pagingEnabled;

- (UIScrollView *(^)(BOOL))b_showsHorizontalScrollIndicator;
- (UIScrollView *(^)(BOOL))b_showsVerticalScrollIndicator;
- (UIScrollView *(^)(BOOL))b_bounces;

@end

