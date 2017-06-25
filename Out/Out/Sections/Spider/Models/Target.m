//
//  GYTargetList.m
//  Spider
//
//  Created by Jolie_Yang on 2017/4/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "Target.h"

@implementation Target
+ (NSString *)dbName {
    return @"TargetDB";
}

+ (NSString *)tableName {
    return @"Target";
}

+ (NSString *)primaryKey {
    return @"targetId";
}
+ (NSArray *)persistentProperties {
    static NSArray *propertis = nil;
    if (!propertis) {
        propertis = @[
                      @"targetId",
                      @"targetName",
                      @"createUnix",
                      @"fromUnix",
                      @"endUnix",
                      @"updateUnix",
                      @"insistDays",
                      @"insistHours",
                      @"status",
                      @"remarks",
                      @"targetIcon",
                      @"targetType"
                      ];
    }
    return propertis;
}

+ (NSDictionary *)defaultValues {
    static NSDictionary *values = nil;
    if (!values) {
        values = @{
                   @"targetType" : [NSNumber numberWithInteger:TargetTypeProject]
                   };
    }
    
    return values;
}
@end
