//
//  HTTPAPI.h
//  GoFun
//
//  Created by xun on 16/4/13.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMImageFile.h"

typedef NS_ENUM(int, RequestType)
{
    POST,
    GET
};

/** HTTP请求成功回调  */
typedef void (^SuccessBlock)(NSURLSessionDataTask *dataTask, id dataObj);
/** HTTP请求失败回调  */
typedef void (^FailedBlock)(NSURLSessionDataTask *dataTask, NSError *error);

@class HTTPAPI;
@class UIView;

@protocol HTTPAPIDelegate <NSObject>

@required

/**
 *  从服务器请求数据成功回调方法
 *
 *  @param data 从服务器获取的数据
 *  @param api  请求对象
 */
- (void)fetchData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api;

/**
 *  从服务器请求数据失败回调方法
 *
 *  @param error 错误详情
 *  @param api  请求对象
 */
- (void)fetchDataFromServerFailedWithError:(NSError *)error API:(HTTPAPI *)api;

@optional
/**
 *  从服务器请求数据成功回调方法
 *
 *  @param data 从服务器获取的原数据
 *  @param api  请求对象
 */
- (void)fetchOriginData:(id)data fromServerSuccessedWithAPI:(HTTPAPI *)api;

@end

@interface HTTPAPI : NSObject

@property (weak, nonatomic) id <HTTPAPIDelegate> delegate;//!<代理

@property (strong, nonatomic) NSDictionary *parameters;     //!<请求参数
@property (strong, nonatomic) NSString *methodName;         //!<请求方法名称
@property (strong, nonatomic) NSString *serverAddr;         //!<服务器地址
@property (strong, nonatomic) NSString *serverPort;         //!<服务器端口
@property (strong, nonatomic) NSString *url;                //!<统一资源定位符

@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (assign, nonatomic) RequestType requestType;      //!<请求方法


@property (nonatomic, assign) BOOL isPromptErrorMessage;//!< 是否浮现服务端Error Description 默认YES

/**
 网络请求
 
 @param type 请求类型
 */
- (void)sendRequestToServerWithType:(RequestType)type;


/**
 网络请求
 
 @param type 请求类型
 @param view 活动指示器所在视图
 */
- (void)sendRequestToServerWithType:(RequestType)type
        showActivityIndicatorOnView:(UIView *)view;


/**
 网络请求，活动指示器居中显示，带蒙版效果
 
 @param type 请求类型
 */
- (void)sendRequestToServerWithActivityViewAndMask:(RequestType)type;


/**
 *  工厂方法初始化当前请求对象以及设置代理
 *
 *  @param object api代理对象
 *
 *  @return 当前实例
 */
+ (instancetype)apiWithDelegate:(id <HTTPAPIDelegate>)object;

/**
 *  表单形式向服务器发送图片
 *
 *  @param imageData    图片二进制数据
 *  @param successBlock 成功回调Block
 *  @param failedBlock  失败回调Block
 */
+ (void)sendServerImageData:(NSData *)imageData
               successBlock:(SuccessBlock)successBlock
                failedBlock:(FailedBlock)failedBlock;

/**
 表单形式向服务器发送图片
 
 @param imageFiles      上传的图片数组
 @param isToTotalSystem 图片是否上传主系统
 @param successBlock    成功回调Block
 @param failedBlock     失败回调Block
 */
+ (void)sendServerImageFiles:(NSArray<HMImageFile *> *)imageFiles
             isToTotalSystem:(IsToTotalSystem)isToTotalSystem
                successBlock:(SuccessBlock)successBlock
                 failedBlock:(FailedBlock)failedBlock;

/**
 *  HTTP请求
 *
 *  @param requestType  请求类型
 *  @param method       请求方法
 *  @param successBlock 成功回调
 *  @param failedBlock  失败回调
 *
 *  @return 本次请求的dataTask
 */
+ (NSURLSessionDataTask *)requestWithRequestType:(RequestType)requestType
                                          method:(NSString *)method
                                      parameters:(NSDictionary *)parameters
                                    successBlock:(SuccessBlock)successBlock
                                     failedBlock:(FailedBlock)failedBlock;

/**
 *  GET请求
 *
 *  @param URLString  请求链接
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

/**
 *  POST请求
 *
 *  @param URLString  请求链接
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

@end

extern NSString * const ErrorDescriptionKey;            //!<返回错误描述
extern const int RequestSuccessReturnCode;              //!<请求成功编码
extern const int RequestWithoutLoginReturnCode;         //!<请求没有登录
extern const int RequestWithVerifyCodeFrequently;       //!<发送验证码频繁
extern const int RequestWithIncorrectPhoneNumber;       //!<手机号码错误
extern const int RequestWithoutRelationDataReturnCode;  //!<服务器没有相关数据
extern const int RequestPhotoCompareResultNotPass;      //!<图片对比不通过
