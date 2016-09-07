//
//  OutNetService.m
//  Out
//
//  Created by Jolie_Yang on 16/9/7.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "OutAPIRequest.h"
#import "const.h"
#import "AFNetworking.h"

typedef void (^SuccessedResponse)(NSDictionary *response);
typedef void (^FailedResponse)(NSString *errMsg);

@interface OutAPIRequest()<NSURLSessionDelegate>
@property (nonatomic, strong) SuccessedResponse successResponse;
@property (nonatomic, strong) FailedResponse failedResponse;
@end
@implementation OutAPIRequest
+ (void)startRequestWithApiName:(NSString *)apiName params:(NSDictionary *)params successed:(void (^)(NSDictionary *response))successResponse failed:(void (^)(NSString *errMsg))failedResponse {
    NSError *error;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kSERVER_URL, apiName];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failedResponse(error.localizedDescription);
        }
        NSError *jsonError;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSString *status = [dataDict objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
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
