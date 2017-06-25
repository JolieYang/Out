//
//  JYAlertControllerManager.m
//  Spider
//
//  Created by Jolie_Yang on 16/9/2.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// Conclusion:
// 1. UIAlertController:addAction 1) 根据Style： 0-2 从右到左排列 2) 相同style: 按添加顺序从左到右排列。


#import "JYAlertControllerManager.h"

@interface JYAlertControllerManager ()

@end

@implementation JYAlertControllerManager

+ (UIAlertController *)showWithTitle:(NSString *)title actionTitle:(NSString *)actionStr {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:actionStr style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    return alertController;
}

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title
                                        message:(NSString *)message
                                        okTitle:(NSString *)okTitle
                                      okHandler:(void (^__nullable)(UIAlertAction * _Nonnull action))okHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler: okHandler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    return alertController;
}
@end
