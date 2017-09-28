//
//  JOCacheHelper.m
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOCacheSizeHelper.h"

@implementation JOCacheSizeHelper

void JOCachePathSize(NSString *path,CacheSizeCalculateBlock block) {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *cacheFileList;
        NSEnumerator *cacheEnumerator;
        NSString *itemFilePath;
        
        unsigned long long cacheFolderSize = 0;
        cacheFileList = [fileManager subpathsOfDirectoryAtPath:path error:nil];
        cacheEnumerator = [cacheFileList objectEnumerator];
        while (itemFilePath = [cacheEnumerator nextObject]) {
            NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:[path stringByAppendingPathComponent:itemFilePath] error:nil];
            cacheFolderSize += [cacheFileAttributes fileSize];
        }
        float mbSize = cacheFolderSize/1024./1024.;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(cacheFolderSize,mbSize);
            }
        });
    });
}

void JOCacheHomeSize(CacheSizeCalculateBlock block) {
    JOCachePathSize(JOHomePath(), block);
}

void JOCacheDocumentSize(CacheSizeCalculateBlock block) {
    JOCachePathSize(JODocumentPath(), block);
}

void JOCacheTempSize(CacheSizeCalculateBlock block) {
    JOCachePathSize(JOTempPath(), block);
}

void JOCacheLibrarySize(CacheSizeCalculateBlock block) {
    JOCachePathSize(JOLibraryPath(), block);
}

void JOCacheCachesSize(CacheSizeCalculateBlock block) {
    JOCachePathSize(JOCachesPath(), block);
}

void JOCachePreferencesSize(CacheSizeCalculateBlock block) {
    JOCachePathSize(JOPreferencesPath(), block);
}

+ (void)joCacheSizeWithPath:(NSString *)path completed:(CacheSizeCalculateBlock)block {
    JOCachePathSize(path, block);
}

+ (void)joCacheHomeSizeWithCompleted:(CacheSizeCalculateBlock)block {
    [JOCacheSizeHelper joCacheSizeWithPath:JOHomePath() completed:block];
}

+ (void)joCacheDocumentSizeWithCompleted:(CacheSizeCalculateBlock)block {
    [JOCacheSizeHelper joCacheSizeWithPath:JODocumentPath() completed:block];
}

+ (void)joCacheTempSizeWithCompleted:(CacheSizeCalculateBlock)block {
    [JOCacheSizeHelper joCacheSizeWithPath:JOTempPath() completed:block];
}

+ (void)joCacheLibrarySizeWithCompleted:(CacheSizeCalculateBlock)block {
    [JOCacheSizeHelper joCacheSizeWithPath:JOLibraryPath() completed:block];
}

+ (void)joCacheCachesSizeWithCompleted:(CacheSizeCalculateBlock)block {
    [JOCacheSizeHelper joCacheSizeWithPath:JOCachesPath() completed:block];
}

+ (void)joCachePreferencesSizeWithCompleted:(CacheSizeCalculateBlock)block {
    [JOCacheSizeHelper joCacheSizeWithPath:JOPreferencesPath() completed:block];
}

@end
