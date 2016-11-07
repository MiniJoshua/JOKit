//
//  JODateMacro.h
//  JOKit
//
//  Created by 刘维 on 16/9/20.
//  Copyright © 2016年 Joshua. All rights reserved.
//
#import "JOMacro.h"
#ifndef JODateMacro_h
#define JODateMacro_h

static NSString *const kDateFormatterComplete           = @"yyyy-MM-dd HH:mm:ss";
static NSString *const kDateFormatterYear               = @"yyyy";
static NSString *const kDateFormatterMonth              = @"MM";
static NSString *const kDateFormatterDay                = @"dd";
static NSString *const kDateFormatterHour               = @"HH";
static NSString *const kDateFormatterMinute             = @"mm";
static NSString *const kDateFormatterSecond             = @"ss";

static NSString *const kDateFormatterYear_Month_Day     = @"yyyy-MM-dd";
static NSString *const kDateFormatterYear_Month         = @"yyyy-MM";
static NSString *const kDateFormatterMonth_Day          = @"MM-dd";

static NSString *const kDateFormatterHour_Minute_Second = @"HH:mm:ss";
static NSString *const kDateFormatterHour_Minute        = @"HH:mm";
static NSString *const kDateFormatterMinute_Second      = @"mm:ss";

/*每个时间单位包含的秒数*/
static const long long kSeconds_Year                    = 31556900;
static const NSInteger kSeconds_Month28                 = 2419200;
static const NSInteger kSeconds_Month29                 = 2505600;
static const NSInteger kSeconds_Month30                 = 2592000;
static const NSInteger kSeconds_Month31                 = 2678400;
static const NSInteger kSeconds_Week                    = 604800;
static const NSInteger kSeconds_Day                     = 86400;
static const NSInteger kSeconds_Hour                    = 3600;
static const NSInteger kSeconds_Minute                  = 60;
static const NSInteger kMilliSeconds_Second             = 1000; //1000毫秒 = 1秒


/**
 根据系统的时区去获取Date,这样取出来的时间不会存在8个小时的差别

 @return Date.
 */
JO_STATIC_INLINE NSDate *JODate() {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date dateByAddingTimeInterval: interval];
}

#endif /* JODateMacro_h */
