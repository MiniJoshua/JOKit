//
//  JOCrashHelper.m
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOCrashHelper.h"
#import "JOLogHelper.h"

static NSString *const kCrashLogName = @"JOCrashLog";

@implementation JOCrashHelper

void uncaughtExceptionHandler(NSException *exception) {
    
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@\n\n",name, reason, stackArray];
    //    NSLog(@"%@", exceptionInfo);
    
    JOLogWrite(exceptionInfo, JOCachesFilePath(kCrashLogName), NO);
}

void JOOpenCrashLog(void) {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

NSString *JOCrashLogPath(void) {
    return JOCachesFilePath(kCrashLogName);
}

void JOCrashLogClean(void){
    JOLogClean(JOCachesFilePath(kCrashLogName));
}

@end
