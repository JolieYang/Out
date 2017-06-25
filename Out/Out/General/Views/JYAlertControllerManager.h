//
//  JYAlertControllerManager.h
//  Spider
//
//  Created by Jolie_Yang on 16/9/2.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYAlertControllerManager : NSObject
+ (nullable UIAlertController *)showWithTitle:(nullable NSString *)title actionTitle:(nullable NSString *)actionStr;

+ (nullable UIAlertController *)alertControllerWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                                        okTitle:(nullable NSString *)okTitle
                                      okHandler:(void (^ __nullable)(UIAlertAction * _Nonnull action))okHandler;
@end
