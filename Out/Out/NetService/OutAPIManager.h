//
//  OutNetService.h
//  Out
//
//  Created by Jolie_Yang on 16/9/7.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SuccessedResponse)(NSDictionary *response);
typedef void (^FailedResponse)(NSString *errMsg);

// photo
typedef void (^UploadImageResponse)(NSString *photoId);
typedef void (^DownloadImageResponse)(UIImage *image);


@interface OutAPIManager : NSObject
+ (void)startRequestWithApiName:(NSString *)apiName params:(NSDictionary *)params successed:(void (^)(NSDictionary *response))successResponse failed:(void (^)(NSString *errMsg))failedResponse;
+ (void)uploadImage:(UIImage *)image  succeed:(UploadImageResponse)successUploadImageResponse failed:(FailedResponse)failedResponse;
+ (void)downloadImageWithPhotoID:(NSString *)photoId completionHandler:(DownloadImageResponse)imageResponse;
@end