//
//  JONetRequestConfig.h
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JONetRequestConfig : NSObject

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSDictionary *postData;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionConfiguration *urlSessionConfiguration;

- (void)synthRequest;

- (void)setURLString:(NSString *)urlString postData:(NSDictionary *)postData;

@end
