//
//  TargetAddViewController.h
//  Spider
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Target.h"

@interface TargetAddOrEditViewController : UIViewController
@property (nonatomic, assign) TargetType addTargetType;
@property (nonatomic, copy) void (^successAddOrEditTargetBlock)(Target *newData);
@property (nonatomic, strong) Target *target;
@end
