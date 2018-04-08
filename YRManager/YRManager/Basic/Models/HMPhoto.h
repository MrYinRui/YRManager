//
//  HMPhoto.h
//  HotelManager
//
//  Created by YR on 2017/4/26.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPhoto : NSObject

@property (nonatomic, copy) NSString *guid;             //!<主键GUID
@property (nonatomic, copy) NSString *path;             //!<图片路径
@property (nonatomic, copy) NSString *type1;
//!<大类(A.酒店总图 B.楼层图 C.房型图 D.房间图 E.服务项目图 F.酒店平面图 G.房间故事图 Y.住客通首页图 Z.住客通登录图)
@property (nonatomic, copy) NSString *type2;            //!<中类
@property (nonatomic, copy) NSString *type3;            //!<小类

@property (nonatomic, copy) NSString *upTime;           //!<上传时间
@property (nonatomic, copy) NSNumber *picSize;          //!<图片大小
@property (nonatomic, copy) NSString *status;           //!<状态
@property (nonatomic, copy) NSString *picNum;           //!<图片编号
@property (nonatomic, copy) NSString *connectGuid;      //!<关联Id

@property (nonatomic, copy) NSNumber *sync_status;      //!<同步状态
@property (nonatomic, copy) NSNumber *cover;            //!<是否设为封面
@property (nonatomic, copy) NSString *hotelId;          //!<cs_id
@property (nonatomic, copy) NSNumber *picSeq;           //!<图片序号

@end
