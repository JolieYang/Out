//
//  TargetHomeViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/1/5.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetHomeViewController.h"

@interface TargetHomeViewController ()
@property (weak, nonatomic) IBOutlet UIView *countDownBgView;
@property (weak, nonatomic) IBOutlet UILabel *countDownDayLB;
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
    self.navigationController.title = @"Target";
    
    self.countDownBgView.layer.cornerRadius = self.countDownBgView.frame.size.width/2;
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
