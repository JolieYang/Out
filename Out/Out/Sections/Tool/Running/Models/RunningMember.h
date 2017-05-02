//
//  RunningMembers.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <GYDataCenter/GYDataCenter.h>

@interface RunningMember : GYModelObject
@property (nonatomic, assign) NSInteger memberId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL exit;
@end
