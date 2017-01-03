//
//  JOMacro.h
//  JOKit
//
//  Created by 刘维 on 16/8/2.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <sys/time.h>

/*
 https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
 消除某些编译器的警告:
 1.方法弃用告警
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wdeprecated-declarations"
 //代码
 #pragma clang diagnostic pop
 
 2.指针类型不兼容
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wincompatible-pointer-types"
 //代码
 #pragma clang diagnostic pop
 
 3.循环引用
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Warc-retain-cycles"
 //代码
 #pragma clang diagnostic pop
 
 4.未使用变量
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wunused-variable"
 //代码
 #pragma clang diagnostic pop
 
 5.代码不会被执行 e.g:else语句中
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wunreachable-code"
 //代码
 #pragma clang diagnostic pop
 */

//#define JOGCCIgnored(JOArgcBlock) \
//_Pragma("clang diagnostic push") \
//_Pragma("clang diagnostic ignored \"-Wunused-variable\"") \
//_Pragma("clang diagnostic pop")

#pragma mark - base
#pragma mark -

#define JOBitsNum(_type_) sizeof(_type_)*8

#define JOMetaConcat_(A, B) A ## B
#define JOMetaConcat(A, B) JOMetaConcat_(A, B)

#if OBJC_API_VERSION >= 2
#define JOGetClass(obj)	object_getClass(obj)
#else
#define JOGetClass(obj)	(obj ? obj->isa : Nil)
#endif

#ifdef DEBUG
#define JOLog(...) printf("[%s line:%d]  %s\n",__func__,__LINE__,[[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define JOLog(...) do{} while(0)
#endif

#ifndef JO_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define JO_INSTANCETYPE instancetype
#else
#define JO_INSTANCETYPE id
#endif
#endif

#if !defined(JO_STATIC_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define JO_STATIC_INLINE static inline
# elif defined(__cplusplus)
#  define JO_STATIC_INLINE static inline
# elif defined(__GNUC__)
#  define JO_STATIC_INLINE static __inline__
# else
#  define JO_STATIC_INLINE static
# endif
#endif

//#define JO_STATIC_INLINE  static inline

#define JOArgumentsCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

/*
 version请查看 Availabilty.h中的定义 __IPHONE_2_0 ....
 */
#define JOAllowMinSystemVersion(version) __IPHONE_OS_VERSION_MAX_ALLOWED >= version

#define JOBlock_Variable              __block
#define JOBlock_WeakSelf_MRC          __block typeof(self) //非ARC
#define JOBlock_WeakSelf              __weak typeof(self)  //ARC
#define JOBlock_StrongObject(object)  __strong typeof(object)

/*
 让语句支持@符号
 */
#ifndef JO_AITE_SUPPORT
#if DEBUG
#define JO_AITE_SUPPORT autoreleasepool{}
#else
#define JO_AITE_SUPPORT try{} @finally{}
#endif
#endif

/**
 避免在使用block的时候出现循环引用.
 block体中使用weak self避免引起循环引用
 strong这个weak self是为了避免在block执行过程中self被释放.
 示例:
 @weakify(self)
 [self handlerOperation^{
 @strongify(self)
 [self doSomeThing];
 }];
 */

#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(object) JO_AITE_SUPPORT __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) JO_AITE_SUPPORT __block __typeof__(object) block##_##object = object;
#endif
#endif


#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(object) JO_AITE_SUPPORT __typeof__(object) object = weak##_##object;
#else
#define strongify(object) JO_AITE_SUPPORT __typeof__(object) object = block##_##object;
#endif
#endif

#pragma mark - attribute
#pragma mark -

#ifdef __cplusplus
#define JO_EXTERN		extern "C" __attribute__((visibility ("default")))
#else
#define JO_EXTERN	    extern __attribute__((visibility ("default")))
#endif


/*
 更多相关属性查阅:
 https://gcc.gnu.org/onlinedocs/gcc-4.0.0/gcc/Function-Attributes.html
 */

/*
#define NS_RETURNS_RETAINED         __attribute__((ns_returns_retained))
#define NS_RETURNS_NOT_RETAINED     __attribute__((ns_returns_not_retained))
#define NS_RETURNS_INNER_POINTER    __attribute__((objc_returns_inner_pointer))
 这三个都属于系统自己使用的标示.
 即:指命名上表示一类型的方法,-init和 -initWithMark:都属于初始化的家族方法.
 编译器有过约定，对于alloc,init,copy,mutableCopy,new这几个的方法，后面默认加NS_RETURNS_RETAINED标识,
 所以你要是使用这些去命名一个属性或者方法的时候,都会得到错误的编译信息.
 e.g:
 所以想要使用一个new开头的名字则需要添加NS_RETURNS_NOT_RETAINED该属性才能通过编译
 id NS_RETURNS_NOT_RETAINED newValue;
 
 因为系统已经定义了这三个宏 就不再这重新定义宏了,在这说明一下
 */

#define JOAttributeNoreturn                 __attribute__((noreturn))   //无返回值
#define JOAttributeConst                    __attribute__((const))

/*
 C指针类型的参数或者Block指针类型可以使用noescape新属性标志，
 它用来标明这个指针参数不会离开这个函数或者方法而使用。即该参数的生命周期不会比这个函数的生命周期要长
 尤其对block来说有用,因为Block是异步调用的,很多时候这个函数的生命周期已经走完,但这个block可能会在这个函数生命周期走完再执行
 加上这个属性可以阻止这种情况存在.
 e.g:- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(ObjectType obj, BOOL *stop))block (系统的方法)
 */
#define JOAttributeNoescape                 __attribute__((noescape))

/*
 在这个对象作用域将要结束的时候被调用,被调用的顺序是按栈的顺序先进后调用的原则
 unused告诉编译器这个方法可能不会被用到,这样不会出现警告啥的
 具体用法查看:
 JOExitExcute
 */
#define JOAttributeCleanup(_cleanupMethod_) __attribute__((cleanup(_cleanupMethod_), unused)

/*
 不允许有子类
 用法:
 JOAttributeSubclassRestricted
 @interface People : NSObject{
 }
 @end
 
 此时如果你尝试
 @interface Man : People{
 }
 @end
 将会得到一个编译的错误:
 Cannot subclass a class with objc_subclassing_restricted attribute
 */
#define JOAttributeSubclassRestricted       __attribute__((objc_subclassing_restricted))

/*
 方法中需要调用super,不然编译器将会给出警告
 用法:
 @interface People : NSObject{
 }
 - (void)people JOAttributeSuper;
 @end
 在其子类里面重载了该方法但是没有调用super将会得到警告
 @interface Man : People{
 }
 @end
 @implementation Man
 - (void)people {
 //为调用[super people] 得到警告: Method possibly missing a [super people] call
 }
 @end
 */
#define JOAttributeSuper                    NS_REQUIRES_SUPER  //__attribute__((objc_requires_super))

/*
 将一个struct类型 或 union类型通过@()转换成NSValue对象
 用法:
 typedef struct JOAttributeBox{
    int age;
    float weight;
 }Peoples;
 然后使用:
 Peoples people = {34,55.6};
 NSValue *peoplesValue = @(people);
 */
#define JOAttributeBox                      __attribute__((objc_boxable))

/*
 constructor 在main函数调用之前调用  但是在+load方法之后调用 执行的时候所有的class都加载完成了 不需要在固定的class的里面实现
 destructor  在main函数return之后才调用
 priority 代表优先级 1-100为系统级别的 需要设置的是从101开始 数字越小优先级越高  存在多个的时候可以通过设置这个优先级来区分执行顺序
 
 用法:
 实现两个方法指定对应的属性,可以在任意的地方实现
 JOAttributeConstructor static void beforeExcute(void) {
        //会在main函数调用之前执行
    }
 JOAttributeDestructor static void afterExcute(void) {
        //会在main函数renturn之后
    }
 
 测试得出正常在后台退出应用是会执行destructor对应的函数的,但是carsh掉的好像并未得出其对应函数的执行
 */
#define JOAttributeConstructors(priority)    __attribute__((constructor(priority)))
#define JOAttributeDestructors(priority)     __attribute__((destructor(priority)))
#define JOAttributeConstructor              JOAttributeConstructors(101)
#define JOAttributeDestructor               JOAttributeDestructors(101)

/*
 仅能对C语言风格函数
 用法:
 static void sum(int a,int b) JOAttributeEnableIf(a<20 && b < 10,"仅仅是提示作用,不会在错误中显示出来"){
    NSLog(@"%d",a+b);
 }
 下面调用:
 sum(30,5);
 将会得到错误:No matching function for call to 'sum'
 */
#define JOAttributeEnableIf(_condition_,msg) __attribute__((enable_if(_condition_, #msg)))

/*
 仅能针对C风格的函数，可以定义若干个函数名相同，但参数不同的方法，调用时编译器能根据参数自动选择函数原型
 用法:
 JOAttributeOverloadable static void add(int a, int b) {
    NSLog(@"%d",a+b);
 }
 
 JOAttributeOverloadable static void add(int a, int b, int c) {
    NSLog(@"%d",a+b+c);
 }
 
 JOAttributeOverloadable static void add(int a, int b, int c, int d) {
    NSLog(@"%d",a+b+c+d);
 }
 
 add(1,2);
 add(1,2,3);
 add(1,2,3,4);
 */
#define JOAttributeOverloadable             __attribute__((overloadable))

/*
 将类或协议的名字在编译时指定成给定的名字
 用法:
 JOAttributeChangeClassName("FuckPeople")
 @interface People : NSObject{
 }
 @end
 
 NSLog(@"peopleClass:%@",NSStringFromClass([People class]));//得到的是FuckPeople
 */
#define JOAttributeChangeClassName(newName)__attribute__((objc_runtime_name(#newName)))

#pragma mark - Function
#pragma mark - 

JO_STATIC_INLINE void JOPrintBits_(size_t const size, void const *__nonnull const p) {
    unsigned char *ptr = (unsigned char *)p;
    unsigned char byte;
    for (int i = (int)size - 1; i >= 0; i--) {
        for (int j = JOBitsNum(byte)-1; j >= 0 ; j--) {
            byte = ((ptr[i] >> j)&1) + '0';
            printf("%c",byte);
        }
    }
    printf("\n");
}

#ifndef JOPrintBits
#define JOPrintBits(_value_) JOPrintBits_(sizeof(_value_),&_value_)
#endif

/*
 //存在内存泄露的风险,移除.
JO_STATIC_INLINE char *__nonnull JOBitsCharStr_(size_t const size, void const *__nonnull const p) {

    unsigned char *ptr = (unsigned char *)p;
    unsigned char byte;
    char *pByte = malloc(size*8 +1); //多一位用来存放结束的标识符:\0
//    size_t charCount = size*8 +1;
//    char pByte[charCount];
    int tempPtr = 0;
    for (int i = (int)size - 1; i >= 0; i--) {
        for (int j = JOBitsNum(byte)-1; j >= 0 ; j--) {
            byte = ((ptr[i] >> j)&1) + '0';
            pByte[tempPtr] = byte;
            tempPtr++;
        }
    }
    pByte[tempPtr] = '\0';
    return pByte;
}
 
 #ifndef JOBitsCharStr
 #define JOBitsCharStr(_value_) JOBitsCharStr_(sizeof(_value_),&_value_)
 #endif
 
 #ifndef JOBitsString
 #define JOBitsString(_value_) [NSString stringWithUTF8String:JOBitsCharStr(_value_)]
 #endif
*/

/*Exception*/
#ifndef JOThrowException
#define JOThrowException(exceptionName , reason) \
NS_DURING \
[NSException raise:exceptionName format:@"%@",reason]; \
NS_HANDLER \
NSLog(@"ExceptionName:%@ %@",exceptionName,reason); \
NS_ENDHANDLER
#endif

/*
 单例的方法实现
 */
#ifndef JO_OBJECT_SINGLETION
#define JO_OBJECT_SINGLETION(_class_name_,_shared_func_name_) \
+ (instancetype)_shared_func_name_ { \
static _class_name_ *jo##_shared_func_name_; \
static dispatch_once_t onceToken; \
Jdispatch_once(&onceToken, ^{ \
jo##_shared_func_name_ = [_class_name_ alloc] init]; \
}); \
return jo##_shared_func_name_; \
}
#endif

#ifndef JO_DEFAULT_OBJECT_SINGLETION
#define JO_DEFAULT_OBJECT_SINGLETION(_class_name_) { \
return JO_OBJECT_SINGLETION(_class_name_,shareInstance); \
}
#endif

/*
 在扩展协议(Category)中动态的添加一个属性对象.
 因为使用了动态的对象关联,使用的时候需要导入 #import <objc/runtime.h>
 association: ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 _cmd: 为当前方法的selector (typedef struct objc_selector *SEL)
 
 示例:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 JO_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef JO_DYNAMIC_PROPERTY_OBJECT
#define JO_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object{ \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

/*
 在扩展协议(Category)中动态的添加一个属性.只是该属性是一个对象:int float enum CGPoint CGRect...
 
 示例:
 @interface NSObject (MyAdd)
 @property (nonatomic) CGPoint myPoint;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 JO_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
 @end
 */
#ifndef JO_DYNAMIC_PROPERTY_CTYPE
#define JO_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
_type_ cValue; \
NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
[value getValue:&cValue]; \
return cValue; \
}
#endif

#pragma mark - Block 
#pragma mark -

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
 BUG:这么写存在一个问题,因为是static dispatch_once_t onceToken;
 将会导致只有第一次调用有效,第二次调用的话发现onceToken每次得到的地址都没改变,所以注释掉该方法.
 */

//DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
//void JODispacth_once(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
//
//DISPATCH_INLINE DISPATCH_ALWAYS_INLINE DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
//void JODispatchOnce(DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
//    
//    static dispatch_once_t onceToken;
//    NSLog(@"地址:%p",&onceToken);
//    dispatch_once(&onceToken,block);
//}
//
//#undef  JODispacth_once
//#define JODispacth_once JODispatchOnce


/**
 方法执行的耗时.单位为毫秒

 @param block JO_voidBlock_t
 */
JO_STATIC_INLINE void JOFunCostTime(JO_voidBlock_t __nonnull block) {
    
    struct timeval start, end;
    gettimeofday(&start, NULL);
    block();
    gettimeofday(&end, NULL);
    double ms = (double)(end.tv_sec - start.tv_sec) * 1e3 + (double)(end.tv_usec - start.tv_usec) * 1e-3;
    JOLog(@"耗时: %f 毫秒",ms);
}

/*
 作用域将要结束的时候执行,多半用于在该作用域释放某个需要释放的对象.
 用法:
 
 @JOExitExcute {
 
 //do something
 };
 
 */
JO_STATIC_INLINE void JO_executeCleanupBlock (__strong JO_voidBlock_t __nonnull * __nonnull block) { !(*block)?:(*block)(); }

#ifndef JOExitExcute
#define JOExitExcute \
JO_AITE_SUPPORT \
__strong JOVoidBlock JOMetaConcat_(JOExitBlock_, __LINE__) JOAttributeCleanup(JO_executeCleanupBlock)) = ^
#endif

#pragma mark - GCD
#pragma mark -

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

/**
 dispatch的group组.

 @param group group.
 @param block JO_voidBlock_t
 */
JODispatchVoidDefineAttribute
void JODispatch_group_async(dispatch_group_t __nonnull group,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchGroupAsync(dispatch_group_t __nonnull group,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_group_enter(group);
    !block?:block();
    dispatch_group_leave(group);
}
#undef JODispatch_group_async
#define JODispatch_group_async JODispatchGroupAsync

/**
 会阻塞group的线程 等待其中所有的任务都完成了才会执行.

 @param group group.
 @param block JO_voidBlock_t.
 */
JODispatchVoidDefineAttribute
void JODispatch_group_complete(dispatch_group_t __nonnull group,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block);
JODispatchVoidFuncAttribute
void JODispatchGroupComplete(dispatch_group_t __nonnull group,DISPATCH_NOESCAPE JO_voidBlock_t __nonnull block) {
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    !block?:block();
}
#undef JODispatch_group_complete
#define JODispatch_group_complete JODispatchGroupComplete

#endif

#pragma mark - Date
#pragma mark - 

/*
 DateFormat
 */
static NSString * __nonnull const kDateFormatterComplete           = @"yyyy-MM-dd HH:mm:ss";
static NSString * __nonnull const kDateFormatterYear               = @"yyyy";
static NSString * __nonnull const kDateFormatterMonth              = @"MM";
static NSString * __nonnull const kDateFormatterDay                = @"dd";
static NSString * __nonnull const kDateFormatterHour               = @"HH";
static NSString * __nonnull const kDateFormatterMinute             = @"mm";
static NSString * __nonnull const kDateFormatterSecond             = @"ss";

static NSString * __nonnull const kDateFormatterYear_Month_Day     = @"yyyy-MM-dd";
static NSString * __nonnull const kDateFormatterYear_Month         = @"yyyy-MM";
static NSString * __nonnull const kDateFormatterMonth_Day          = @"MM-dd";

static NSString * __nonnull const kDateFormatterHour_Minute_Second = @"HH:mm:ss";
static NSString * __nonnull const kDateFormatterHour_Minute        = @"HH:mm";
static NSString * __nonnull const kDateFormatterMinute_Second      = @"mm:ss";

/*
 每个时间单位包含的秒数
 */
static const long long kSeconds_Year                    = 31556900;
static const NSInteger kSeconds_Month28                 = 2419200;
static const NSInteger kSeconds_Month29                 = 2505600;
static const NSInteger kSeconds_Month30                 = 2592000;
static const NSInteger kSeconds_Month31                 = 2678400;
static const NSInteger kSeconds_Week                    = 604800;
static const NSInteger kSeconds_Day                     = 86400;
static const NSInteger kSeconds_Hour                    = 3600;
static const NSInteger kSeconds_Minute                  = 60;
static const NSInteger kMilliSeconds_Second             = 1000; //1000毫秒 = 1秒

/**
 根据系统的时区去获取Date,这样取出来的时间不会存在8个小时的差别
 获取中国时区的格式:
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 
 @return Date.
 */
JO_STATIC_INLINE NSDate * _Nullable JODate() {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date dateByAddingTimeInterval: interval];
}

