//
//  UIColor+JOExtend.h
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JOMacro.h"

#ifndef JORGB
#define JORGB struct JORGBColor
JORGB
{
    CGFloat r; //0 - 1.0
    CGFloat g; //0 - 1.0
    CGFloat b; //0 - 1.0
    CGFloat a; //0 - 1.0
};
#endif

JO_STATIC_INLINE JORGB JORGBColorMake(CGFloat r, CGFloat g, CGFloat b, CGFloat a){ JORGB RGBColor;RGBColor.r = fabs(r);RGBColor.g = fabs(g);RGBColor.b = fabs(b);RGBColor.a = fabs(a); return RGBColor;}

//创建一个UIColor对象
JO_STATIC_INLINE UIColor* JORGBAMake(CGFloat R,CGFloat G,CGFloat B,CGFloat A)   { return [UIColor colorWithRed:fabs(R)/255. green:fabs(G)/255. blue:fabs(B)/255. alpha:fabs(A)]; }
JO_STATIC_INLINE UIColor* JORGBMake(CGFloat R,CGFloat G,CGFloat B)              { return JORGBAMake(R,G,B,1.); }
JO_STATIC_INLINE UIColor* JORGBSMake(CGFloat R)                                 { return JORGBAMake(R,R,R,1.); }
JO_STATIC_INLINE UIColor* JORGBSAMake(CGFloat R,CGFloat A)                      { return JORGBAMake(R,R,R,A); }

@interface UIColor(JOExtend)

/**
 *  随机生成一个颜色,默认透明度为1.
 *
 *  @return UIColor对象.
 */
JO_EXTERN UIColor *JORandomColor(void);

/**
 *  将RGBColor的结构体数据转换为UIColor的对象.
 *
 *  @param rgbColor JORGBColor的结构体.
 *
 *  @return 转换后的UIColor的对象.
 */
JO_EXTERN UIColor *JORGBToColor(JORGB rgbColor);

#pragma mark - 十六进制的颜色与UIColor之间的转换
#pragma mark -

/**
 *  将十六进制的字符串格式的值转换为UIColor的对象.
 *
 *  @param hexString 十六进制的字符串:@"0x66ccff" @"0x66ccffff" @"#66ccff" @"#66ccffff" @"66ccff" @"66ccffff"
 *
 *  @return 转换后的UIColor对象.
 */
JO_EXTERN UIColor *JOHexRGBStringToColor(NSString *hexString);

/**
 *  将十六进制的字符串格式的值转换为UIColor的对象.
 *
 *  @param hexString 十六进制的字符串::@"0x66ccff" @"0x66ccffff" @"#66ccff" @"#66ccffff" @"66ccff" @"66ccffff"
 *  @param alpha     颜色的透明度.
 *
 *  @return 转换后的UIColor对象
 */
JO_EXTERN UIColor *JOHexRGBStringDefineAlphaToColor(NSString *hexString,CGFloat alpha);

/**
 *  将UIColor的对象转换为用十六进制字符串来表示.
 *
 *  @param color UIColor的对象.
 *
 *  @return 转换后的十六进制的字符串.不包含alpha的位
 */
JO_EXTERN NSString *JOColorToRGBHexString(UIColor *color);

/**
 *  将UIColor的对象转换为用十六进制字符串来表示.
 *
 *  @param color UIColor的对象.
 *
 *  @return  转换后的十六进制的字符串.包含alpha的位
 */
JO_EXTERN NSString *JOColorToRGBAHexString(UIColor *color);

/**
 *  将UIColor的对象转换为用十六进制来表示.
 *
 *  @param color UIColor对象.
 *
 *  @return 转换后的十六进制:0x66ccff
 */
JO_EXTERN uint32_t JOColorToRGBHex(UIColor *color)NS_AVAILABLE_IOS(5_0);

/**
 *  将UIColor的对象转换为用十六进制来表示.
 *
 *  @param color UIColor对象.
 *
 *  @return 转换后的十六进制:0x66ccffff
 */
JO_EXTERN uint32_t JOColorToRGBAHex(UIColor *color)NS_AVAILABLE_IOS(5_0);

#pragma mark - JORGB 与 UIColor 十六进制颜色表示 之间的转换
#pragma mark -

/**
 *  将UICloro对象转换为JORGB的结构体.
 *  可以使用该方法取一个颜色的r g b a的数值.
 *
 *  @param color UIColor对象.
 *
 *  @return 转换后的JORGBColor的结构体.
 */
JO_EXTERN JORGB JOColorToJORGB(UIColor *color)NS_AVAILABLE_IOS(5_0);

/**
 *  将十六进制表示颜色的字符串转换为JORGBColor的结构体.默认的透明度为1.
 *
 *  @param hex 十六进制的颜色值
 *
 *  @return 转换后的JORGBValue的结构体.
 */
JO_EXTERN JORGB JOHexRGBStringToJORGB(NSString *hexString);

/**
 *  将十六进制表示颜色的字符串转换为JORGBColor的结构体.
 *
 *  @param hex 十六进制的颜色值:@"0x66ccff"
 *  @param alpha 透明度.
 *
 *  @return 转换后的JORGBValue的结构体.
 */
JO_EXTERN JORGB JOHexRGBStringDefineAlphaToJORGB(NSString *hexString,CGFloat alpha);

#pragma mark - UIColor Space Model
#pragma mark -

/**
 *  根据给定的UIColor对象获取该Color的色空间模型.
 *  更多信息查看:CGColorSpaceModel.
 *
 *  @param color UIColor对象.
 *
 *  @return 色空间模型的字符串.
 */
JO_EXTERN NSString *JOColorSpaceModel(UIColor *color);

@end
