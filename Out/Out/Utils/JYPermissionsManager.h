//
//  JYPermissionsManager.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/13.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYPermissionsManager : NSObject
- (void)checkCameraAuthorizationStatusWithBlock:(void(^)(BOOL granted))block;
@end
