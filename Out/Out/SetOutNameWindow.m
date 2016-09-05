//
//  SetOutNameWindow.m
//  Out
//
//  Created by Jolie_Yang on 16/9/5.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "SetOutNameWindow.h"
#import "SetOutNameViewController.h"

@interface SetOutNameWindow()

@property (nonatomic, strong) UIWindow *window;

@end

@implementation SetOutNameWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (void)show {
    SetOutNameViewController *setOutNameVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetOutNameViewController"];
//    [self setRootViewController:setOutNameVC];
//    [self makeKeyWindow];
}

- (void)hide {
    [self resignKeyWindow];
}

@end
