//
//  JOLogHelper.h
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOFileHelper.h"

@interface JOLogHelper : NSObject

/**
 *  需要确保存放log日志的文件夹是存在的,否则会写入失败.
 *
 *  @param content    log的内容
 *  @param logPath    log的路径
 *  @param coverState 写入的时候是否覆盖原来的log的日志
 */
JO_EXTERN void JOLogWrite(NSString *content,NSString *logPath,BOOL coverState);

/**
 *  将log日志保存到默认的log文件中,该文件最大存放的日志的容量大小为1024*100的字节数即100KB.
 *
 *  @param content    写入的内容
 *  @param coverState 写入的时候是否覆盖原来的log的日志
 */
JO_EXTERN void JOLogDefaultWrite(NSString *content,BOOL coverState);

/**
 *  清空log日志
 *
 *  @param logPath log的路径
 */
JO_EXTERN void JOLogClean(NSString *logPath);

/**
 *  清空默认的log日志
 */
JO_EXTERN void JOLogDefaultClean(void);

/**
 *  默认的Log日志路径.
 *
 *  @return 默认的Log日志的路径.
 */
JO_EXTERN NSString *JOLogDefaultPath(void);

@end
