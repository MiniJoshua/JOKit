//
//  JOCommand.m
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOCommand.h"
#import "JOMacro.h"

@implementation JOCommand

- (instancetype)initWithSignalBlock:(JOSignalBlock)signalBlock {
    
    NSCParameterAssert(signalBlock != nil);
    self = [super init];
    if (self == nil) { return nil; }
    _signalBlock = [signalBlock copy];
    return self;
}

- (JOSignal *)excute:(id)input {

    JOSignal *signal = _signalBlock(input);
    NSCAssert(signal != nil, @"nil signal returned from signal block for value: %@", input);
    return signal;
}

@end
