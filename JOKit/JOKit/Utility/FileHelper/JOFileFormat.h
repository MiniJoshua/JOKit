//
//  JOFileFormat.h
//  JOKit
//
//  Created by 刘维 on 2017/7/11.
//  Copyright © 2017年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JOFileType) {

    JOFileType_Unknow,  //未知
    
    JOFileType_JPG,     //jpg/jpeg
    JOFileType_GIF,     //gif
    JOFileType_PSD,     //psd
    JOFileType_BMP,     //bmp
    JOFileType_SWF,     //swf
    JOFileType_SWC,     //swc
    JOFileType_PNG,     //png
    JOFileType_TIFF,    //tiff
    JOFileType_JPC,     //jpc
    JOFileType_JP2,     //jp2
    JOFileType_IFF,     //iff
    JOFileType_XICON,   //x-icon
    JOFileType_WEBP,    //webp
};

@interface JOFileFormat : NSObject

/**
 获取文件内容前/后多少个字节的对应的String.
 PS:对应编码是:NSASCIIStringEncoding 
 所以某些对应空白或者其他某些字符转过来就直接忽略掉了

 @param data 文件的data
 @param range 需要获取字符的位置与大小.
 @param reverse 是否是逆序去取这些字节. YES为从去取末尾的多少个字节
 @return 转换之后的字符串.
 */
+ (NSString *)joFileFormatWithData:(NSData *)data range:(NSRange)range reverseState:(BOOL)reverse;
+ (NSString *)joFileFormatWithPath:(NSString *)path range:(NSRange)range reverseState:(BOOL)reverse;

+ (JOFileType)fileTypeWithData:(NSData *)data;
+ (JOFileType)fileTypeWithPath:(NSString *)Path;

@end
