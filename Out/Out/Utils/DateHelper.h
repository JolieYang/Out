//
//  DateHelper.h
//  Out
//
//  Created by Jolie_Yang on 16/9/7.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DayInterval 24*60*60

@interface DateHelper : NSObject
// Base
+ (NSTimeInterval)getCurrentTimeInterval;
+ (NSTimeInterval)getTodayTimeInterval;
+ (NSTimeInterval)timeIntervalFromDateStr:(NSString *)dateString dateFormat:(NSString *)dateFormat;
+ (NSString *)dateStringFromTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormat;

+ (NSDateComponents *)dateComponentsFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSDateComponents *)currentDateComponents;
// 汉化
+ (NSString *)customeDateStr:(NSString *)timeStr;

+ (NSString *)chineseWithArabString:(NSString *)arabStr;
+ (NSString *)chineseFromArab:(NSString *)arabStr; // 根据系统语言
@end
