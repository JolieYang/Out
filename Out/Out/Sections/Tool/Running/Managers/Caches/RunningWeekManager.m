//
//  RunningWeekManager.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//
//  [todo] 事务处理 -- 11st,April,2017

#import "RunningWeekManager.h"
#import "RunningWeek.h"

#define NSTimeStringFromJolie @"2017-04-03"
#define SumContributionFromJolie 2640
#define WeekInterval 7*24*60*60 - 1

static NSTimeInterval timeIntervalFromJolie = 1491148800;

@implementation RunningWeekManager

+ (NSArray *)addWeekRecord {
    // 获取最新一条数据
    NSMutableArray *addedRecordArray = [NSMutableArray array];
    RunningWeek *lastRecord = [self getRecentWeekRecord];
    if (!lastRecord) {
        // 无记录，添加新纪录
        NSDateComponents *dateComponents = [self dateComponentsFromTimeInterval:timeIntervalFromJolie + WeekInterval/2];
        
        RunningWeek *newRecord = [[RunningWeek alloc] init];
        newRecord.fromUnix = timeIntervalFromJolie;
        newRecord.endUnix = timeIntervalFromJolie + WeekInterval;
        newRecord.month = dateComponents.month;
        newRecord.year = dateComponents.year;
        newRecord.weekOfMonth = 1;
        newRecord.preSumContribution = SumContributionFromJolie;
        newRecord.sumContribution = newRecord.preSumContribution + newRecord.weekContribution;
        [newRecord save];
        [addedRecordArray addObject:newRecord];
        lastRecord = newRecord;
    }
    
    NSTimeInterval currentTimeInterval = [self getCurrentTimeInterval];
    // 判断当前时间是否超过endUnix，超过才可添加新纪录
    while (lastRecord.endUnix < currentTimeInterval) {
        NSDateComponents *currentDateComponents = [self currentDateComponents];
        RunningWeek *newRecord = [[RunningWeek alloc] init];
        newRecord.fromUnix = lastRecord.endUnix + 1;
        newRecord.endUnix = newRecord.fromUnix + WeekInterval;
        newRecord.year = currentDateComponents.year;
        newRecord.month = currentDateComponents.month;
        newRecord.preSumContribution = lastRecord.sumContribution;
        newRecord.sumContribution = newRecord.preSumContribution + newRecord.weekContribution;
        if (currentDateComponents.month != lastRecord.month) {
            newRecord.weekOfMonth = 1;
        } else {
            newRecord.weekOfMonth = lastRecord.weekOfMonth + 1;
        }
        
        [newRecord save];
        [addedRecordArray addObject:newRecord];
        lastRecord = newRecord;
    }
    
    return addedRecordArray;
}

+ (void)updateData {
   
}

+ (RunningWeek *)getRecentWeekRecord {
    NSString *whereSql = @"ORDER BY weekId DESC LIMIT 1";
    NSArray *arguments = nil;
    NSArray *recordArray = [RunningWeek objectsWhere:whereSql arguments:arguments];
    if (recordArray.count == 1) {
        return recordArray[0];
    } else {
        return nil;
    }
}
// 限制一次只拉取最新的二十条记录
+ (NSArray *)getRecentTwentyWeekRecords {
    NSString *whereSql = @"WHERE weekId > 0 ORDER BY fromUnix DESC LIMIT 20";
    NSArray *arguments = @[];
    NSArray *recordsArray = [RunningWeek objectsWhere:whereSql arguments:arguments];
    
    return recordsArray;
}

+ (RunningWeek *)getWeekRecordWithWeekId:(NSInteger)weekId {
    RunningWeek *weekRecord = (RunningWeek *)[RunningWeek objectForId:[NSNumber numberWithInteger:weekId]];
    return weekRecord;
}

+ (RunningWeek *)updateContributionWithWeekId:(NSInteger)weekId weekContribution:(NSInteger)weekContribution {
    RunningWeek *weekRecord = [self getWeekRecordWithWeekId:weekId];
    weekRecord.weekContribution = weekContribution;
    if (weekId == 1) {
        weekRecord.preSumContribution = SumContributionFromJolie;
    }
    weekRecord.sumContribution = weekRecord.preSumContribution + weekRecord.weekContribution;
    [weekRecord save];
    
    NSString *whereSql = @"WHERE weekId > ?";
    NSArray *arguments = @[[NSNumber numberWithInteger:weekId]];
    NSArray *needToUpdateRecords = [RunningWeek objectsWhere:whereSql arguments:arguments];
    NSInteger preSumContribution = weekRecord.sumContribution;
    if (needToUpdateRecords.count > 0) {
        for (int i = 0; i < needToUpdateRecords.count; i++) {
            RunningWeek *nextWeekRecord = needToUpdateRecords[i];
            nextWeekRecord.preSumContribution = preSumContribution;
            nextWeekRecord.sumContribution = nextWeekRecord.preSumContribution + nextWeekRecord.weekContribution;
            preSumContribution = nextWeekRecord.sumContribution;
            [nextWeekRecord save];
        }
    }
    return weekRecord;
}

#pragma mark Date Tool
+ (NSDateComponents *)dateComponentsFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self customComponentsFromDate:date];
}

+ (NSDateComponents *)currentDateComponents {
    return [self customComponentsFromDate:[NSDate date]];
}

+ (NSDateComponents *)customComponentsFromDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth fromDate:date];
    return dateComponents;
}

+ (NSTimeInterval)getCurrentTimeInterval {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    return timeInterval;
}

+ (void)timeIntervalFromDateStr:(NSString *)dateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [df dateFromString:NSTimeStringFromJolie];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    NSLog(@"timeInterval:%f", timeInterval);
}

@end
