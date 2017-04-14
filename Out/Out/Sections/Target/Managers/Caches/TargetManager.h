//
//  TargetManager.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Target;

@interface TargetManager : NSObject
+ (void)addTarget:(Target *)target;
+ (Target *)addTargetWithTargetName:(NSString *)targetName createUnix:(NSTimeInterval)createUnix;

+ (NSArray *)getTargetList;
+ (Target *)getTargetWithTargetId:(NSInteger)targetId;


@end
