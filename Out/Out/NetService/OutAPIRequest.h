//
//  OutNetService.h
//  Out
//
//  Created by Jolie_Yang on 16/9/7.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutAPIRequest : NSObject
+ (void)startRequestWithApiName:(NSString *)apiName params:(NSDictionary *)params successed:(void (^)(NSDictionary *response))successResponse failed:(void (^)(NSString *errMsg))failedResponse;
@end
