//
//  OutAlertViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/9/2.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// Conclusion:
// 1. UIAlertController:addAction 1) 根据Style： 0-2 从右到左排列 2) 相同style: 按添加顺序从左到右排列。


#import "OutAlertViewController.h"

@interface OutAlertViewController ()

@end

@implementation OutAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ (UIAlertController *)lenghtExceedLimit {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"超出100字限制" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    return alertController;
}

+ (UIAlertController *)giveUpEditWithOkHandler:(void (^ __nullable)(UIAlertAction *action))okHandler {
    UIAlertController *giveUpEditAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否放弃编辑?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler: okHandler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [giveUpEditAlert addAction:okAction];
    [giveUpEditAlert addAction:cancelAction];
    
    return giveUpEditAlert;
}

@end
