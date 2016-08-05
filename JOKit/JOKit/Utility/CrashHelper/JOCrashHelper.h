//
//  JOCrashHelper.h
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOMacro.h"

@interface JOCrashHelper : NSObject

/**
 *  开启Crash日志的收集
 */
JO_EXTERN void JOOpenCrashLog(void);

/**
 *  Crash Log日志的路径.
 *
 *  @return 日志的路径.
 */
JO_EXTERN NSString *JOCrashLogPath(void);

/**
 *  清空Crash Log的日志.
 */
JO_EXTERN void JOCrashLogClean(void);

@end
