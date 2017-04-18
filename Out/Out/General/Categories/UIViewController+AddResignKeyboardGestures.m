//
//  UIViewController+AddResignKeyboardGestures.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "UIViewController+AddResignKeyboardGestures.h"

@implementation UIViewController (AddResignKeyboardGestures)
- (void)addResignKeyboardGestures {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

-(void)keyboardHide:(UIGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}
@end
