//
//  GYTargetList.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <GYDataCenter/GYDataCenter.h>

@interface Target : GYModelObject
@property (nonatomic, assign) NSInteger targetId;
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, assign) NSTimeInterval createUnix;// 项目创建时间
@property (nonatomic, assign) NSTimeInterval fromUnix;// 项目开始时间
@property (nonatomic, assign) NSTimeInterval endUnix; // 项目结束时间
@property (nonatomic, assign) NSTimeInterval updateUnix;// 项目最近更新时间
@property (nonatomic, assign) NSInteger insistDays;
@property (nonatomic, assign) float insistHours;// 保留到小数点后一位
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, assign) NSInteger status; // 项目状态 0尚未开始  1进行中 2暂停
@property (nonatomic, strong) NSString *remarks;
@end
