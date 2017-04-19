//
//  BaseNavigationController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor = System_Nav_Black;
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = System_Nav_White;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: System_Nav_White}];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
