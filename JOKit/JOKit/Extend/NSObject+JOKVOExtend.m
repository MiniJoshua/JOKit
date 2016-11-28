//
//  NSObject+JOKVOExtend.m
//  JOKit
//
//  Created by 刘维 on 16/11/11.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "NSObject+JOKVOExtend.h"
#import "NSObject+JOExtend.h"
#import "JOMacro.h"
#import <objc/message.h>

static NSString     *const  kJOKVODefaultSubClassString = @"JOKVOSub";
static const char   * const kJOKVOAssociatedKey = "kJOKVOAssociatedKey";

@interface JOKVOItem : NSObject {
    
@public
    id                  _observeredObject;
    Class               _observerdClass;
    Class               _observerSubClass;
    NSMutableDictionary *_kvoBlockInfo;
}
@end

@implementation JOKVOItem

@end

@interface NSObject()

@property (nonatomic, strong) JOKVOItem *kvoItem;

@end

@implementation NSObject(JOKVOCustom)

JO_DYNAMIC_PROPERTY_OBJECT(kvoItem,setKvoItem,RETAIN,JOKVOItem *);

JO_STATIC_INLINE NSString * JOKVOSubClassName(Class class) {
    return [NSString stringWithFormat:@"JOKvoObserver%@",NSStringFromClass(class)];
}

JO_STATIC_INLINE SEL JOKVOSetSeletor(NSString *path) {
    
    NSString *firstLetter = [[path substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [path substringFromIndex:1];
    return NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters]);
}

JO_STATIC_INLINE void JOKVOAddMethod(Class selClass,SEL seletor, Class toClass, IMP imp) {

    Method setterMethod = class_getInstanceMethod(selClass, seletor);
    const char *types = method_getTypeEncoding(setterMethod);
    class_addMethod(toClass, seletor, imp, types);
}

- (void)joObserver:(id)observerObject path:(NSString *)path observerBlock:(JOKVOBlock)block {

    if (!self.kvoItem) {
        self.kvoItem = [JOKVOItem new];
        self.kvoItem->_kvoBlockInfo = [NSMutableDictionary dictionary];
    }
    
    if (![self.kvoItem->_observeredObject isEqual:observerObject]) {
        Class observerClass = JOGetClass(observerObject);
        Class observerSubClass = objc_allocateClassPair(observerClass, JOKVOSubClassName(observerClass).UTF8String, 0);
        
        self.kvoItem -> _observerdClass = observerClass;
        self.kvoItem -> _observerSubClass = observerSubClass;
        
        objc_registerClassPair(observerSubClass);
        object_setClass(observerObject, observerSubClass);
        
        self.kvoItem->_observeredObject = observerObject;
        
    }else {
        //已经生成过了的子类就务须理会了.
    }
    
    [self joRemoveObserverWithPath:path];
    [self.kvoItem->_kvoBlockInfo setObject:[block copy] forKey:path];
    JOKVOAddMethod(self.kvoItem -> _observerdClass, JOKVOSetSeletor(path), self.kvoItem -> _observerSubClass, (IMP)setIMP);
    objc_setAssociatedObject(observerObject, &kJOKVOAssociatedKey, self.kvoItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void setIMP(id self, SEL _cmd, id newValue) {
    
    NSString *setterName = NSStringFromSelector(_cmd);

    if ([setterName length] > 4) {
        
        NSRange range = NSMakeRange(3, setterName.length - 4);
        NSString *key = [setterName substringWithRange:range];
        NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
        key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                           withString:firstLetter];
        
        id oldValue = [self valueForKey:key];
        
        //获取到superClass 即原本的类 让原本的来去执行setter方法的执行
        struct objc_super superclazz = {
            .receiver = self,
            .super_class = class_getSuperclass(object_getClass(self))
        };
        //组装msg的执行函数
        void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
        //调用
        objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
        
        //执行Block
        JOKVOItem *KVOItem = objc_getAssociatedObject(self, &kJOKVOAssociatedKey);
        JOKVOBlock block = [KVOItem ->_kvoBlockInfo objectForKey:key];
        !block?:block(oldValue,newValue);
    }
}

- (void)joRemoveObserverWithPath:(NSString *)path {
    
    [self.kvoItem -> _kvoBlockInfo removeObjectForKey:path];
}

- (void)joRemoveAllObserver {
    
    [self.kvoItem -> _kvoBlockInfo removeAllObjects];
}

@end
