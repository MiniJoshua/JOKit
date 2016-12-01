//
//  NSObject+JOKVOExtend.h
//  JOKit
//
//  Created by 刘维 on 16/11/11.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 使用下面的KVO去监听对象,不需要在dealloc里面去做移除,因为调用dealloc的时候里面已经帮你做好了这一步.
 每一个监听的属性都对应一个独立的block，跟其他的不冲突,重复监听同一个属性,那么原来的将会被覆盖,只响应最新的监听.
 e.g:
 [self joObservered:_cover
            keyPath:@"test"
            options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
        changeBlock:^(JOKVONotificationItem *item) {
            NSLog(@"!~~~~~~~~~~~new:%@ old:%@",[item newValue],[item oldValue]);
 }];
 
 */

@interface JOKVONotificationItem : NSObject

@property (nonatomic, readonly, copy)   NSString *keyPath;
@property (nonatomic, readonly, weak)   id observer;
@property (nonatomic, readonly, weak)   id observered;
@property (nonatomic, readonly, assign) NSKeyValueChange kind;
@property (nonatomic, readonly)         id oldValue;
@property (nonatomic, readonly)         id NS_RETURNS_NOT_RETAINED newValue;
@property (nonatomic, readonly)         NSIndexSet *indexes;
@property (nonatomic, readonly, assign) BOOL isPrior;

@end

/**
 KVO触发的回调.

 @param item JOKVONotificationItem.
 */
typedef void(^JOKVOBlock) (JOKVONotificationItem *item);

/**
 KOV触发的回调.

 @param newValue 新变化的值.
 */
typedef void(^JOKVONewValueBlock) (id newValue);

@interface NSObject(JOKVOExtend)

/**
 KVO监听一个对象值的变化.
 这里有一个地方与系统的不一样了.observered对应的是被监听的对象,即keyPath对应的那个对象.

 @param observered  被监听的对象.
 @param keyPath     对监听对面个的哪个key.
 @param options     NSKeyValueObservingOptions.
 @param block       JOKVOBlock.
 */
- (void)joObservered:(id)observered keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeBlock:(JOKVOBlock)block;

/**
 KVO监听一个对象值的变化.
 默认的options为NSKeyValueObservingOptionNew.

 @param observered  被监听的对象.
 @param keyPath     对监听对象的哪个值的key.
 @param block       JOKVONewValueBlock
 */
- (void)joObservered:(id)observered keyPath:(NSString *)keyPath newValueBlock:(JOKVONewValueBlock)block;

/**
 移除响应的监听

 @param observered  被监听的对象.
 @param keyPath     对监听对象的哪个值的key.
 */
- (void)joRemoveObservered:(id)observered keyPath:(NSString *)keyPath;

/**
 移除所有的监听.

 @param observered 被监听的对象.
 */
- (void)joRemoveAllObservered:(id)observered;

@end




/*‖=========================================================‖
 ‖                                                          ‖
 ‖       下面这个自定义的KOV还是放弃使用吧                        ‖
 ‖       这个就当做一个技术参考吧,别用了,能处理的情况太少了          ‖
 ‖                                                          ‖
 ‖==========================================================‖
 */

/*
 自己实现的一个kVO的监听,问题所在:
 对于readonly属性的变量,如何通过重写setter方法去做到值改变就获得通知呢,根本就不会走setter方法.
 对于自己实现的类好办,提供类似willChangeValueForKey跟didChangeValueForKey方法来给定通知.
 但是对于系统的类里面某个readonly的属性是没办法这么做到的,这是这个自己实现的kvo的问题所在.
 PS:别用他来监听系统的类的值的变化吧
 监听他人的类中readonly的属性要先确定他调用了joDidChangeValueForKey方法(未实现)来告知值已经变化.
 */

/**
 KVO监听到值变化的时候的Block回调.

 @param oldValue 原来的值.
 @param newValue 新的值.
 */
typedef void(^JOKVOValueBlock)(id oldValue, id newValue);

@interface NSObject(JOKVOCustom)

/**
 KVO的监听.

 @param observerObject 需要监听的对象.
 @param path 监听对象对应的path的值.
 @param block JOKVOBlock.
 */
- (void)joObserver:(id)observerObject path:(NSString *)path observerBlock:(JOKVOValueBlock)block;

/**
 删除给定path的KVO.

 @param path 对应的path的值.
 */
- (void)joRemoveObserverWithPath:(NSString *)path;

/**
 删除所有的KVO
 */
- (void)joRemoveAllObserver;

@end

