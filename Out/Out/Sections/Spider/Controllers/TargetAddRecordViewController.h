//
//  TargetAddRecordViewController.h
//  Spider
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Target;

@interface TargetAddRecordViewController : UIViewController
@property (nonatomic, assign) Target *target;
@property (nonatomic, copy) void (^updateTargetBlock)(Target *target);
@end
