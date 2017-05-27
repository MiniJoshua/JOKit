//
//  JONetManage.m
//  JOKit
//
//  Created by 刘维 on 16/8/9.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JONetManage.h"
#import "AFNetworking.h"
#import "JOFileHelper.h"
#import "JOExceptionHelper.h"

static NSString *const kFileDownloadTempDirectoriesName = @"JODownloadTemp/";
//从缓存的文件信息里面读取缓存的URL的key
static NSString *const kFileDownloadURLKey = @"NSURLSessionDownloadURL";
//从缓存的文件信息里面读取缓存文件名字的key
static NSString *const kFileDownloadTempNameKey = @"NSURLSessionResumeInfoTempFileName";

@interface JONetManage ()

@end

@implementation JONetManage

+ (NSMutableDictionary *)shareRequestTaskDic {
    
    static NSMutableDictionary *requestTaskDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        requestTaskDic = [NSMutableDictionary dictionary];
    });
    return requestTaskDic;
}

+ (void)networkReachabilityMonitoringHandler:(void(^)(JONetworkReachabilityStatus states))handler {

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSInteger statusInteger = status;
        if (handler) {
            handler(statusInteger);
        }
    }];
}

+ (void)cancelNetRequestWithIdentifier:(NSString *)identifier {

    if ([[[JONetManage shareRequestTaskDic] allKeys] containsObject:identifier]) {
        
        id task = [[JONetManage shareRequestTaskDic] objectForKey:identifier];
        
        if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
            
            [(NSURLSessionDownloadTask *)task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                
                if (resumeData) {
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *tempFilePath = [JOCachesFilePath(kFileDownloadTempDirectoriesName) stringByAppendingPathComponent:identifier];
                    //创建临时文件并写入数据,写入的只是一些文件的信息而已,真正的临时存的文件默认都在temp里面.
                    [fileManager createFileAtPath:tempFilePath contents:resumeData attributes:nil];
                    
//                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:tempFilePath];
//                    JOLog(@"dic:%@",dic);
                }
            }];
            
        }else{
            [(NSURLSessionTask *)[[JONetManage shareRequestTaskDic] objectForKey:identifier] cancel];
        }
    }
}

#pragma mark - private
#pragma mark -

/**
 *  根据标示保存或者移除网络
 *
 *  @param identifier 网络的标示.
 *  @param task       网络的task.
 *  @param cacheState YES:缓存 NO:移除缓存
 */
static inline void JOCacheReqeust(NSString *identifier, NSURLSessionTask *task, BOOL cacheState) {

    if (identifier && [identifier length]) {
        if (cacheState) {
            //存储
            if (![[[JONetManage shareRequestTaskDic] allKeys] containsObject:identifier]) {
                [[JONetManage shareRequestTaskDic] setObject:task forKey:identifier];
            }else{
                JOException(@"JONetManage Exception",@"identifier已经存在,请勿添加两个相同的identifier");
            }
        }else{
            //移除
            if ([[[JONetManage shareRequestTaskDic] allKeys] containsObject:identifier]) {
                [[JONetManage shareRequestTaskDic] removeObjectForKey:identifier];
            }
        }
    }
}

static inline void JOSessionConfiguration(NSURLSessionConfiguration *configuration) {

    if (configuration) {
        //若未设置 则默认设置一个
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setTimeoutIntervalForRequest:30.];
        [configuration setTimeoutIntervalForResource:30.];
    }
}

static inline void JOJSONModelParse(NSDictionary *responseDic, JONetReqeustDataParseHandler dataParseHandler) {

    if (!responseDic) {
        return;
    }
    
    if (dataParseHandler) {
        dataParseHandler(^id(Class class1,...){
            
            if ([[class1 new] isKindOfClass:NSClassFromString(@"JSONModel")]) {
                
                va_list args;
                va_start(args, class1);
                Class arg = class1;
                while (arg) {

                    id model = nil;
                    SEL initSelector = sel_registerName("initWithDictionary:error:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    if ([arg instancesRespondToSelector:initSelector]) {
                        model = [[arg alloc] performSelector:initSelector withObject:responseDic withObject:NULL];
                    }
#pragma clang diagnostic pop
                    if (model) {
                        va_end(args);
                        return model;
                    }
                   arg = va_arg(args, Class);
                }
                va_end(args);
    
                return nil;
            }else{
            
                JOException(@"JONetManage JOJSONModelParse Exception.", @"暂时只能将得到的数据解析一个JSONModel的子类的数据模型");
                return nil;
            }
        });
    }
}

static inline void JOFileProgress(NSProgress *progress, JONetFileProgressBlock fileProgressBlock) {

    if (progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fileProgressBlock) {
                fileProgressBlock(progress);
            }
        });
    }
}

static inline void JORequestSuccess(NSURLResponse *response, NSDictionary *responseDic, JONetRequestSuccessHandler successHandler) {

    if (successHandler) {
        successHandler(response,responseDic);
    }
}

static inline void JORequestFailed(NSError *error, JONetRequestFailedHandler failedHandler) {

    if (failedHandler) {
        failedHandler(error);
    }
}

#pragma mark - Net Request Public
#pragma mark -

+ (void)netRequestWithConfig:(JONetRequestConfig *)config
           requestIdentifier:(NSString *)identifier
         fileProgressHandler:(JONetFileProgressBlock)progressBlock
            jsonModelHandler:(JONetReqeustDataParseHandler)jsonModelHandler
              successHandler:(JONetRequestSuccessHandler)successHandler
               failedHandler:(JONetRequestFailedHandler)failedHandler {

    NSCParameterAssert(config != nil);
    JOSessionConfiguration(config.urlSessionConfiguration);
    
    if ([config isKindOfClass:[JODataRequestConfig class]]) {
        //数据的网络请求
        JODataRequestConfig *dataRequestConfig = (JODataRequestConfig *)config;
        
        AFHTTPSessionManager *manager = ({
        
            manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config.urlSessionConfiguration];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
            manager;
        });
        
        NSURLSessionDataTask *dataTask = nil;
        
        if (dataRequestConfig.httpMethod == JOHttpMethodPost) {
            //POST
            dataTask = JONetRequestPost(dataRequestConfig, identifier, manager, jsonModelHandler, successHandler, failedHandler);
        }else if (dataRequestConfig.httpMethod == JOHttpMethodGet) {
            //Get
            dataTask = JONetRequestGet(dataRequestConfig, identifier, manager, jsonModelHandler, successHandler, failedHandler);
        }else if (dataRequestConfig.httpMethod == JOHttpMethodHead) {
            //Head
            dataTask = JONetRequestHead(dataRequestConfig, identifier, manager, jsonModelHandler, successHandler, failedHandler);
        }else if (dataRequestConfig.httpMethod == JOHttpMethodPut) {
            //Put
            dataTask = JONetRequestPut(dataRequestConfig, identifier, manager, jsonModelHandler, successHandler, failedHandler);
        }else if (dataRequestConfig.httpMethod == JOHttpMethodPatch) {
            //Patch
            dataTask = JONetRequestPatch(dataRequestConfig, identifier, manager, jsonModelHandler, successHandler, failedHandler);
        }else if (dataRequestConfig.httpMethod == JOHttpMethodDelete) {
            //Delete
            dataTask = JONetRequestDelete(dataRequestConfig, identifier, manager, jsonModelHandler, successHandler, failedHandler);
        }
        
        JOCacheReqeust(identifier, dataTask, YES);
        [dataTask resume];
        
    }else if([config isKindOfClass:[JOFileUploadConfig class]]) {
        //文件的上传
        JOFileUploadConfig *fileUploadConfig = (JOFileUploadConfig *)config;
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config.urlSessionConfiguration];
        AFJSONResponseSerializer *JSONResponseSerializer = [AFJSONResponseSerializer serializer];
        JSONResponseSerializer.acceptableContentTypes = [JSONResponseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        manager.responseSerializer = JSONResponseSerializer;
        
        NSURLSessionUploadTask *uploadTask = JONetFileUpload(fileUploadConfig, identifier, manager, progressBlock, jsonModelHandler, successHandler, failedHandler);
        JOCacheReqeust(identifier, uploadTask, YES);
        [uploadTask resume];
        
    }else if([config isKindOfClass:[JOFileDownloadConfig class]]) {
        //文件的下载
        JOFileDownloadConfig *downloadConfig = (JOFileDownloadConfig *)config;
        
        AFURLSessionManager *manager = ({
            manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config.urlSessionConfiguration];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager;
        });
        NSURLSessionDownloadTask *downloadTask = JONetFileDownload(downloadConfig, identifier, manager, progressBlock, jsonModelHandler, successHandler, failedHandler);
        
        JOCacheReqeust(identifier, downloadTask, YES);
        [downloadTask resume];
    }
}

+ (void)netRequestWithConfig:(JONetRequestConfig *)config
           requestIdentifier:(NSString *)identifier {

    [JONetManage netRequestWithConfig:config
                    requestIdentifier:identifier
                  fileProgressHandler:nil
                     jsonModelHandler:nil
                       successHandler:nil
                        failedHandler:nil];
}

+ (void)netRequestWithConfig:(JONetRequestConfig *)config
           requestIdentifier:(NSString *)identifier
              successHandler:(JONetRequestSuccessHandler)successHandler
               failedHandler:(JONetRequestFailedHandler)failedHandler {

    [JONetManage netRequestWithConfig:config
                    requestIdentifier:identifier
                  fileProgressHandler:nil
                     jsonModelHandler:nil
                       successHandler:successHandler
                        failedHandler:failedHandler];

}

+ (void)netRequestWithConfig:(JONetRequestConfig *)config
           requestIdentifier:(NSString *)identifier
            jsonModelHandler:(JONetReqeustDataParseHandler)jsonModelHandler
               failedHandler:(JONetRequestFailedHandler)failedHandler {

    [JONetManage netRequestWithConfig:config
                    requestIdentifier:identifier
                  fileProgressHandler:nil
                     jsonModelHandler:jsonModelHandler
                       successHandler:nil
                        failedHandler:failedHandler];
}

+ (void)netRequestWithConfig:(JONetRequestConfig *)config
           requestIdentifier:(NSString *)identifier
            jsonModelHandler:(JONetReqeustDataParseHandler)jsonModelHandler
              successHandler:(JONetRequestSuccessHandler)successHandler
               failedHandler:(JONetRequestFailedHandler)failedHandler {

    [JONetManage netRequestWithConfig:config
                    requestIdentifier:identifier
                  fileProgressHandler:nil
                     jsonModelHandler:jsonModelHandler
                       successHandler:successHandler
                        failedHandler:failedHandler];
}

+ (void)netRequestWithConfig:(JONetRequestConfig *)config
           requestIdentifier:(NSString *)identifier
         fileProgressHandler:(JONetFileProgressBlock)progressBlock
              successHandler:(JONetRequestSuccessHandler)successHandler
               failedHandler:(JONetRequestFailedHandler)failedHandler {

    [JONetManage netRequestWithConfig:config
                    requestIdentifier:identifier
                  fileProgressHandler:progressBlock
                     jsonModelHandler:nil
                       successHandler:successHandler
                        failedHandler:failedHandler];
}

+ (void)netRequestWithConfig:(JONetRequestConfig *)config
           requestIdentifier:(NSString *)identifier
         fileProgressHandler:(JONetFileProgressBlock)progressBlock
            jsonModelHandler:(JONetReqeustDataParseHandler)jsonModelHandler
               failedHandler:(JONetRequestFailedHandler)failedHandler {

    [JONetManage netRequestWithConfig:config
                    requestIdentifier:identifier
                  fileProgressHandler:progressBlock
                     jsonModelHandler:jsonModelHandler
                       successHandler:nil
                        failedHandler:failedHandler];
}

+ (void)netRequestWithConfig:(JONetRequestConfig *)config
           requestIdentifier:(NSString *)identifier
         fileProgressHandler:(JONetFileProgressBlock)progressBlock
               failedHandler:(JONetRequestFailedHandler)failedHandler {

    [JONetManage netRequestWithConfig:config
                    requestIdentifier:identifier
                  fileProgressHandler:progressBlock
                     jsonModelHandler:nil
                       successHandler:nil
                        failedHandler:failedHandler];
}

#pragma mark - Net Request HTTP
#pragma mark -

static inline NSURLSessionDataTask *JONetRequestPost(JODataRequestConfig *config,
                                              NSString *identifier,
                                              AFHTTPSessionManager *manager,
                                              JONetReqeustDataParseHandler jsonModelHandler,
                                              JONetRequestSuccessHandler successHandler,
                                              JONetRequestFailedHandler failedHandler) {

    
    NSURLSessionDataTask *dataTask = [manager POST:config.urlString
                                        parameters:config.postData
                                          progress:nil
                                           success:^(NSURLSessionDataTask *task, id responseObject) {
                                               
                                               JORequestSuccess(task.response,responseObject, successHandler);
                                               JOJSONModelParse(responseObject, jsonModelHandler);
                                               JOCacheReqeust(identifier, nil, NO);
                                           }
                                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                                               
                                               JOLog(@"errordomain:%@",error.domain);
                                               JOLog(@"errorDic:%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
                                               
                                               JORequestFailed(error, failedHandler);
                                               JOCacheReqeust(identifier, nil, NO);
                                               
//                                               if(!([[error.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"cancelled"]||[[error.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"已取消"])){
//                                                   
//                                                   JOLog(@"error:%@",error);
//                                                   Request_Failed_Handler;
//                                                   
//                                               }
                                               /*
                                                if (task.state == NSURLSessionTaskStateCanceling) {
                                                
                                                NSLog(@"cancel");
                                                }else if(task.state == NSURLSessionTaskStateRunning){
                                                
                                                NSLog(@"Running");
                                                }else if(task.state == NSURLSessionTaskStateSuspended){
                                                
                                                NSLog(@"suspended");
                                                }else if(task.state == NSURLSessionTaskStateCompleted){
                                                
                                                
                                                NSLog(@"completed");
                                                }
                                                */
                                           }
                                      ];
    return dataTask;
}

static inline NSURLSessionDataTask *JONetRequestGet(JODataRequestConfig *config,
                                             NSString *identifier,
                                             AFHTTPSessionManager *manager,
                                             JONetReqeustDataParseHandler jsonModelHandler,
                                             JONetRequestSuccessHandler successHandler,
                                             JONetRequestFailedHandler failedHandler) {

    NSURLSessionDataTask *dataTask = [manager GET:config.urlString
                                       parameters:config.postData
                                         progress:nil
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                               
                                               JORequestSuccess(task.response, responseObject, successHandler);
                                               JOJSONModelParse(responseObject, jsonModelHandler);
                                               JOCacheReqeust(identifier, nil, NO);
                                           }
                                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                                               
                                               JORequestFailed(error, failedHandler);
                                              JOCacheReqeust(identifier, nil, NO);
                                           }
                                      ];
    return dataTask;
}

static inline NSURLSessionDataTask *JONetRequestHead(JODataRequestConfig *config,
                                              NSString *identifier,
                                              AFHTTPSessionManager *manager,
                                              JONetReqeustDataParseHandler jsonModelHandler,
                                              JONetRequestSuccessHandler successHandler,
                                              JONetRequestFailedHandler failedHandler) {

    NSURLSessionDataTask *dataTask  = [manager HEAD:config.urlString
                                         parameters:config.postData
                                            success:^(NSURLSessionDataTask * _Nonnull task) {
                                                
                                                JORequestSuccess(task.response, @{@"task":task}, successHandler);
                                                JOCacheReqeust(identifier, nil, NO);
                                            }
                                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                
                                                JORequestFailed(error, failedHandler);
                                                JOCacheReqeust(identifier, nil, NO);
                                            }];
    return dataTask;
}

static inline NSURLSessionDataTask *JONetRequestPut(JODataRequestConfig *config,
                                             NSString *identifier,
                                             AFHTTPSessionManager *manager,
                                             JONetReqeustDataParseHandler jsonModelHandler,
                                             JONetRequestSuccessHandler successHandler,
                                             JONetRequestFailedHandler failedHandler) {
    
    NSURLSessionDataTask *dataTask = [manager PUT:config.urlString
                                       parameters:config.postData
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                              
                                              JORequestSuccess(task.response, responseObject, successHandler);
                                              JOJSONModelParse(responseObject, jsonModelHandler);
                                              JOCacheReqeust(identifier, nil, NO);
                                          }
                                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                                              
                                              JORequestFailed(error, failedHandler);
                                              JOCacheReqeust(identifier, nil, NO);
                                          }
                                      ];
    return dataTask;
}

static inline NSURLSessionDataTask *JONetRequestPatch(JODataRequestConfig *config,
                                               NSString *identifier,
                                               AFHTTPSessionManager *manager,
                                               JONetReqeustDataParseHandler jsonModelHandler,
                                               JONetRequestSuccessHandler successHandler,
                                               JONetRequestFailedHandler failedHandler) {
    
    NSURLSessionDataTask *dataTask = [manager PATCH:config.urlString
                                       parameters:config.postData
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                              
                                              JORequestSuccess(task.response, responseObject, successHandler);
                                              JOJSONModelParse(responseObject, jsonModelHandler);
                                              JOCacheReqeust(identifier, nil, NO);
                                          }
                                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            
                                              JORequestFailed(error, failedHandler);
                                              JOCacheReqeust(identifier, nil, NO);
                                          }
                                      ];
    return dataTask;
}

static inline NSURLSessionDataTask *JONetRequestDelete(JODataRequestConfig *config,
                                                NSString *identifier,
                                                AFHTTPSessionManager *manager,
                                                JONetReqeustDataParseHandler jsonModelHandler,
                                                JONetRequestSuccessHandler successHandler,
                                                JONetRequestFailedHandler failedHandler) {
    
    NSURLSessionDataTask *dataTask = [manager DELETE:config.urlString
                                          parameters:config.postData
                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                
                                                 JORequestSuccess(task.response, responseObject, successHandler);
                                                 JOJSONModelParse(responseObject, jsonModelHandler);
                                                 JOCacheReqeust(identifier, nil, NO);
                                             }
                                             failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                 
                                                 JORequestFailed(error, failedHandler);
                                                 JOCacheReqeust(identifier, nil, NO);
                                             }
                                        ];
    return dataTask;
}

#pragma mark - File Upload
#pragma mark -

//文件的上传
static inline NSURLSessionUploadTask *JONetFileUpload(JOFileUploadConfig *config,
                                               NSString *identifier,
                                               AFURLSessionManager *manager,
                                               JONetFileProgressBlock progressBlock,
                                               JONetReqeustDataParseHandler jsonModelHandler,
                                               JONetRequestSuccessHandler successHandler,
                                               JONetRequestFailedHandler failedHandler) {
    
    NSURLSessionUploadTask *uploadTask = nil;
    
    if (config.fileURLRequestHandler) {
        //文件流的形式上传
        NSMutableURLRequest *request =({
            
                            JOBlock_Variable NSString *methodStr = @"";
                            JOBlock_Variable NSString *URLStringStr = @"";
                            JOBlock_Variable NSDictionary *postDataDic = nil;
                            JOBlock_Variable NSData *fileOfData = nil;
                            JOBlock_Variable NSString *nameStr = @"";
                            JOBlock_Variable NSString *fileNameStr = @"";
                            JOBlock_Variable NSString *mimeTypeStr = @"";
                            config.fileURLRequestHandler(^(NSString *method, NSString *URLString, NSDictionary *postData){
                                methodStr = method;
                                URLStringStr = URLString;
                                postDataDic = postData;
                            },^(NSData *fileData, NSString *name, NSString *fileName, NSString *mimeType){
                                fileOfData = fileData;
                                nameStr = name;
                                fileNameStr = fileName;
                                mimeTypeStr = mimeType;
                            });
                            
                            request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:methodStr
                                                                                                 URLString:URLStringStr
                                                                                                parameters:postDataDic
                                                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                     
                                                                                     [formData appendPartWithFileData:fileOfData
                                                                                                                 name:nameStr
                                                                                                             fileName:fileNameStr
                                                                                                             mimeType:mimeTypeStr];
                                                                                     
                                                                                                                }
                                                                                                     error:nil];
                            request;
            
        });
        
        uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                   progress:^(NSProgress * _Nonnull uploadProgress) {
                                                       JOFileProgress(uploadProgress,progressBlock);
                                                   }
                                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              
                                              if (error) {
                                                  //失败
                                                  JORequestFailed(error, failedHandler);
                                                  JOCacheReqeust(identifier, nil, NO);
                                              }else{
                                                  //成功
                                                  JORequestSuccess(response, responseObject, successHandler);
                                                  JOJSONModelParse(responseObject, jsonModelHandler);
                                                  JOCacheReqeust(identifier, nil, NO);
                                              }
                                          }
                      ];
        
    }else{
        //非文件流的上传方式
        [config synthRequest]; //组装request
        
        if (config.filePath && [config.filePath length]) {
            //以文件的路径的上传方式
            uploadTask = [manager uploadTaskWithRequest:config.request
                                               fromFile:[NSURL URLWithString:config.filePath]
                                               progress:^(NSProgress * _Nonnull uploadProgress) {
                                                   JOFileProgress(uploadProgress,progressBlock);
                                               }
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                        
                                          if (error) {
                                              //失败
                                              JORequestFailed(error, failedHandler);
                                              JOCacheReqeust(identifier, nil, NO);
                                          }else{
                                              //成功
                                              JORequestSuccess(response, responseObject, successHandler);
                                              JOJSONModelParse(responseObject, jsonModelHandler);
                                              JOCacheReqeust(identifier, nil, NO);
                                          }
                                      }
                          ];
            
        }else if (config.fileData) {
            
            uploadTask = [manager uploadTaskWithRequest:config.request
                                               fromData:config.fileData
                                               progress:^(NSProgress * _Nonnull uploadProgress) {
                                                   JOFileProgress(uploadProgress,progressBlock);
                                               }
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          
                                          if (error) {
                                              //失败
                                              JORequestFailed(error, failedHandler);
                                              JOCacheReqeust(identifier, nil, NO);
                                          }else{
                                              //成功
                                              JORequestSuccess(response, responseObject, successHandler);
                                              JOJSONModelParse(responseObject, jsonModelHandler);
                                              JOCacheReqeust(identifier, nil, NO);
                                          }
                                      }];
        }else {
        
            uploadTask = [NSURLSessionUploadTask new];
        }
        
    }

    return uploadTask;
}

#pragma mark - File Download
#pragma mark - 

//文件下载

static inline NSURLSessionDownloadTask *JONetFileDownload(JOFileDownloadConfig *config,
                                                   NSString *identifier,
                                                   AFURLSessionManager *manager,
                                                   JONetFileProgressBlock progressBlock,
                                                   JONetReqeustDataParseHandler jsonModelHandler,
                                                   JONetRequestSuccessHandler successHandler,
                                                   JONetRequestFailedHandler failedHandler) {
    
    [config synthRequest];
    
    NSURLSessionDownloadTask *downloadTask = nil;
    
    //检查临时文件夹是否存在:是的话则创建临时的文件夹
    JOFileCreateDirectoryAtPath(JOCachesFilePath(kFileDownloadTempDirectoriesName),NO);
    NSString *tempPath = [JOCachesFilePath(kFileDownloadTempDirectoriesName) stringByAppendingPathComponent:identifier];
    
    if (config.isCleanExistFile){
        //清空原来存在的文件
        JOFileRemovePath([config.fileSavePath stringByAppendingPathComponent:config.fileSaveName]);
        
        if (JOFileExistAtPath(tempPath)) {
            //如果临时文件存在 也要一起清空 同时还需要清空系统自动保存的临时文件.
            NSDictionary *resumeDataDic = [NSDictionary dictionaryWithContentsOfFile:tempPath];
            JOFileRemovePath(tempPath);
            JOFileRemovePath(JOTempFilePath([resumeDataDic objectForKey:kFileDownloadTempNameKey]));
        }
    }
    
    if (JOFileExistAtPath(tempPath)) {
        //如果存在临时的下载文件,那么应该从原来暂停的地方继续下载
        if (config.resumeURLString && [config.resumeURLString length]) {
            //是否更新了新的URL地址去下载,当URL存在时效性的时候考虑
            NSMutableDictionary *resumeDataDic = [NSMutableDictionary dictionaryWithContentsOfFile:tempPath];
            
            if (![[resumeDataDic objectForKey:kFileDownloadURLKey] isEqualToString:config.resumeURLString]) {
                //如果两者不相同的话 则需要替换成最新的URL
                [resumeDataDic setObject:config.resumeURLString forKey:kFileDownloadURLKey];
            }
        }
        NSData *resumeData = [NSData dataWithContentsOfFile:tempPath];
        
        downloadTask = [manager downloadTaskWithResumeData:resumeData
                                                  progress:^(NSProgress * _Nonnull downloadProgress) {
                                                      
                                                      JOFileProgress(downloadProgress,progressBlock);
                                                  }
                                               destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                   
                                                   NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:config.fileSavePath];
                                                   return [documentsDirectoryPath URLByAppendingPathComponent:config.fileSaveName];
                                               }
                                         completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                             
                                                     if (error) {
                                                         //失败
                                                         JORequestFailed(error, failedHandler);
                                                         JOCacheReqeust(identifier, nil, NO);
                                                     }else{
                                                         //成功
                                                         JORequestSuccess(response, [NSDictionary dictionary], successHandler);
                                                         JOCacheReqeust(identifier, nil, NO);
                                                     }
                                         }];
        
    }else{
        //如果不存在临时下载文件时
        
        downloadTask = [manager downloadTaskWithRequest:config.request
                                               progress:^(NSProgress * _Nonnull downloadProgress) {
                                                   
                                                   JOFileProgress(downloadProgress,progressBlock);
                                               }
                                            destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                
                                                    NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:config.fileSavePath];
                                                    return [documentsDirectoryPath URLByAppendingPathComponent:config.fileSaveName];
                                            }
                                      completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                          
                                                  if (error) {
                                                      //失败
                                                      JORequestFailed(error, failedHandler);
                                                      JOCacheReqeust(identifier, nil, NO);
                                                  }else{
                                                      //成功
                                                      JORequestSuccess(response, [NSDictionary dictionary], successHandler);
                                                      JOCacheReqeust(identifier, nil, NO);
                                                  }
                                        }];
    }
    
    return downloadTask;
}



@end
