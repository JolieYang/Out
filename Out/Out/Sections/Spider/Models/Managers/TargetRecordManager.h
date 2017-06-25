//
//  TargetRecordManager.h
//  Spider
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <GYDataCenter/GYDataCenter.h>
@class Target;

@interface TargetRecordManager : GYModelObject
+ (NSArray *)getLogRecordWithTargetId:(NSInteger)targetId;
// 添加纪录并返回更新后的项目信息
+ (Target *)addTargetRecordAndReturnTargetWithTarget:(Target *)target insistHours:(float)insistHours log:(NSString *)log;
+ (void)deleteAllTargetRecord;
@end
