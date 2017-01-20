//
//  JOFileHelper.m
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOFileHelper.h"

@implementation JOFileHelper

#pragma mark - File 创建
#pragma mark -

BOOL JOFileCreateAtPath(NSString *filePath,BOOL removeState) {

    if (JOFileExistAtPath(filePath)) {
        if (removeState) {
            JOFileRemovePath(filePath);
        }else{
            return YES;
        }
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL createState = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    return createState;
}

BOOL JOFileCreateDirectoryAtPath(NSString *filePath,BOOL removeState) {

    if (JOFileExistAtPath(filePath)) {
        if (removeState) {
            JOFileRemovePath(filePath);
        }else{
            return YES;
        }
    }
    NSError *newFileError;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //第二个参数的意思是否创建最终目录的不存在的父目录,如果该目录不存在的话,是否创建一个该目录
    BOOL createState = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&newFileError];
//    BOOL createState = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    return createState;
}

BOOL JOFileCreateAtHomeDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateAtPath(JOHomeFilePath(fileName), removeState);
}

BOOL JOFileCreateAtDocumentDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateAtPath(JODocumentFilePath(fileName), removeState);
}

BOOL JOFileCreateAtLibraryDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateAtPath(JOLibraryFilePath(fileName), removeState);
}

BOOL JOFileCreateAtTempDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateAtPath(JOTempFilePath(fileName), removeState);
}

BOOL JOFileCreateAtPreferencesDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateAtPath(JOPreferencesFilePath(fileName), removeState);
}

BOOL JOFileCreateAtCachesDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateAtPath(JOCachesFilePath(fileName), removeState);
}

BOOL JOFileCreateDirectoryAtHomeDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateDirectoryAtPath(fileName,removeState);
}

BOOL JOFileCreateDirectoryAtDocumentDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateDirectoryAtPath(fileName,removeState);
}

BOOL JOFileCreateDirectoryAtTempDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateDirectoryAtPath(fileName,removeState);
}

BOOL JOFileCreateDirectoryAtLibraryDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateDirectoryAtPath(fileName,removeState);
}


BOOL JOFileCreateDirectoryAtPreferencesDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateDirectoryAtPath(fileName,removeState);
}

BOOL JOFileCreateDirectoryAtCachesDirectory(NSString *fileName,BOOL removeState) {
    return JOFileCreateDirectoryAtPath(fileName,removeState);
    
}

#pragma mark - File Exist 检测
#pragma mark -

BOOL JOFileExistAtPath(NSString *filePath) {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

BOOL JOFileExistAtHomeDirectory(NSString *fileName) {
    return JOFileExistAtPath(JOHomeFilePath(fileName));
}

BOOL JOFileExistAtDocumentDirectory(NSString *fileName) {
    return JOFileExistAtPath(JODocumentFilePath(fileName));
}

BOOL JOFileExistAtTempDirectory(NSString *fileName) {
    return JOFileExistAtPath(JOTempFilePath(fileName));
}

BOOL JOFileExistAtLibraryDirectory(NSString *fileName) {
    return JOFileExistAtPath(JOLibraryFilePath(fileName));
}

BOOL JOFileExistAtPreferencesDirectory(NSString *fileName) {
    return JOFileExistAtPath(JOPreferencesFilePath(fileName));
}

BOOL JOFileExistAtCachesDirectory(NSString *fileName) {
    return JOFileExistAtPath(JOCachesFilePath(fileName));
}

#pragma mark - File 删除
#pragma mark -

BOOL JOFileRemovePath(NSString *filePath) {
    NSError *removeFileError;
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:&removeFileError];
}

BOOL JOFileRemoveAtHomeDirectory(NSString *fileName) {
    return JOFileRemovePath(JOHomeFilePath(fileName));
}

BOOL JOFileRemoveAtDocumentDirectory(NSString *fileName) {
    return JOFileRemovePath(JODocumentFilePath(fileName));
}

BOOL JOFileRemoveAtTempDirectory(NSString *fileName) {
    return JOFileRemovePath(JOTempFilePath(fileName));
}

BOOL JOFileRemoveAtLibraryDirectory(NSString *fileName) {
    return JOFileRemovePath(JOLibraryFilePath(fileName));
}

BOOL JOFileRemoveAtPreferencesDirectory(NSString *fileName) {
    return JOFileRemovePath(JOPreferencesFilePath(fileName));
}

BOOL JOFileRemoveAtCachesDirectory(NSString *fileName) {
    return JOFileRemovePath(JOCachesFilePath(fileName));
}

#pragma mark - 文件夹的清空
#pragma mark -

void JOFileCleanDirectory(NSString *directoryPath,void (^completeBlock)()) {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0.), ^{
       
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:directoryPath error:NULL];
        //    NSEnumerator *enumer = [directoryContents objectEnumerator];
        //    NSString *filename;
        //    while ((filename = [enumer nextObject])) {
        //        [fileManager removeItemAtPath:[directoryPath stringByAppendingPathComponent:filename] error:NULL];
        //    }
        for (NSString *fileName in [directoryContents objectEnumerator]) {
            [fileManager removeItemAtPath:[directoryPath stringByAppendingPathComponent:fileName] error:NULL];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock();
            }
        });
    });
}

void JOFileCleanDocumentDirectory(void (^completeBlock)()) {
    JOFileCleanDirectory(JODocumentPath(),completeBlock);
}

void JOFileCleanTempDirectory(void (^completeBlock)()) {
    JOFileCleanDirectory(JOTempPath(),completeBlock);
}

void JOFileCleanCachesDirectory(void (^completeBlock)()) {
    JOFileCleanDirectory(JOCachesPath(),completeBlock);
}

@end
