//
//  HMScanVC.h
//  HotelManager
//
//  Created by kqz on 2018/2/1.
//  Copyright © 2018年 samsoft. All rights reserved.
//

#import "HMBasicVC.h"

@interface HMScanVC : HMBasicVC
/*
 infoArr 二维码目前有4个参数(以后增加再补充),以下用下标表示参数
 0.代表类型(例如: 1个人信息 2早餐卷）
 1.orderGuid
 2.个人guid 可用于查询用户个人信息
 3.用户的电话
 */
@property (nonatomic, copy) void (^scanDataBlock)(NSArray *infoArr);//!<扫描成功后返回数据
-(void)closeVC;//!<移除这个VC

@end
