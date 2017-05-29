//
//  OutMood.m
//  Out
//
//  Created by Jolie on 2017/5/27.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "OutMood.h"

@implementation OutMood
+ (NSString *)dbName {
    return @"OutDB";
}

+ (NSString *)tableName {
    return @"OutMood";
}

+ (NSString *)primaryKey {
    return @"moodId";
}

+ (NSArray *)persistentProperties {
    static NSArray *properties = nil;
    if (!properties) {
        properties = @[
                       @"moodId",
                       @"content",
                       @"createTime",
                       @"backgroundImage"
                       ];
    }
    
    return properties;
}
@end
