//
//  TargetAddViewController.h
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Target;

@interface TargetAddViewController : UIViewController

@property (nonatomic, copy) void (^successAddTargetBlock)(Target *newData);

@end
