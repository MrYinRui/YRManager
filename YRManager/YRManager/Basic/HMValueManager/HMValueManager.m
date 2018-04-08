//
//  HMValueManager.m
//  HotelManager
//
//  Created by kqz on 17/3/24.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "HMValueManager.h"
#import <objc/runtime.h>

@interface HMValueManager ()

@end

@implementation HMValueManager

+ (instancetype)shareManager
{
    static HMValueManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[super allocWithZone:NULL] init];
    });
    
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self shareManager];
}

@end


#define kAssociateRoomStatusOrderKey     "ASSOCIATE_ROOM_STATUS_ORDER_KEY"
@implementation HMValueManager (HMRoomStatusBottomVC)

-(void)setRoomStatusOrder:(HMOrder *)roomStatusOrder
{
    objc_setAssociatedObject(self, kAssociateRoomStatusOrderKey, roomStatusOrder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(HMOrder *)roomStatusOrder
{
    return objc_getAssociatedObject(self, kAssociateRoomStatusOrderKey);
}

@end

#import <objc/runtime.h>
#import "HMCredentials.h"
#import "HMLodger.h"
#import "WintoneCardOCR.h"

#define kAssociateCredetialsKey "ASSOCIATE_CREDENTIALS_KEY"
#define kAssociateLodgerKey     "ASSOCIATE_LODGER_KEY"
#define kAssociateOrderKey      "ASSOCIATE_ORDER_KEY"
#define kAssociateCardOCRKey      "ASSOCIATE_CARDOCR_KEY"
#define kAssociateAddLodgerTypeKey      "ASSOCIATE_ADD_LODGER_TYPE_KEY"
#define kAssociateIsAddMemberKey      "ASSOCIATE_ADD_MEMBER_KEY"
#define kAssociateIsFromCompareResultVCKey      "ASSOCIATE_FROM_CompareResultVC_KEY"
#define kAssociateIsGroupMemberKey      "ASSOCIATE_GROUP_MEMBER_KEY"
#define kAssociateGroupGuidKey          "ASSOCIATE_GROUP_GUID_KEY"

@implementation HMValueManager (Credentials)

@dynamic shareCredentials;

- (void)setShareCredentials:(HMCredentials *)shareCredentials {
    objc_setAssociatedObject(self, kAssociateCredetialsKey, shareCredentials, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HMCredentials *)shareCredentials {
    return objc_getAssociatedObject(self, kAssociateCredetialsKey);
}

- (void)setLodger:(HMLodger *)lodger {
    objc_setAssociatedObject(self, kAssociateLodgerKey, lodger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HMLodger *)lodger {
    return objc_getAssociatedObject(self, kAssociateLodgerKey);
}

- (void)setOrder:(HMOrder *)order {
    objc_setAssociatedObject(self, kAssociateOrderKey, order, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HMOrder *)order {
    return objc_getAssociatedObject(self, kAssociateOrderKey);
}

-(void)setWintoneCardOCR:(WintoneCardOCR *)wintoneCardOCR {
    objc_setAssociatedObject(self, kAssociateCardOCRKey, wintoneCardOCR, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WintoneCardOCR *)wintoneCardOCR {
    return objc_getAssociatedObject(self, kAssociateCardOCRKey);
}

- (void)setAddLodgerType:(AddLodgerType)addLodgerType {
    objc_setAssociatedObject(self, kAssociateAddLodgerTypeKey, @(addLodgerType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AddLodgerType)addLodgerType {
    return [objc_getAssociatedObject(self, kAssociateAddLodgerTypeKey) integerValue];
}

- (void)setIsAddMember:(BOOL)isAddMember {
    objc_setAssociatedObject(self, kAssociateIsAddMemberKey, @(isAddMember), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAddMember {
    return [objc_getAssociatedObject(self, kAssociateIsAddMemberKey) boolValue];
}

- (void)setIsFromCompareResultVC:(BOOL)isFromCompareResultVC {
    objc_setAssociatedObject(self, kAssociateIsFromCompareResultVCKey, @(isFromCompareResultVC), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isFromCompareResultVC {
    return [objc_getAssociatedObject(self, kAssociateIsFromCompareResultVCKey) boolValue];
}

- (void)setIsGroupMember:(BOOL)isGroupMember
{
    objc_setAssociatedObject(self, kAssociateIsGroupMemberKey, @(isGroupMember), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isGroupMember
{
    return [objc_getAssociatedObject(self, kAssociateIsGroupMemberKey) boolValue];
}

- (void)setGroupGuid:(NSString *)groupGuid
{
    objc_setAssociatedObject(self, kAssociateGroupGuidKey, groupGuid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)groupGuid
{
    return objc_getAssociatedObject(self, kAssociateGroupGuidKey);
}

@end

#import "HMHotelParameterModel.h"
#define kAssociateHotelParameterKey     "ASSOCIATE_HOTEl_PARAMETER_KEY"

@implementation HMValueManager (HotelParameter)

-(void)setHotelParameter:(HMHotelParameterModel *)hotelParameter
{
    objc_setAssociatedObject(self, kAssociateHotelParameterKey, hotelParameter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(HMHotelParameterModel *)hotelParameter
{
    return objc_getAssociatedObject(self, kAssociateHotelParameterKey);
}
@end

#define kAssociateCurrentTimeKey  "ASSOCIATE_CURRENT_TIME_KEY"
#define kAssociateMoveTimeKey     "ASSOCIATE_MOVE_TIME_KEY"

@implementation HMValueManager (date)

-(void)setCurrentTime:(NSString *)currentTime
{
        objc_setAssociatedObject(self, kAssociateCurrentTimeKey, currentTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)currentTime
{
    return objc_getAssociatedObject(self, kAssociateCurrentTimeKey);
}

-(void)setMoveTime:(NSInteger)moveTime
{
    NSString *time = [NSString stringWithFormat:@"%zd",moveTime];
        objc_setAssociatedObject(self, kAssociateMoveTimeKey, time, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSInteger)moveTime
{
    NSString *time = objc_getAssociatedObject(self, kAssociateMoveTimeKey);
    return time.integerValue;
}

@end


