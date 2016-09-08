//
//  OutNetService.h
//  Out
//
//  Created by Jolie_Yang on 16/9/7.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SuccessedResponse)(NSDictionary *response);
typedef void (^FailedResponse)(NSString *errMsg);

@interface OutAPIRequest : NSObject
+ (void)startRequestWithApiName:(NSString *)apiName params:(NSDictionary *)params successed:(void (^)(NSDictionary *response))successResponse failed:(void (^)(NSString *errMsg))failedResponse;
+ (void)uploadImage:(UIImage *)image  succeed:(SuccessedResponse)successResponse failed:(FailedResponse)failedResponse;
@end