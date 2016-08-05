//
//  JOExceptionHelper.h
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOMacro.h"

@interface JOExceptionHelper : NSObject

/**
 *  会抛出一个异常并捕获该异常打印相关的信息出来.
 *
 *  @param exceptionName 异常的名字.
 *  @param reason        异常的原因.
 */
JO_EXTERN void JOException(NSString *exceptionName,NSString *reason);

/**
 *  仅仅是抛出一个异常 需要自己去捕获该异常.
 *
 *  @param exceptionName exceptionName.
 *  @param reason        reason.
 */
JO_EXTERN void JORaiseException(NSString *exceptionName,NSString *reason);

@end
