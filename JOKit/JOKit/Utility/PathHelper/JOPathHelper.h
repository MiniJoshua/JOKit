//
//  JOPathHelper.h
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOMacro.h"

@interface JOPathHelper : NSObject

/**
 *  app的沙盒目录,即就是跟Document在同一个目录下
 *
 *  @return 文件路径
 */
JO_EXTERN NSString *JOHomePath(void);
JO_EXTERN NSString *JOHomeFilePath(NSString *fileName);


/**
 *  Document文件夹路径. 将程序中建立的或在程序运行当中需要用到的文件数据保存在该目录下,
 *  用户数据或其它应该定期备份的信息应该保存在Documents目录下面，它可以通过iCloud自动备份
 *
 *  @return 文件路径
 */
JO_EXTERN NSString *JODocumentPath(void);
JO_EXTERN NSString *JODocumentFilePath(NSString *fileName);

/**
 *  Temp文件夹路径.临时使用的数据应该保存在tmp文件夹,尽管iCloud不会备份这些文件,但在应用使用完这些数据之后要注意随时删除,避免占用用户设备的空间.
 *  下载文件过程中,如果文件下载暂停了,保存的已经下载的数据也在该文件中,会有iOS自动存放在该文件夹中
 *
 *  @return 文件路径
 */
JO_EXTERN NSString *JOTempPath(void);
JO_EXTERN NSString *JOTempFilePath(NSString *fileName);

/**
 *  Library文件夹路径.
 *
 *  @return 文件路径
 */
JO_EXTERN NSString *JOLibraryPath(void);
JO_EXTERN NSString *JOLibraryFilePath(NSString *fileName);

/**
 *  Preferences文件夹路径.包含应用程序的偏好设置文件.您不应该直接创建偏好设置文件,而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
 *
 *  @return 文件路径
 */
JO_EXTERN NSString *JOPreferencesPath(void);
JO_EXTERN NSString *JOPreferencesFilePath(NSString *fileName);

/**
 *  Caches文件夹路径.可以重新下载或者重新生成的数据应该保存在/Library /caches目录下面.
 *  比如杂志、新闻、地图应用使用的数据库缓存文件和可下载内容应该保存到这个文件夹.iTunes不会备份此目录,此目录下文件不会在应用退出删除,但会在iphone重启时丢弃所有里面的文件
 *
 *  @return 文件路径
 */
JO_EXTERN NSString *JOCachesPath(void);
JO_EXTERN NSString *JOCachesFilePath(NSString *fileName);

@end
