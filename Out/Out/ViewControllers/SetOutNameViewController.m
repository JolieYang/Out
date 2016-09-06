//
//  SetOutNameViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/9/5.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "SetOutNameViewController.h"
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setOutNameAction:(id)sender {
    if ([StringHelper stripSpace:self.outNameTF.text].length == 0 || [StringHelper isEmpty:self.outNameTF.text]) {
        // 请输入OutName
        return;
    }
    [self.outNameTF resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setValue:self.outNameTF.text forKey: OUT_NAME];
    [[SetOutNameWindow shareInstance] hide];
}

@end
