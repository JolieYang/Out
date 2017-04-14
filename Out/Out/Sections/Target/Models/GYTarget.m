//
//  GYTargetList.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "GYTarget.h"

@implementation GYTarget
+ (NSString *)dbName {
    return @"Target";
}

+ (NSString *)tableName {
    return @"GYTarget";
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
                      @"fromUnix",
                      @"insistDays",
                      @"insistHours",
                      @"iconName"
                      ];
    }
    return propertis;
}
@end
