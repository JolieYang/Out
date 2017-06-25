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
@property (nonatomic, assign) NSTimeInterval fromUnix;// 一周第一天的unix时间
@property (nonatomic, assign) NSTimeInterval endUnix;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger weekOfMonth;// 第几周，原生的不是很符合需求
@property (nonatomic, assign) NSInteger preSumContribution;// 上期经费
@property (nonatomic, assign) NSInteger weekContribution;// 当期经费
@property (nonatomic, assign) NSInteger sumContribution;// 累计经费
@property (nonatomic, assign) BOOL isParty;
@property (nonatomic, assign) NSInteger partyCost;
@end
