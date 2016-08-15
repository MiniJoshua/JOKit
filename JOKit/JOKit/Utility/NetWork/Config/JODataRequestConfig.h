//
//  JODataRequestConfig.h
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JONetRequestConfig.h"
#import "JOMacro.h"

typedef NS_ENUM(NSUInteger, JOHttpMethod) {

    JOHttpMethodPost,
    JOHttpMethodGet,
    JOHttpMethodHead,
    JOHttpMethodPut,
    JOHttpMethodPatch,
    JOHttpMethodDelete,
};

@interface JODataRequestConfig : JONetRequestConfig

@property (nonatomic, assign) JOHttpMethod httpMethod;

/**
 *  创建一个DataRequestConfig.
 *
 *  @param urlString  URLString.
 *  @param postData   发送的数据参数.
 *  @param httpMethod 请求的方法.
 *
 *  @return JODataRequestConfig.
 */
JO_EXTERN JODataRequestConfig *JODataRequestConfigMake(NSString *urlString,NSDictionary *postData,JOHttpMethod httpMethod);

@end
