//
//  SetOutNameViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/9/5.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// TODO:
// 1. 换一张好看的背景图片

#import "SetOutNameViewController.h"
#import "OutAlertViewController.h"
#import "SetOutnameWindow.h"
#import "StringHelper.h"
#import "const.h"

@interface SetOutNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *outNameTF;

@end

@implementation SetOutNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.outNameTF becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.outNameTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setOutNameAction:(id)sender {
    if ([StringHelper isEmpty:self.outNameTF.text]) {
        UIAlertController *alertController = [OutAlertViewController nullOutName];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
   
    [self.outNameTF resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setValue:self.outNameTF.text forKey: OUT_NAME];
    [[SetOutNameWindow shareInstance] hide];
}

@end
