//
//  RunningWeekManager.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningWeekManager.h"

@implementation RunningWeekManager
- (void)addWeekrecord {
    
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
@end
