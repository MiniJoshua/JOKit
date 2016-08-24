//
//  JOSignal.m
//  JOKit
//
//  Created by 刘维 on 16/8/9.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOSignal.h"
#import <objc/runtime.h>

@interface JOSignal()

@property (nonatomic, copy, readonly) JOSignalCompleteBlock completeBlock;
@property (nonatomic, copy, readonly) JOSignalNextBlock nextBlock;
@property (nonatomic, copy, readonly) JOSignalErrorBlock errorBlock;

@property (nonatomic, copy, readonly) JOSignalProtocolBlock signalBlock;

@end

@implementation JOSignal

+ (instancetype)createSignal:(JOSignalProtocolBlock)signalBlock {
    
    return [[self alloc] initWithProtocol:signalBlock];
}

- (instancetype)initWithProtocol:(JOSignalProtocolBlock)signalBlock {

    self = [super init];
    if (self) {
        if (signalBlock) {
            _signalBlock = nil;
            _signalBlock = [signalBlock copy];
            
//            [self signaleBlockExcute];
        }
    }
    return self;
}

- (void)subscribeNext:(JOSignalNextBlock)nextBlock {
    
    [self subscribeNext:nextBlock complete:nil error:nil];
}

- (void)subscribeNext:(JOSignalNextBlock)nextBlock complete:(JOSignalCompleteBlock)completeBlock {
    
    [self subscribeNext:nextBlock complete:completeBlock error:nil];
}

- (void)subscribeNext:(JOSignalNextBlock)nextBlock complete:(JOSignalCompleteBlock)completeBlock error:(JOSignalErrorBlock)errorBlock {
    
    [self setCurrentNextBlock:nextBlock];
    [self setCurrentCompleteBlock:completeBlock];
    [self setCurrentErrorBlock:errorBlock];
    [self signaleBlockExcute];
}

- (void)subscribeComplete:(JOSignalCompleteBlock)completeBlock {

    [self subscribeNext:nil complete:completeBlock error:nil];
}

- (void)subscribeComplete:(JOSignalCompleteBlock)completeBlock error:(JOSignalErrorBlock)errorBlock {
    [self subscribeNext:nil complete:completeBlock error:errorBlock];
}

- (void)subscribeError:(JOSignalErrorBlock)errorBlock {
    
    [self subscribeNext:nil complete:nil error:errorBlock];
}

#pragma mark - private Block 

- (void)setCurrentCompleteBlock:(JOSignalCompleteBlock)block {

    if (block) {
        _completeBlock = nil;
        _completeBlock = [block copy];
    }
}

- (void)setCurrentNextBlock:(JOSignalNextBlock)block {
    
    if (block) {
        _nextBlock = nil;
        _nextBlock = [block copy];
    }
}

- (void)setCurrentErrorBlock:(JOSignalErrorBlock)block {
    
    if (block) {
        _errorBlock = nil;
        _errorBlock = [block copy];
    }
}

- (void)signaleBlockExcute {

    if (objc_getAssociatedObject(self, _cmd)) {
        //
    }else{
        
        if (_signalBlock) {
            _signalBlock(self);
        }
        objc_setAssociatedObject(self, _cmd, @"only", OBJC_ASSOCIATION_RETAIN);
    }
    
}

#pragma mark - signal delegate

- (void)sendNext:(id)value {
    if (_nextBlock) {
        _nextBlock(value);
    }
}

- (void)sendError:(NSError *)error {
    if (_errorBlock) {
        _errorBlock(error);
    }
}

- (void)sendComplete {
    if (_completeBlock) {
        _completeBlock();
    }
}

@end
