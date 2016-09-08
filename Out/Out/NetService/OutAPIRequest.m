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

+ (void)uploadImage:(UIImage *)image  succeed:(SuccessedResponse)successResponse failed:(FailedResponse)failedResponse {
    NSString *urlString = [NSString stringWithFormat:@"%@photo", kSERVER_URL];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 获取图片的大小，根据大小进行不同等级的压缩
        // 压缩图片
        NSData *data = UIImageJPEGRepresentation(image, 0.3);
        [formData appendPartWithFileData:data name:kPHOTO_NAME fileName:@"default.jpg" mimeType:@"image/jpeg"];
    } error: nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新进度条
        });
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failedResponse(error.localizedDescription);
        }
        NSString *status = [responseObject valueForKey:@"status"];
        if ([status isEqualToString:@"succeed"]) {
            successResponse(responseObject);
        } else {
            NSString *message = [responseObject objectForKey:@"message"];
            failedResponse(message);
        }
    }];
    [uploadTask resume];
}
@end
