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
#import "OutAPIManager.h"
#import "const.h"

@interface SetOutNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *outNameTF;
@property (weak, nonatomic) IBOutlet UITextField *outPasswdTF;

@property (nonatomic, assign) OutLoginType outLoginType;
@end

@implementation SetOutNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
    [self.outNameTF becomeFirstResponder];
}

- (void)config {
    self.outLoginType = OutLoginTypeNickName;
    if (self.outLoginType == OutLoginTypeNickName) {
        self.outNameTF.returnKeyType = UIReturnKeyGo;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setOutNameAction:(id)sender {
    [self resignKeyboard];
    if ([StringHelper isEmpty:self.outNameTF.text]) {
        UIAlertController *alertController = [OutAlertViewController nullOutName];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    NSString *apiName = @"user/login";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.outLoginType == OutLoginTypeNickName) {
        [params setValue:self.outNameTF.text forKey:@"nickname"];
    } else {
        if ([StringHelper isEmpty:self.outPasswdTF.text]) {
            // todo 弹窗
            return;
        }
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.outNameTF.text,@"email",self.outPasswdTF.text, @"password", nil];
        //    NSDictionary *params = @{@"email":@"jolie@icloud.com",@"password":@"sl0131"};
    }
    [OutAPIManager startRequestWithApiName:apiName params:params successed:^(NSDictionary *response) {
        NSLog(@"succeed:%@", response);
        NSString *token = [response objectForKey:@"token"];
        NSNumber *number = [response objectForKey:@"number"];
        [[NSUserDefaults standardUserDefaults] setValue:self.outNameTF.text forKey: OUT_NAME];
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:OUT_TOKEN];
        [[NSUserDefaults standardUserDefaults] setValue:number forKey:OUT_NAME_NUMBER];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[SetOutNameWindow shareInstance] hide];
    } failed:^(NSString *errMsg) {
        NSLog(@"error:%@", errMsg);
    }];
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.outLoginType == OutLoginTypeNickName) {
        // 进入Out
        [self setOutNameAction:nil];
    } else {
        if (textField == self.outNameTF) {
            // 下一步
            [self.outPasswdTF becomeFirstResponder];
        } else if (textField == self.outPasswdTF) {
            [self setOutNameAction:nil];
        }
    }
    
    return YES;
}

#pragma mark Tool

- (void)resignKeyboard {
    if (self.outLoginType == OutLoginTypeNickName) {
        [self.outNameTF resignFirstResponder];
    } else {
        if (![self.outNameTF resignFirstResponder]) {
            [self.outPasswdTF resignFirstResponder];
        }
    }
}
@end
