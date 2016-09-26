//
//  UIColor+JOExtend.m
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "UIColor+JOExtend.h"

@implementation UIColor(JOExtend)

UIColor *JORandomColor() {
    return [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:fabs(1.)];
}

+ (UIColor *)joRandomColor {
    return JORandomColor();
}

UIColor *JORGBToColor(JORGB rgbColor) {
    return [UIColor colorWithRed:rgbColor.r green:rgbColor.g blue:rgbColor.b alpha:rgbColor.a];
}

+ (UIColor *)joRGBToColor:(JORGB )rgbColor {
    return JORGBToColor(rgbColor);
}

#pragma mark - Private:hexRGB to UIColor
#pragma mark -
/**
 * 不带透明度的十六进制的颜色转换为UIColor对象 0x66ccff
 */
UIColor *JOConvertHexRGBToColor(uint32_t hex) {
    
    return JOConvertHexRGBDefineAlphaToColor(hex, 1.);
}

/**
 * 不带透明度的十六进制的颜色转换为UIColor对象 0x66ccff
 */
UIColor *JOConvertHexRGBDefineAlphaToColor(uint32_t hex,CGFloat alpha) {
    
    int r = (hex >> 16)& 0xFF;
    int g = (hex >> 8)& 0xFF;
    int b = hex & 0xFF;
    
    return JORGBAMake(r, g, b, alpha);
}

/**
 * 带透明度的十六进制的颜色转换为UIColor对象 0x66ccffff
 */
UIColor *JOConvertHexRGBAToColor(uint32_t hex) {
    
    int r = (hex >> 24) & 0xFF;
    int g = (hex >> 16) & 0xFF;
    int b = (hex >> 8) & 0xFF;
    int a = hex & 0xFF;
    
    return JORGBAMake(r, g, b, a);
}

#pragma mark - 十六进制的颜色与UIColor之间的转换
#pragma mark -

UIColor *JOHexRGBStringToColor(NSString *hexString) {

#define JOHexStringToInt(hexString,result)\
do{\
sscanf([hexString UTF8String], "%X", &result);\
}while(0)
    
    CGFloat r,g,b,a;
    
    NSString *str = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    
    //MARK: length长度为 3:RGB 4:RGBA 6:RRGGBB 8:RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        JOLog(@"该16进制的颜色表示的字符串不正确,请检查,错的默认返回一个黑色的颜色对象");
        return [UIColor blackColor];
    }
    
    uint32_t result = 0;
    if (length < 5) {
        JOHexStringToInt([str substringWithRange:NSMakeRange(0, 1)],result);
        r = result;
        JOHexStringToInt([str substringWithRange:NSMakeRange(1, 1)],result);
        g =  result;
        JOHexStringToInt([str substringWithRange:NSMakeRange(2, 1)],result);
        b =  result;
        if (length == 4){
            JOHexStringToInt([str substringWithRange:NSMakeRange(3, 1)],result);
            a = result/ 225.0f;
        }else {
            a = 1.;
        }
    } else {
        JOHexStringToInt([str substringWithRange:NSMakeRange(0, 2)],result);
        r = result ;
        JOHexStringToInt([str substringWithRange:NSMakeRange(2, 2)],result);
        g = result ;
        JOHexStringToInt([str substringWithRange:NSMakeRange(4, 2)],result);
        b =  result;
        if (length == 8) {
            JOHexStringToInt([str substringWithRange:NSMakeRange(6, 2)],result);
            a = result/ 255.0f;
        }else {
            a = 1.;
        }
    }
    return JORGBAMake(r, g, b, a);
    
#undef JOHexStringToInt
}

+ (UIColor *)joHexRGBStringToColorWithHexString:(NSString *)hexString {
    return JOHexRGBStringToColor(hexString);
}

UIColor *JOHexRGBStringDefineAlphaToColor(NSString *hexString,CGFloat alpha) {

    UIColor *rgbColor = JOHexRGBStringToColor(hexString);
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [rgbColor getRed:&r green:&g blue:&b alpha:&a];
    //    uint32_t tt = JOConvertColorToRGBHex(rgbColor);
    //    return JOConvertHexRGBDefineAlphaToColor(tt,alpha);
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)joHexRGBStringToColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    return JOHexRGBStringDefineAlphaToColor(hexString,alpha);
}

#pragma mark - private UIColor to hexstring
#pragma mark -

NSString *JOConvertColorToRGBHexStringWithAlphaState(UIColor *color,BOOL state) {
    
    CGColorRef colorRef = color.CGColor;
    size_t count = CGColorGetNumberOfComponents(colorRef);
    const CGFloat *components = CGColorGetComponents(colorRef);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components  [0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && state) {
        hex = [hex stringByAppendingFormat:@"%02lx",
               (unsigned long)(CGColorGetAlpha(colorRef) * 255.0 + 0.5)];
    }
    return hex;
}

NSString *JOColorToRGBHexString(UIColor *color) {
    return JOConvertColorToRGBHexStringWithAlphaState(color, NO);
}

- (NSString *)joColorToRGBHexString {
    return JOColorToRGBHexString(self);
}

NSString *JOColorToRGBAHexString(UIColor *color) {
    return JOConvertColorToRGBHexStringWithAlphaState(color, YES);
}

- (NSString *)joColorToRGBAHexString {
    return JOColorToRGBAHexString(self);
}

uint32_t JOColorToRGBHex(UIColor *color) {

    CGFloat r = 0, g = 0, b = 0, a = 0;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)joColorToRGBHex {
    return JOColorToRGBHex(self);
}

uint32_t JOColorToRGBAHex(UIColor *color) {

    CGFloat r = 0, g = 0, b = 0, a = 0;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}

- (uint32_t)joColorToRGBAHex {
    return JOColorToRGBAHex(self);
}

#pragma mark - JORGB 与 UIColor 十六进制颜色表示 之间的转换
#pragma mark -

JORGB JOColorToJORGB(UIColor *color) {

    CGFloat r = 0, g = 0, b = 0, a = 0;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r;
    uint8_t green = g;
    uint8_t blue = b;
    uint8_t alpha = a;
    
    JORGB rgbColor;
    rgbColor.r = red;
    rgbColor.g = green;
    rgbColor.b = blue;
    rgbColor.a = alpha;
    
    return rgbColor;
}

- (JORGB)joColorToJORGB {
    return JOColorToJORGB(self);
}

JORGB JOHexRGBStringToJORGB(NSString *hexString) {
    return JOColorToJORGB(JOHexRGBStringToColor(hexString));
}

+ (JORGB)joHexRGBStringToJORGBWithHexString:(NSString *)hexString {
    return JOHexRGBStringToJORGB(hexString);
}

JORGB JOHexRGBStringDefineAlphaToJORGB(NSString *hexString,CGFloat alpha) {
    return JOColorToJORGB(JOHexRGBStringDefineAlphaToColor(hexString, alpha));
}

+ (JORGB)joHexRGBStringToJORGBWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    return JOHexRGBStringDefineAlphaToJORGB(hexString,alpha);
}

#pragma mark - UIColor Space Model
#pragma mark -

NSString *JOColorSpaceModel(UIColor *color) {

    CGColorSpaceModel model =  CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    switch (model) {
        case kCGColorSpaceModelUnknown:
            return @"kCGColorSpaceModelUnknown";
            
        case kCGColorSpaceModelMonochrome:
            return @"kCGColorSpaceModelMonochrome";
            
        case kCGColorSpaceModelRGB:
            return @"kCGColorSpaceModelRGB";
            
        case kCGColorSpaceModelCMYK:
            return @"kCGColorSpaceModelCMYK";
            
        case kCGColorSpaceModelLab:
            return @"kCGColorSpaceModelLab";
            
        case kCGColorSpaceModelDeviceN:
            return @"kCGColorSpaceModelDeviceN";
            
        case kCGColorSpaceModelIndexed:
            return @"kCGColorSpaceModelIndexed";
            
        case kCGColorSpaceModelPattern:
            return @"kCGColorSpaceModelPattern";
            
        default:
            return @"ColorSpaceInvalid";
    }
}

- (NSString *)joColorSpaceModel {
    return JOColorSpaceModel(self);
}

@end
