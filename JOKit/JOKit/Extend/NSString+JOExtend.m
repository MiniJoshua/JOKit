//
//  NSString+JOExtend.m
//  JOKit
//
//  Created by 刘维 on 16/8/2.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "NSString+JOExtend.h"

@implementation NSString(JOExtend)


NSString *JONormalString(NSString *string) {
    
    return (![string isEqual:[NSNull null]] && string)? string : @"";
}

- (NSString *)joNormalString {
    return JONormalString(self);
}

NSString *JOTrimString(NSString *string) {
    
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)joTrimString {
    return JOTrimString(self);
}

NSString *JOTrimEndString(NSString *string) {
    
    NSString *tempString;
    tempString = [[@"a" stringByAppendingString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [tempString substringFromIndex:1];
}

- (NSString *)joTrimEndString {
    return JOTrimEndString(self);
}

NSString *JOTrimStartString(NSString *string) {
    
    NSString *tempString;
    tempString = [[string stringByAppendingString:@"a"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [tempString substringToIndex:[tempString length]-1];
}

- (NSString *)joTrimStartString {
    return JOTrimStartString(self);
}

NSString *JOTrimAllSpaceString(NSString *string) {
    
    NSString *resultStr;
    //先去除首尾的空格
    resultStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //根据空格拆分成数组
    NSArray *components = [resultStr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤掉数组中每个数据中的空格
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ' '"]];
    //将数组拼接成一个字符串
    resultStr = [components componentsJoinedByString:@""];
    
    return resultStr;
}

- (NSString *)joTrimAllSpaceString {
    
    return JOTrimAllSpaceString(self);
}

BOOL JOStringIsInt(NSString *string) {
    
    //    NSString *NUMBER=@"[0-9]+";
    //    NSPredicate *regextestNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",NUMBER];
    //
    //    if([regextestNumber evaluateWithObject:string]== YES){
    //        return YES;
    //    }else{
    //        return NO;
    //    }
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)joStringIsInt {
    return JOStringIsInt(self);
}

BOOL JOStringIsFloat(NSString *string) {
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)joStringIsFloat {
    return JOStringIsFloat(self);
}

NSUInteger JOConvertHexStringToInt(NSString *string) {
    return strtoul([string UTF8String], 0, 16);
}

- (NSUInteger)joConvertHexStringToInt {
    return JOConvertHexStringToInt(self);
}

NSString *JOConvertIntToHexString(long long int intValue) {
    
    NSString *tempValue;
    NSString *hexString =@"";
    long long int temp;
    for (int i = 0; i<9; i++) {
        temp=intValue%16;
        intValue=intValue/16;
        switch (temp)
        {
            case 10:
                tempValue =@"A";break;
            case 11:
                tempValue =@"B";break;
            case 12:
                tempValue =@"C";break;
            case 13:
                tempValue =@"D";break;
            case 14:
                tempValue =@"E";break;
            case 15:
                tempValue =@"F";break;
            default:tempValue=[[NSString alloc]initWithFormat:@"%lli",temp];
        }
        hexString = [tempValue stringByAppendingString:hexString];
        if (intValue == 0) {
            break;
        }
    }
    return hexString;
}

+ (NSString *)joConvertToHexStringWithInt:(long long int) intValue {
    return JOConvertIntToHexString(intValue);
}

BOOL JOStringIsValidPhoneNumber(NSString *string) {
    
    NSString *MOBILE=@"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    NSString *CM=@"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *CU=@"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT= @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    
    if(([regextestmobile evaluateWithObject:string]== YES)||
       ([regextestcm evaluateWithObject:string] == YES)||
       ([regextestct evaluateWithObject:string] ==  YES)||
       ([regextestcu evaluateWithObject:string]== YES)){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)joStringIsValidPhoneNumber {
    return JOStringIsValidPhoneNumber(self);
}

BOOL JOStringIsValidEmail(NSString *string) {
    
    //    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [predicate evaluateWithObject:string];
}

- (BOOL)joStringIsValidEmail {
    return JOStringIsValidEmail(self);
}

BOOL JOStringIsValidPassword(NSString *string) {
    
    NSString *pattern = @"^[a-zA-Z0-9]{6,16}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if ([predicate evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}

- (BOOL)joStringIsValidPassword {
    return JOStringIsValidPassword(self);
}

BOOL JOStringIsValidIDCardNum(NSString *string) {
    
    if (string.length > 18 || JONormalString(string).length == 0) {
       return NO;
    }

    NSString *num = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    if ([predicate evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}

- (BOOL)joStringIsValidIDCardNum {
    return JOStringIsValidIDCardNum(self);
}

#pragma mark - Attributed String

- (NSMutableAttributedString *)joAttributedStringWithFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)style {
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, [self length])];
    return attributedString;
}

- (NSMutableAttributedString *)joAttributedStringWithFont:(UIFont *)font lineSpace:(CGFloat )lineSpace {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    return [self joAttributedStringWithFont:font paragraphStyle:paragraphStyle];
}

- (NSMutableAttributedString *)joAttributedStringwithNormalColor:(UIColor *)normalColor
                                                      normalFont:(UIFont *)normalFont
                                                      markString:(NSString *)markString
                                                        markFont:(UIFont *)markFont
                                                       markColor:(UIColor *)markColor {
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [contentAttributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            normalColor,NSForegroundColorAttributeName,
                                            normalFont,NSFontAttributeName,nil]
                                     range:NSMakeRange(0, self.length)];
    
    for(NSTextCheckingResult *result in [self regularCheckingString:markString]){
        
        NSRange matchRange = [result range];
        [contentAttributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                markColor,NSForegroundColorAttributeName,
                                                markFont,NSFontAttributeName,nil]
                                         range:matchRange];
    }
    
    return contentAttributedString;
}

- (NSMutableAttributedString *)joAttributedStringwithMarkString:(NSString *)markString
                                                       markFont:(UIFont *)markFont
                                                      markColor:(UIColor *)markColor {
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:self];
    for(NSTextCheckingResult *result in [self regularCheckingString:markString]){
        
        NSRange matchRange = [result range];
        [contentAttributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                markColor,NSForegroundColorAttributeName,
                                                markFont,NSFontAttributeName,nil]
                                         range:matchRange];
    }
    
    return contentAttributedString;
}

- (NSArray *)regularCheckingString:(NSString *)checkString {
    
    NSString *patternString = @"";
    if ([checkString isEqualToString:@"|"] || [checkString isEqualToString:@"+"]) {
        patternString = [NSString stringWithFormat:@"[\%@]",checkString];
    }else{
        patternString = checkString;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternString options:0 error:nil];
    return [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
}

#pragma mark - Size Of String

- (CGSize)joSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)model {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = model;
    
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,nil]
                              context:nil].size;
}

- (CGSize)joSizeWithFont:(UIFont *)font size:(CGSize)size {
    
    return [self joSizeWithFont:font size:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGFloat)joHeightWithFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)model {
    
    return [self joSizeWithFont:font size:CGSizeMake(width, HUGE) lineBreakMode:model].height;
}

- (CGFloat)joHeightWithFont:(UIFont *)font width:(CGFloat)width {
    
    return [self joSizeWithFont:font size:CGSizeMake(width, HUGE)].height;
}

- (CGSize)joSizeWithFont:(UIFont *)font size:(CGSize)size lineSpace:(CGFloat)lineSpace paragraphStyle:(NSParagraphStyle *)style {
    
    return [[self joAttributedStringWithFont:font paragraphStyle:style] boundingRectWithSize:size
                                                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                                     context:nil].size;
}

- (CGSize)joSizeWithFont:(UIFont *)font size:(CGSize)size lineSpace:(CGFloat)lineSpace {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    if (!([self joSizeWithFont:font size:CGSizeMake(HUGE, HUGE) lineSpace:lineSpace paragraphStyle:paragraphStyle].width <= size.width)) {
        //多行的时候
        [paragraphStyle setLineSpacing:lineSpace];
    }
    
    return [self joSizeWithFont:font size:size lineSpace:lineSpace paragraphStyle:paragraphStyle];
}

- (CGFloat)joHeightWithFont:(UIFont *)font width:(CGFloat)width lineSpace:(CGFloat)lineSpace paragraphStyle:(NSParagraphStyle *)style {
    
    return [self joSizeWithFont:font size:CGSizeMake(width, HUGE) lineSpace:lineSpace paragraphStyle:style].height;
}

- (CGFloat)joHeightWithFont:(UIFont *)font width:(CGFloat)width lineSpace:(CGFloat)lineSpace {
    
    return [self joSizeWithFont:font size:CGSizeMake(width, HUGE) lineSpace:lineSpace].height;
}

- (CGFloat)joWidthWithFont:(UIFont *)font {
    
    return [self joSizeWithFont:font size:CGSizeMake(HUGE, HUGE)].width;
}

#pragma mark - Regular Expression

- (BOOL)joMatchesStateWithRegex:(NSString *)regexString options:(NSRegularExpressionOptions)options {
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:regexString options:options error:NULL];
    if (!regularExpression) {
        return NO;
    }
    return ([regularExpression numberOfMatchesInString:self options:0 range:NSMakeRange(0., self.length)]>0);
}

- (void)joEnumerateMatchesWithRegex:(NSString *)regexString
                            options:(NSRegularExpressionOptions)options
                         usingBlock:(void (^)(NSString *matchString, NSRange matchRange, BOOL *stop))block {
    
    if (regexString.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regexString options:options error:nil];
    if (!regexString) return;
    [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

- (NSString *)joStringByReplacingWithRegex:(NSString *)regex
                                   options:(NSRegularExpressionOptions)options
                                withString:(NSString *)replacement {
    
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!pattern){
        return self;
    }
    return [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
}

@end


@implementation NSString(JODateExtend)

NSString *JODateFormat(NSDate *date,NSString *formatter) {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)joDateStringWithDate:(NSDate *)date format:(NSString *)formatter {
    return JODateFormat(date,formatter);
}

NSString *JODateStringFormat(NSString *dateString,NSString *formatter) {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormatterComplete];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return JODateFormat(date,formatter);
}

- (NSString *)joDateStringWithForamt:(NSString *)formatter {
    return JODateStringFormat(self, formatter);
}

NSString *JODateFormatTimeline(NSString *timelineString,NSString *formatter) {

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timelineString longLongValue]];
    return JODateFormat(date, formatter);
}

- (NSString *)joDateFormatTimelineWithForamt:(NSString *)formatter {
    return JODateFormatTimeline(self,formatter);
}

NSString *JODateConvertToTimelineString(NSDate *date) {

    return [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
}

+ (NSString *)joDateConvertToTimelineStringWithDate:(NSDate *)date {
    return JODateConvertToTimelineString(date);
}

NSString *JODateCustomFormatTimeline(NSString *timelineString,NSInteger days) {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timelineString longLongValue]];
    return JODateCustomFormat(date, days);
}

- (NSString *)joDateCustomFormatTimelineWithDays:(NSInteger)days {
    return JODateCustomFormatTimeline(self,days);
}


NSString *JODateCustomDefaultFormatTimeline(NSString *timelineString) {
    
    return JODateCustomFormatTimeline(timelineString, 5);
}

- (NSString *)joDateCustomDefaultFormatTimeline {
    return JODateCustomDefaultFormatTimeline(self);
}

NSString *JODateCustomFormat(NSDate *date,NSInteger days) {

    NSInteger hours =  ABS(MIN(([date timeIntervalSinceDate:[NSDate date]])/kSeconds_Hour, 0));
    NSString *format = @"刚刚";
    if (hours <= 0) {
        format = @"刚刚";
    } else if (hours > 0 && hours <= 24) {
        format = [NSString stringWithFormat:@"%ld小时前", (long)hours];
    } else {
        NSInteger day = ABS(MIN(([date timeIntervalSinceDate:[NSDate date]])/kSeconds_Day, 0));
        if (day < days) {
            format = [NSString stringWithFormat:@"%ld天前", (long)days];
        } else {
            format = JODateFormat(date,kDateFormatterYear_Month_Day);
        }
    }
    return format;
}

+ (NSString *)joDateCustomFormatWithDate:(NSDate *)date days:(NSInteger)days {
    return JODateCustomFormat(date,days);
}

NSString *JODateCustomDefaultFormat(NSDate *date) {

    return JODateCustomFormat(date,5);
}

+ (NSString *)joDateCustomDefaultFormatWithDate:(NSDate *)date {
    return JODateCustomDefaultFormat(date);
}

@end

