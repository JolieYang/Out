//
//  GYTargetList.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <GYDataCenter/GYDataCenter.h>

@interface GYTarget : GYModelObject
@property (nonatomic, assign) NSInteger *targetId;
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, assign) NSTimeInterval fromUnix;
@property (nonatomic, assign) NSInteger insistDays;
@property (nonatomic, assign) float insistHours;// 保留到小数点后一位
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, assign) NSInteger status; // 项目状态
@property (nonatomic, strong) NSString *remarks;
@end
