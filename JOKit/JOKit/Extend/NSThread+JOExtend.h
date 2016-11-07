//
//  NSThread+JOExtend.h
//  JOKit
//
//  Created by 刘维 on 16/10/26.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread(JOExtend)

/**
 为线程的的Runloop添加自动释放池
 */
+ (void)addAutoreleasePoolToCurrentRunLoop;

@end
