//
//  RunningRecordsModel.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunningRecordsModel : NSObject
@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, assign) BOOL isAchieve;
@property (nonatomic, assign) NSInteger contributionMoney;
@property (nonatomic, strong) NSString *remarks;
@end
