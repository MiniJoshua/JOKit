//
//  JOMacro.h
//  JOKit
//
//  Created by 刘维 on 16/8/2.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/time.h>

#ifndef JOMacro_h
#define JOMacro_h

#if OBJC_API_VERSION >= 2
#define JOGetClass(obj)	object_getClass(obj)
#else
#define JOGetClass(obj)	(obj ? obj->isa : Nil)
#endif

#ifdef DEBUG
#define JOLog(...) NSLog(@"[%s line:%d]  %@",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define JOLog(...)
#endif

#ifndef JO_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define JO_INSTANCETYPE instancetype
#else
#define JO_INSTANCETYPE id
#endif
#endif


#ifdef __cplusplus
#define JO_EXTERN		extern "C" __attribute__((visibility ("default")))
#else
#define JO_EXTERN	    extern __attribute__((visibility ("default")))
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
 @property (nonatomic, retain) CGPoint myPoint;
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
- (type)_getter_ { \
_type_ cValue = { 0 }; \
NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
[value getValue:&cValue]; \
return cValue; \
}
#endif


#import "JODateMacro.h"

#endif /* JOMacro_h */
