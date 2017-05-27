//
//  OutProgressHUD.h
//  Out
//
//  Created by Jolie_Yang on 16/9/11.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "MBProgressHUD.h"

typedef void(^JYProgressHUDCompletion)();

@interface JYProgressHUD : MBProgressHUD
+ (instancetype)showTextHUDWithDetailString:(NSString *)string AddedTo:(UIView *)view;
+ (void)changeToTextHUDWithDetailString:(NSString *)string AddedTo:(UIView *)view completion:(JYProgressHUDCompletion)completion;

+ (instancetype)showQuicklyTextHUDWithDetailContent:(NSString *)content AddedTo:(UIView *)view completion:(JYProgressHUDCompletion)completion; // text,1s后会消失
+ (instancetype)showNormalTextHUDWithDetailContent:(NSString *)content AddedTo:(UIView *)view completion:(JYProgressHUDCompletion)completion; // text,1s后会消失
+ (instancetype)showLongerTextHUDWithContent:(NSString *)content AddedTo:(UIView *)view completion:(JYProgressHUDCompletion)completion;

+ (instancetype)showIndicatorHUDWithDetailString:(NSString *)detailString AddedTo:(UIView *)view animated:(BOOL)animated;
@end
