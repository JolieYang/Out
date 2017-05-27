//
//  InputMoodViewController.h
//  Out
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OutMood;

@interface InputMoodViewController : UIViewController

@property (nonatomic, strong) void (^finishMoodBlock)(OutMood *mood);

@end
