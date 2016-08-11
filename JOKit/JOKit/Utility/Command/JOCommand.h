//
//  JOCommand.h
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOMacro.h"
#import "JOSignal.h"

/**
 *  返回一个JOSignal的Block.
 *
 *  @param input 输入的值.
 *
 *  @return JOSignal的对象.
 */
typedef JOSignal * _Nullable(^JOSignalBlock) (_Nullable id input);

@interface JOCommand : NSObject

@property (nonatomic, copy, readonly) _Nullable JOSignalBlock signalBlock;

//构造函数.
- (nullable instancetype)initWithSignalBlock:(nullable JOSignalBlock)signalBlock;

/**
 *  执行该命令.
 *
 *  @param input 需要输入的值
 *
 *  @return JOSignal对象.
 */
- (nullable JOSignal *)excute:(nullable id)input;

@end
