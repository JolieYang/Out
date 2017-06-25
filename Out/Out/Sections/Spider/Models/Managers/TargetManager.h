//
//  TargetManager.h
//  Spider
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Target;

@interface TargetManager : NSObject

+ (void)addOrModifyTarget:(Target *)target;
+ (Target *)addTargetWithTargetName:(NSString *)targetName createUnix:(NSTimeInterval)createUnix;

+ (NSArray *)getTargetList;
+ (Target *)getTargetWithTargetId:(NSInteger)targetId;

+ (void)deleteTarget:(Target *)target;
+ (void)deleteTargetWithTargetId:(NSInteger)targetId;
+ (void)deleteAllTargets;

@end
