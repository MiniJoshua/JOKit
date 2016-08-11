//
//  JODataRequestConfig.h
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JONetRequestConfig.h"

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

@end
