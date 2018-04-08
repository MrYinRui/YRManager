//
//  HMMember.m
//  HotelManager
//
//  Created by r on 17/6/20.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMMember.h"
#import "MJExtension.h"
#import "HMLodger.h"
#import "HMMemberLevelInfo.h"

@implementation HMMember

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"memberGuid":@"memberId",
             @"memberLevelInfo":@"memberLevelSet",
             @"birthday":@"borth",
             @"source":@"identityInfoFrom",
             @"memberPoints":@"integral",
             @"idCardNum":@"idCard",
             @"phone":@"mobile",};
    
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"memberLevelInfo"  :   [HMMemberLevelInfo class]
             };
}

- (void)getValueFromLodger:(HMLodger *)lodger {

    self.name = lodger.name;
    self.sex = lodger.sex;
    self.phone = lodger.phone;
    self.idCardNum = lodger.idNum;
    self.birthday = lodger.birthday;
    self.country = lodger.country;
    self.address = lodger.address;
    self.idCardImg = lodger.idImg;
    self.nation = lodger.nation;
    self.idCardType = @(lodger.credentialsCode).stringValue;
    
    //后添加
    self.memberGuid = lodger.memberGuid;
    self.csId = lodger.csId;
    self.source = lodger.source;
    self.memberStatus = lodger.memberStatus;
    self.memberLevel = lodger.memberLevelName;
    self.areaCode = lodger.areaCode;
    self.type = @(lodger.area).stringValue;
    
//    self.idcardPhoto = lodger.
}

- (NSString *)credentialsName
{
    switch (_idCardType.integerValue)
    {
        case IDCard:
            return @"二代身份证";
        case Passport:
            return @"护照";
        case TaiwanCompatriotEntryPermit:
            return @"台胞证";
        case HongKong_MacaoReturnHomePermit:
            return @"回乡证";
        case ChinaPassPort:
            return @"中国护照";
        case DriversLicense:
            return @"驾照";
        case HongKongAndMacaoPassPermit:
            return @"港澳通行证";
        default:
            return @"无";
    }
}

- (HMLodger *)getLodger
{
    HMLodger *lodger = [HMLodger new];
    lodger.credentialsCode = (CredentialsCode)self.idCardType.integerValue;
    lodger.credentialsName = self.credentialsName;
    lodger.creImg = self.idCardPhoto;
    lodger.checkinImg = self.idCardPhoto;
    lodger.name = self.name;
    lodger.sex = self.sex;
    lodger.nation = self.nation;
    lodger.areaCode = self.country;
    lodger.birthday = self.birthday;
    lodger.address = self.address;
    lodger.idNum = self.idCardNum;
    lodger.idImg = self.idCardImg;
    lodger.phone = self.phone;
    lodger.firstName = self.firstName;
    lodger.secondName = self.secondName;
    lodger.memberGuid = self.memberGuid;
    lodger.memberDiscount = self.memberLevelInfo.discount;
    lodger.memberLevelName = self.memberLevelInfo.levelName;
    lodger.member = [HMMember new];
    lodger.member = self;
    lodger.member.memberLevelInfo = self.memberLevelInfo;
    
    return lodger;
}

- (id)copyWithZone:(NSZone *)zone {
    
    HMMember *member = [[[self class] allocWithZone:zone] init];
    member.memberGuid = self.memberGuid;
    member.memberNo = self.memberNo;
    member.name = self.name;
    member.sex = self.sex;
    member.phone = self.phone;
    member.idCardNum = self.idCardNum;
    member.birthday = self.birthday;
    member.country = self.country;
    member.city = self.city;
    member.csId = self.csId;
    member.address = self.address;
    member.idCardImg = self.idCardImg;
    member.addTime = self.addTime;
    member.nation = self.nation;
    member.source = self.source;
    member.idCardType = self.idCardType;
    member.memberStatus = self.memberStatus;
    member.memberLevel = self.memberLevel;
    member.memberSource = self.memberSource;
    member.syncStatus = self.syncStatus;
    member.remark = self.remark;
    member.memberFee = self.memberFee;
    member.creationMode = self.creationMode;
    member.rechargeAmount = self.rechargeAmount;
    member.memberPoints = self.memberPoints;
    member.isLevelLock = self.isLevelLock;
    member.idCardPhoto = self.idCardPhoto;
    member.firstName = self.firstName;
    member.secondName = self.secondName;
    member.areaCode = self.areaCode;
    member.type = self.type;
    member.isHotelApply = self.isHotelApply;
    
    member.memberLevelInfo = [self.memberLevelInfo copy];
    
    return member;
}

@end
