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
    NSArray *members = [RunningMemberManager getAllNotExitMembers];
    NSMutableArray *recordsArray = [NSMutableArray arrayWithCapacity:members.count];
    for (int i = 0; i < members.count; i++) {
        RunningMember *member = members[i];
        RunningRecord *newRecord = [self addRecordWithWeekId:weekId memberId:member.memberId memberName:member.name];
        if (member.suspend) {
            newRecord.remarks = @"暂停跑步";
            [newRecord save];
        }
        
        [recordsArray addObject:newRecord];
    }
    return recordsArray;
}

+ (RunningRecord *)addRecordWithWeekId:(NSInteger)weekId memberId:(NSInteger)memberId memberName:(NSString *)memberName {
    RunningRecord *newRecord = [[RunningRecord alloc] init];
    newRecord.memerId = memberId;
    newRecord.weekId = weekId;
    newRecord.memberName = memberName;
    newRecord.isAchieve = NO;
    
    [newRecord save];
    return newRecord;
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
