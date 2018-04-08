//
//  HMDropDownView.m
//  HotelManager
//
//  Created by kqz on 2018/1/12.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMDropDownView.h"

@interface HMDropDownView()

@property (nonatomic, strong) NSArray *imageNameArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) CGPoint viewPoint;//!<白色view的起始位置

@end

@implementation HMDropDownView

-(instancetype)initWihtIconArr:(NSArray *)imageNameArr TitleArr:(NSArray *)titleArr AndPoint:(CGPoint)point
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)])
    {
        _imageNameArr = imageNameArr;
        _titleArr = titleArr;
        _viewPoint = point;
        [self initUI];
    }
    return self;
}

#pragma mark - event
-(void)clickedBgBtn:(UIButton *)sender
{
    [self removeFromSuperview];
}

-(void)clickedTitleBtn:(UIButton *)sender
{
    !_selectNumBlcok ?: _selectNumBlcok(sender.tag);
    [self removeFromSuperview];
}

#pragma mark - initUI
-(void)initUI
{
    if (self.titleArr.count == 0) return;
    
    UIButton *bgBtn =
    ({
        bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        bgBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [bgBtn addTarget:self action:@selector(clickedBgBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        bgBtn;
    });
    
    UIView *whiteView =
    ({
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(self.viewPoint.x, self.viewPoint.y, kScaleNum(120), kScaleNum(13 + self.titleArr.count * 40))];
        [self addSubview:whiteView];
        whiteView;
    });
    
    UIImageView *upArrow =
    ({
        upArrow = [[UIImageView alloc] initWithFrame:LPRectMake(87, 0, 20, 8)];
        upArrow.image = [UIImage imageNamed:@"menu-arrow"];
        [whiteView addSubview:upArrow];
        upArrow;
    });
    
    UIView *bgView =
    ({
        bgView = [[UIView alloc] initWithFrame:LPRectMake(0, 8, 120, self.titleArr.count * 40 + 5)];
        bgView.layer.cornerRadius = kScaleNum(5);
        bgView.layer.masksToBounds = YES;
        bgView.backgroundColor = [UIColor whiteColor];
        [whiteView addSubview:bgView];
        bgView;
    });
    
    for (int i = 0; i < self.titleArr.count; i++)
    {
        UIImageView *imageView =
        ({
            imageView = [[UIImageView alloc] initWithFrame:LPRectMake(10, 12 + 40 * i, 16, 16)];
            imageView.image = [UIImage imageNamed:self.imageNameArr[i]];
            [bgView addSubview:imageView];
            imageView;
        });
        
        UIButton *titleBtn =
        ({
            titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.frame = LPRectMake(0, i * 40, 120, 40);
            [titleBtn setTitle:self.titleArr[i] forState:UIControlStateNormal];
            titleBtn.titleLabel.font = kFont(15);
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            titleBtn.titleEdgeInsets = kEdgeInsetsMake(0, 40, 0, 0);
            titleBtn.tag = i;
            [titleBtn addTarget:self action:@selector(clickedTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:titleBtn];
            titleBtn;
        });
        
        if (i == self.titleArr.count - 1) break;

        UIView *line =
        ({
            line = [[UIView alloc] initWithFrame:LPRectMake(10, 39 + 40 * i, 110, 1)];
            line.backgroundColor = kColor(233, 233, 237, 1);
            [bgView addSubview:line];
            line;
        });
    }
}

@end
