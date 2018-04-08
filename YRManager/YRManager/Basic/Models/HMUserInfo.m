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
//  HMUserInfo.m
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMUserInfo.h"


@implementation HMUserInfo

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.currentDate = [aDecoder decodeObjectForKey:@"currentDate"];
        self.deptName = [aDecoder decodeObjectForKey:@"deptName"];
        self.employeeNo = [aDecoder decodeObjectForKey:@"employeeNo"];
        self.entryDate = [aDecoder decodeObjectForKey:@"entryDate"];
        self.headImg = [aDecoder decodeObjectForKey:@"headImg"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.personId = [aDecoder decodeObjectForKey:@"personId"];
        self.ownerGuid = [aDecoder decodeObjectForKey:@"ownerGuid"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.currentDate forKey:@"currentDate"];
    [aCoder encodeObject:self.deptName forKey:@"deptName"];
    [aCoder encodeObject:self.employeeNo forKey:@"employeeNo"];
    [aCoder encodeObject:self.entryDate forKey:@"entryDate"];
    [aCoder encodeObject:self.headImg forKey:@"headImg"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.personId forKey:@"personId"];
    [aCoder encodeObject:self.ownerGuid forKey:@"ownerGuid"];
}


@end

@implementation HMUserInfo (BusinessLogic)

- (NSArray *)OrderedProperties
{
    NSArray *array = @[
                       self.name,
                       self.sex,
                       self.mobile,
                       @"",//身份证
                       self.employeeNo,
                       self.deptName,
                       @"",//岗位
                       self.personId,
                       self.entryDate,
                       @"arrow_06",//修改密码
                       ];
    
    return array;
}

+ (instancetype)getLocalUserInfo;{
    
    NSData *data = [kUserDefault objectForKey:kUserInfoKey];
    HMUserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return userInfo;
}

@end
