//
//  JOExceptionHelper.m
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOExceptionHelper.h"

@implementation JOExceptionHelper

void JOException(NSString *exceptionName,NSString *reason) {
    
    JOThrowException(exceptionName, reason);

//    NS_DURING
//    JORaiseException(exceptionName, reason);
//    NS_HANDLER
////    if (yesOrNo) {
////        [[JOFLog logWithFileName:kDeafultExceptionLogFileName] writeLogToFileWithContextString:[NSString stringWithFormat:@"%@------%@",localException.name,localException.reason]];
////    }
//    NSLog(@"ExceptionName:%@ Reason:%@",localException.name,localException.reason);
//    
//    NS_ENDHANDLER
}

void JORaiseException(NSString *exceptionName,NSString *reason) {

    [NSException raise:exceptionName format:@"%@",reason];
}

@end
