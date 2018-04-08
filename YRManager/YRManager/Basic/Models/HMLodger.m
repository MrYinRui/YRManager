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
//  HMLodger.m
//  HotelManager-Pad
//
//  Created by xun on 11/16/16.
//  Copyright © 2016 塞米酒店. All rights reserved.
//

#import "HMLodger.h"
#import "MJExtension.h"

@implementation HMLodger

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"name":@"xm",
             @"phone":@"lxdh",
             @"credentialsCode":@"zjlx",
             @"credentialsName":@"cardName",
             @"nation":@"mz",
             
             @"isDataFull":@"isable",
             @"isRepeat":@"sfcf",
             @"idImg":@"sfzxp",
             
             @"vipGuid":@"memberguid",
             @"area":@"type",
             @"creImg":@"grzlfj",
             @"sex":@"xb",
             
//             @"orderGuid": @"ddGuid",
             @"idNum":@"sfz",
             @"address":@"dz",
             @"birthday":@"csrq",
             
             @"isDefault":@"sfmrrzr",
             @"checkInDate":@"beginDate",
             @"checkOutDate":@"endDate",
             
             @"orderGuid":@"zbGuid",
             @"uploadStatus":@"putStatus",
             
             @"member":@"hotelMember",
             };
}


- (id)copyWithZone:(NSZone *)zone
{
    HMLodger *lodger = [[self class] allocWithZone:zone];
    
    
//    lodger.certify = [_certify copy];
    lodger.verifyImg = self.verifyImg;
    lodger.name = self.name;
    lodger.birthday = self.birthday;
    lodger.phone = self.phone;
    
    lodger.sex = self.sex;
    lodger.address = self.address;
    lodger.idImg = self.idImg;
    lodger.nation = self.nation;
    lodger.idNum = self.idNum;
    
    lodger.guid = self.guid;
    lodger.vipGuid = self.vipGuid;
    lodger.source = self.source;
    lodger.email = self.email;
    lodger.area = self.area;
    
    lodger.idStatus = self.idStatus;
    lodger.areaCode = self.areaCode;
    lodger.firstName = self.firstName;
    lodger.secondName = self.secondName;
    lodger.credentialsCode = self.credentialsCode;
    
    lodger.creImg = self.creImg;
    lodger.isDataFull = self.isDataFull;
    lodger.isRepeat = self.isRepeat;
    lodger.country = self.country;
    
    lodger.orderGuid = self.orderGuid;
    lodger.isDefault = self.isDefault;
    lodger.checkInDate = self.checkInDate;
    lodger.checkOutDate = self.checkOutDate;
    lodger.uploadStatus = self.uploadStatus;
    
    return lodger;
}


@end

#import <objc/runtime.h>
#import "HMCredentials.h"

#define kAssociateImageKey  "ASSOCIATE_IMAGE_KEY"

#define kLodgerAssociateCredentialsKey      "LODGER_ASSOCIATE_CREDENTIALS_KEY"
#define kLodgerAssociateCheckedMobileKey    "LODGER_ASSOCIATE_CHECKED_MOBILE_KEY"
#define kLOdgerAssociateCheckinWithoutMobileKEY "LODGER_ASSOCIATE_CHECKIN_WITHOUT_MOBILE_KEY"

@implementation HMLodger (BusinessLogic)

- (void)setCheckedMobile:(BOOL)checkedMobile
{
    objc_setAssociatedObject(self, kLodgerAssociateCheckedMobileKey, @(checkedMobile), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)checkedMobile
{
    return [objc_getAssociatedObject(self, kLodgerAssociateCheckedMobileKey) boolValue];
}

- (void)setCheckinWithoutMobile:(BOOL)checkinWithoutMobile
{
    objc_setAssociatedObject(self, kLOdgerAssociateCheckinWithoutMobileKEY, @(checkinWithoutMobile), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)checkinWithoutMobile
{
    return [objc_getAssociatedObject(self, kLOdgerAssociateCheckinWithoutMobileKEY) boolValue];
}

- (HMCredentials *)credentials
{
    NSUInteger CredentialsTypeId = 0;
    
    switch (self.credentialsCode)
    {
        case IDCard:
            CredentialsTypeId = kSecondIDCard;
            break;
        case DriversLicense:
            CredentialsTypeId = kDriversLicense;
            break;
        case Passport:
            CredentialsTypeId = kPassport;
            break;
        case ChinaPassPort:
            CredentialsTypeId = kPassport;
            break;
        case HongKongAndMacaoPassPermit:
            CredentialsTypeId = kHongKongAndMacaoPassPermit;
            break;
        case TaiwanCompatriotEntryPermit:
            CredentialsTypeId = kTaiwanCompatriotEntryPermit;
            break;
        case HongKong_MacaoReturnHomePermit:
            CredentialsTypeId = kReturnHomePermit;
            break;
        default:
            CredentialsTypeId = 0;
            break;
    }
    
    HMCredentials *credentials = [HMCredentials new];
    
    credentials.typeId = CredentialsTypeId;
    
    credentials.name = self.name;
    credentials.enName = self.secondName;
    credentials.enSurename = self.firstName;
    credentials.nation = self.nation;
    credentials.birthday = self.birthday;
    
    credentials.num = self.idNum;
    credentials.nationality = self.areaCode;
    credentials.sex = self.sex;
//    credentials.headImg = self.verify.imgUrl;
    credentials.img = self.creImg;
    
    credentials.address = self.address;
    
    return credentials;
}

- (NSString *)birthYear
{
    return [_birthday componentsSeparatedByString:@"-"][0];
}

- (NSString *)birthMonth
{
    return [_birthday componentsSeparatedByString:@"-"][1];
}

- (NSString *)birthDay
{
    return [_birthday componentsSeparatedByString:@"-"][2];
}

- (NSString *)credentialsName
{
    switch (self.credentialsCode)
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
            return @"无证件";
    }
}

+ (instancetype)lodgerWithBleUserInfo:(BleUserInfo *)userInfo
{
    HMLodger *lodger = [HMLodger new];
    
    lodger.idNum = userInfo[@"certNumber"];
    lodger.name = userInfo[@"partyName"];
    lodger.nation = userInfo[@"nation"];
    lodger.sex = userInfo[@"gender"];
    lodger.address = userInfo[@"certAddress"];
    lodger.credentialsCode = IDCard;
    lodger.source = @"3";
    
    NSMutableString *birthday = [NSMutableString stringWithString:userInfo[@"bornDay"]];
    
    [birthday insertString:@"-" atIndex:6];
    [birthday insertString:@"-" atIndex:4];
    
    lodger.birthday = birthday;
    
    NSData *headData = userInfo[@"bmp"];
    
    UIImage *headerImg = [UIImage imageWithData:headData];
    lodger.headerImage = headerImg;
    
    return lodger;
}

- (void)updateLodgerWithLodger:(HMLodger *)tmpLodger
{
    self.idNum = tmpLodger.idNum;
    self.name = tmpLodger.name;
    self.nation = tmpLodger.nation;
    self.sex = tmpLodger.sex;
    self.address = tmpLodger.address;
    
    self.idImg = tmpLodger.idImg;
    self.credentialsCode = tmpLodger.credentialsCode;
    self.source = @"3";
    self.birthday = tmpLodger.birthday;
    self.headerImage = tmpLodger.headerImage;
    
    tmpLodger = nil;
}

- (UIImage *)headerImage
{
    return objc_getAssociatedObject(self, kAssociateImageKey);
}

- (void)setHeaderImage:(UIImage *)headerImage
{
    objc_setAssociatedObject(self, kAssociateImageKey, headerImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *mSig = [HMLodger instanceMethodSignatureForSelector:aSelector];
    
    if (!mSig)
    {
        mSig = [HMLodger instanceMethodSignatureForSelector:@selector(doNothing)];
    }
    
    return mSig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self respondsToSelector:anInvocation.selector])
    {
        [anInvocation invoke];
    }
}

- (void)doNothing
{
    
}
@end
