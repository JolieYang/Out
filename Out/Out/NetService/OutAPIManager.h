//
//  OutNetService.h
//  Out
//
//  Created by Jolie_Yang on 16/9/7.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@interface OutAPIManager :APIManager
+ (void)startRequestWithApiName:(NSString *)apiName params:(NSDictionary *)params successed:(void (^)(NSDictionary *response))successResponse failed:(void (^)(NSString *errMsg))failedResponse;
+ (void)uploadImage:(UIImage *)image  succeed:(UploadImageResponse)successUploadImageResponse failed:(FailedResponse)failedResponse;
+ (void)downloadImageWithPhotoID:(NSString *)photoId succeed:(DownloadImageResponse)successDownloadImageResponse failed:(FailedResponse)failedResponse;
@end
