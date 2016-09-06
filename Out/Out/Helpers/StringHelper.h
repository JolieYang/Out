//
//  StringLengthHelper.h
//  Out
//
//  Created by Jolie_Yang on 16/9/1.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringHelper : NSObject
+ (int)length:(NSString *)str;
+ (BOOL)isEmpty:(NSString *)str; // 判空
+ (NSString *)trim:(NSString *)string; // 去除首尾空格
+ (NSString *)stripSpace:(NSString *)string; // 去除包含的空格
@end
