//
//  OutAlertViewController.h
//  Out
//
//  Created by Jolie_Yang on 16/9/2.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutAlertViewController : UIAlertController
+ (UIAlertController *)showWithTitle:(NSString *)title actionTitle:(NSString *)actionStr;
+ (UIAlertController * __nullable)nullOutName;// OutName为空
+ (UIAlertController * __nullable)spaceOutName;// 设置OutName时全为空格
+ (UIAlertController  * _Nullable)lenghtExceedLimit; // 字数超过限制弹窗
+ (UIAlertController *__nullable)giveUpEditWithOkHandler:(void (^ __nullable)(UIAlertAction *__nullable action))okHandler;// 是否要放弃编辑
@end
