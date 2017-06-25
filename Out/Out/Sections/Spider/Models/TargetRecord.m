//
//  TargetRecord.m
//  Spider
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetRecord.h"

@implementation TargetRecord
+ (NSString *)dbName {
    return @"TargetDB";
}

+ (NSString *)tableName {
    return NSStringFromClass([self class]);
}

+ (NSString *)primaryKey {
    return @"recordId";
}

+ (NSArray *)persistentProperties {
    static NSArray *propertis = nil;
    if (!propertis) {
        propertis = @[
                      @"recordId",
                      @"targetId",
                      @"addUnix",
                      @"recordUnix",
                      @"insistHours",
                      @"log"
                      ];
    }
    return propertis;
}
@end
