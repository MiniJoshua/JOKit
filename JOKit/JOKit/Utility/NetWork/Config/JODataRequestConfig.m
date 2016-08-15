//
//  JODataRequestConfig.m
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JODataRequestConfig.h"

@implementation JODataRequestConfig

JODataRequestConfig *JODataRequestConfigMake(NSString *urlString,NSDictionary *postData,JOHttpMethod httpMethod) {

    JODataRequestConfig *dataRequestConfig = [JODataRequestConfig new];
    [dataRequestConfig setUrlString:urlString];
    [dataRequestConfig setPostData:postData];
    [dataRequestConfig setHttpMethod:httpMethod];
    return dataRequestConfig;
}

@end
