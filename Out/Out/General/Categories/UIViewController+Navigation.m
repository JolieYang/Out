//
//  UIViewController+Navigation.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)
- (void)addRightNavigationItemWithTitle:(NSString *)title action:(void (^)(void))action {
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = titleItem;
}

- (void)rightItemAction {
    
}
@end
