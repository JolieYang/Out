//
//  RunningMemberManager.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/11.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningMemberManager.h"
#import "RunningMember.h"

@implementation RunningMemberManager

+ (BOOL)addMemberWithName:(NSString *)name {
    NSArray *existMembers = [self getAllNotExitMembers];
    for (RunningMember *member in existMembers) {
        if ([member.name isEqualToString:name]) {
            if (member.exit == NO) {
                return NO;// 该成员已存在
            } else {
                member.exit = NO;
                [member save];
                return YES;
            }
        }
    }
    
    // 不存在该成员，则添加
    RunningMember *member = [RunningMember new];
    member.name = name;
    [member save];
    return YES;
}

+ (NSArray *)getAllNotExitMembers {
    NSString *whereSql = @"WHERE exit = ? ORDER BY memberId";
    BOOL exit = NO;
    NSArray *arguments = @[[NSNumber numberWithBool: exit]];
    NSArray *members = [RunningMember objectsWhere:whereSql arguments:arguments];
    if (members.count == 0) {
        members = [self addDefaultMembers];
    }
    return members;
}

+ (BOOL)exitMemberForId:(NSInteger)memberId {
    RunningMember *member = (RunningMember *)[RunningMember objectForId:[NSNumber numberWithInteger:memberId]];
    if (member == nil) {
        // 不存在该成员
        return NO;
    }
    if (member.exit == NO) {
        member.exit = YES;
        [member save];
    }
    
    return YES;
}

+ (NSArray *)addDefaultMembers {
   NSArray *defaultRunningMembers = @[@"孙宇翔", @"沈聪维", @"陈炜枫",@"陈明智",@"陈双",@"黄佳萍",@"杨巧伶",@"范本清",@"李旭东",@"苏忠伟",@"林思颖",@"叶金新",@"唐尧",@"曾佑杰",@"陈文静",@"刘文迪",@"赵赫",@"张波",@"林善统",@"池如海",@"王丽仙"];
    NSMutableArray *membersArray = [NSMutableArray arrayWithCapacity:defaultRunningMembers.count];
    for (int i = 0; i < defaultRunningMembers.count; i++) {
        RunningMember *member = [RunningMember new];
        member.name = defaultRunningMembers[i];
        [member save];
        [membersArray addObject:member];
    }
    return membersArray;
}
@end
