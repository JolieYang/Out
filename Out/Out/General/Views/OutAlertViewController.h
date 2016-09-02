//
//  OutAlertViewController.h
//  Out
//
//  Created by Jolie_Yang on 16/9/2.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutAlertViewController : UIAlertController
+ (UIAlertController  * _Nullable)lenghtExceedLimit; // 字数超过限制弹窗
+ (UIAlertController *)giveUpEditWithOkHandler:(void (^ __nullable)(UIAlertAction *action))okHandler;// 是否要放弃编辑
@end
