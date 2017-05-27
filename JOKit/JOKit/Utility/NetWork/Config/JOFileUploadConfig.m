//
//  JOFileUploadConfig.m
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOFileUploadConfig.h"
#import "JOExceptionHelper.h"

@implementation JOFileUploadConfig

- (void)synthFileURLRequestHandler:(FileURLRequestHandler )handler {

    if (handler) {
        self.fileURLRequestHandler = nil;
        self.fileURLRequestHandler = handler;
    }
}

- (void)setFile:(id)file {
    
    if ([file isKindOfClass:[NSString class]]) {
        //文件的路径
        self.filePath = nil;
        self.filePath = file;
    }else if ([file isKindOfClass:[NSData class]]){
        //文件的Data
        self.fileData = nil;
        self.fileData = file;
    }else{
        JOException(@"JOFileUploadConfig Exception!",@"file的类型不支持,现在只支持NNSString NSData类型");
    }
}

@end
