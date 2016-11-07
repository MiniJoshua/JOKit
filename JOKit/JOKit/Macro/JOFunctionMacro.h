//
//  JOFunctionMacro.h
//  JOKit
//
//  Created by 刘维 on 16/10/27.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <objc/runtime.h>
#import <sys/time.h>

#ifndef JOFunctionMacro_h
#define JOFunctionMacro_h

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
JODispacth_once(^{ \
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

#endif /* JOFunctionMacro_h */
