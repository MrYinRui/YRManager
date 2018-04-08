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
//  HMBasicVC.h
//  HotelManage
//
//  Created by xun on 17/2/21.
//  Copyright © 2017年 Xun. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void (^CallBack)(NSDictionary * dict);


@interface HMBasicVC : UIViewController

@property (nonatomic, strong) UIView *navItemView;
@property (nonatomic, strong ,readonly) UILabel *titleLab;
@property (nonatomic, strong) UIButton *backBBI;

/**
 设置导航栏标题和返回按钮
 
 @param title 标题
 */
- (void)setNavigationItemBackBBIAndTitle:(NSString *)title;
- (void)setTitle:(NSString *)title;

//设置标题的颜色和字体 (传入需要改变的部分字符)
- (void)setTitleColor:(NSString *)title Color:(UIColor *)color Font:(UIFont *)font;

/**
 设置导航栏标题和自定义返回按钮名字
 
 @param backName 自定义返回名
 @param title    标题
 */
- (void)setNavigationItemBackBBI:(NSString *)backName AndTitle:(NSString *)title;

/**
 设置导航栏两侧视图
 
 @param views 视图数组
 */
- (void)addRightViews:(NSArray *)views;
- (void)addLeftViews:(NSArray *)views;


/**
 初始化UI界面，由子类实现，父类调用
 */
- (void)initUI;
- (void)initData;

/**
 返回上一层界面
 */
- (void)backToLastVC;

/**
 push到指定的vc
 */
-(void)pushVC:(NSString *)controllerName :(BOOL)animated;

/**
 pushVC加强
 @param controllerName 控制器名称
 @param animated 是否开启动画
 @param data 传输数据
 @param callBack 返回block的数据
 */
-(void)pushVC:(NSString *)controllerName :(BOOL)animated :(NSArray *)data AndBlock:(CallBack *)callBack;

/**
 pop到指定的vc，如果堆栈中不存在，就push到该vc
 */
-(void)popVC:(NSString *)controllerName :(BOOL)animated;


/**
 移除navItemView
 */
- (void)removeNavItemView;

/**
 适配iPhoneX 填充底部为灰色
 */
- (void)fillBottomView;

@end
