//
//  UIViewController+JY.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/19.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "UIViewController+JY.h"
#import <objc/runtime.h>

@interface UIViewController ()<UIGestureRecognizerDelegate>

@end

@implementation UIViewController (JY)
static char *backActionBlockKey = "backActionBlockKey";
static char *rightActinBlockKey = "rightActinBlockKey";
static char *firstRightActionBlockKey = "firstRightActionBlockKey";
static char *secondRightActionBlockKey = "secondRightActionBlockKey";


#pragma mark -- UINavigationController

- (void)setNavigationBarTitleColor:(UIColor *)color {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
}

- (void)customBackItemWithImageName:(NSString *)imageName
                             action:(void (^)(void))actionBlock
{
    self.backActionBlock = [actionBlock copy];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 25,25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = -8;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)customRightItemWithImageName:(NSString *)imageName
                              action:(void (^)(void))actionBlock
{
    self.rightActionBlock = [actionBlock copy];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 25,25);
    [rightBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];;
    self.navigationItem.rightBarButtonItems = @[rightBarBtn];
}

- (void)systemRightItemWithImageName:(NSString *)imageName
                              action:(void (^)(void))actionBlock {
    self.rightActionBlock = [actionBlock copy];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
   }

// 顺序从左到右
- (void)customRightItemsWithFirstImageName:(NSString *)firstImageName
                                   action:(void (^)(void))firstActionBlock
                          secondImageName:(NSString *)secondImageName
                                   action:(void (^)(void))secondActionBlock
{
    self.firstRightActionBlock = [firstActionBlock copy];
    self.secondRightActionBlock = [secondActionBlock copy];
    
    UIBarButtonItem *firstItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:firstImageName] style:UIBarButtonItemStylePlain target:self action:@selector(firstRightItemAction)];
    UIBarButtonItem *secondItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:secondImageName] style:UIBarButtonItemStylePlain target:self action:@selector(secondRightItemAction)];
    self.navigationItem.rightBarButtonItems = @[secondItem, firstItem];
}

- (void)firstRightItemAction {
    if (self.firstRightActionBlock) {
        self.firstRightActionBlock();
    }
}

- (void)secondRightItemAction {
    if (self.secondRightActionBlock) {
        self.secondRightActionBlock();
    }
}

- (void)backAction {
    if (self.backActionBlock) {
        self.backActionBlock();
    }
}

- (void)rightItemAction {
    if (self.rightActionBlock) {
        self.rightActionBlock();
    }
}

- (void)setBackActionBlock:(void (^)())backActionBlock {
    objc_setAssociatedObject(self, backActionBlockKey, backActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())backActionBlock {
    return  objc_getAssociatedObject(self, backActionBlockKey);
}

- (void)setRightActionBlock:(void (^)())backActionBlock {
    objc_setAssociatedObject(self, rightActinBlockKey, backActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())rightActionBlock {
    return  objc_getAssociatedObject(self, rightActinBlockKey);
}

- (void)setFirstRightActionBlock:(void (^)())backActionBlock {
    objc_setAssociatedObject(self, firstRightActionBlockKey, backActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())firstRightActionBlock {
    return  objc_getAssociatedObject(self, firstRightActionBlockKey);
}
- (void)setSecondRightActionBlock:(void (^)())backActionBlock {
    objc_setAssociatedObject(self, secondRightActionBlockKey, backActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())secondRightActionBlock {
    return  objc_getAssociatedObject(self, secondRightActionBlockKey);
}

#pragma mark -- UIGestureRecognizer

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
