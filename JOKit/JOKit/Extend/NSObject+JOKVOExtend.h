//
//  NSObject+JOKVOExtend.h
//  JOKit
//
//  Created by 刘维 on 16/11/11.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 KVO监听到值变化的时候的Block回调.

 @param oldValue 原来的值.
 @param newValue 新的值.
 */
typedef void(^JOKVOBlock)(id oldValue, id newValue);

@interface NSObject(JOKVOExtend)

/**
 KVO的监听.

 @param observerObject 需要监听的对象.
 @param path 监听对象对应的path的值.
 @param block JOKVOBlock.
 */
- (void)joObserver:(id)observerObject path:(NSString *)path observerBlock:(JOKVOBlock)block;

@end
