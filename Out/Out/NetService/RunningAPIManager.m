//
//  RunningAPIManager.m
//  Out
//
//  Created by Jolie on 2017/10/2.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningAPIManager.h"
#import "RunningMemberManager.h"
#import "RunningWeekManager.h"
#import "RunningRecordManager.h"
#import "RunningMember.h"
#import "RunningWeek.h"
#import "RunningRecord.h"
#import "AFNetworking.h"
#import <YYModel/YYModel.h>

// ***
// {"object": "week", "records": Array}

@implementation RunningAPIManager
+ (void)uploadRequestForApiName:(NSString *)apiName params:(NSDictionary *)params successed:(SuccessedResponse)successResponse failed:(FailedResponse)failedResponse {
    [self startRequestWithMethod:@"POST" BaseUrl:Running_Base_URL ApiName:apiName params:params successed:successResponse failed:failedResponse];
}
+ (void)uploadMemeberList {
    NSArray *memberList = [RunningMemberManager getAllMembers];
    
    for (int i = 0; i < memberList.count; i++) {
        NSTimeInterval period = 1.0; //设置时间间隔
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            RunningMember *member = memberList[i];
            NSDictionary *params = (NSDictionary *)[member yy_modelToJSONObject];
            [self addMemberWithParams:params];
            
            dispatch_resume(_timer);
        });
    }
}

+ (void)addMemberWithParams:(NSDictionary *)parmas {
    [self uploadRequestForApiName:Running_Add_Member params:parmas successed:^(NSDictionary *response) {
        NSLog(@"success:%@", parmas);
    } failed:^(NSString *errMsg) {
        NSLog(@"failed");
    }];
}
+ (void)uploadRecordList {
    NSArray *recordsList = [RunningRecordManager getAllRecords];
    
//    for (int i = 0; i < recordsList.count; i++) {
//        NSTimeInterval period = 0.2; //设置时间间隔
//        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
//        
//        dispatch_source_set_event_handler(_timer, ^{
//            RunningWeek *record = recordsList[i];
//            NSDictionary *params = (NSDictionary *)[record yy_modelToJSONObject];
//            [self addRecordWithParams:params];
//            
//            dispatch_resume(_timer);
//            
//            if (i == recordsList.count - 1) {
//                dispatch_source_cancel(_timer);
//            }
//        });
//
//    }
//
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:NO];
    NSTimeInterval period = 1.2; //设置时间间隔
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    
    
    __block int tmp = 0;
    dispatch_source_set_event_handler(_timer, ^{
        int m = tmp * 10;
        int n = (tmp+1)*10 < recordsList.count ? (tmp+1) * 10 : recordsList.count;
        for (int i = m; i < n; i++) {
            RunningWeek *record = recordsList[i];
            NSDictionary *params = (NSDictionary *)[record yy_modelToJSONObject];
            [self addRecordWithParams:params];
            
            if (i == recordsList.count - 1) {
                dispatch_source_cancel(_timer);
            }
        }
        
        dispatch_resume(_timer);
    });
}
+ (void)addTenReocrdsWithParams:(NSArray *)recordsList from:(int)m to:(int)n {
    for (int i = m; i < n; i++) {
        RunningWeek *record = recordsList[i];
        NSDictionary *params = (NSDictionary *)[record yy_modelToJSONObject];
        [self addRecordWithParams:params];
    }
    
}
+ (void)addRecordWithParams:(NSDictionary *)params {
    [self uploadRequestForApiName:Running_Add_Record params:params successed:^(NSDictionary *response) {
        NSLog(@"success");
    } failed:^(NSString *errMsg) {
        NSLog(@"failed");
    }];
}

+ (void)uploadWeekList {
//    NSArray *weeksList = [RunningWeekManager getAllWeekRecords];
    
    // 批量上传
//    int tmp = 2;
//    int m = tmp * 10;
//    int n = weeksList.count;
//    for (int i = m; i < n; i++) {
//        RunningWeek *week = weeksList[i];
//        NSDictionary *params = (NSDictionary *)[week yy_modelToJSONObject];
//        [self addWeekWithParams:params];
//    }
//    NSTimeInterval period = 2; //设置时间间隔
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
//    
//    dispatch_source_set_event_handler(_timer, ^{
//        int tmp = 0;
//        int m = tmp * 10;
//        int n = (tmp+1) * 10;
//        for (int i = m; i < n; i++) {
//            RunningWeek *week = weeksList[i];
//            NSDictionary *params = (NSDictionary *)[week yy_modelToJSONObject];
//            [self addWeekWithParams:params];
//            
//            dispatch_resume(_timer);
//        }
//    });
    
}

+ (void)addWeekWithParams:(NSDictionary *)params {
    [self uploadRequestForApiName:Running_Add_Week params:params successed:^(NSDictionary *response) {
        NSLog(@"success222:%@", params);
    } failed:^(NSString *errMsg) {
        NSLog(@"failed tmp");
    }];
}

+ (NSMutableDictionary *)dataDictForObject:(NSString *)objectName data:(id)data {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:objectName forKey:@"object"];
    [dataDict setValue:data forKey:@"records"];
    
    return dataDict;
}
@end
