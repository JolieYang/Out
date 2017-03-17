//
//  KeyedArchiverHelper.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/17.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "KeyedArchiverHelper.h"
#import "BaseKeyedArchiverModel.h"
#import <objc/runtime.h>

@implementation KeyedArchiverHelper

+ (BOOL)addObject:(NSObject *)dataObject {
    return [self addObject:dataObject archiverPathComponent:[self getDefaultArchiverPath]];
}

+ (BOOL)addObject:(NSObject *)dataObject archiverPathComponent:(NSString *)path {
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableDictionary *dict = [KeyedArchiverHelper dictionaryFromModel:dataObject];
    NSMutableDictionary *existDataDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSMutableArray *existDataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (existDataArray.count == 0) {
        [dataArray addObject:dataObject];
    }
    // 向已有文件添加数据
    
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:dataArray toFile:path];
    return isSuccess;
}

#pragma mark Tool
+ (NSMutableDictionary *)dictionaryFromModel:(NSObject *)model {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key =  [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [model valueForKey:key];
        if (key && value) {
            [dict setObject:value forKey:key];
        }
    }
    free(properties);
    return dict;
}
+ (NSString *)getDefaultArchiverPath {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"default.archieve"];
    return path;
}
@end
