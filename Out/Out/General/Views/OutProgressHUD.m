//
//  OutProgressHUD.m
//  Out
//
//  Created by Jolie_Yang on 16/9/11.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "OutProgressHUD.h"

@implementation OutProgressHUD

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    OutProgressHUD *hud = [super showHUDAddedTo:view animated:animated];
    [self configHUD:hud];
    
    return hud;
}

+ (instancetype)showIndicatorHUDWithDetailString:(NSString *)detailString AddedTo:(UIView *)view animated:(BOOL)animated {
    OutProgressHUD *hud = [super showHUDAddedTo:view animated:animated];
    hud.detailsLabel.text = detailString;
    [self configHUD:hud];
    
    return hud;
}
// 定制Out's HUD
+ (void)configHUD:(OutProgressHUD *)hud {
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.layer.cornerRadius = 7;
    hud.bezelView.alpha = 0.7;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.contentColor = [UIColor whiteColor];
    hud.square = YES;
    hud.minShowTime = 1.0;
    // TODO 定制HUD's Size
}

@end
