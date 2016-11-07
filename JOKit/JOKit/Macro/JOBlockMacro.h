//
//  JOBlockMacro.h
//  JOKit
//
//  Created by 刘维 on 16/10/31.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#ifndef JOBlockMacro_h
#define JOBlockMacro_h

#ifdef __BLOCKS__
__OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0)

/*
 一个可以任意参数无返回的block
 */
typedef void(^JO_argcBlock_t) ();
#ifndef JOArgcBlock
#define JOArgcBlock JO_argcBlock_t
#endif

/*
 一个无参无返回的block的
 */
typedef void (^JO_voidBlock_t)(void);
#ifndef JOVoidBlock
#define JOVoidBlock JO_voidBlock_t
#endif

/*
 单例
 */
DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
void JODispacth_once(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);

DISPATCH_INLINE DISPATCH_ALWAYS_INLINE DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
void JODispatchOnce(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,block);
}

#undef  JODispacth_once
#define JODispacth_once JODispatchOnce

/*
 作用域将要结束的时候执行
 用法:
 
 @JOExitExcute {
 
 //do something
 };
 
 */
JO_STATIC_INLINE void JO_executeCleanupBlock (__strong JO_voidBlock_t __nonnull * __nonnull block) { if (*block) (*block)(); }

#ifndef JOExitExcute
#define JOExitExcute \
JO_AITE_SUPPORT \
__strong JOVoidBlock JOMetaConcat_(JOExitBlock_, __LINE__) JOAttributeCleanup(JO_executeCleanupBlock)) = ^
#endif

#pragma mark - GCD

/*
 主线程的队列
 */
#define JODispatchMainQueue dispatch_get_main_queue()

/*
 queue create
 */
#define JODispatch_queue(_queueName_,_queueType_)   dispatch_queue_create(#_queueName_, _queueType_)

#define JODispatch_serial_queue(_queueName_)        JODispatch_queue(_queueName_, DISPATCH_QUEUE_SERIAL)
#define JODispatch_concurrent_queue(_queueName_)    JODispatch_queue(_queueName_, DISPATCH_QUEUE_CONCURRENT)

#define JODefaultSerialQueue        JODispatch_serial_queue(JODeafultSeriaQueue)
#define JODefaultConcurrentQueue    JODispatch_concurrent_queue(JODefaultConcurrentQueue)

#define JODispatchVoidDefineAttribute        DISPATCH_EXPORT DISPATCH_NONNULL_ALL
#define JODispatchVoidFuncAttribute         DISPATCH_INLINE DISPATCH_ALWAYS_INLINE DISPATCH_NONNULL_ALL
/*
 在主线程里面添加任务
 */
JODispatchVoidDefineAttribute
void JODispatchMainQueue_async(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchMainQueueAsync(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_async(JODispatchMainQueue, block);
}

#undef JODispatchMainQueue_async
#define JODispatchMainQueue_async JODispatchMainQueueAsync

//#define JODispatchMainQueue_async(JOVoidBlock) \
//dispatch_async(JODispatchMainQueue, JOVoidBlock);

/**
 开辟新的异步线程
 
 @param _queue_     队列
 @param JOVoidBlock JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_async(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchAsync(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_async(queue, block);
}
#undef JODispatch_async
#define JODispatch_async JODispatchAsync

/**
 开辟新的同步线程.
 
 @param _queue_     队列
 @param JOVoidBlock JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_sync(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchSync(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_sync(queue, block);
}
#undef JODispatch_sync
#define JODispatch_sync JODispatchSync

/**
 开辟新的异步串行队列的线程
 
 @param _queueName_ 线程的名字
 @param JOVoidBlock JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_serial_async(const char *_Nullable label,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchSerialAsync(const char *_Nullable label,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_async(JODispatch_serial_queue(label), block);
}
#undef JODispatch_serial_async
#define JODispatch_serial_async JODispatchSerialAsync


/**
 开辟新的异步并行队列的线程
 
 @param _queueName_ 线程的名字
 @param JOVoidBlock JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_concurrent_async(const char *_Nullable label,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchConcurrentAsync(const char *_Nullable label,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_async(JODispatch_concurrent_queue(label), block);
}
#undef JODispatch_concurrent_async
#define JODispatch_concurrent_async JODispatchConcurrentAsync

/**
 开辟新的同步串行队列的线程
 
 @param _queueName_ 线程的名字
 @param JOVoidBlock JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_serial_sync(const char *_Nullable label,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchSerialSync(const char *_Nullable label,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_sync(JODispatch_serial_queue(label), block);
}
#undef JODispatch_serial_sync
#define JODispatch_serial_sync JODispatchSerialSync

/**
 开辟新的同步并行队列的线程
 
 @param _queueName_ 线程的名字
 @param JOVoidBlock JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_concurrent_sync(const char *_Nullable label,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchConcurrentSync(const char *_Nullable label,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_async(JODispatch_concurrent_queue(label), block);
}
#undef JODispatch_concurrent_sync
#define JODispatch_concurrent_sync JODispatchConcurrentSync


/*
 优先级相关
 DISPATCH_QUEUE_PRIORITY_HIGH 2
 DISPATCH_QUEUE_PRIORITY_DEFAULT 0
 DISPATCH_QUEUE_PRIORITY_LOW (-2)
 DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN
 */
/**
 global的异步线程

 @param priority 优先级
 @param block JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_global_async(long priority,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchGolbalAsync(long priority,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_async(dispatch_get_global_queue(priority, 0), block);
}
#undef JODispatch_global_async
#define JODispatch_global_async JODispatchGolbalAsync

/**
 global的同步线程
 
 @param priority 优先级
 @param block JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_global_sync(long priority,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchGolbalSync(long priority,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_sync(dispatch_get_global_queue(priority, 0), block);
}
#undef JODispatch_global_sync
#define JODispatch_global_sync JODispatchGolbalSync

/**
 global的异步线程,默认的优先级:DISPATCH_QUEUE_PRIORITY_DEFAULT
 
 @param block JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_default_global_async(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchDefaultGolbalAsync(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    JODispatchGolbalAsync(DISPATCH_QUEUE_PRIORITY_DEFAULT, block);
}
#undef JODispatch_default_global_async
#define JODispatch_default_global_async JODispatchDefaultGolbalAsync

/**
 global的同步线程,默认的优先级:DISPATCH_QUEUE_PRIORITY_DEFAULT
 
 @param block JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_default_global_sync(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchDefaultGolbalSync(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    JODispatchGolbalSync(DISPATCH_QUEUE_PRIORITY_DEFAULT, block);
}
#undef JODispatch_default_global_sync
#define JODispatch_default_global_sync JODispatchDefaultGolbalSync

/*
 关于dispatch_after相关:
 不是一段时间后执行相应的任务,而是一段时间后将执行的操作加入到队列中去执行.
 NSEC_PER_SEC 秒
 NSEC_PER_MSEC 毫秒
 NSEC_PER_USEC 微秒
 主线程 RunLoop 1/60秒检测时间，追加的时间范围 3s~(3+1/60)s
 */
/**
 延迟执行一个Block

 @param timeInterval 延迟的时间间隔.
 @param queue 在哪个queue中执行.
 @param block JO_voidBlock_t.
 */
JODispatchVoidDefineAttribute
void JODispatch_after(NSTimeInterval timeInterval,dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchAfter(NSTimeInterval timeInterval,dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), queue, block);
}
#undef JODispatch_after
#define JODispatch_after JODispatchAfter

/**
 延迟执行一个Block,默认在main线程中执行
 
 @param timeInterval 延迟的时间间隔.
 @param block JO_voidBlock_t.
 */
JODispatchVoidDefineAttribute
void JODispatch_default_after(NSTimeInterval timeInterval,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchDefaultAfter(NSTimeInterval timeInterval,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    JODispatchAfter(timeInterval, JODispatchMainQueue, block);
}
#undef JODispatch_default_after
#define JODispatch_default_after JODispatchDefaultAfter

/**
 会等待在barrier中加入之前的block执行完了才会执行barrier的block操作,后加入的必须等待barrier中的Block执行完才会去执行
 有点类似于NSOperation中的依赖关系
 PS:If the queue you pass to this function is a serial queue or one of the global concurrent queues,
    this function behaves like the dispatch_async function.
 只能在自己创建的queue中使用,且必须是并行的queue,如果是串行的queue跟gloab的queue,效果就是dispatch_async
 
 @param queue 添加到那个线程池queue中
 @param block 执行的block
 */
JODispatchVoidDefineAttribute
void JODispatch_barrier_async(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchBarrierAsync(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_barrier_async(queue, block);
}
#undef JODispatch_barrier_async
#define JODispatch_barrier_async JODispatchBarrierAsync

/**
 @see JODispatch_barrier_async 
      不同的是,这个是在queue中同步执行的
 
 @param queue 添加到那个线程池queue中
 @param block 执行的block
 */
JODispatchVoidDefineAttribute
void JODispatch_barrier_sync(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchBarrierSync(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_barrier_sync(queue, block);
}
#undef JODispatch_barrier_sync
#define JODispatch_barrier_sync JODispatchBarrierSync

/**
 让fromQueue中还未执行的的Block执行的代码在toQueue中的Block中执行,
 若对fromQueue做dispatch_suspend挂起,将不会让在toQueue中Block执行的代码收到影响.

 @param fromQueue 来自那个线程池queue.
 @param toQueue 指定到哪个线程池quque.
 */
JODispatchVoidDefineAttribute
void JODispatch_set_target_queue(dispatch_queue_t __nonnull fromQueue,dispatch_queue_t __nonnull toQueue);
JODispatchVoidFuncAttribute
void JODispatchSetTargetQueue(dispatch_queue_t __nonnull fromQueue,dispatch_queue_t __nonnull toQueue) {
    dispatch_set_target_queue(fromQueue, toQueue);
}
#undef JODispatch_set_target_queue
#define JODispatch_set_target_queue JODispatchSetTargetQueue

/*
 会在线程池被销毁的时候执行(线程池的析构函数)
 PS:调用了JODispatchQueueDealloc之后 你在用dispatch_get_context取得的值将会是一个字典类型,对应的KEY:
 kQueueContextBlockKey  可以通过这个取你给定的Block
 kQueueContextKey       通过这个取你原来设置的context的值

 context在里面已经调用了free,你不用在block里面再去释放,你可以在block里面(释放之前)提取一下你需要的数据出来保存
 dispatch_set_context 转换对象类型的时候 要用__bridge_retained 将内存管理权给自己,不要给系统,不然他会被释放掉,你拿不到该值从而引起crash
 dispatch_set_context(queue, (__bridge_retained void * _Nullable)([WhyModel new]));
 */
//获取block的key
static NSString *__nonnull const kQueueContextBlockKey = @"kQueueContextBlockKey";
//获取你设置的context的值
static NSString *__nonnull const kQueueContextKey = @"kQueueContextKey";

JODispatchVoidDefineAttribute
void JODispatch_queue_dealloc(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_argcBlock_t __nonnull block);
DISPATCH_INLINE DISPATCH_ALWAYS_INLINE
void JOQueueDealloc(void * _Nullable context) {
    
    NSDictionary *contextDic = (__bridge NSDictionary *)(context);
    JO_argcBlock_t block = contextDic[kQueueContextBlockKey];
    !block?:block(contextDic[kQueueContextKey]);
    block = nil;
    CFRelease((__bridge CFTypeRef)(contextDic[kQueueContextKey]));
    CFRelease(context);
}
DISPATCH_INLINE DISPATCH_ALWAYS_INLINE
void JODispatchQueueDealloc(dispatch_queue_t __nonnull queue,DISPATCH_NOESCAPE JO_argcBlock_t _Nullable block) {
    id contextObject = (__bridge id)(dispatch_get_context(queue));
    NSDictionary *newContxt = nil;
    if (block) {
        !contextObject?(newContxt = @{kQueueContextBlockKey:[block copy]}):(newContxt =@{kQueueContextBlockKey:[block copy],kQueueContextKey:contextObject});
    }else {
        !contextObject?(newContxt = [NSDictionary dictionary]):(newContxt =@{kQueueContextKey:contextObject});
    }
#if !__has_feature(objc_arc)
    dispatch_set_context(queue, (__bridge void * _Nullable)(newContxt));
#else
    dispatch_set_context(queue, (__bridge_retained void * _Nullable)(newContxt));
#endif
    dispatch_set_finalizer_f(queue, &JOQueueDealloc);
}
#undef JODispatch_queue_dealloc
#define JODispatch_queue_dealloc JODispatchQueueDealloc

/*
 在并发队列里面循环执行100次这个操作.如果指定串行队列的话就没有必要了。
 在所有迭代完之后才会有返回.会阻塞当前的线程全部执行完之后才能继续其他线程的工作.
 循环迭代执行的工作量需要仔细平衡，太多的话会降低响应性;太少则会影响整体性能，因为调度的开销大于实际执行代码。
 */

/**
 并发队列重复执行某个操作

 @param count 执行的次数
 @param queue 并发的队列
 @param block JO_argcBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_apply(size_t count, dispatch_queue_t __nonnull queue , DISPATCH_NOESCAPE JO_argcBlock_t _Nullable block);
JODispatchVoidFuncAttribute
void JODispatchApply(size_t count, dispatch_queue_t __nonnull queue , DISPATCH_NOESCAPE JO_argcBlock_t _Nullable block) {
    dispatch_apply(count, queue, block);
}
#undef JODispatch_apply
#define JODispatch_apply JODispatchApply

/**
 并发队列重复执行某个操作, 默认在全局队列中优先级为DISPATCH_QUEUE_PRIORITY_DEFAULT
 
 @param count 执行的次数
 @param block JO_argcBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_default_apply(size_t count, DISPATCH_NOESCAPE JO_argcBlock_t _Nullable block);
JODispatchVoidFuncAttribute
void JODispatchDefaultApply(size_t count, DISPATCH_NOESCAPE JO_argcBlock_t _Nullable block) {
    JODispatch_apply(count,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
#undef JODispatch_default_apply
#define JODispatch_default_apply JODispatchDefaultApply

#endif
#endif /* JOBlockMacro_h */
