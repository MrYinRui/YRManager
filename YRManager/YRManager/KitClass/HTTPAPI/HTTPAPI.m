//
//  HTTPAPI.m
//  GoFun
//
//  Created by xun on 16/4/13.
//  Copyright © 2016年 xun. All rights reserved.
//

#import "HTTPAPI.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Prompt.h"
#import <objc/runtime.h>
#import "MBProgressHUD+GoGoFun.h"
#import "LPActivityIndicatorView.h"
#import "NSObject+JsonString.h"

#import "Alert.h"


NSString * const ErrorDescriptionKey            = @"ERROR_DESCRIPTION_KEY";
const int RequestSuccessReturnCode              = 1;
const int RequestWithoutLoginReturnCode         = -1;
const int RequestWithVerifyCodeFrequently       = 3003;
const int RequestWithIncorrectPhoneNumber       = 3004;
const int RequestWithoutRelationDataReturnCode  = 0;
const int RequestPhotoCompareResultNotPass      = 4;

@interface HTTPAPI ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end

@implementation HTTPAPI

- (NSDictionary *)parameters
{
    NSArray *propertyList = [self propertyList];
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithCapacity:propertyList.count];
    for(NSString *property in propertyList)
    {
        if ([[self valueForKey:property] isKindOfClass:[NSNull class]] ||
            (![self valueForKey:property]))
        {
            continue;
        }
        else if([[self valueForKey:property] isKindOfClass:[NSArray class]] && [[self valueForKey:property] count])
        {
            mutableDict[property] = [[self valueForKey:property] jsonString];
        }
        else
        {
            [mutableDict setValue:[self valueForKeyPath:property] forKeyPath:property];
        }
    }
    return mutableDict;
}

- (NSString *)url
{
    //!<如果请求地址包含有http开头，则直接返回改地址
    if ([self.methodName rangeOfString:@"http" options:NSCaseInsensitiveSearch].length > 0)
    {
        return self.methodName;
    }
    
    if (self.serverPort.length == 0 ||
        [self.serverPort containsString:@":"])
    {
        return [NSString stringWithFormat:@"http://%@%@/%@", self.serverAddr, self.serverPort, self.methodName];
    }
    return [NSString stringWithFormat:@"http://%@:%@/%@", self.serverAddr, self.serverPort, self.methodName];
}

- (NSString *)methodName
{
    [self createExceptionWithMsg:NSStringFromSelector(_cmd)];
    return nil;
}

- (NSString *)serverAddr
{
    return [NSUserDefaults hotelHost];
}

- (NSString *)serverPort
{
    return [NSUserDefaults hotelPort];
}

#pragma mark GET 请求

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/%@",[NSUserDefaults hotelHost], [NSUserDefaults hotelPort], URLString];
    if ([URLString rangeOfString:@"http" options:NSCaseInsensitiveSearch].length > 0)
    {
        url = URLString;
    }
    
    //设置请求类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@", kSessionID] forHTTPHeaderField:@"Cookie"];
    
    [manager GET:url parameters:parameters progress:nil success:success failure:failure];
}

+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *url = [NSString stringWithFormat:@"http://%@%@/%@",[NSUserDefaults hotelHost], [NSUserDefaults hotelPort], URLString];
    if ([URLString rangeOfString:@"http" options:NSCaseInsensitiveSearch].length > 0)
    {
        url = URLString;
    }
    
    //设置请求类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil]];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@", kSessionID] forHTTPHeaderField:@"Cookie"];
    
    [manager POST:url parameters:parameters progress:nil success:success failure:failure];
}

- (void)sendRequestToServerWithType:(RequestType)type
{
    [self sendRequestToServerWithType:type showActivityIndicatorOnView:nil];
}

- (void)sendRequestToServerWithActivityViewAndMask:(RequestType)type
{
    [LPActivityIndicatorView showWithMask];
    [self sendRequestToServerWithType:type showActivityIndicatorOnView:nil];
    //    [self sendRequestToServerWithType:type showActivityIndicatorOnView:[UIApplication sharedApplication].keyWindow];
}

- (void)sendRequestToServerWithType:(RequestType)type showActivityIndicatorOnView:(UIView *)view
{
    if (view)
    {
        [LPActivityIndicatorView showOnView:view];
    }
    _requestType = type;
    self.manager.requestSerializer.timeoutInterval = 30;
    [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil]];
    
    void (^SuccessBlock)(NSURLSessionDataTask *dataTask, id dataObj) = ^(NSURLSessionDataTask *dataTask, id dataObj)
    {
        [LPActivityIndicatorView hide];
        
        //刷新时间
        HMValueManager *manger = [HMValueManager shareManager];
        if (manger.timer)
        {
            dispatch_source_cancel(manger.timer);
        }
        manger.currentTime = dataObj[@"currentTime"];
        manger.time = 0;
        [self sunTime];
        
        [self handleResponseDataObj:dataObj];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(fetchOriginData:fromServerSuccessedWithAPI:)])
        {
            [self.delegate fetchOriginData:dataObj fromServerSuccessedWithAPI:self];
        }
    };
    
    void (^FailedBlock)(NSURLSessionDataTask *dataTask, NSError *error) = ^(NSURLSessionDataTask *dataTask, NSError *error){
        
        if ([self.delegate respondsToSelector:@selector(fetchDataFromServerFailedWithError:API:)])
        {
            [LPActivityIndicatorView hide];
            [self.delegate fetchDataFromServerFailedWithError:error API:self];
            if (self.isPromptErrorMessage == YES) {
                [Prompt popPromptViewWithMsg:error.localizedDescription duration:3.f];
            }
        }
    };
    
    if (type == GET)
    {
        self.dataTask = [self.manager GET:self.url parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:SuccessBlock failure:FailedBlock];
    }
    else if (type == POST)
    {
        self.dataTask = [self.manager POST:self.url parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress){} success:SuccessBlock failure:FailedBlock];
    }
}

//计时器
- (void)sunTime//计算秒数
{
    time_t beginInterval;
    time(&beginInterval);
    
    HMValueManager *manger = [HMValueManager shareManager];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    manger.timer = timer;
    //每秒执行一次
    dispatch_source_set_timer(manger.timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(manger.timer,^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            time_t nowInterval;
            time(&nowInterval);
            manger.time ++;
            manger.moveTime = manger.time;
        });
    });
    dispatch_resume(manger.timer);
}

- (void)sendRequestToServerWithType:(RequestType)type
          showActivityIndicatorView:(BOOL)show
{
    [LPActivityIndicatorView show];
}

+ (void)sendServerImageData:(NSData *)imageData
               successBlock:(SuccessBlock)successBlock
                failedBlock:(FailedBlock)failedBlock
{
    if (!imageData)
    {
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@%@/FileUpload?doAction=headImages&&fileName", [NSUserDefaults hotelHost], [NSUserDefaults hotelPort]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate newDate]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    NSDictionary *parameters = nil;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json", @"text/plain", nil]];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"headPic" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress)
     {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         successBlock(task, responseObject[@"result"]);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         failedBlock(task, error);
         [Prompt popPromptViewWithMsg:error.localizedDescription duration:3.f];
     }];
}


+ (void)sendServerImageFiles:(NSArray<HMImageFile *> *)imageFiles isToTotalSystem:(IsToTotalSystem)isToTotalSystem successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock{
    
    if (!imageFiles || !imageFiles.count) {
        return;
    }
  
    [LPActivityIndicatorView showWithMask];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@%@/spring/fileUpload/upload", [NSUserDefaults hotelHost], [NSUserDefaults hotelPort]];
    
    if (imageFiles.firstObject.subPath == ImageSubPathChatImage || imageFiles.firstObject.subPath == ImageSubPathChatMp3)
    {
        urlStr = [NSString stringWithFormat:@"%@/homtripserver/file/kqzupload", kImageService];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isToTotalSystem == IsToTotalSystemSend) {// 照片组是否上传主系统
        [parameters setObject:@"1" forKey:@"isToTotalSystem"];
    } else if (isToTotalSystem == IsToTotalSystemNotSend){
        [parameters setObject:@"0" forKey:@"isToTotalSystem"];
    }
    
    NSInteger i = 0;
    NSString *key = nil;
    NSArray *subPaths = @[kImageSubPathChatMp3Key,
                          kImageSubPathChatImageKey,
                          kImageSubPathHeadImageKey,
                          kImageSubPathIdcardImageKey,
                          kImageSubPathPersonalphotoKey,
                          kImageSubPathIdentificationphotoKey,
                          kImageSubPathAttachmentKey,
                          kImageSubPathMembers,
                          kImageSubPathServices,
                          kImageSubPathNonCashChangeProblemKey,
                          
                          kImageSubPathProprietorKey,
                          kImageSubPathProprietorWithdrawKey,
                          kImageSubPathHouseKey,
                          kImageSubPathProblemOrderOperationKey,
                          kImageSubPathTallyBookKey,
                          kImageSubPathProtocolUnitKey,
                          kImageSubPathCheckRoomKey
                          ];
    for (HMImageFile *imageFile in imageFiles) {
        if (imageFile.imageData) {
            
            key = [NSString stringWithFormat:@"files[%ld].type",(long)i];// 自定义唯一标示 用于数据返回时对应原来的文件
            [parameters setObject:key forKey:key];
            
            key = [NSString stringWithFormat:@"files[%ld].subPath",(long)i];// 图片存储在服务器的子路径
            [parameters setObject:subPaths[imageFile.subPath] forKey:key];
            
            if (imageFile.fileName && ![imageFile.fileName isEqualToString:@""]) {// 文件名
                key = [NSString stringWithFormat:@"files[%ld].fileName",(long)i];
                [parameters setObject:imageFile.fileName forKey:key];
            }
            
            key = [NSString stringWithFormat:@"files[%ld].isToSystem",(long)i]; // 照片是否上传主系统
            if (imageFile.isToSystem == IsToTotalSystemSend) {
                [parameters setObject:@"1" forKey:key];
            } else if (imageFile.isToSystem == IsToTotalSystemNotSend){
                [parameters setObject:@"0" forKey:key];
            }
            
            i++;
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json", @"text/plain", nil]];
  
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
           
        NSInteger i = 0;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        for (HMImageFile *imageFile in imageFiles) {
            if (imageFile.imageData) {
                
                NSString *name = [NSString stringWithFormat:@"files[%ld].file",(long)i];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate newDate]]];
                
                if (imageFile.subPath == ImageSubPathChatMp3)
                {
                    fileName = [NSString stringWithFormat:@"%@.m4a", [formatter stringFromDate:[NSDate newDate]]];
                    [formData appendPartWithFileData:imageFile.imageData name:name fileName:fileName mimeType:@"audio/mpeg"];
                }
                else
                {
                    [formData appendPartWithFileData:imageFile.imageData name:name fileName:fileName mimeType:@"image/jpeg"];
                }
                
                i ++;
            }
        }
    
    } progress:^(NSProgress * _Nonnull uploadProgress){ }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
             
              [LPActivityIndicatorView hide];
              successBlock(task, responseObject[@"result"]);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              [LPActivityIndicatorView hide];
              failedBlock(task, error);
              [Prompt popPromptViewWithMsg:error.localizedDescription duration:3.f];
          }];
}


+ (NSURLSessionDataTask *)requestWithRequestType:(RequestType)requestType
                                          method:(NSString *)method
                                      parameters:(NSDictionary *)parameters
                                    successBlock:(SuccessBlock)successBlock
                                     failedBlock:(FailedBlock)failedBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html", @"application/json", nil];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *url = [NSString stringWithFormat:@"http://%@%@/%@",[NSUserDefaults hotelHost], [NSUserDefaults hotelPort], method];
    
    void (^SuccessBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        
        if([responseObject[@"retCode"] intValue] == RequestSuccessReturnCode)
        {
            successBlock(task, responseObject[@"result"]);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:@"服务器错误" code:[responseObject[@"retCode"] intValue] userInfo:@{ErrorDescriptionKey:responseObject[@"msg"]}];
            failedBlock(task, error);
        }
    };
    
    void (^FailedBlock)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error){
        
        failedBlock(task, error);
    };
    
    if (requestType == GET)
    {
        return [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:SuccessBlock failure:FailedBlock];
    }
    else if (requestType == POST)
    {
        return [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {} success:SuccessBlock failure:FailedBlock];
    }
    return nil;
}

#pragma mark 初始化API

+ (instancetype)apiWithDelegate:(id)object
{
    HTTPAPI *api = [self new];
    api.delegate = object;
    
    return api;
}

- (instancetype)init {
    if (self = [super init]) {
        self.isPromptErrorMessage = YES;
    }
    return self;
}

#pragma mark Helper-Method

- (void)createExceptionWithMsg:(NSString*)msg
{
    [NSException raise:NSInternalInconsistencyException format:@"你必须要自己实现%@方法", msg];
}

/** 处理请求返回数据    */
- (void)handleResponseDataObj:(id)dataObj
{
    if ([dataObj[@"retCode"] integerValue] == RequestSuccessReturnCode)
        
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fetchData:fromServerSuccessedWithAPI:)])
        {
            [self.delegate fetchData:dataObj[@"result"] fromServerSuccessedWithAPI:self];
        }
    }
    else
    {
        if ([dataObj[@"retCode"] intValue] == RequestWithoutLoginReturnCode)
        {
            //            if ([NSUserDefaults loginStatus] == LOGIN_OUT)
            //            {
            //                [LPAccountManager showLoginOutInfo];
            //            }
            //            else
            //            {
            //                [LPAccountManager autoLoginWithDelayAPI:self];
            //            }
        }
        else if ([dataObj[@"retCode"] intValue] == RequestWithIncorrectPhoneNumber)
        {
            [Prompt popPromptViewWithMsg:@"请输入正确手机号码" duration:3.f];
        }
        else if([dataObj[@"retCode"] intValue] == RequestWithVerifyCodeFrequently)
        {
            [Prompt popPromptViewWithMsg:@"一分钟之内只能获取一次验证码哦~" duration:3.f];
        }
        else if ([dataObj[@"retCode"] intValue] == RequestPhotoCompareResultNotPass)
        {
            if ([self.url containsString:@"changePW"])
            {
                [Prompt popPromptViewWithMsg:dataObj[@"msg"] duration:2.f];
                return;
            }
            
            if (![dataObj[@"result"] isKindOfClass:[NSNull class]]) {
                //                CGFloat score = [dataObj[@"result"][@"score"] floatValue];
                //                [Prompt popPromptViewWithMsg:[NSString stringWithFormat:@"分数：%f",score] duration:10.f];
            } else{
                [Prompt popPromptViewWithMsg:dataObj[@"msg"] duration:10.f];
            }
            
        }
        else
        {
            if (![self.url containsString:@"getIP"] &&
                ![self.url containsString:@"checkmobilecheckcode"] &&
                ![self.url containsString:@"getCleanPersonAndDutyInfo"] &&
                ![self.url containsString:@"messageBoardList"] &&
                ![self.url containsString:@"getCleanList/allot"] &&
                ![self.url containsString:@"getRzrOrderInfo"] &&
                ![self.url containsString:@"sendBluetoothKey"])
            {
                if (self.isPromptErrorMessage == YES) {
                    [Prompt popPromptViewInScreenCenterWithMsg:dataObj[@"msg"] duration:3];
                }
            }
        }
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(fetchDataFromServerFailedWithError:API:)] && dataObj)
        {
            NSError *error = [[NSError alloc] initWithDomain:@"服务器内部错误" code:[dataObj[@"retCode"] integerValue] userInfo:@{ErrorDescriptionKey:dataObj[@"msg"]}];
            [self.delegate fetchDataFromServerFailedWithError:error API:self];
        }
    }
}

- (AFHTTPSessionManager *)manager
{
    if (! _manager)
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSArray *)propertyList
{
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertyList = [NSMutableArray new];
    
    for (int i = 0; i < count; i++)
    {
        [propertyList addObject:[NSString stringWithUTF8String:property_getName(*(properties + i))]];
    }
    free(properties);
    return propertyList;
}

@end
