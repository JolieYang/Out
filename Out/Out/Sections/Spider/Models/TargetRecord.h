//
//  TargetRecord.h
//  Spider
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <GYDataCenter/GYDataCenter.h>

@interface TargetRecord : GYModelObject
@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, assign) NSInteger targetId;
@property (nonatomic, assign) NSTimeInterval addUnix;
@property (nonatomic, assign) NSTimeInterval recordUnix;
@property (nonatomic, assign) float insistHours;
@property (nonatomic, strong) NSString *log;
@end
