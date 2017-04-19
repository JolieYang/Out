//
//  TargetRecordManager.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetRecordManager.h"
#import "TargetManager.h"
#import "DateHelper.h"
#import "TargetRecord.h"
#import "Target.h"

@implementation TargetRecordManager

+ (NSArray *)getLogRecordWithTargetId:(NSInteger)targetId {
    NSString *whereSql = @"WHERE log IS NOT NULL AND targetId = ? ORDER BY addUnix DESC";
    NSArray *arguments = @[[NSNumber numberWithInteger:targetId]];
    NSArray *records = [TargetRecord objectsWhere:whereSql arguments:arguments];
    return records;
}

+ (Target *)addTargetRecordAndReturnTargetWithTarget:(Target *)target insistHours:(float)insistHours log:(NSString *)log {
    target.updateUnix = [DateHelper getCurrentTimeInterval];
    target.insistHours += insistHours;
    if (![self existRecordOnTodayWithTargetId:target.targetId]) {
        target.insistDays += 1;
    }
    [target save];
    
    TargetRecord *record = [[TargetRecord alloc] init];
    record.targetId = target.targetId;
    record.addUnix = target.updateUnix;
    record.recordUnix = target.updateUnix;// ps: todo
    record.insistHours = insistHours;
    record.log = log;
    [record save];
    
    return target;
}

+ (BOOL)existRecordOnTodayWithTargetId:(NSInteger)targetId {
    NSTimeInterval todayInterval = [DateHelper getTodayTimeInterval];
    NSString *whereSql = @"WHERE recordUnix > ? AND recordUnix < ? AND targetId = ?";
    NSArray *arguments = @[[NSNumber numberWithFloat:todayInterval], [NSNumber numberWithFloat:todayInterval + DayInterval], [NSNumber numberWithInteger:targetId]];
    NSArray *record = [TargetRecord objectsWhere:whereSql arguments:arguments];
    if (record.count > 0) {
        return YES;
    } else {
        return NO;
    }
    
}

+ (void)deleteAllTargetRecord {
    NSString *whereSql = @"WHERE recordId > ?";
    NSArray *arguments = @[[NSNumber numberWithInt:0]];
    [Target deleteObjectsWhere:whereSql arguments:arguments];
}
@end
