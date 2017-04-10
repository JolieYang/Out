//
//  RunningRecordsModel.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningRecord.h"

@implementation RunningRecord
+ (NSString *)dbName {
    return @"Running";
}

+ (NSString *)tableName {
    return @"RunningRecord";
}

+ (NSString *)primaryKey {
    return @"recordId";
}

+ (NSArray *)persistentProperties {
    static NSArray *propertis = nil;
    if (!propertis) {
        propertis = @[
                      @"recordId",
                      @"memerId",
                      @"memberName",
                      @"isAchieve"
                      @"contributionMoney",
                      @"remarks",
                      @"weeksId",
                      ];
    }
    return propertis;
}
@end
