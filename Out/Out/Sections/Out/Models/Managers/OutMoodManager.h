//
//  OutMoodManager.h
//  Out
//
//  Created by Jolie on 2017/5/27.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OutMood;

@interface OutMoodManager : NSObject
+ (OutMood *)addOutMoodWithContent:(NSString *)content image:(UIImage *)image;
+ (OutMood *)getRandomOutMood;
@end
