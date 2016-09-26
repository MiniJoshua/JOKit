//
//  NSDate+JOExtend.m
//  JOKit
//
//  Created by 刘维 on 16/9/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "NSDate+JOExtend.h"

@implementation NSDate(JOExtend)

#define JODate \
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; \
[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; \
[dateFormatter setLocale:[NSLocale autoupdatingCurrentLocale]]; \
[dateFormatter setDateFormat:kDateFormatterComplete]; \
return [dateFormatter dateFromString:dateString]; \

NSDate *JODateCompleteString(NSString *dateString) {
    JODate;
}

#undef JODate

NSDate *JODateYearMonthDayString(NSString *year,NSString *month,NSString *day) {
   return JODateCompleteString([NSString stringWithFormat:@"%@-%@-%@ 00:00:00",year,month,day]);
}

NSDate *JODateYearMonthString(NSString *year,NSString *month) {
    return JODateYearMonthDayString(year,month,@"01");
}

NSDate *JODateYearString(NSString *year) {
    return JODateYearMonthString(year,@"01");
}

NSDate *JODateTimelineString(NSString *timelineString) {

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timelineString longLongValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    [dateFormatter setDateFormat:kDateFormatterComplete];
    return JODateCompleteString([dateFormatter stringFromDate:date]);
}

+ (NSDate *)joDateWithCompleteString:(NSString *)dateString {
    return JODateCompleteString(dateString);
}

+ (NSDate *)joDateWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
    return JODateYearMonthDayString(year,month,day);
}

+ (NSDate *)joDateWithYear:(NSString *)year month:(NSString *)month {
    return JODateYearMonthString(year,month);
}

+ (NSDate *)joDateWithYear:(NSString *)year {
    return JODateYearString(year);
}

+ (NSDate *)joDateWithTimelineString:(NSString *)timelineString {
    return JODateTimelineString(timelineString);
}

NSDateComponents *JODateComponents(NSString *identifier,NSCalendarUnit calendarUnit, NSDate *date) {

    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:identifier];
    return [gregorian components:calendarUnit fromDate:date];
}

NSDateComponents *JODateDefaultComponents(NSCalendarUnit calendarUnit, NSDate *date) {
    return JODateComponents(NSCalendarIdentifierGregorian, calendarUnit, date);
}

- (NSDateComponents *)joDateComponentsWithIdentifier:(NSString *)identifier calendarUnit:(NSCalendarUnit)calendarUnit {
    return JODateComponents(identifier,calendarUnit,self);
}

- (NSDateComponents *)joDateComponentsWithCalendarUnit:(NSCalendarUnit)calendarUnit {
    return JODateDefaultComponents(calendarUnit,self);
}

NSInteger JODateEra(NSDate *date) {
    return [JODateDefaultComponents(NSCalendarUnitEra, date) era];
}

NSInteger JODateYear(NSDate *date) {
    return [JODateDefaultComponents(NSCalendarUnitYear, date) year];
}

NSInteger JODateMonth(NSDate *date) {
    return [JODateDefaultComponents(NSCalendarUnitMonth, date) month];
}

NSInteger JODateDay(NSDate *date) {
    return [JODateDefaultComponents(NSCalendarUnitDay, date) day];
}

NSInteger JODateHour(NSDate *date) {
    return [JODateDefaultComponents(NSCalendarUnitHour, date) hour];
}

NSInteger JODateMinute(NSDate *date) {
    return [JODateDefaultComponents(NSCalendarUnitMinute, date) minute];
}

NSInteger JODateSecond(NSDate *date) {
    return [JODateDefaultComponents(NSCalendarUnitSecond, date) second];
}

- (NSInteger)joDateEra {
    return JODateEra(self);
}

- (NSInteger)joDateYear {
    return JODateYear(self);
}

- (NSInteger)joDateMonth {
    return JODateMonth(self);
}

- (NSInteger)joDateDay {
    return JODateDay(self);
}

- (NSInteger)joDateHour {
    return JODateHour(self);
}

- (NSInteger)joDateMinute {
    return JODateMinute(self);
}

- (NSInteger)joDateSecond {
    return JODateSecond(self);
}

NSInteger JODateMonthDayInWeekLocation(NSDate *date,NSInteger start,NSInteger day) {

    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //设置第一个工作日
    //设定每周的第一天从星期几开始，比如:
    //如需设定从星期日开始，则value传入1
    //如需设定从星期一开始，则value传入2
    //以此类推
    [gregorian setFirstWeekday:start];
    
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [comps setDay:day];
    NSDate *newDate = [gregorian dateFromComponents:comps];
    
    return [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate];
}

NSInteger JODateMonthDefaultDayInWeekLocation(NSDate *date) {

    return JODateMonthDayInWeekLocation(date, 1,1);
}

- (NSInteger)joDateMonthDayInWeekLocationWithStart:(NSInteger)start day:(NSInteger)day {
    return JODateMonthDayInWeekLocation(self,start,day);
}
- (NSInteger)joDateMonthDayInWeekLocation {
    return JODateMonthDefaultDayInWeekLocation(self);
}

#define JOOffsetDate(_method_) \
NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; \
NSDateComponents *offsetComponents = [[NSDateComponents alloc] init]; \
[offsetComponents _method_:offset]; \
return [gregorian dateByAddingComponents:offsetComponents toDate:date options:0]; \

NSDate *JODateYearOffset(NSDate *date,NSInteger offset) {
    JOOffsetDate(setYear);
}

NSDate *JODateMonthOffset(NSDate *date,NSInteger offset) {
    JOOffsetDate(setMonth);
}

NSDate *JODateDayOffset(NSDate *date,NSInteger offset) {
    JOOffsetDate(setDay);
}

NSDate *JODateHourOffset(NSDate *date,NSInteger offset) {
    JOOffsetDate(setHour);
}

NSDate *JODateMinuteOffset(NSDate *date,NSInteger offset) {
    JOOffsetDate(setMinute);
}

NSDate *JODateSecondOffset(NSDate *date,NSInteger offset) {
    JOOffsetDate(setSecond);
}

#undef JOOffsetComponent

- (NSDate *)joDateYearWithOffset:(NSInteger)offset {
    return JODateYearOffset(self,offset);
}

- (NSDate *)joDateMonthWithOffset:(NSInteger)offset {
    return JODateMonthOffset(self,offset);
}

- (NSDate *)joDateDayWithOffset:(NSInteger)offset {
    return JODateDayOffset(self,offset);
}

- (NSDate *)joDateHourWithOffset:(NSInteger)offset {
    return JODateHourOffset(self,offset);
}

- (NSDate *)joDateMinuteWithOffset:(NSInteger)offset {
    return JODateMinuteOffset(self,offset);
}

- (NSDate *)joDateSecondWithOffset:(NSInteger)offset {
    return JODateSecondOffset(self,offset);
}

/*
 不能被4整除的一定是平年；能被4整除的不好说,一般来说是闰年,也有可能是平年.
 准确来说,如果能被4整除,同时不能被100整除,是闰年；
 如果能被4整除,也能被100整除,但不能被400整除,是平年；
 如果能被4整除,也能被100整除,也能被400整除,是闰年.
 */
BOOL JODateIsLeapYear(NSDate *date) {

    NSInteger year = JODateYear(date);
    if (year%4) {
        return NO;
    }else {
        if ((!(year%4) && (year%100)) || (!(year%4) && !(year % 100) && !(year % 400))) {
            return YES;
        }else {
            return NO;
        }
    }
}

- (BOOL)joDateIsLeapYear {
    return JODateIsLeapYear(self);
}

NSInteger JODateDaysInMonth(NSDate *date) {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDays = rng.length;
    return numberOfDays;
}

NSInteger JODateDaysInYear(NSDate *date) {
    
    if (JODateIsLeapYear(date)) {
        return 366;
    }else {
        return 365;
    }
    
    /*
    NSCalendar *cal = [NSCalendar currentCalendar];
    //返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的范围
    // NSCalendarUnitDay NSCalendarUnitYear 则表示day在year里面的范围  最大为31天 所以返回的就是 31
    //NSCalendarUnitMonth NSCalendarUnitYear 则表示month在year里面的范围 最大为12个月 所以返回的就是12
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    //返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的顺序
    //NSCalendarUnitDay NSCalendarUnitYear 给定的Date在一年的第几天.
    //[cal ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate: someDate];
    NSUInteger numberOfDays = rng.length;
    return numberOfDays;
     */
}

NSInteger JODateDaysInYearString(NSString *year) {
    return JODateDaysInYear(JODateYearString(year));
}

- (NSInteger)joDateDaysInMonth {
    return JODateDaysInMonth(self);
}

- (NSInteger)joDateDaysInYear {
    return JODateDaysInYear(self);
}

+ (NSInteger)joDateDaysInYearWithYearString:(NSString *)yearString {
    return JODateDaysInYearString(yearString);
}

#define JOWeekDate(day) \
NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; \
[gregorian setFirstWeekday:start]; \
NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date]; \
NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init]; \
[componentsToSubtract setDay: day]; \
NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0]; \
NSDateComponents *componentsStripped = [gregorian components: (NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate: beginningOfWeek]; \
beginningOfWeek = [gregorian dateFromComponents: componentsStripped]; \
return beginningOfWeek; \

NSDate *JODateStartWeek(NSDate *date,NSInteger start) {
    
    JOWeekDate(- ((([components weekday] - [gregorian firstWeekday]) + 7 ) % 7));
    
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [gregorian setFirstWeekday:start];
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date]; //获得星期几
//    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
//    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday]) + 7 ) % 7)];
//    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
//    NSDateComponents *componentsStripped = [gregorian components: (NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate: beginningOfWeek];
//    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
//    return beginningOfWeek;
}

NSDate *JODateDefaultStartWeek(NSDate *date) {
    return JODateStartWeek(date, 1);
}

NSDate *JODateCurrentStartWeek() {
    return JODateDefaultStartWeek(JODate());
}

NSDate *JODateEndWeek(NSDate *date,NSInteger start) {
    JOWeekDate((((([components weekday] - [gregorian firstWeekday]) + 7 ) % 7)));
}

NSDate *JODateDefaultEndWeek(NSDate *date) {
    return JODateEndWeek(date, 1);
}

NSDate *JODateCurrentEndWeek() {
    return JODateDefaultEndWeek(JODate());
}

- (NSDate *)joDateStartWeekWithStart:(NSInteger)start {
    return JODateStartWeek(self, start);
}

- (NSDate *)joDateStartWeek {
    return JODateDefaultStartWeek(self);
}

+ (NSDate *)joDateCurrentStartWeek {
    return JODateCurrentStartWeek();
}

- (NSDate *)joDateEndWeekWithStart:(NSInteger)start {
    return JODateEndWeek(self,start);
}

- (NSDate *)joDateEndWeek {
    return JODateDefaultEndWeek(self);
}

+ (NSDate *)joDateCurrentEndWeek {
    return JODateCurrentEndWeek();
}

#define JORemianTime(_type_) \
NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; \
NSDateComponents *components = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:JODate() toDate:toDate options:0]; \
return [components _type_]; \

NSInteger JODateRemainSeconds(NSDate *toDate) {
    JORemianTime(second);
}

NSInteger JODateRemainMinutes(NSDate *toDate) {
    JORemianTime(minute);
}

NSInteger JODateRemainHours(NSDate *toDate) {
    JORemianTime(hour);
}

NSInteger JODateRemainDays(NSDate *toDate) {
    JORemianTime(day);
}

NSInteger JODateRemainMonths(NSDate *toDate) {
    JORemianTime(month);
}

NSInteger JODateRemainYears(NSDate *toDate) {
    JORemianTime(year);
}

#undef JOWeekDate

+ (NSInteger)joDateRemainSecondsToDate:(NSDate *)date {
    return JODateRemainSeconds(date);
}

+ (NSInteger)joDateRemainMinutesToDate:(NSDate *)date {
    return JODateRemainMinutes(date);
}

+ (NSInteger)joDateRemainHoursToDate:(NSDate *)date {
    return JODateRemainHours(date);
}

+ (NSInteger)joDateRemainDaysToDate:(NSDate *)date {
    return JODateRemainDays(date);
}

+ (NSInteger)joDateRemainMonthsToDate:(NSDate *)date {
    return JODateRemainMonths(date);
}

+ (NSInteger)joDateRemainYearsToDate:(NSDate *)date {
    return JODateRemainYears(date);
}

NSString *JODateRemainTimeString(NSDate *toDate) {
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日 %ld时%ld分%ld秒",JODateRemainYears(toDate),JODateRemainMonths(toDate),JODateRemainDays(toDate),JODateRemainHours(toDate),JODateRemainMinutes(toDate),JODateRemainSeconds(toDate)];
}

+ (NSString *)joDateRemainTimeStringToDate:(NSDate *)date {
    return JODateRemainTimeString(date);
}

@end
