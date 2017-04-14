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
+ (Target *)addTargetRecordAndReturnTargetWithTarget:(Target *)target insistHours:(float)insistHours log:(NSString *)log {
    TargetRecord *record = [[TargetRecord alloc] init];
    record.targetId = target.targetId;
    record.addUnix = [DateHelper getCurrentTimeInterval];
    record.recordUnix = [DateHelper getCurrentTimeInterval];// ps: todo
    record.insistHours = insistHours;
    record.log = log;
    [record save];
    
    target.updateUnix= record.addUnix;
    target.insistHours += record.insistHours;
    if (![self existRecordOnTodayWithTargetId:target.targetId]) {
        target.insistDays += 1;
    }
    [target save];
    
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
@end
