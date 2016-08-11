//
//  JOSignal.h
//  JOKit
//
//  Created by 刘维 on 16/8/9.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOSignalProtocol.h"

/**
 *  完成的Block.
 */
typedef void(^JOSignalCompleteBlock) ();

/**
 *  传递到下一步的block
 *
 *  @param input 传递的值.
 */
typedef void(^JOSignalNextBlock) (id input);

/**
 *  发生Error的Block.
 *
 *  @param error NSError.
 */
typedef void(^JOSignalErrorBlock) (NSError *error);

/**
 *  带有JOSignalProtocol作为参数的Block
 *
 *  @param subscriber JOSignalProtocol.
 */
typedef void(^JOSignalProtocolBlock) (id <JOSignalProtocol> subscriber);

@interface JOSignal : NSObject<JOSignalProtocol>

//创建一个JOSignal.
+ (instancetype)createSignal:(JOSignalProtocolBlock)signalBlock;
- (instancetype)initWithProtocol:(JOSignalProtocolBlock)signalBlock;

/**
 *  监听是否存在以下的消息.
 *
 *  @param nextBlock     JOSignalNextBlock
 *  @param completeBlock JOSignalCompleteBlock
 *  @param errorBlock    JOSignalErrorBlock
 */
- (void)subscribeNext:(JOSignalNextBlock)nextBlock complete:(JOSignalCompleteBlock)completeBlock error:(JOSignalErrorBlock)errorBlock;
- (void)subscribeNext:(JOSignalNextBlock)nextBlock complete:(JOSignalCompleteBlock)completeBlock;
- (void)subscribeNext:(JOSignalNextBlock)nextBlock;

- (void)subscribeComplete:(JOSignalCompleteBlock)completeBlock error:(JOSignalErrorBlock)errorBlock;
- (void)subscribeComplete:(JOSignalCompleteBlock)completeBlock;
- (void)subscribeError:(JOSignalErrorBlock)errorBlock;

@end
