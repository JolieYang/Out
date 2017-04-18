//
//  RunningWeekManager.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RunningWeek;

@interface RunningWeekManager : NSObject
+ (NSArray *)addWeekRecord;// 返回添加的记录
+ (NSArray *)getRecentTwentyWeekRecords;
+ (RunningWeek *)updateContributionWithWeekId:(NSInteger)weekId weekContribution:(NSInteger)weekContribution;


@end
