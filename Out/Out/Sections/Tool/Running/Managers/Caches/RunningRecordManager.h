//
//  RunningRecordManager.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/11.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunningRecordManager : NSObject
+ (NSArray *)addAllMembersRecordWithWeekId:(NSInteger)weekId;
+ (NSArray *)getRecordsWithWeekId:(NSInteger)weekId;
+ (void)updateRecordWithPrimaryId:(NSInteger)recordId set:(NSDictionary *)set;
@end
