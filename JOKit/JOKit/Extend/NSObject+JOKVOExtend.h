//
//  NSObject+JOKVOExtend.h
//  JOKit
//
//  Created by 刘维 on 16/11/11.
//  Copyright © 2016年 Joshua. All rights reserved.
//

/*
 自己实现的一个kVO的监听,问题所在:
 对于readonly属性的变量,如何通过重写setter方法去做到值改变就获得通知呢,根本就不会走setter方法.
 对于自己实现的类好办,提供类似willChangeValueForKey跟didChangeValueForKey方法来给定通知.
 但是对于系统的类里面某个readonly的属性是没办法这么做到的,这是这个自己实现的kvo的问题所在.
 PS:别用他来监听系统的类的值的变化吧
 监听他人的类中readonly的属性要先确定他调用了joDidChangeValueForKey方法来告知值已经变化.
 */

#import <Foundation/Foundation.h>

/**
 KVO监听到值变化的时候的Block回调.

 @param oldValue 原来的值.
 @param newValue 新的值.
 */
typedef void(^JOKVOBlock)(id oldValue, id newValue);

@interface NSObject(JOKVOCustom)

/**
 KVO的监听.

 @param observerObject 需要监听的对象.
 @param path 监听对象对应的path的值.
 @param block JOKVOBlock.
 */
- (void)joObserver:(id)observerObject path:(NSString *)path observerBlock:(JOKVOBlock)block;

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
