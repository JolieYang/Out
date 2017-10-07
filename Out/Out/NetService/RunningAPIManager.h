//
//  RunningAPIManager.h
//  Out
//
//  Created by Jolie on 2017/10/2.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"

@interface RunningAPIManager :APIManager
//+ (NSDictionary *)getMemberList;
//+ (NSDictionary *)getRecordList;
//+ (NSDictionary *)getWeekList;

+ (void)uploadMemeberList;
+ (void)uploadRecordList;
+ (void)uploadWeekList;
@end
