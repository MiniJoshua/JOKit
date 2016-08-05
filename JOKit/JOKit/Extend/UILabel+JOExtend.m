//
//  UILabel+JOExtend.m
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import "UILabel+JOExtend.h"

@implementation UILabel(Extend)

+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font {

    return JONewLabel(font,0,NSTextAlignmentLeft,NSLineBreakByWordWrapping);
}

+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font numberLines:(NSInteger)numberLines {

    return JONewLabel(font,numberLines,NSTextAlignmentLeft,NSLineBreakByWordWrapping);
}

+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font alignment:(NSTextAlignment)alignment {

    return JONewLabel(font,0,alignment,NSLineBreakByWordWrapping);
}

+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode {

    return JONewLabel(font,0,NSTextAlignmentLeft,NSLineBreakByWordWrapping);
}

+ (UILabel *)joNewLabelWithJOFont:(JOFont *)font numberLines:(NSInteger)numberLines alignment:(NSTextAlignment)alignment {

    return JONewLabel(font,numberLines,alignment,NSLineBreakByWordWrapping);
}

- (void)setJOFont:(JOFont *)font {
    
    [self setFont:font->font];
    [self setTextColor:font->color];
}

CGFloat JOLabelDynamicWidth(UILabel *label) {

    return [label sizeThatFits:CGSizeMake(HUGE, HUGE)].width+1;
}

CGFloat JOLabelDynamicHeight(UILabel *label,CGFloat width) {

    return [label sizeThatFits:CGSizeMake(width, HUGE)].height+1;
}

@end
