//
//  JOFileFormat.m
//  JOKit
//
//  Created by 刘维 on 2017/7/11.
//  Copyright © 2017年 Joshua. All rights reserved.
//

#import "JOFileFormat.h"

@implementation JOFileFormat

uint8_t *JODataContent(NSData *data, NSRange range) {

    uint8_t *bytes = (uint8_t *)malloc(range.length * sizeof(uint8_t));
    [data getBytes:bytes range:range];
    return bytes;
}

NSString *JOFileContentString(NSData *data, NSRange range, BOOL reverse) {

    if (reverse) {
        NSRange reverseRange = NSMakeRange(data.length-range.location-range.length, range.length);
        range = reverseRange;
    }
    char *byte = (char *)JODataContent(data, range);
    NSString *str = [NSString stringWithCString:byte encoding:NSASCIIStringEncoding];
    free(byte);
    return str;
}

+ (NSString *)joFileFormatWithData:(NSData *)data range:(NSRange)range reverseState:(BOOL)reverse {

    return JOFileContentString(data,range,reverse);
}

+ (NSString *)joFileFormatWithPath:(NSString *)path range:(NSRange)range reverseState:(BOOL)reverse {

    return [JOFileFormat joFileFormatWithData:[NSData dataWithContentsOfFile:path] range:range reverseState:reverse];
}

+ (JOFileType)fileTypeWithData:(NSData *)data {
    
    JOFileType fileType = JOFileType_Unknow;
    
    uint8_t bytes[12];
    memset(bytes, 0, 12*sizeof(uint8_t));
    [data getBytes:bytes length:12];
    
    ///图片
    //常用的
    const uint8_t gif[3]    = {'G','I','F'};
    const uint8_t jpg[3]    = {(char)0xff,(char)0xd8,(char)0xff};
    const uint8_t png[8]    = {(char) 0x89, (char) 0x50, (char) 0x4e, (char) 0x47,
        (char) 0x0d, (char) 0x0a, (char) 0x1a, (char) 0x0a};
    const uint8_t tifii[4]  = {'I','I', (char)0x2A, (char)0x00};
    const uint8_t tifmm[4]  = {'M','M', (char)0x00, (char)0x2A};
    const uint8_t webp[4]   = {'R', 'I', 'F', 'F'};
    
    //非 常用的
    const uint8_t swc[3]    = {'C','W','S'};
    const uint8_t psd[4]    = {'8','B','P','S'};
    const uint8_t bmp[2]    = {'B','M'};
    const uint8_t swf[3]    = {'F','W','S'};
    const uint8_t jpc[3]    = {(char)0xff, (char)0x4f, (char)0xff};
    const uint8_t jp2[12]   = {(char)0x00, (char)0x00, (char)0x00, (char)0x0c,
        (char)0x6a, (char)0x50, (char)0x20, (char)0x20,
        (char)0x0d, (char)0x0a, (char)0x87, (char)0x0a};
    const uint8_t iff[4]    = {'F','O','R','M'};
    const uint8_t ico[4]    = {(char)0x00, (char)0x00, (char)0x01, (char)0x00};

    if (!memcmp(bytes, gif, 3)) fileType = JOFileType_GIF;
    if (!memcmp(bytes, jpg, 3)) fileType = JOFileType_JPG;
    if (!memcmp(bytes, png, 8)) fileType = JOFileType_PNG;
    if (!memcmp(bytes, tifii, 4)) fileType = JOFileType_TIFF;
    if (!memcmp(bytes, tifmm, 4)) fileType = JOFileType_TIFF;
    if (!memcmp(bytes, webp, 4)) fileType = JOFileType_WEBP;
    if (!memcmp(bytes, swc, 3)) fileType = JOFileType_SWC;
    if (!memcmp(bytes, psd, 4)) fileType = JOFileType_PSD;
    if (!memcmp(bytes, bmp, 2)) fileType = JOFileType_BMP;
    if (!memcmp(bytes, swf, 3)) fileType = JOFileType_SWF;
    if (!memcmp(bytes, jpc, 3)) fileType = JOFileType_JPC;
    if (!memcmp(bytes, jp2, 12)) fileType = JOFileType_JP2;
    if (!memcmp(bytes, iff, 4)) fileType = JOFileType_IFF;
    if (!memcmp(bytes, ico, 4)) fileType = JOFileType_XICON;

    return fileType;
}

+ (JOFileType)fileTypeWithPath:(NSString *)Path {

    return [JOFileFormat fileTypeWithData:[NSData dataWithContentsOfFile:Path]];
}


/**
 *  取一个文件的前8个字节的16位和8个字节的16位
 */
//void getFileAbstract(string &str_abstract, string filepath)
//{
//    FILE* pFile = fopen(filepath.c_str(), "rb");
//    if (pFile == 0) return;
//    char buf[16] = {0};
//    fread(buf, 1, 8, pFile);
//    fseek(pFile, -8, SEEK_END);
//    fread(buf+8, 1, 8, pFile);
//    
//    int i = 0;
//    while (i<16) {
//        char temp[3] = {0};
//        sprintf(temp, "%.2x", 0xff&buf[i]);
//        str_abstract += temp;
//        NSLog(@"%s", __func__);
//        i = i + 1;
//        NSLog(@"i = %d", i);
//    }
//}

@end
