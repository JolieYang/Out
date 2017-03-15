//
//  ScanResultViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "ScanResultViewController.h"

@interface ScanResultViewController ()
@property (nonatomic, strong) UITextView *resultTextView;
@end

@implementation ScanResultViewController
static CGFloat StatusBarHeight = 20;
static CGFloat NavigationHeight = 44;
static CGFloat TabBarHeight = 48;
static CGFloat FullScreenHeight;// 满屏高度

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
}

- (void)configView {
    // 判读是否存在导航栏
    if ([[self.navigationController visibleViewController] isKindOfClass:[self class]]) {
        FullScreenHeight = kAppHeight - NavigationHeight - StatusBarHeight;
    }
    // 判断是否存在 TabBar
    [self.tabBarController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc isKindOfClass:[self class]]) {
            FullScreenHeight -= TabBarHeight;
            return ;
        }
    }];
    
    self.title = @"扫描结果";
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    [self.view addSubview:backgroundView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = Apple_Silver;
    [backgroundView addSubview:scrollView];
    
    self.resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, FullScreenHeight)];
    self.resultTextView.editable = NO;
    self.resultTextView.font = [UIFont systemFontOfSize:16.0];
    self.resultTextView.text = self.resultString == nil ? @"扫描失败" : self.resultString;
    [scrollView addSubview:self.resultTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
