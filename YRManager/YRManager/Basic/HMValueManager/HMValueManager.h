//
//  HMValueManager.h
//  HotelManager
//
//  Created by kqz on 17/3/24.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>
// 添加入住人的方法
typedef NS_ENUM(NSInteger, AddLodgerType) {
    AddLodgerTypeAdd,       //!<添加入住人
    AddLodgerTypeUpdate,    //!<更新入住人
    AddLodgerTypeReplace,   //!<变更入住人(替换)
};

@class HMOrder, HMLodger, HMCredentials, WintoneCardOCR ,HMHotelParameterModel;

/**
 *  该类不存在任何业务逻辑处理，只有一个单例方法，维护自身的内存在App中始终存在。
 *
 *  程序员若想使用该类进行数据共享，请在扩展里面自定义属性，若不再用，请自行释放，保证该类内存稳定
 */

@interface HMValueManager : NSObject

@property (nonatomic, strong) dispatch_source_t timer; //!<定时器
@property (nonatomic, assign) __block NSInteger time;

+ (instancetype)shareManager;

@end

@interface HMValueManager (HMRoomStatusBottomVC)

@property (nonatomic, strong) HMOrder *roomStatusOrder;

@end

@interface HMValueManager (Credentials)

@property (nonatomic, strong) HMCredentials *shareCredentials;

@property (nonatomic, strong) HMLodger *lodger;

@property (nonatomic, strong) HMOrder *order;

@property (nonatomic, strong) WintoneCardOCR *wintoneCardOCR;

@property (nonatomic, assign) AddLodgerType addLodgerType;

@property (nonatomic, assign) BOOL  isAddMember;

@property (nonatomic, assign) BOOL isFromCompareResultVC;// 是否从HMCompareResultVC进入HMRecordLodgerVC

@property (nonatomic, assign) BOOL isGroupMember;

@property (nonatomic, strong) NSString *groupGuid;      //!<添加团员是团房guid

@end

@interface HMValueManager (HotelParameter)

@property (nonatomic, strong) HMHotelParameterModel *hotelParameter;

@end

@interface HMValueManager (date)//时间管理

@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, assign) NSInteger moveTime;//秒数

@end
