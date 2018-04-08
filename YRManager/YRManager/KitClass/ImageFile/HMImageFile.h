//
//  HMImageFile.h
//  HotelManager-Pad
//
//  Created by Seven on 2016/12/14.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ImageSubPath) {
    ImageSubPathChatMp3,                //!<聊天语音
    ImageSubPathChatImage,              //!<聊天图片
    ImageSubPathHeadImage,              //!<头像
    ImageSubPathIdcardImage,            //!<身份证头像
    ImageSubPathPersonalphoto,          //!<个人自拍照
    ImageSubPathIdentificationphoto,    //!<证件全图
    ImageSubPathAttachment,             //!<订单附件
    ImageSubPathMembers,                //!<会员
    ImageSubPathServices,               //!< 酒店服务
    ImageSubPathNonCashChangeProblem,   //!<非现转问题单
    
    ImageSubPathProprietor,             //!< 业主图
    ImageSubPathProprietorWithdraw,     //!< 业主提现
    ImageSubPathHouse,                  //!< 房屋
    ImageSubPathProblemOrderOperation,  //!< 问题单处理
    ImageSubPathTallyBook,              //!< 记账簿
    ImageSubPathProtocolUnit,           //!< 协议单位
    ImageSubPathCheckRoom,              //!< 查房-图片
    
};

typedef NS_ENUM(NSInteger, IsToTotalSystem) {
    IsToTotalSystemDefault,     //!<默认
    IsToTotalSystemSend,        //!<上传主系统
    IsToTotalSystemNotSend,      //!<不上传主系统
};
//t2410
#define kImageSubPathChatMp3Key @"chat/amr"
#define kImageSubPathChatImageKey @"chat/img"
#define kImageSubPathHeadImageKey @"headImages"
#define kImageSubPathIdcardImageKey @"idcard-images"
#define kImageSubPathPersonalphotoKey @"personal-photos"
#define kImageSubPathIdentificationphotoKey @"identification-photo"
#define kImageSubPathAttachmentKey @"t2410" //!<订单附件
#define kImageSubPathMembers @"members" //!<会员
#define kImageSubPathServices @"services" //!< 酒店服务
#define kImageSubPathNonCashChangeProblemKey @"t2717" //!<非现转问题单

#define kImageSubPathProprietorKey @"t2388" //!< 业主图
#define kImageSubPathProprietorWithdrawKey @"t2388/cashin" //!< 业主提现
#define kImageSubPathHouseKey @"t2394" //!< 房屋
#define kImageSubPathProblemOrderOperationKey @"t2721" //!< 问题单处理
#define kImageSubPathTallyBookKey @"bookkeeping" //!< 记账簿
#define kImageSubPathProtocolUnitKey @"t2594" //!< 协议单位
#define kImageSubPathCheckRoomKey @"checks/photo" //!< 查房-图片

#define kVideoSubPathCheckRoomKey @"checks/media" //!< 查房-视频
#define kVoiceSubPathCheckRoomKey @"checks/sound" //!< 查房-声音


@interface HMImageFile : NSObject

@property (nonatomic, assign) ImageSubPath subPath;//!<文件子路径(必填)
@property (nonatomic, strong) NSData *imageData;//!<图片(必填)
@property (nonatomic, copy) NSString *fileName;//!<文件名
@property (nonatomic, assign) IsToTotalSystem isToSystem;//!<是否上传主系统

+ (NSArray *)imagePathFromServerWithResult:(NSDictionary *)result;

@end
