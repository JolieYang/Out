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
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    if (!reachabilityManager.reachable) {
        failedResponse(@"网络无法连接"); // 网络出问题了
        return;
    }
    [self downloadImageWithPhotoID:photoId completionHandler:successDownloadImageResponse];
}
+ (void)downloadImageWithPhotoID:(NSString *)photoId completionHandler:(DownloadImageResponse)imageResponse {
    NSLog(@"download Photoid:%@", photoId);
    // m1 31.4MB 33.7-34.1
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration: configuration];
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kPHOTO_URL, photoId];
//    NSURL *URL = [NSURL URLWithString:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        NSURL *documentDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        UIImage *image = [UIImage imageWithContentsOfFile:[filePath path]];
//        imageResponse(image);
//    }];
//    [downloadTask resume];
    
    // m2 31.1-9MB 35.4-8
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self loadImageWithPhotoID:photoId completionHandler:^(UIImage *image) {
            imageResponse(image);
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
@end
