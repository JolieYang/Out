//
//  StringLengthHelper.m
//  Out
//
//  Created by Jolie_Yang on 16/9/1.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper
// 计算字符长度，进行特殊处理：emoji 当作一个长度  ascii吗与数字 两个当做一个长度
+ (int)length:(NSString *)str {
    NSUInteger length = [str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    int len = (int)length;
    
    int blankCount = 0, asciiCount = 0, otherCount = 0;
    unichar c;
    for (int i = 0; i < len; i++) {
        c = [str characterAtIndex:i];
        if (isblank(c)) {
            blankCount++;
        } else if (isascii(c)) {
            asciiCount++;
        } else {
            otherCount++;
        }
    }
    len = (int)ceilf((float)(blankCount+asciiCount)/2.0) + otherCount;
    
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
@end
