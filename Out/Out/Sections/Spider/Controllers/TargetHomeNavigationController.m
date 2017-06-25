//
//  TargetHomeNavigationController.m
//  Spider
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetHomeNavigationController.h"
#import "TargetHomeViewController.h"

@interface TargetHomeNavigationController ()

@end

@implementation TargetHomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = @[[TargetHomeViewController new]];
    
    self.navigationBar.barTintColor = System_Nav_Black;
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = System_White;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: System_White}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
