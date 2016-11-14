//
//  NSThread+JORunLoop.h
//  JOKit
//
//  Created by 刘维 on 16/11/9.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread(JORunLoop)

/**
 返回单例的Thread,并默认开启了Runloop.
 建议使用这个,你可以在任何线程里面调用它.

 @return NSThread.
 */
+ (NSThread *)joRunLoopThread;

/**
 返回新的的Thread,并默认开启了Runloop.
 
 @return NSThread.
 */
+ (NSThread *)joNewRunLoopThread;

@end
