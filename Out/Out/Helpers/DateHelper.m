//
//  DateHelper.m
//  Out
//
//  Created by Jolie_Yang on 16/9/7.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// 是否在非中文环境下不做日期的中式转换

#import "DateHelper.h"

@implementation DateHelper
+ (NSString *)customeDateStr:(NSString *)timeStr {
    NSString *customeStr = [timeStr substringToIndex:10];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:customeStr];
    if (!date) {
        return @""; // 不合法的时间字符
    }
    // 系统语言是否为中文
    if ([self Chinese]) {// 系统语言为中文
        customeStr = [self defaultChineseFromDate:date];
    } else {
        customeStr = [self customeChineseFromDate:date];
    }
    
    return customeStr;
}

#pragma mark 系统语言为中文
+ (NSString *)defaultChineseFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    // 年月日转汉字
    // 1. 年
    NSString *yearArabStr = [NSString stringWithFormat:@"%li", (long)year];
    NSString *yearStr = [self yearChineseFromArab:yearArabStr];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = kCFNumberFormatterRoundHalfDown;
    // 2. 月
    NSString *monthStr = [nf stringFromNumber:[NSNumber numberWithInteger:month]];
    // 3. 日
    NSString *dayStr = [nf stringFromNumber:[NSNumber numberWithInteger:day]];
    
    NSString *customeStr = [NSString stringWithFormat:@"%@年%@月%@日", yearStr, monthStr, dayStr];
    
    return customeStr;
}

+ (NSString *)chineseFromArab:(NSString *)arabStr {
    NSInteger arab = [arabStr integerValue];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = kCFNumberFormatterRoundHalfDown;
    return [nf stringFromNumber:[NSNumber numberWithInteger:arab]];
}
+ (NSString *)yearChineseFromArab:(NSString *)yearArabStr {
    NSString *yearChinese = @"";
    for (int i = 0; i < yearArabStr.length; i++) {
        NSString *arab = [yearArabStr substringWithRange:NSMakeRange(i, 1)];
        yearChinese = [yearChinese stringByAppendingFormat: @"%@", [self chineseFromArab:arab]];
    }
    return yearChinese;
}

#pragma mark 强制中式转换
+ (NSString *)customeChineseFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    // 年月日转汉字
    NSString *yearStr = [self customeYearChineseFromArab:[NSString stringWithFormat:@"%ld", (long)year]];
    NSString *monthStr = [self customChineseFromArab:[NSString stringWithFormat:@"%ld", (long)month]];
    NSString *dayStr = [self customChineseFromArab:[NSString stringWithFormat:@"%ld", (long)day]];
    
    NSString *customeStr = [NSString stringWithFormat:@"%@年%@月%@日", yearStr, monthStr, dayStr];
    
    return customeStr;
}

+ (NSString *)customeYearChineseFromArab:(NSString *)yearArabStr {
    NSString *yearChinese = @"";
    for (int i = 0; i < yearArabStr.length; i++) {
        NSString *arab = [yearArabStr substringWithRange:NSMakeRange(i, 1)];
        yearChinese = [yearChinese stringByAppendingFormat:@"%@", [self customChineseFromArab:arab]];
    }
    return yearChinese;
}

+ (NSString *)customChineseFromArab:(NSString *)arabStr {
    NSArray *arab_numbers = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_str = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"〇"];
    NSDictionary *transDict = [NSDictionary dictionaryWithObjects:chinese_str forKeys:arab_numbers];
    NSString *chineseStr = @"";
    if (arabStr.length == 1) {
        chineseStr = [transDict valueForKey:arabStr];
    } else {// 定制处理: 最大只需两位数
        NSString *firstStr = [arabStr substringWithRange:NSMakeRange(0, 1)];
        NSString *secondStr = [arabStr substringWithRange:NSMakeRange(1, 1)];
        if ([firstStr isEqualToString:@"1"]) {
            chineseStr = [NSString stringWithFormat:@"十%@", transDict[secondStr]];
        } else {
            chineseStr = [NSString stringWithFormat:@"%@十%@", transDict[firstStr], transDict[secondStr]];
        }
    }
    return chineseStr;
}
// todo : rslt:一十万〇三百〇五, two:十万〇三百〇五
+ (NSString *)chineseWithArabString:(NSString *)arabStr {
    NSArray *arab_numbers = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_strs = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"〇"];
    NSArray *digits = @[@"", @"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *tranDict = [NSDictionary dictionaryWithObjects:chinese_strs forKeys:arab_numbers];
    NSString *chineseStr = @"";
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < arabStr.length; i++) {
        NSString *subStr = [arabStr substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [tranDict objectForKey:subStr];
        NSString *b = digits[arabStr.length - i - 1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_strs[9]]) {
            if ([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_strs[9]]) {
                    [sums removeLastObject];
                }
            } else {
                sum = chinese_strs[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum]) {
                continue;
            }
        }
        [sums addObject:sum];
    }
    chineseStr = [sums componentsJoinedByString:@""];
    
    return chineseStr;
}

+ (BOOL)Chinese {
    NSString *language = [self getCurrentLanguage];
    // 简体或繁体
    if ([language compare:@"zh-Hans" options:NSCaseInsensitiveSearch] == NSOrderedSame || [language compare:@"zh-Hant" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)getCurrentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    return [languages firstObject];
}
@end
