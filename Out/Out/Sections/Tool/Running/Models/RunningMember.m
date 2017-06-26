//
//  RunningMembers.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningMember.h"

@implementation RunningMember
+ (NSString *)dbName {
    return @"Running";
}

+ (NSString *)tableName {
    return @"RunningMember";
}

+ (NSString *)primaryKey {
    return @"memberId";
}

+ (NSArray *)persistentProperties {
    static NSArray *propertis = nil;
    if (!propertis) {
        propertis = @[
                      @"memberId",
                      @"name",
                      @"exit",
                      @"suspend"
                      ];
    }
    return propertis;
}

+ (NSDictionary *)defaultValues {
    static  NSDictionary *defaultValues = nil;
    if (!defaultValues) {
        defaultValues = @{
                          @"exit" : @NO,
                          @"suspend": @NO
                          };
    }
    return defaultValues;
}
@end
