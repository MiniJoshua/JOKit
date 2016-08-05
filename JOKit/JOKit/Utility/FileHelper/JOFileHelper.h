//
//  JOFileHelper.h
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOPathHelper.h"

#pragma mark - File 创建
#pragma mark -

@interface JOFileHelper : NSObject

/**
 *  新建一个文件. PS:确定存放该文件的该文件夹是存在的,否则文件会创建失败.
 *
 *  @param filePath   文件的路径
 *  @param removeState 如果文件已经存在是否删除,YES则会删除原来存在的文件新建一个 NO则不会删除新建一个
 *
 *  @return 文件创建的状态.
 */
JO_EXTERN BOOL JOFileCreateAtPath(NSString *filePath,BOOL removeState);

/**
 *  创建一个文件夹,如果其父类的文件夹不存在则会帮其创建该父类的文件夹
 *
 *  @param filePath    文件夹的路径
 *  @param removeState 文件夹已经存在是否删除
 *
 *  @return 文件夹创建的状态
 */
JO_EXTERN BOOL JOFileCreateDirectoryAtPath(NSString *filePath,BOOL removeState);

/**
 *  新建一个文件
 *
 *  @param fileName    文件的名字
 *  @param removeState 如果文件已经存在是否删除,YES则会删除原来存在的文件新建一个 NO则不会删除新建一个
 *
 *  @return 文件创建的状态.
 */
JO_EXTERN BOOL JOFileCreateAtHomeDirectory(NSString *fileName,BOOL removeState);       //主目录下,即跟document在同一个文件夹
JO_EXTERN BOOL JOFileCreateAtDocumentDirectory(NSString *fileName,BOOL removeState);   //Document
JO_EXTERN BOOL JOFileCreateAtTempDirectory(NSString *fileName,BOOL removeState);       //Temp
JO_EXTERN BOOL JOFileCreateAtLibraryDirectory(NSString *fileName,BOOL removeState);    //Library
JO_EXTERN BOOL JOFileCreateAtPreferencesDirectory(NSString *fileName,BOOL removeState);//Preferences
JO_EXTERN BOOL JOFileCreateAtCachesDirectory(NSString *fileName,BOOL removeState);     //Caches


#pragma mark - File Exist 检测
#pragma mark -
/**
 *  文件是否存在.
 *
 *  @param filePath 文件的路径
 *
 *  @return 存在的状态.
 */
JO_EXTERN BOOL JOFileExistAtPath(NSString *filePath);

/**
 *  文件是否存在.
 *
 *  @param fileName 文件的名字.
 *
 *  @return 存在的状态.
 */
JO_EXTERN BOOL JOFileExistAtHomeDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileExistAtDocumentDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileExistAtTempDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileExistAtLibraryDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileExistAtPreferencesDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileExistAtCachesDirectory(NSString *fileName);

#pragma mark - File 删除
#pragma mark -
/**
 *  删除指定路径的文件.
 *
 *  @param filePath 需要删除文件的文件路径.
 *
 *  @return 删除的状态.
 */
JO_EXTERN BOOL JOFileRemovePath(NSString *filePath);

/**
 *  删除文件
 *
 *  @param fileName 删除文件的名字.
 *
 *  @return 删除的状态.
 */
JO_EXTERN BOOL JOFileRemoveAtHomeDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileRemoveAtDocumentDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileRemoveAtTempDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileRemoveAtLibraryDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileRemoveAtPreferencesDirectory(NSString *fileName);
JO_EXTERN BOOL JOFileRemoveAtCachesDirectory(NSString *fileName);

#pragma mark - 文件夹的清空
#pragma mark -
/**
 *  清空文件夹下面所有的文件. 清空文件放在了Gloab的队列中去执行,清空完成后会在主线程里面调用completeBlock.
 *
 *  @return 清空的状态.
 */
JO_EXTERN void JOFileCleanDirectory(NSString *directoryPath,void (^completeBlock)());
JO_EXTERN void JOFileCleanDocumentDirectory(void (^completeBlock)());
JO_EXTERN void JOFileCleanTempDirectory(void (^completeBlock)());
JO_EXTERN void JOFileCleanCachesDirectory(void (^completeBlock)());

@end
