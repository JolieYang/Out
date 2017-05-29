//
//  InputMoodPictureViewController.h
//  Out
//
//  Created by Jolie_Yang on 16/9/1.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OutMood;

@interface InputMoodPictureViewController : UIViewController
@property (nonatomic, strong) void (^finishPictureMoodBlock)(OutMood *mood);
@end
