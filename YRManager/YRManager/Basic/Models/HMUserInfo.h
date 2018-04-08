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
//  HMUserInfo.h
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMUserInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString *currentDate;  //!<当前日期
@property (nonatomic, copy) NSString *deptName;     //!<eg.总经办 部门
@property (nonatomic, copy) NSString *employeeNo;   //!<岗位系数
@property (nonatomic, copy) NSString *entryDate;    //!<入职日期
@property (nonatomic, copy) NSString *headImg;      //!<头像URL
@property (nonatomic, copy) NSString *mobile;       //!<手机
@property (nonatomic, copy) NSString *name;         //!<姓名
@property (nonatomic, copy) NSString *personId;     //!<工号
@property (nonatomic, copy) NSString *sex;          //!<性别
@property (nonatomic, copy) NSString *userId;       //!<用户Id
@property (nonatomic, copy) NSString *ownerGuid;    //!<业主id


@end


@interface HMUserInfo(BusinessLogic)

- (NSArray *)OrderedProperties;

+ (instancetype)getLocalUserInfo;

@end
