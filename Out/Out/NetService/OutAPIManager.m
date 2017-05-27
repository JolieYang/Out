//
//  OutNetService.m
//  Out
//
//  Created by Jolie_Yang on 16/9/7.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "OutAPIManager.h"
#import "const.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface OutAPIManager()<NSURLSessionDelegate>
@property (nonatomic, strong) SuccessedResponse successResponse;
@property (nonatomic, strong) FailedResponse failedResponse;
@end
@implementation OutAPIManager
+ (void)startRequestWithApiName:(NSString *)apiName params:(NSDictionary *)params successed:(void (^)(NSDictionary *response))successResponse failed:(void (^)(NSString *errMsg))failedResponse {
    NSLog(@"send:%@", params);
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (!manager.reachable) {
        failedResponse(@"网络无法连接"); // 网络出问题了
        return;
    }
    NSError *error;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kSERVER_URL, apiName];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 7.0;
    configuration.timeoutIntervalForResource = 7.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"failed:%@", error.localizedDescription);
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

+ (void)uploadImage:(UIImage *)image  succeed:(UploadImageResponse)successUploadImageResponse failed:(FailedResponse)failedResponse {
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    if (!reachabilityManager.reachable) {
        failedResponse(@"网络无法连接"); // 网络出问题了
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@photo", kSERVER_URL];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 获取图片的大小，根据大小进行不同等级的压缩
        // 压缩图片
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        NSString *photoName = [self photoName];
        NSLog(@"photoName:%@", photoName);
        [formData appendPartWithFileData:data name:kPHOTO_NAME fileName:photoName mimeType:@"image/jpeg"];
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
        if ([status isEqualToString:SUCCESS_STATUS]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *photoId = [data valueForKey:@"photoId"];
            NSLog(@"receive photoId:%@", photoId);
            successUploadImageResponse(photoId);
        } else {
            NSString *message = [responseObject objectForKey:@"message"];
            failedResponse(message);
        }
    }];
    [uploadTask resume];
}
+ (void)downloadImageWithPhotoID:(NSString *)photoId succeed:(DownloadImageResponse)successDownloadImageResponse failed:(FailedResponse)failedResponse {
    NSLog(@"download Photoid:%@", photoId);
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    if (!reachabilityManager.reachable) {
        failedResponse(@"网络无法连接"); // 网络出问题了
        return;
    }
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self loadImageWithPhotoID:photoId completionHandler:^(UIImage *image) {
            if (image) {
                successDownloadImageResponse(image);
            } else {
                failedResponse(@"图片ID错误");
            }
        }];
    });
}

+ (void)loadImageWithPhotoID:(NSString *)photoId completionHandler:(DownloadImageResponse)imageResponse {
    NSData *imageData = [self requestImageDataWithPhotoID:photoId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageWithData:imageData];
        imageResponse(image);
    });
}
+ (NSData *)requestImageDataWithPhotoID:(NSString *)photoID {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kPHOTO_URL, photoID];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:URL];
    return imageData;
}
#pragma mark Tool
+ (NSString *)photoName {
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HHmmss"];
    NSString *photoName = [[df stringFromDate:date] stringByAppendingString:@".jpg"];
    return photoName;
}
@end
