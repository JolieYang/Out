//
//  OutProgressHUD.m
//  Out
//
//  Created by Jolie_Yang on 16/9/11.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "OutProgressHUD.h"

@implementation OutProgressHUD


+ (instancetype)showIndicatorHUDWithDetailString:(NSString *)detailString AddedTo:(UIView *)view animated:(BOOL)animated {
    OutProgressHUD *hud = [super showHUDAddedTo:view animated:animated];
    hud.detailsLabel.text = detailString;
    [self configIndicatorHUD:hud];
    
    return hud;
}

+ (instancetype)showTextHUDWithDetailString:(NSString *)string AddedTo:(UIView *)view {
    OutProgressHUD *hud = [super showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = string;
    [self configTextHUD:hud];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [super hideHUDForView:view animated:YES];
    });
    
    return hud;
}
// 定制Out's HUD
+ (void)configIndicatorHUD:(OutProgressHUD *)hud {
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minShowTime = 1.0;
    hud.margin = 10.0;// default is '20.0'
    hud.bezelView.layer.cornerRadius = 7;
    hud.square = YES;
    [self configDarkHUD:hud];
}
+ (void)configTextHUD:(OutProgressHUD *)hud {
    hud.mode = MBProgressHUDModeText;
    hud.margin = 14.0;
    hud.detailsLabel.font = [UIFont fontWithName:@"Thonburi" size:14.0];
    [self configDarkHUD:hud];
}

+ (void)configDarkHUD:(OutProgressHUD *)hud {
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.alpha = 0.7;
    hud.contentColor = [UIColor whiteColor];
}

@end
