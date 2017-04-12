//
//  OutProgressHUD.h
//  Out
//
//  Created by Jolie_Yang on 16/9/11.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "MBProgressHUD.h"

@interface JYProgressHUD : MBProgressHUD
+ (void)changeToTextHUDWithDetailString:(NSString *)string AddedTo:(UIView *)view; // 已显示HUD再改为显示textHUD
+ (instancetype)showTextHUDWithDetailString:(NSString *)string AddedTo:(UIView *)view; // text,1s后会消失
+ (instancetype)showLongerTextHUDWithString:(NSString *)string AddedTo:(UIView *)view;
+ (instancetype)showIndicatorHUDWithDetailString:(NSString *)detailString AddedTo:(UIView *)view animated:(BOOL)animated;
@end
