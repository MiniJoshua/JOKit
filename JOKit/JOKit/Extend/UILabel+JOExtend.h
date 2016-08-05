//
//  UILabel+JOExtend.h
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JOExtend.h"
#import "UIFont+JOExtend.h"

/**
 *  根据需要new一个label.
 *
 *  @param font          JOFont.
 *  @param numberLines   行数.
 *  @param alignment     排列的方式.
 *  @param lineBreakMode 显示的方式.
 *
 *  @return UILabel.
 */
JO_STATIC_INLINE UILabel *JONewLabel(JOFont *font,NSInteger numberLines,NSTextAlignment alignment,NSLineBreakMode lineBreakMode) {

    UILabel *label = [UILabel newAutoLayoutView];
    [label setFont:font->font];
    [label setTextColor:font->color];
    [label setTextAlignment:alignment];
    [label setLineBreakMode:lineBreakMode];
    [label setNumberOfLines:numberLines];
    return label;
}

@interface UILabel(Extend)

/* new一个Label 默认的numberlines为0  alignment为NSTextAlignmentLeft lineBreakMode为NSLineBreakByWordWrapping */
+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font;
+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font numberLines:(NSInteger)numberLines;
+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font alignment:(NSTextAlignment)alignment;
+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font numberLines:(NSInteger)numberLines alignment:(NSTextAlignment)alignment;

/**
 *  设置Lebel的JOFont属性.
 *
 *  @param font JOFont.
 */
- (void)setJOFont:(JOFont *)font;

#pragma mark - 动态大小获取
#pragma mark -

/**
 *  动态宽度获取.
 *
 *  @param label label.
 *
 *  @return 宽度.
 */
JO_EXTERN CGFloat JOLabelDynamicWidth(UILabel *label);

/**
 *  动态高度获取.
 *
 *  @param label label.
 *  @param width 给定的宽度.
 *
 *  @return 动态高度.
 */
JO_EXTERN CGFloat JOLabelDynamicHeight(UILabel *label,CGFloat width);

@end
