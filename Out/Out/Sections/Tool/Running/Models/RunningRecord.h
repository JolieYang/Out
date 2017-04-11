//
//  RunningRecordsModel.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDataCenter.h"

@interface RunningRecord :GYModelObject
@property (nonatomic, assign ) NSInteger recordId;
@property (nonatomic, assign) NSInteger memerId;
@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, assign) BOOL isAchieve;
@property (nonatomic, assign) NSInteger contributionMoney;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, assign) NSInteger weekId;
@end
