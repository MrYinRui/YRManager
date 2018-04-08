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
//  HMLodger.h
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMCredentials.h"
//#import "HMCertify.h"

@class HMMember;

typedef enum
{
    IDCard = 11,
    Passport = 14,
    TaiwanCompatriotEntryPermit = 16,
    HongKong_MacaoReturnHomePermit = 60,
    ChinaPassPort = 93,
    DriversLicense = 94,
    HongKongAndMacaoPassPermit = 95,
    
    UnknowCredentials = 0xfffffff
}CredentialsCode;

typedef enum {
    
    UploadStatusTouristSystem = 100 //!<上传至旅业系统
    
}UploadStatus;

typedef NSDictionary BleUserInfo;

@interface HMLodger : NSObject

@property (nonatomic, copy) NSString *name;         //!<姓名
@property (nonatomic, copy) NSString *birthday;     //!<生日
@property (nonatomic, copy) NSString *phone;        //!<手机号
@property (nonatomic, copy) NSString *age;          //!<年龄

@property (nonatomic, copy) NSString *sex;          //!<性别
@property (nonatomic, copy) NSString *address;      //!<地址
@property (nonatomic, copy) NSString *idImg;        //!<身份证照片
@property (nonatomic, copy) NSString *nation;       //!<民族
@property (nonatomic, copy) NSString *idNum;        //!<身份证号

@property (nonatomic, copy) NSString *isDataFull;   //!<资料是否齐全
@property (nonatomic, copy) NSString *isRepeat;     //!<是否重复入住
@property (nonatomic, copy) NSString *country;      //!<国家编号

@property (nonatomic, copy) NSString *csId;

@property (nonatomic, copy) NSString *guid;         //!<主键
@property (nonatomic, copy) NSString *vipGuid;      //!<会员Guid
@property (nonatomic, copy) NSString *source;       //!<来源，0:手动输入,1:手机拍照,2:手机蓝牙扫描,3:PC端系统扫描,4:已认证 5:历史入住人
@property (nonatomic, copy) NSString *email;        //!<邮箱
@property (nonatomic, assign)NSInteger area;        //!<(1.境内, 0.境外)

@property (nonatomic, assign) NSUInteger idStatus;  //!<身份证状态(1.发起认证邀请2.待审核3.审核失败4.审核成功6.待核实7.核实失败8.核实成功)
@property (nonatomic, copy) NSString *areaCode;     //!<国家、地区编号
@property (nonatomic, copy) NSString *firstName;    //!<姓
@property (nonatomic, copy) NSString *secondName;   //!<名
@property (nonatomic, assign) CredentialsCode credentialsCode;//!<证件类型代码
@property (nonatomic, copy) NSString *credentialsName;//!<证件名称

@property (nonatomic, copy) NSString *creImg;       //!<证件照片
@property (nonatomic, copy) NSString *orderGuid;    //!<订单guid
@property (nonatomic, assign) BOOL isDefault;       //!<是否默认入住人

@property (nonatomic, copy) NSString *checkInDate;  //!<入住日期
@property (nonatomic, copy) NSString *checkOutDate; //!<截止时间
@property (nonatomic, assign) UploadStatus uploadStatus;     //!<上传状态

@property (nonatomic, copy) NSString *verifyImg;//!<核实照片
@property (nonatomic, copy) NSString *checkinImg;//!<入住照片

@property (nonatomic, copy) NSString *approveTime;//!<证件录入时间

@property (nonatomic, copy) NSString *memberGuid;//!<会员Guid
@property (nonatomic, copy) NSString *memberLevelName;//!<会员级别（当时）
@property (nonatomic, assign) NSInteger memberDiscount;//!<会员折扣（当时）
@property (nonatomic, strong) HMMember *member;//!<会员

@property (nonatomic, copy) NSString *operateName;//!<操作人姓名
@property (nonatomic, copy) NSString *operateTime;//!<操作时间(yyyy-MM-dd HH:mm:ss)

@property (nonatomic, copy) NSString *memberStatus;//!<是否会员 1是，搜索会员VC用到

@property (nonatomic, assign) BOOL  isGroupMember;  //!<是否为待分配团员 团房管理使用

//编辑业主 控制属性
@property (nonatomic, assign) BOOL isEditingLodger;//!< 是否正在编辑

@end


@interface HMLodger (BusinessLogic)

@property (nonatomic, assign) BOOL checkedMobile;       //!<是否验证过手机
@property (nonatomic, assign) BOOL checkinWithoutMobile;//!<无手机入住
@property (nonatomic, strong) UIImage *headerImage;

- (NSString *)birthYear;
- (NSString *)birthMonth;
- (NSString *)birthDay;

+ (instancetype)lodgerWithBleUserInfo:(BleUserInfo *)userInfo;

- (void)updateLodgerWithLodger:(HMLodger *)tmpLodger;

- (HMCredentials *)credentials;


@end


