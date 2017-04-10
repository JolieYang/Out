//
//  RunningWeekManager.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningWeekManager.h"
#import "RunningWeek.h"

#define NSTimeStringFromJolie @"2017-04-03"
#define WeekInterval 7*24*60*60

@implementation RunningWeekManager
- (void)addWeekRecord:(RunningWeek *)record {
    [record save];
}

- (NSArray *)getWeekRecord {
    NSString *whereSql = @"";
    NSArray *arguments = @[];
    NSArray *recordsArray = [RunningWeek objectsWhere:whereSql arguments:arguments];
    if (recordsArray.count == 0) {
        // 没有记录，就创建第一条记录
        RunningWeek *record = [[RunningWeek alloc] init];
        record.weekId = recordsArray.count + 1;
        
        
    }
    return recordsArray;
}

#pragma mark Tool
// 获取当天所在周的第一天unix时间
+ (void)weekFirstDayUnix {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:now];
    NSInteger day = [dateComponents day];
    NSLog(@"day:%li", (long)day);
}

- (void)timeIntervalWithDateStr:(NSString *)dateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:@"yyyy-MM-dd"];
    
}
@end
