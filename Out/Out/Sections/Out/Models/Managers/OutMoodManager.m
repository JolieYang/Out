//
//  OutMoodManager.m
//  Out
//
//  Created by Jolie on 2017/5/27.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "OutMoodManager.h"
#import "DateHelper.h"
#import "OutMood.h"

@implementation OutMoodManager
+ (OutMood *)addOutMoodWithContent:(NSString *)content image:(UIImage *)image {
    OutMood *mood = [[OutMood alloc] init];
    mood.content = content;
    if (image) {
        mood.backgroundImage = image;
    }
    mood.createTime = [DateHelper getCurrentTimeInterval];
    
    [mood save];
    
    return mood;
}

+ (OutMood *)getRandomOutMood {
    NSArray *moods = [self getOutMoodList];
    if (moods.count == 0) return nil;
    if (moods.count == 1) return moods[0];
    
    NSInteger randomNumber = arc4random() % ([moods count] - 1);
    OutMood *mood = (OutMood *)moods[randomNumber];
    
    return mood;
}

+ (NSArray *)getOutMoodList {
    NSString *whereSql = @"ORDER BY moodId";
    NSArray *arguments = nil;
    NSArray *moodList = [OutMood objectsWhere:whereSql arguments:arguments];
    return moodList;
}
@end
