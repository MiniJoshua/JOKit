//
//  JOCacheHelper.h
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOPathHelper.h"

/**
 *
 *  uint8_t: 1字节     uint16_t: 2字节    uint32_t: 4字节        uint64_t: 8字节
 *  计算得到的文件的大小  8bit(比特) = 1byte 1024byte(字节) = 1KB  1024KB = 1MB  1024MB = 1G 1024G = 1T
 *
 *  @param cacheSize   byte为单位的大小值
 *  @param CacheMBSize MB为单位的值
 */
typedef void(^CacheSizeCalculateBlock) (unsigned long long cacheSize, float CacheMBSize);

@interface JOCacheHelper : NSObject

/**
 *  计算某个文件的大小.
 *
 *  @param path  文件的路径.
 *  @param block CacheSizeCalculateBlock.
 */
JO_EXTERN void JOCachePathSize(NSString *path,CacheSizeCalculateBlock block);
JO_EXTERN void JOCacheHomeSize(CacheSizeCalculateBlock block);
JO_EXTERN void JOCacheDocumentSize(CacheSizeCalculateBlock block);
JO_EXTERN void JOCacheTempSize(CacheSizeCalculateBlock block);
JO_EXTERN void JOCacheLibrarySize(CacheSizeCalculateBlock block);
JO_EXTERN void JOCacheCachesSize(CacheSizeCalculateBlock block);
JO_EXTERN void JOCachePreferencesSize(CacheSizeCalculateBlock block);

/* 与上面的方法同样的效果,只是方法不同而已 */
+ (void)joCacheSizeWithPath:(NSString *)path completed:(CacheSizeCalculateBlock)block;
+ (void)joCacheHomeSizeWithCompleted:(CacheSizeCalculateBlock)block;
+ (void)joCacheDocumentSizeWithCompleted:(CacheSizeCalculateBlock)block;
+ (void)joCacheTempSizeWithCompleted:(CacheSizeCalculateBlock)block;
+ (void)joCacheLibrarySizeWithCompleted:(CacheSizeCalculateBlock)block;
+ (void)joCacheCachesSizeWithCompleted:(CacheSizeCalculateBlock)block;
+ (void)joCachePreferencesSizeWithCompleted:(CacheSizeCalculateBlock)block;

@end
