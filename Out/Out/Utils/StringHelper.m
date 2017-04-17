//
//  StringLengthHelper.m
//  Out
//
//  Created by Jolie_Yang on 16/9/1.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper
// 计算字符长度，进行特殊处理：emoji 当作一个长度  ascii码与数字与空格 两个当做一个长度.英文标点符号2个为一个长度(不包括中文标点符号)
+ (NSInteger)length:(NSString *)str {
    NSInteger len = 0;
    NSInteger blankCount = 0, asciiCount = 0, otherCount = 0, emojiLength = 0;
    
    // emoji
    NSString *trimEmoji = [self stringByTrimmingEmoji:str];
    emojiLength = str.length - trimEmoji.length;
    NSInteger characterLength = trimEmoji.length;
    
    // ascii
    unichar c;
    for (int i = 0; i < characterLength; i++) {
        c = [trimEmoji characterAtIndex:i];
        if (isblank(c)) {// ? 空格时并没有判断出来
            blankCount++;
        } else if (isascii(c)) {
            asciiCount++;// 英文字母，数字以及英文标点符号和一些控制字符
        } else {
            otherCount++;
        }
    }
    
    // 空格无法计算出来，所以通过其他方式获取空格
    NSString *trimBlackStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];// ?去除空格失败
    NSArray *blankStrings = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    trimBlackStr = [blankStrings componentsJoinedByString:@""];
    blankCount = (int)(str.length - trimBlackStr.length);
    otherCount = otherCount - blankCount;
    
    len = ceilf((float)(blankCount+asciiCount+emojiLength)/2.0) + otherCount;
    
    return len;
}
+ (BOOL)isEmpty:(NSString *)string {
    return (![string isKindOfClass:[NSString class]]) || ([StringHelper trim: string].length <= 0);
}
+ (NSString *)trim:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+ (NSString *)stripSpace:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}
+ (NSString *)stringByTrimmingEmoji:(NSString *)string {
    __block NSString *trimEmoji = @"";
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                } else {
                    trimEmoji = [trimEmoji stringByAppendingString:substring];
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            } else {
                trimEmoji = [trimEmoji stringByAppendingString:substring];
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            } else {
                trimEmoji = [trimEmoji stringByAppendingString:substring];
            }
        }
    }];
    return trimEmoji;
}
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    NSString *trimEmoji = [self stringByTrimmingEmoji:string];
    if (trimEmoji.length == string.length) {
        return NO;
    } else {
        return YES;
    }
}
@end
