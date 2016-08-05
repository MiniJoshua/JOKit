//
//  JOLogHelper.m
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOLogHelper.h"
#import "JOCacheHelper.h"

#define kDefaultLogFilePath JOCachesFilePath(@"app.log")

static const unsigned long long kMaxDefaultLogSize = 1024*100.; //默认的Log日志存放的最大容量.

@implementation JOLogHelper

void JOLogWrite(NSString *content,NSString *logPath,BOOL coverState) {

    if(JOFileCreateAtPath(logPath, NO)){
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSString *writeString = [NSString stringWithFormat:@"%@ :%@\n", dateString, content];
        
        if (coverState) {
            //覆盖
            NSError *error;
            [writeString writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        }else{
            //追加在末尾
            NSFileHandle * fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
            if(fileHandle == nil){
                return;
            }
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
        }
    }
}

void JOLogDefaultWrite(NSString *content,BOOL coverState) {

    if (JOFileExistAtPath(kDefaultLogFilePath)) {
        JOCachePathSize(kDefaultLogFilePath,
                        ^(unsigned long long cacheSize, float CacheMBSize) {
                            if (cacheSize > kMaxDefaultLogSize) {
                                JOFileRemovePath(kDefaultLogFilePath);
                            }
                        });
    }
    JOLogWrite(content, kDefaultLogFilePath, NO);
}

void JOLogClean(NSString *logPath) {
    NSError *error;
    [@"" writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

void JOLogDefaultClean() {
    JOLogClean(kDefaultLogFilePath);
}

NSString *JOLogDefaultPath(void) {
    return kDefaultLogFilePath;
}

@end
