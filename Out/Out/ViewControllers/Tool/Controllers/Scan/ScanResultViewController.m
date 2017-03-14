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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫描结果";
    [self configView];
}

- (void)configView {
    self.resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, kAppWidth - 8*2, kAppHeight - 8*2)];
    self.resultTextView.text = self.resultString;
    [self.view addSubview:self.resultTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
