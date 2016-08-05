//
//  JOPathHelper.m
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOPathHelper.h"

@implementation JOPathHelper

NSString *JOHomePath(void) {
    return NSHomeDirectory();
}

NSString *JOHomeFilePath(NSString *fileName) {
    return [JOHomePath() stringByAppendingPathComponent:fileName];
}

NSString *JODocumentPath(void) {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

NSString *JODocumentFilePath(NSString *fileName) {
    return [JODocumentPath() stringByAppendingPathComponent:fileName];
}

NSString *JOTempPath(void) {
    return NSTemporaryDirectory();
}

NSString *JOTempFilePath(NSString *fileName) {
    return [JOTempPath() stringByAppendingPathComponent:fileName];
}

NSString *JOLibraryPath(void) {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

NSString *JOLibraryFilePath(NSString *fileName) {
    return [JOLibraryPath() stringByAppendingPathComponent:fileName];
}

NSString *JOPreferencesPath(void) {

    return [JOLibraryPath() stringByAppendingPathComponent:@"Preferences"];
}

NSString *JOPreferencesFilePath(NSString *fileName) {
    return [JOPreferencesPath() stringByAppendingPathComponent:fileName];
}

NSString *JOCachesPath(void) {

    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

NSString *JOCachesFilePath(NSString *fileName) {
    return [JOCachesPath() stringByAppendingPathComponent:fileName];
}

@end
