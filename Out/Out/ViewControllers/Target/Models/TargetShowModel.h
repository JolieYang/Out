//
//  TargetShowModel.h
//  Out
//
//  Created by Jolie_Yang on 2017/3/17.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetShowModel : NSObject
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *insistDays;
@property (nonatomic, copy) NSString *insistHours;
@property (nonatomic, copy) NSString *targetName;
@property (nonatomic, strong) NSString *iconName;
@end
