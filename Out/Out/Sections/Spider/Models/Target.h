//
//  GYTargetList.h
//  Spider
//
//  Created by Jolie_Yang on 2017/4/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <GYDataCenter/GYDataCenter.h>

typedef NS_ENUM(NSInteger,TargetType) {
    TargetTypeProject = 0,
    TargetTypeLog = 1
};

@interface Target : GYModelObject
@property (nonatomic, assign) NSInteger targetId;
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, assign) NSTimeInterval createUnix;// 项目创建时间
@property (nonatomic, assign) NSTimeInterval fromUnix;// 项目开始时间
@property (nonatomic, assign) NSTimeInterval endUnix; // 项目结束时间
@property (nonatomic, assign) NSTimeInterval updateUnix;// 项目最近更新时间
@property (nonatomic, assign) NSInteger insistDays;
@property (nonatomic, assign) float insistHours;// 保留到小数点后一位
@property (nonatomic, assign) NSInteger status; // 项目状态 0尚未开始  1进行中 2暂停
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) UIImage *targetIcon;
@property (nonatomic, assign) TargetType targetType;
@end
