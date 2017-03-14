//
//  HomeNavigationController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "ToolHomeNavigationController.h"
#import "ToolHomeViewController.h"

@interface ToolHomeNavigationController ()

@end

@implementation ToolHomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = @[[ToolHomeViewController new]];
    self.navigationBar.barTintColor = System_Black;
    self.navigationBar.tintColor = System_White;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: System_White}];
    self.tabBarItem.title = @"Tool";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
