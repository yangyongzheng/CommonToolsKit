//
//  CTLDateManager.m
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/4.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLDateManager.h"

@implementation CTLDateManager

#pragma mark - Public Method
#pragma mark 生成公历日历
+ (NSCalendar *)gregorianCalendar {
    static NSCalendar *gregorianCalendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        gregorianCalendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
        gregorianCalendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:28800];
    });
    
    return gregorianCalendar;
}

#pragma mark 日期(中国北京时间)的所有日期组件
+ (NSDateComponents *)chineseDateComponentsFromDate:(NSDate *)fromDate {
    NSCalendar *gregorianCalendar = [CTLDateManager gregorianCalendar];
    return [gregorianCalendar componentsInTimeZone:[CTLDateManager beijingTimeZone] fromDate:fromDate];
}

#pragma mark 简体中文本地化日期格式化对象
+ (NSDateFormatter *)chineseDateFormatterWithDateFormat:(NSString *)dateFormat {
    return [CTLDateManager dateFormatterWithDateFormat:dateFormat local:[CTLDateManager chineseLocale]];
}

#pragma mark 英文本地化日期格式化对象
+ (NSDateFormatter *)englishDateFormatterWithDateFormat:(NSString *)dateFormat {
    return [CTLDateManager dateFormatterWithDateFormat:dateFormat local:[CTLDateManager englishLocale]];
}

#pragma mark 根据日期格式和本地化生成日期格式化对象
+ (NSDateFormatter *)dateFormatterWithDateFormat:(NSString *)dateFormat local:(NSLocale *)local {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = [CTLDateManager gregorianCalendar];
    dateFormatter.timeZone = [CTLDateManager beijingTimeZone];
    dateFormatter.locale = local ?: [CTLDateManager chineseLocale];
    dateFormatter.dateFormat = dateFormat ?: CTLDateFormatLongStyle;
    return dateFormatter;
}

+ (NSString *)stringFromTimeIntervalSeconds:(NSTimeInterval)intervalSeconds withDateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [CTLDateManager chineseDateFormatterWithDateFormat:dateFormat];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalSeconds];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringFromTimeIntervalMilliseconds:(NSTimeInterval)intervalMilliseconds withDateFormat:(NSString *)dateFormat {
    return [CTLDateManager stringFromTimeIntervalSeconds:intervalMilliseconds/1000.0 withDateFormat:dateFormat];
}

#pragma mark - Misc
#pragma mark 北京时区
+ (NSTimeZone *)beijingTimeZone {
    return [NSTimeZone timeZoneForSecondsFromGMT:28800];
}

#pragma mark 本地化-简体中文
+ (NSLocale *)chineseLocale {
    return [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
}

#pragma mark 本地化-英文
+ (NSLocale *)englishLocale {
    return [NSLocale localeWithLocaleIdentifier:@"en_US"];
}

@end
