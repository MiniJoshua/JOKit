//
//  JONetRequestConfig.m
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JONetRequestConfig.h"
#import "JOExceptionHelper.h"

@implementation JONetRequestConfig

- (void)setURLString:(NSString *)urlString postData:(NSDictionary *)postData {

    self.urlString = nil;
    self.urlString = urlString;
    
    self.postData = nil;
    self.postData = postData;
}

- (void)synthRequest {

    if (self.urlString && [self.urlString length]) {
        
        NSData *httpBody = nil;
        if ([NSJSONSerialization isValidJSONObject:self.postData]) {
            NSError *error;
            NSData *registerData = [NSJSONSerialization dataWithJSONObject:self.postData options:kNilOptions error:&error];
            NSString *postString = [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
            httpBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        [request setHTTPBody:httpBody];
        _request = request;
    }else{
        
        JOException(@"JOFileDownloadConfig exception!",@"urlString不能为空");
    }
}

@end
