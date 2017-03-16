//
//  TargetHomeViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/1/5.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetHomeViewController.h"
#import "TargetAddViewController.h"

@interface TargetHomeViewController ()
@end

@implementation TargetHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Target";
    [self setupNavigationItem];
}
- (void)setupNavigationItem {
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage: Default_Image style:UIBarButtonItemStylePlain target:self action:@selector(addItemAction)];
    self.navigationItem.rightBarButtonItem = addItem;
}

// 添加项目
- (void)addItemAction {
    [self jumpToTargetAddVC];
}

- (void)jumpToTargetAddVC {
    TargetAddViewController *vc = [TargetAddViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
