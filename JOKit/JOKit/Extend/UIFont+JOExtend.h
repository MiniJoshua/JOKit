//
//  UIFont+JOExtend.h
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOMacro.h"

@interface JOFont : NSObject {
@public
    NSString *name;
    UIColor *color;
    UIFont *font;
    CGFloat size;
}

@end

/**
 *  JOFont Make
 *
 *  @param font      字体.
 *  @param fontColor 字体的颜色.
 *
 *  @return JOFont.
 */
JO_STATIC_INLINE JOFont *JOFontMake(UIFont *font,UIColor *fontColor) {
    
    JOFont *Font = [JOFont new];
    Font -> name = font.fontName;
    Font -> color = fontColor;
    Font -> size = font.pointSize;
    Font -> font = font;
    return Font;
}

/**
 *  JOFont Make
 *
 *  @param fontName  字体的名字.
 *  @param fontSize  字体的大小.
 *  @param fontColor 字体的颜色.
 *
 *  @return JOFont.
 */
JO_STATIC_INLINE JOFont *JOCFontMake(NSString *fontName,CGFloat fontSize,UIColor *fontColor) {

    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    return JOFontMake(font, fontColor);
}

/**
 *  JOFont Make
 *
 *  @param weight    UIFontWeightLight  UIFontWeightRegular  UIFontWeightBold ...
 *  @param fontSize  字体的大小.
 *  @param fontColor 字体的颜色.
 *
 *  @return JOFont.
 */
JO_STATIC_INLINE JOFont *JOSFontMake(CGFloat weight,CGFloat fontSize,UIColor *fontColor) NS_AVAILABLE_IOS(8_2) {

    UIFont *font = [UIFont systemFontOfSize:fontSize weight:weight];
    return JOFontMake(font, fontColor);
}

/**
 *  JOFont Make 主要针对IOS7以及以下的系统. Blod的字体
 *
 *  @param fontSize  字体的大小.
 *  @param fontColor 字体的颜色.
 *
 *  @return JOFont.
 */
JO_STATIC_INLINE JOFont *JOSBlodFontMake(CGFloat fontSize,UIColor *fontColor) {

    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    return JOFontMake(font, fontColor);
}

/**
 *  JOFont Make 主要针对IOS7以及以下的系统. 平常的字体
 *
 *  @param fontSize  字体的大小.
 *  @param fontColor 字体的颜色.
 *
 *  @return JOFont.
 */
JO_STATIC_INLINE JOFont *JOSNormalFontMake(CGFloat fontSize,UIColor *fontColor) {
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return JOFontMake(font, fontColor);
}


@interface UIFont(Extend)

@end
