//
//  JOCommandProtocol.h
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JOSignalProtocol <NSObject>

@optional
/**
 *  设置需要传递到过去的值.
 *
 *  @param value 传递的值.
 */
- (void)sendNext:(id)value;

/**
 *  发送一个错误的指令.
 *
 *  @param error NSError.
 */
- (void)sendError:(NSError *)error;

/**
 *  发送一个完成的指令.
 */
- (void)sendComplete;

@end

