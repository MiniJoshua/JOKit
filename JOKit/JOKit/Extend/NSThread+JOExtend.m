//
//  NSThread+JOExtend.m
//  JOKit
//
//  Created by 刘维 on 16/10/26.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "NSThread+JOExtend.h"
#import <CoreFoundation/CoreFoundation.h>
#import "JOMacro.h"

/*
 根据YYKit中来实现
 */

/*
 系统提供出来让使用的Model:
 kCFRunLoopDefaultMode      //默认的Model
 kCFRunLoopCommonModes      //添加到Model里面的timer Source/input source/Observer 在切换Model的时候会被同步到新切换的Model中去
 
 为Runloop添加Observer的几种状态 CFRunLoopActivity
 kCFRunLoopEntry            //RunLoop准备开始执行
 kCFRunLoopBeforeTimers     //Runloop将要执行一个timer source的事件.
 kCFRunLoopBeforeSources    //Runloop将要执行一个事件源的事件.
 kCFRunLoopBeforeWaiting    //Runloop将要进入休眠等待状态
 kCFRunLoopAfterWaiting     //Runloop被唤醒还未开始执行事件消息
 kCFRunLoopExit             //Runloop退出时.
 kCFRunLoopAllActivities    //Runlopp处于活动状态.
 
 Runloop执行的几种结果状态 CFRunLoopRunResult
 kCFRunLoopRunFinished      //Runloop执行完了分发的任务,再无新的任务将会退出
 kCFRunLoopRunStopped       //Runloop通过CFRunLoopStop函数强制退出
 kCFRunLoopRunTimedOut      //Runloop因为超时而退出
 kCFRunLoopRunHandledSource //Runloop执行完任务退出
 */

static NSString *const kThreadAutoreleasePoolStateKey = @"kThreadAutoreleasePoolStateKey";
static NSString *const kThreadAutoreleaseStackKey = @"kThreadAutoreleaseStackKey";

@interface NSThread_JOExtend : NSObject @end
@implementation NSThread_JOExtend @end

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif

JO_STATIC_INLINE void JOAutoreleasePoolPush() {

    NSMutableDictionary *threadDic = [[NSThread currentThread] threadDictionary];
    NSMutableArray *poolStack = [threadDic objectForKey:kThreadAutoreleaseStackKey];
    
    if (!poolStack) {
        poolStack = [NSMutableArray array];
        [threadDic setObject:poolStack forKey:kThreadAutoreleaseStackKey];
        
//        CFArrayCallBacks callbacks = {0};
//        poolStack = (id)CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
//        [threadDic setObject:poolStack forKey:kThreadAutoreleaseStackKey];
//        CFRelease(poolStack);
    }
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    [poolStack addObject:autoreleasePool];
}

JO_STATIC_INLINE void JOAutoreleasePoolPop() {
    
    NSMutableDictionary *threadDic = [[NSThread currentThread] threadDictionary];
    NSMutableArray *poolStack = [threadDic objectForKey:kThreadAutoreleaseStackKey];
    NSAutoreleasePool *pool = [poolStack lastObject];
    [poolStack removeLastObject];
    [pool release];
}

static void JORunloopAutoreleasePoolObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    switch (activity) {
        case kCFRunLoopEntry: {
            JOAutoreleasePoolPush();
        }
            break;
        case kCFRunLoopBeforeWaiting: {
            JOAutoreleasePoolPop();
            JOAutoreleasePoolPush();
        }
            break;
        case kCFRunLoopExit: {
            JOAutoreleasePoolPop();
        }
            break;
        default:
            break;
    }
}

static void JORunloopAutoreleasePoolSetup() {
    
    JODispacth_once(^{
        
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        CFRunLoopObserverRef pushObserverRef;
        pushObserverRef = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                  kCFRunLoopEntry,
                                                  YES,//是否重复监听
                                                  -0X7FFFFFFF, //索引值 CFIndex是有符的long行 这里给定的是最小值 ,runloop会按索引值从低到高依次处理.所以他会在其他的Observer的前面
                                                  JORunloopAutoreleasePoolObserverCallBack,
                                                  NULL);
        CFRunLoopAddObserver(runloop, pushObserverRef, kCFRunLoopCommonModes);
        CFRelease(pushObserverRef);
        
        CFRunLoopObserverRef popObserverRef;
        popObserverRef = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                 kCFRunLoopBeforeWaiting|kCFRunLoopExit,
                                                 YES,
                                                 0X7FFFFFFF,//最大值,保证他会在其他的Observer的后面
                                                 JORunloopAutoreleasePoolObserverCallBack,
                                                 NULL);
        CFRunLoopAddObserver(runloop, popObserverRef, kCFRunLoopCommonModes);
        CFRelease(popObserverRef);
    });
}

@implementation NSThread(JOExtend)

+ (void)addAutoreleasePoolToCurrentRunLoop {

    //主线程的RunLoop已有自动释放池,不需要添加
    if ([NSThread isMainThread])  return;
    NSThread *currentThread = [NSThread currentThread];
    //当前线程为空的,直接返回
    if (!currentThread) return;
    //已经添加过的,直接返回
    if ([[currentThread threadDictionary] objectForKey:kThreadAutoreleasePoolStateKey])  return;
    //为RunLoop添加类似于主线程的Runloop的自动释放池的功能
    JORunloopAutoreleasePoolSetup();
    //为添加过的标记已添加的状态
    [[currentThread threadDictionary] setObject:kThreadAutoreleasePoolStateKey forKey:kThreadAutoreleasePoolStateKey];
}

@end
