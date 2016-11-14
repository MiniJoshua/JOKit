//
//  NSThread+JORunLoop.m
//  JOKit
//
//  Created by 刘维 on 16/11/9.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "NSThread+JORunLoop.h"
#import "JOMacro.h"

@implementation NSThread(JORunLoop)

//static void JORunloopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
//    
//    switch (activity) {
//        case kCFRunLoopEntry: {
//            JOLog(@"进入RunLoop执行任务");
//        }
//            break;
//        case kCFRunLoopBeforeWaiting: {
//            JOLog(@"线程执行完任务将要进入休眠状态");
//        }
//            break;
//        case kCFRunLoopAfterWaiting: {
//            JOLog(@"线程结束休眠将要执行任务");
//        }
//            break;
//        case kCFRunLoopExit: {
//            JOLog(@"Runloop将要退出");
//        }
//            break;
//        default:
//            break;
//    }
//}

+ (void)joThreadRunLoop {

    @autoreleasepool {
        [[NSThread currentThread] setName:@"JODefaultThread"];
        
//        CFRunLoopRef runloops = CFRunLoopGetCurrent();
        
        /*
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            
            switch (activity) {
                case kCFRunLoopEntry: {
                   NSLog(@"当RunLoop启动的时候");
                }
                    break;
                case kCFRunLoopBeforeWaiting: {
                    NSLog(@"即将进入睡眠状态");
                }
                    break;
                case kCFRunLoopAfterWaiting: {
                    NSLog(@"被唤醒将要执行任务");
                }
                    break;
                case kCFRunLoopExit: {
                    NSLog(@"将要退出");
                }
                default:
                    break;
            }
            
        });
        
        CFRunLoopAddObserver(runloops, observer, kCFRunLoopDefaultMode);
*/
        
        //对状态的监听
        
        /*
        CFRunLoopObserverRef pushObserverRef;
        pushObserverRef = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                  kCFRunLoopEntry,
                                                  YES,//是否重复监听
                                                  -0X7FFFFFFF,
                                                  JORunloopObserverCallBack,
                                                  NULL);
        CFRunLoopAddObserver(runloops, pushObserverRef, kCFRunLoopDefaultMode);
        CFRelease(pushObserverRef);
        
        CFRunLoopObserverRef popObserverRef;
        popObserverRef = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                 kCFRunLoopBeforeWaiting|kCFRunLoopAfterWaiting|kCFRunLoopExit,
                                                 YES,
                                                 0X7FFFFFFF,
                                                 JORunloopObserverCallBack,
                                                 NULL);
        CFRunLoopAddObserver(runloops, popObserverRef, kCFRunLoopDefaultMode);
        CFRelease(popObserverRef);
        
        CFRunLoopObserverRef afterObserverRef;
        afterObserverRef = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                 kCFRunLoopAfterWaiting,
                                                 YES,
                                                 0X7FFFFFFF,
                                                 JORunloopObserverCallBack,
                                                 NULL);
        CFRunLoopAddObserver(runloops, afterObserverRef, kCFRunLoopDefaultMode);
        CFRelease(afterObserverRef);
        
        CFRunLoopObserverRef exitObserverRef;
        exitObserverRef = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                 kCFRunLoopExit,
                                                 YES,
                                                 0X7FFFFFFF,
                                                 JORunloopObserverCallBack,
                                                 NULL);
        CFRunLoopAddObserver(runloops, exitObserverRef, kCFRunLoopDefaultMode);
        CFRelease(exitObserverRef);
        CFRunLoopRun();
        
//        CFRunLoopRun();
*/
        
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
        [runloop run];
    }
}

+ (NSThread *)joRunLoopThread {
    
    static NSThread *runLoopThread;
    JODispatchOnce(^{
        runLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(joThreadRunLoop) object:nil];
        [runLoopThread start];
    });
    return runLoopThread;
}

+ (NSThread *)joNewRunLoopThread {
 
    NSThread * runLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(joThreadRunLoop) object:nil];
    [runLoopThread start];
    return runLoopThread;
}

@end
