//
//  NSDate+JOExtend.h
//  JOKit
//
//  Created by 刘维 on 16/9/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOMacro.h"

/*
NSCalendarIdentifierGregorian;        //公历（常用）
NSCalendarIdentifierBuddhist;         //佛教日历
NSCalendarIdentifierChinese;          //中国农历（常用）
NSCalendarIdentifierCoptic;           //希伯来日历
NSCalendarIdentifierIslamic;          //伊斯兰历
NSCalendarIdentifierIslamicCivil;     //伊斯兰教日历
NSCalendarIdentifierJapanese;         //日本日历(和历，常用)
NSCalendarIdentifierRepublicOfChina;  //中华民国日历（台湾）
NSCalendarIdentifierPersian;          //波斯历
NSCalendarIdentifierIndian;           //印度日历
NSCalendarIdentifierISO8601;          //ISO8601（但是现在还不可用）
 */

@interface NSDate(JOExtend)

/**
 将DateString转换为Date类型.

 @param dateString 完整的格式示例 1987-02-23 12:23:32
 @param year 年  1987    得到的Date格式 1987-01-01 00:00:00 +0000
 @param month 月 02      得到的Date格式 1987-02-01 00:00:00 +0000
 @param day 日 23        得到的Date格式 1987-02-23 00:00:00 +0000

 @return Date
 */
JO_EXTERN NSDate *JODateCompleteString(NSString *dateString);
JO_EXTERN NSDate *JODateYearMonthDayString(NSString *year,NSString *month,NSString *day);
JO_EXTERN NSDate *JODateYearMonthString(NSString *year,NSString *month);
JO_EXTERN NSDate *JODateYearString(NSString *year);
JO_EXTERN NSDate *JODateTimelineString(NSString *timelineString);

/**
 根据给定的属性得到相应的NSDateComponents.

 @param identifier   标示.  默认为:NSCalendarIdentifierGregorian.
 @param calendarUnit NSCalendarUnit 属性.
 @param date         给定的Date.

 @return NSDateComponents.
 */
JO_EXTERN NSDateComponents *JODateComponents(NSString *identifier,NSCalendarUnit calendarUnit, NSDate *date);
JO_EXTERN NSDateComponents *JODateDefaultComponents(NSCalendarUnit calendarUnit, NSDate *date);

/**
 获取给定Date中的需要的值.

 @param date 给定的Date.

 @return 值.
 */
JO_EXTERN NSInteger JODateEra(NSDate *date);
JO_EXTERN NSInteger JODateYear(NSDate *date);
JO_EXTERN NSInteger JODateMonth(NSDate *date);
JO_EXTERN NSInteger JODateDay(NSDate *date);
JO_EXTERN NSInteger JODateHour(NSDate *date);
JO_EXTERN NSInteger JODateMinute(NSDate *date);
JO_EXTERN NSInteger JODateSecond(NSDate *date);

/**
 给定的Date的月中计算,此月中的第几天是周几.

 @param date  给定的Date.
 @param start 星期的第一天从周几开始算的,1为周日开始算,2为周一开始算,以此类推...  默认为1.
 @param day   这个月的第几天  默认为1代表计算此月第一天是周几.

 @return 如果1为周日开始计算,返回1则代表是周日,2则代表周一,以此类推...
 */
JO_EXTERN NSInteger JODateMonthDayInWeekLocation(NSDate *date,NSInteger start,NSInteger day);
JO_EXTERN NSInteger JODateMonthDefaultDayInWeekLocation(NSDate *date);

/**
 与给定Date向前或向后移动多少得到的Date.

 @param date   给定的Date.
 @param offset 位移.

 @return 得到位移后的Date.
 */
JO_EXTERN NSDate *JODateYearOffset(NSDate *date,NSInteger offset);
JO_EXTERN NSDate *JODateMonthOffset(NSDate *date,NSInteger offset);
JO_EXTERN NSDate *JODateDayOffset(NSDate *date,NSInteger offset);
JO_EXTERN NSDate *JODateHourOffset(NSDate *date,NSInteger offset);
JO_EXTERN NSDate *JODateMinuteOffset(NSDate *date,NSInteger offset);
JO_EXTERN NSDate *JODateSecondOffset(NSDate *date,NSInteger offset);

/**
 是否是闰年.

 @param date date.

 @return YES为闰年,NO为平年.
 */
JO_EXTERN BOOL JODateIsLeapYear(NSDate *date);

/**
 获取一个月或者一年里面有多少天数.

 @param date 给定的时间.
 @param year year的字符串.

 @return 天数.
 */
JO_EXTERN NSInteger JODateDaysInMonth(NSDate *date);
JO_EXTERN NSInteger JODateDaysInYear(NSDate *date);
JO_EXTERN NSInteger JODateDaysInYearString(NSString *year);

/**
 给定Date中在的那一周第一天或者最后一天的Date.

 @param date  给定的日期.
 @param start 一周的第一天从周几开始算的,1为周日(第一天),2为周一(第一天),以此类推... 如果是算最后一天: 1为周六(最后一天) 2为周日(最后一天) 以此类推...  PS:默认为1

 @return 得到的Date.
 */
JO_EXTERN NSDate *JODateStartWeek(NSDate *date,NSInteger start);
JO_EXTERN NSDate *JODateDefaultStartWeek(NSDate *date);
JO_EXTERN NSDate *JODateCurrentStartWeek(); //date默认为当前的Date.
JO_EXTERN NSDate *JODateEndWeek(NSDate *date,NSInteger start);
JO_EXTERN NSDate *JODateDefaultEndWeek(NSDate *date);
JO_EXTERN NSDate *JODateCurrentEndWeek();  //date默认为当前的Date.

/**
 距离给定的时间各个时间类型的剩余量. 
 ps:可以用下面的属性拼接成的 1年1月12日 12时23分34秒  代表剩余量为:1年1月12日12时23分34秒

 @param toDate 给定的时间.

 @return 剩余量.
 */
JO_EXTERN NSInteger JODateRemainSeconds(NSDate *toDate);
JO_EXTERN NSInteger JODateRemainMinutes(NSDate *toDate);
JO_EXTERN NSInteger JODateRemainHours(NSDate *toDate);
JO_EXTERN NSInteger JODateRemainDays(NSDate *toDate);
JO_EXTERN NSInteger JODateRemainMonths(NSDate *toDate);
JO_EXTERN NSInteger JODateRemainYears(NSDate *toDate);


/**
 剩余的时间格式为 1年1月12日 12时23分34秒 代表距离给定的时间剩余这么多.
 如果该格式不是你想要的类型,你可以用上面的方法自己拼接成自己想要的格式.

 @param toDate 给定的时间.

 @return 剩余量.
 */
JO_EXTERN NSString *JODateRemainTimeString(NSDate *toDate);

@end
