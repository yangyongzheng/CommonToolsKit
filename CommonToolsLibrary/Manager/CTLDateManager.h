//
//  CTLDateManager.h
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/4.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 h: [1 12], H: [0 23]
 HH: 一位数时使用0填充为2位数字，如03
 */
static NSString * const CTLTimeFormatShortStyle = @"HH:mm:ss";
static NSString * const CTLDateFormatShortStyle = @"yyyy-MM-dd";
static NSString * const CTLDateFormatLongStyle = @"yyyy-MM-dd HH:mm:ss";
static NSString * const CTLDateFormatFullStyle = @"yyyy-MM-dd HH:mm:ss.SSS";
static NSString * const CTLDateFormatForeignFullStyle = @"MMM d, yyyy h:mm:ss a";

@interface CTLDateManager : NSDate

/** 生成公历日历, 获取单例
 1.timeZone: GMT+8（北京时区）
 2.locale: 本地化为简体中文
 */
+ (NSCalendar *)gregorianCalendar;

/** 日期(中国北京时区)的所有日期组件 */
+ (NSDateComponents *)chineseDateComponentsFromDate:(NSDate *)fromDate;

/** 日期格式化对象
 1.timeZone: GMT+8（北京时区）
 2.locale: 本地化为简体中文
 */
+ (NSDateFormatter *)chineseDateFormatterWithDateFormat:(NSString *)dateFormat;

/** 日期格式化对象
 1.timeZone: GMT+8（北京时区）
 2.locale: 本地化为英文
 */
+ (NSDateFormatter *)englishDateFormatterWithDateFormat:(NSString *)dateFormat;

/** 时间戳(单位秒)转字符串
 @param intervalSeconds 时间戳，单位秒
 @param dateFormat 日期格式
 */
+ (NSString *)stringFromTimeIntervalSeconds:(NSTimeInterval)intervalSeconds withDateFormat:(NSString *)dateFormat;
/** 时间戳(单位毫秒)转字符串
 @param intervalMilliseconds 时间戳，单位毫秒
 @param dateFormat 日期格式
 */
+ (NSString *)stringFromTimeIntervalMilliseconds:(NSTimeInterval)intervalMilliseconds withDateFormat:(NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END
