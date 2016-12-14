//
//  NSObject+JOKVOExtend.h
//  JOKit
//
//  Created by 刘维 on 16/11/11.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 相关属性解释: http://southpeak.github.io/2015/04/23/cocoa-foundation-nskeyvalueobserving/
 -------------------------------------
 Option:
 NSKeyValueObservingOptionNew  新值  对应的Key:
 NSKeyValueObservingOptionOld  旧值
 //在添加观察者的时候就会发送一个通知给观察者，在注册观察者方法返回之前
 NSKeyValueObservingOptionInitial
 //每次修改属性时，会在修改通知被发送之前预先发送一条通知给观察者， 这与-willChangeValueForKey:被触发的时间是相对应的。
  即在每次修改属性时，会发送两条通知。
 NSKeyValueObservingOptionPrior
 -----------------------------------------
 NSKeyValueChange:
 
 //设置一个新值。被监听的属性可以是一个对象，也可以是一对一关系的属性或一对多关系的属性。
 NSKeyValueChangeSetting
 //表示一个对象被插入到一对多关系的属性。
 NSKeyValueChangeInsertion
 // 表示一个对象被从一对多关系的属性中移除。
 NSKeyValueChangeRemoval
 // 表示一个对象在一对多的关系的属性中被替换
 NSKeyValueChangeReplacement

---------------------------------------------
 KEY:
 // 属性变化的类型，是一个NSNumber对象，包含NSKeyValueChange枚举相关的值
 NSString *const NSKeyValueChangeKindKey;
 // 属性的新值。当NSKeyValueChangeKindKey是 NSKeyValueChangeSetting，
 // 且添加观察的方法设置了NSKeyValueObservingOptionNew时，我们能获取到属性的新值。
 // 如果NSKeyValueChangeKindKey是NSKeyValueChangeInsertion或者NSKeyValueChangeReplacement，
 // 且指定了NSKeyValueObservingOptionNew时，则我们能获取到一个NSArray对象，包含被插入的对象或
 // 用于替换其它对象的对象。
 NSString *const NSKeyValueChangeNewKey;
 // 属性的旧值。当NSKeyValueChangeKindKey是 NSKeyValueChangeSetting，
 // 且添加观察的方法设置了NSKeyValueObservingOptionOld时，我们能获取到属性的旧值。
 // 如果NSKeyValueChangeKindKey是NSKeyValueChangeRemoval或者NSKeyValueChangeReplacement，
 // 且指定了NSKeyValueObservingOptionOld时，则我们能获取到一个NSArray对象，包含被移除的对象或
 // 被替换的对象。
 NSString *const NSKeyValueChangeOldKey;
 // 如果NSKeyValueChangeKindKey的值是NSKeyValueChangeInsertion、NSKeyValueChangeRemoval
 // 或者NSKeyValueChangeReplacement，则这个key对应的值是一个NSIndexSet对象，
 // 包含了被插入、移除或替换的对象的索引
 NSString *const NSKeyValueChangeIndexesKey;
 // 当指定了NSKeyValueObservingOptionPrior选项时，在属性被修改的通知发送前，
 // 会先发送一条通知给观察者。我们可以使用NSKeyValueChangeNotificationIsPriorKey
 // 来获取到通知是否是预先发送的，如果是，获取到的值总是@(YES)
 NSString *const NSKeyValueChangeNotificationIsPriorKey;
 */

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
- (void)joObserver:(id)observerObject path:(NSString *)path observerBlock:(JOKVOValueBlock)block DEPRECATED_MSG_ATTRIBUTE("仅做技术参考 勿用");

/**
 删除给定path的KVO.

 @param path 对应的path的值.
 */
- (void)joRemoveObserverWithPath:(NSString *)path DEPRECATED_MSG_ATTRIBUTE("仅做技术参考 勿用");

/**
 删除所有的KVO
 */
- (void)joRemoveAllObserver DEPRECATED_MSG_ATTRIBUTE("仅做技术参考 勿用");

@end

