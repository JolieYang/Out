//
//  RunningRecordManager.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/11.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningRecordManager.h"
#import "RunningMember.h"
#import "RunningMemberManager.h"
#import "RunningRecord.h"
#import "GYDataCenter.h"

@implementation RunningRecordManager
+ (NSArray *)addAllMembersRecordWithWeekId:(NSInteger)weekId {
    NSArray *members = [RunningMemberManager getAllMembers];
    NSMutableArray *recordsArray = [NSMutableArray arrayWithCapacity:members.count];
    for (int i = 0; i < members.count; i++) {
        RunningMember *member = members[i];
        RunningRecord *newRecord = [[RunningRecord alloc] init];
        newRecord.memerId = member.memberId;
        newRecord.memberName = member.name;
        newRecord.isAchieve = NO;
        newRecord.weekId = weekId;
        [newRecord save];
        [recordsArray addObject:newRecord];
    }
    return recordsArray;
}

+ (NSArray *)getRecordsWithWeekId:(NSInteger)weekId {
    // 获取指定weekId的所有记录
    NSString *whereSql = @"WHERE weekId = ?";
    NSArray *arguments = @[[NSNumber numberWithInteger:weekId]];
    NSArray *records = [RunningRecord objectsWhere:whereSql arguments:arguments];
    if (!records) {
        // 批量添加所有成员指定week的记录
        records = [self addAllMembersRecordWithWeekId:weekId];
    }
    return records;
}

+ (void)updateRecordWithPrimaryId:(NSInteger)recordId set:(NSDictionary *)set {
    [[GYDataContext sharedInstance] updateObject:[RunningRecord class] set:set primaryKey:[NSNumber numberWithInteger:recordId]];
}

@end
