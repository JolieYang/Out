//
//  OutProgressHUD.h
//  Out
//
//  Created by Jolie_Yang on 16/9/11.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "MBProgressHUD.h"

@interface OutProgressHUD : MBProgressHUD
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
+ (instancetype)showIndicatorHUDWithDetailString:(NSString *)detailString AddedTo:(UIView *)view animated:(BOOL)animated;
@end