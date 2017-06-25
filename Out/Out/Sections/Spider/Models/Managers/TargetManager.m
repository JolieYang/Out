//
//  TargetManager.m
//  Spider
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetManager.h"
#import "Target.h"
#import "DateHelper.h"

@implementation TargetManager
#pragma makr - C
+ (void)addOrModifyTarget:(Target *)target {
    [target save];
}

+ (Target *)addTargetWithTargetName:(NSString *)targetName createUnix:(NSTimeInterval)createUnix {
    Target *target = [[Target alloc] init];
    target.targetName = targetName;
    target.createUnix = createUnix;
    target.updateUnix = createUnix;
    [target save];
    
    return target;
}

#pragma mark G
+ (NSArray *)getTargetList {
    NSString *whereSql = @"ORDER BY updateUnix DESC";
    NSArray *arguments = nil;
    NSArray *targetList = [Target objectsWhere:whereSql arguments:arguments];
    return targetList;
}

+ (Target *)getTargetWithTargetId:(NSInteger)targetId {
    NSString *whereSql = @"WHERE targetId = ?";
    NSArray *arguments = @[[NSNumber numberWithInteger:targetId]];
    NSArray *records = [Target objectsWhere:whereSql arguments:arguments];
    if (records.count < 1) {
        return nil;
    }
    return records[0];
}


#pragma mark -- U

#pragma mark -- D
+ (void)deleteTarget:(Target *)target {
    [target deleteObject];
}

+ (void)deleteTargetWithTargetId:(NSInteger)targetId {
    NSString *whereSQl = @"Where targetId = ?";
    NSArray *arguments = @[[NSNumber numberWithInteger:targetId]];
    
    [Target deleteObjectsWhere:whereSQl arguments:arguments];
}
+ (void)deleteAllTargets {
    NSString *whereSql = @"WHERE targetId > ?";
    NSArray *arguments = @[[NSNumber numberWithInt:0]];
    [Target deleteObjectsWhere:whereSql arguments:arguments];
}

@end
