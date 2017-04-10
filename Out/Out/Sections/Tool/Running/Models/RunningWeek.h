//
//  RunningWeek.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <GYDataCenter/GYDataCenter.h>

@interface RunningWeek : GYModelObject
@property (nonatomic, assign) NSInteger weekId;
@property (nonatomic, strong) NSDate *fromDate;// yyyy-MM-dd
@property (nonatomic, strong) NSDate *endDate;// yyyy-MM-dd
@property (nonatomic, assign) NSInteger weekOrder;// 第几周
@property (nonatomic, assign) NSInteger unix;// 一周第一天的unix时间
@end
