//
//  APIManager.h
//  Out
//
//  Created by Jolie on 2017/10/2.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

// Response
typedef void (^SuccessedResponse)(NSDictionary *response);
typedef void (^FailedResponse)(NSString *errMsg);

// photo
typedef void (^UploadImageResponse)(NSString *photoId);
typedef void (^DownloadImageResponse)(UIImage *image);

@interface APIManager : NSObject
+ (void)startRequestWithApiName:(NSString *)apiName params:(NSDictionary *)params successed:(SuccessedResponse)successResponse failed:(FailedResponse)failedResponse;
@end
