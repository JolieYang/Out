//
//  RunningWeek.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningWeek.h"

@implementation RunningWeek
+ (NSString *)dbName {
    return @"Running";
}

+ (NSString *)tableName {
    return @"RunningWeek";
}

+ (NSString *)primaryKey {
    return @"weekId";
}

+ (NSArray *)persistentProperties {
    static NSArray *propertis = nil;
    if (!propertis) {
        propertis = @[
                      @"weekId",
                      @"fromUnix",
                      @"endUnix",
                      @"year",
                      @"month",
                      @"weekOfMonth",
                      @"preSumContribution",
                      @"weekContribution",
                      @"sumContribution"
                      ];
    }
    return propertis;
}
@end
