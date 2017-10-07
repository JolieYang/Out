//
//  APIManager.m
//  Out
//
//  Created by Jolie on 2017/10/2.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"

@implementation APIManager

+ (void)startRequestWithMethod:(NSString *)method BaseUrl:(NSString *)baseUrl ApiName:(NSString *)apiName params:(NSDictionary *)params successed:(SuccessedResponse)successResponse failed:(FailedResponse)failedResponse {
    NSLog(@"send:%@", params);
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (!manager.reachable) {
        failedResponse(@"网络无法连接"); // 网络出问题了
        return;
    }
    NSError *error;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseUrl, apiName];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:urlString parameters:params error:&error];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 7.0;
    configuration.timeoutIntervalForResource = 7.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"failed id111:%@", error.localizedDescription);
            failedResponse(error.localizedDescription);
            return ;
        }
        NSError *jsonError;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"receive:%@", dataDict);
        NSString *status = [dataDict objectForKey:@"status"];
        if ([status isEqualToString:SUCCESS_STATUS]) {
            NSDictionary *response = [dataDict objectForKey:@"data"];
            successResponse(response);
        } else {
            NSString *message = [dataDict objectForKey:@"message"];
            failedResponse(message);
        }
        
    }];
    
    [dataTask resume];
}
@end
