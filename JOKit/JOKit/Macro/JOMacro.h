//
//  JOMacro.h
//  JOKit
//
//  Created by 刘维 on 16/8/2.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef JOMacro_h
#define JOMacro_h

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
 
 */

//#define JOGCCIgnored(JOArgcBlock) \
//_Pragma("clang diagnostic push") \
//_Pragma("clang diagnostic ignored \"-Wunused-variable\"") \
//_Pragma("clang diagnostic pop")


#pragma mark - attribute

#ifdef __cplusplus
#define JO_EXTERN		extern "C" __attribute__((visibility ("default")))
#else
#define JO_EXTERN	    extern __attribute__((visibility ("default")))
#endif

/*
 在这个对象作用域将要结束的时候被调用,被调用的顺序是按栈的顺序先进后调用的原则
 unused告诉编译器这个方法可能不会被用到,这样不会出现警告啥的
 具体用法查看:
 JOExitExcute
 */
#define JOAttributeCleanup(_cleanupMethod_) __attribute__((cleanup(_cleanupMethod_), unused)

/*
 更多相关属性查阅:
 https://gcc.gnu.org/onlinedocs/gcc-4.0.0/gcc/Function-Attributes.html
 */
#define JOAttributeNoreturn                 __attribute__((noreturn))   //无返回值
#define JOAttributeConst                    __attribute__((const))

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

#pragma mark -

#define JOMetaConcat_(A, B) A ## B
#define JOMetaConcat(A, B) JOMetaConcat_(A, B)

#if OBJC_API_VERSION >= 2
#define JOGetClass(obj)	object_getClass(obj)
#else
#define JOGetClass(obj)	(obj ? obj->isa : Nil)
#endif

#ifdef DEBUG
#define JOLog(...) NSLog(@"[%s line:%d]  %@",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
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

#import "JOFunctionMacro.h"
#import "JODateMacro.h"
#import "JOBlockMacro.h"

#endif /* JOMacro_h */
