//
//  RunningMemberManager.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/11.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunningMemberManager : NSObject
+ (BOOL)addMemberWithName:(NSString *)name;
+ (NSArray *)getAllMembers;
@end
