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

static const char * const JOKVONotificationCenterHelpersKey = "JOKVONotificationCenterHelpersKey";

@interface JOKVONotificationItem(){

    NSDictionary <NSKeyValueChangeKey,id>*_change;
}

@property (nonatomic, copy, readwrite) NSString *keyPath;
@property (nonatomic, weak, readwrite) id       observer;
@property (nonatomic, weak, readwrite) id       observered;

- (JO_INSTANCETYPE)initWithObserver:(id)observer observered:(id)observered keyPath:(NSString *)keyPath change:(NSDictionary<NSKeyValueChangeKey,id> *)change;

@end

@implementation JOKVONotificationItem

- (JO_INSTANCETYPE)initWithObserver:(id)observer observered:(id)observered keyPath:(NSString *)keyPath change:(NSDictionary<NSKeyValueChangeKey,id> *)change {

    self = [super init];
    if (self) {
        self.observer = observer;
        self.observered = observered;
        self.keyPath = keyPath;
        _change = change;
    }
    return self;
}

- (NSKeyValueChange)kind {
    return [_change[NSKeyValueChangeKindKey] unsignedIntegerValue];
}

- (id)newValue {
    return _change[NSKeyValueChangeNewKey];
}

- (id)oldValue {
    return _change[NSKeyValueChangeOldKey];
}

- (NSIndexSet *)indexes {
    return _change[NSKeyValueChangeIndexesKey];
}

- (BOOL)isPrior {
    return [_change[NSKeyValueChangeNotificationIsPriorKey] boolValue];
}

@end

@interface JOKVONotificationHelper : NSObject

@property (nonatomic, weak)     id                          observer;
@property (nonatomic, weak)     id                          observered;
@property (nonatomic, copy)     NSString                    *keyPath;
@property (nonatomic, assign)   NSKeyValueObservingOptions	options;
@property (nonatomic, copy)     JOKVOBlock                  kvoBlock;

- (JO_INSTANCETYPE)initWithObserver:(id)observer
                      observered:(id)observered
                         keyPath:(NSString *)keyPath
                         options:(NSKeyValueObservingOptions)options
                           block:(JOKVOBlock)block;

@end

@implementation JOKVONotificationHelper

static char *JOKVONotificationHelperContext = "JOKVONotificationHelperContext";

- (JO_INSTANCETYPE)initWithObserver:(id)observer
                         observered:(id)observered
                            keyPath:(NSString *)keyPath
                            options:(NSKeyValueObservingOptions)options
                              block:(JOKVOBlock)block {
    
    if ((self = [super init])) {
        self.observer = observer;
        self.observered = observered;
        self.keyPath = keyPath;
        self.options = options;
        self.kvoBlock = [block copy];
        
        //确保options是个正数
//        options &= ~(0x80000000);
    
        if ([observered isKindOfClass:[NSArray class]]) {
            
            [observered addObserver:self
                 toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [(NSArray *)observered count])]
                         forKeyPath:keyPath
                            options:options
                            context:JOKVONotificationHelperContext];
        }else {
            
            [observered addObserver:self
                         forKeyPath:keyPath
                            options:options
                            context:JOKVONotificationHelperContext];
        }
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (context == JOKVONotificationHelperContext) {
        JOKVONotificationItem *item = [[JOKVONotificationItem alloc] initWithObserver:self.observer observered:self.observered keyPath:self.keyPath change:change];
        !_kvoBlock?:_kvoBlock(item);
    }
}

- (void)removeObserver {

    if ([self.observered isKindOfClass:[NSArray class]]) {
        NSIndexSet		*idxSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [(NSArray *)_observered count])];
        [_observered removeObserver:self fromObjectsAtIndexes:idxSet forKeyPath:_keyPath context:JOKVONotificationHelperContext];
    }else {
        [_observered removeObserver:self forKeyPath:_keyPath context:JOKVONotificationHelperContext];
    }
    self.kvoBlock = nil;
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        return YES;
    }
    
    if ([self isKindOfClass:[object class]]) {
        
        JOKVONotificationHelper *equalObject = (JOKVONotificationHelper *)object;
        if ([self.observer isEqual:equalObject.observer] && [self.observered isEqual:equalObject.observered] && [self.keyPath isEqualToString:equalObject.keyPath]) {
            return YES;
        }else {
            return NO;
        }
    }
    return NO;
}

@end

static NSMutableArray *JOKVONoticifationHelperArray = nil;

@interface JOKVONotificationCenter : NSObject

@property (nonatomic, strong) NSMutableArray *helperArray;

@end

@implementation JOKVONotificationCenter

+ (void)initialize {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JOKVONoticifationHelperArray = [NSMutableArray array];
    });
}

+ (id)defaultCenter {
    static JOKVONotificationCenter * notificationCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notificationCenter = [[JOKVONotificationCenter alloc] init];
    });
    return notificationCenter;
}

- (void)observer:(id)observer observered:(id)observered keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(JOKVOBlock)block {

    JOKVONotificationHelper *helper = [[JOKVONotificationHelper alloc] initWithObserver:observer observered:observered keyPath:keyPath options:options block:block];
    [JOKVONoticifationHelperArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:helper]) {
            [obj removeObserver];
            [JOKVONoticifationHelperArray removeObject:obj];
            *stop = YES;
        }
    }];
    [JOKVONoticifationHelperArray addObject:helper];
    objc_setAssociatedObject(observer, &JOKVONotificationCenterHelpersKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addBlockToDeallocWithObject:observer];
}

- (void)addBlockToDeallocWithObject:(id)object {

    Class class = JOGetClass(object);
    if ([JOKVONoticifationHelperArray containsObject:class]) {
        return;
    }

    [object addBlockToSelector:NSSelectorFromString(@"dealloc") beforeBlock:^(void *obj){

        JOKVONotificationHelper *helper = objc_getAssociatedObject((__bridge id)obj, &JOKVONotificationCenterHelpersKey);
        if (helper) {
            [helper removeObserver];
            [JOKVONoticifationHelperArray removeObject:helper];
        }
    }];
}

- (void)removeObserver:(id)observer observered:(id)observered keyPath:(NSString *)keyPath {

    [JOKVONoticifationHelperArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JOKVONotificationHelper *helper = obj;
        if ([helper.observer isEqual:observer] && [helper.observered isEqual:observered] && [helper.keyPath isEqual:keyPath]) {
            [obj removeObserver];
            [JOKVONoticifationHelperArray removeObject:obj];
            *stop = YES;
        }
    }];
}

- (void)removeAllObserver:(id)observer observered:(id)observered {

    [JOKVONoticifationHelperArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JOKVONotificationHelper *helper = obj;
        if ([helper.observer isEqual:observer] && [helper.observered isEqual:observered]) {
            [obj removeObserver];
            [JOKVONoticifationHelperArray removeObject:obj];
        }
    }];
}

@end

@implementation NSObject(JOKVOExtend)

- (void)joObservered:(id)observered keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeBlock:(JOKVOBlock)block {
    
    [[JOKVONotificationCenter defaultCenter] observer:self observered:observered keyPath:keyPath options:options block:block];
}

- (void)joObservered:(id)observered keyPath:(NSString *)keyPath newValueBlock:(JOKVONewValueBlock)block {
    [[JOKVONotificationCenter defaultCenter] observer:self
                                           observered:observered
                                              keyPath:keyPath
                                              options:NSKeyValueObservingOptionNew
                                                block:^(JOKVONotificationItem *item) {
        !block?:block([item newValue]);
    }];
}

- (void)joRemoveObservered:(id)observered keyPath:(NSString *)keyPath {
    [[JOKVONotificationCenter defaultCenter] removeObserver:self observered:observered keyPath:keyPath];
}

- (void)joRemoveAllObservered:(id)observered {
    [[JOKVONotificationCenter defaultCenter] removeAllObserver:self observered:observered];
}

@end


#pragma mark - 技术参考自定义的KVO
#pragma mark -

/*‖==========================================================‖
 ‖                                                          ‖
 ‖                  仅当做技术参考                             ‖
 ‖                                                          ‖
 ‖                                                          ‖
 ‖==========================================================‖
 */

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

- (void)joObserver:(id)observerObject path:(NSString *)path observerBlock:(JOKVOValueBlock)block {

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
        JOKVOValueBlock block = [KVOItem ->_kvoBlockInfo objectForKey:key];
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
