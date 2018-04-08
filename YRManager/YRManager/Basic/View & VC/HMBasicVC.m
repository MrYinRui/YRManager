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
//  HMBasicVC.m
//  HotelManage
//
//  Created by xun on 17/2/21.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMBasicVC.h"
#import "UILabel+NSMutableAttributedString.h"
#import "HMJumpManager.h"
#import <sys/utsname.h>

#define kBackGroundViewHeight 65
#define kNavItemViewHeight 45

@interface HMBasicVC ()

@property (nonatomic, assign) CGFloat statusHeight;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic, strong ,readwrite) UILabel *titleLab;

@end

@implementation HMBasicVC

#pragma mark - view controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.statusHeight = StatusHeight-44;
    
    UIView *statusView = [UIView new];
    statusView.frame = LPRectMake(0, 0, kBaseScreenWidth, self.statusHeight);
    statusView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusView];
    self.statusView = statusView;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initData];
    [self initUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Interface Method

- (void)setNavigationItemBackBBIAndTitle:(NSString *)title
{
    [self setTitle:title];
    [self.navItemView addSubview:self.backBBI];
}
- (void)setNavigationItemBackBBI:(NSString *)backName AndTitle:(NSString *)title
{
    [self setTitle:title];
    [self.navItemView addSubview:[self backBBIWithName:backName]];
}
- (void)setTitle:(NSString *)title
{
    [self.navItemView addSubview:self.titleLab];
    self.titleLab.text = title;
}

- (void)setTitleColor:(NSString *)title Color:(UIColor *)color Font:(UIFont *)font
{
    [self.titleLab setAttributedStringWithSubString:title color:color font:font];
}

- (void)backToLastVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRightViews:(NSArray *)views
{
    CGFloat startX = ScreenWidth;
    for (UIView *subview in views)
    {
        startX -= subview.width;
        subview.origin = CGPointMake(startX, 0);
        [self.navItemView addSubview:subview];
    }
}

- (void)addLeftViews:(NSArray *)views
{
    CGFloat startX = 0;
    
    for (UIView *subview in views)
    {
        [self.navItemView addSubview:subview];
        subview.x = startX;
        startX += subview.width;
    }
}

- (void)initUI
{
    
}

- (void)initData
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - lazy init

- (UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
        _backGroundView.backgroundColor = kColor(81, 80, 73, 1);
        _backGroundView.frame = LPRectMake(0, 0, kBaseScreenWidth, kBackGroundViewHeight);
        [self.view addSubview:_backGroundView];
    }
    return _backGroundView;
}

- (UIView *)navItemView
{
    if (! _navItemView)
    {
        _navItemView = [UIView new];
        _navItemView.backgroundColor = kColor(81, 80, 73, 1);
        _navItemView.frame = LPRectMake(0, self.statusHeight, kBaseScreenWidth, kNavItemViewHeight);
        [self.backGroundView addSubview:_navItemView];
    }
    return _navItemView;
}

- (UILabel *)titleLab
{
    if (! _titleLab)
    {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = kBFont(20);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.frame = LPRectMake(40, 0, kBaseScreenWidth - 80, kNavItemViewHeight);
    }
    return _titleLab;
}

- (UIButton *)backBBI
{
    if (! _backBBI)
    {
        _backBBI = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBBI setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
        [_backBBI addTarget:self action:@selector(backToLastVC) forControlEvents:UIControlEventTouchUpInside];
        _backBBI.titleLabel.font = kFont(18);
        _backBBI.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _backBBI.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _backBBI.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _backBBI.frame = LPRectMake(0, 0, 80, kNavItemViewHeight);
    }
    return _backBBI;
}

- (UIButton *)backBBIWithName:(NSString *)name
{
    UIButton  *customButton = [self backBBI];
    [customButton setTitle:name forState:UIControlStateNormal];
    return customButton;
}

- (UIButton *)backBtn
{
    return self.backBBI;
}

-(void)pushVC:(NSString *)controllerName :(BOOL)animated
{
    [self.navigationController pushViewController:(UIViewController *)[NSClassFromString(controllerName) new] animated:animated];
}

-(void)pushVC:(NSString *)controllerName :(BOOL)animated :(NSArray *)data AndBlock:(__autoreleasing CallBack *)callBack
{
    HMJumpManager *manager = [HMJumpManager new];
    manager.controller = self;
    [manager pushVC:controllerName Animated:YES Data:data AndBlock:callBack];
}

-(void)popVC:(NSString *)controllerName :(BOOL)animated
{
    NSArray *temArray = self.navigationController.viewControllers;
    BOOL pop = NO; //!<记录是否已经跳转
    for(UIViewController *temVC in temArray)
    {
        if ([temVC isKindOfClass:NSClassFromString(controllerName)])
        {
            pop = YES;
            [self.navigationController popToViewController:temVC animated:animated];
        }
    }
    
    if (!pop)
    {
        [self pushVC:controllerName :animated];
    }
}

- (void)removeNavItemView {
    
    [self.backGroundView removeFromSuperview];
    [self.statusView removeFromSuperview];
}

- (void)fillBottomView
{
    if (KIsiPhoneX)
    {
        UIView *bottomView  =
        ({
            bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kScaleNum(34), kScreenWidth, kScaleNum(34))];
            bottomView.backgroundColor = kGrayColor;
            [self.view addSubview:bottomView];
            bottomView;
        });
    }
}

-(void)dealloc
{
    HMLog(@"%@ 控制器已经被释放",NSStringFromClass([self class]));
}

@end
