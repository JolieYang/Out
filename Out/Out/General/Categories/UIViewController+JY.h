//
//  UIViewController+JY.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/19.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JY)
#pragma mark -- UINavigationController
@property (nonatomic, copy) void (^backActionBlock)();
@property (nonatomic, copy) void (^rightActionBlock)();
@property (nonatomic, copy) void (^firstRightActionBlock)();
@property (nonatomic, copy) void (^secondRightActionBlock)();
- (void)setNavigationBarTitleColor:(UIColor *)color;

- (void)customBackItemWithImageName:(NSString *)imageName
                             action:(void (^)(void))actionBlock;
- (void)customRightItemWithImageName:(NSString *)imageName
                              action:(void (^)(void))actionBlock;
- (void)customRightItemsWithFirstImageName:(NSString *)firstImageName
                                   action:(void (^)(void))firstActionBlock
                          secondImageName:(NSString *)secondImageName
                                   action:(void (^)(void))secondActionBlock;

#pragma mark -- UIGestureRecognizer
- (void)addResignKeyboardGestures;// 包括点击，上下滑动
@end
