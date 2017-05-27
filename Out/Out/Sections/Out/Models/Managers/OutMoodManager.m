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
    mood.backgroundImage = image;
    mood.createTime = [DateHelper getCurrentTimeInterval];
    
    [mood save];
    OutMood *randomMood = [self getRandomOutMood];
    
    return mood;
}

+ (OutMood *)getRandomOutMood {
    NSString *whereSql = @"WHERE moodId >= ?";
    NSArray *arguments = @[[NSNumber numberWithInteger:0]];
    NSArray *ids = [OutMood idsWhere:whereSql arguments:arguments];
    NSArray *objects = [OutMood objectsWhere:whereSql arguments:nil];
    if (ids.count == 0) return nil;
    
    NSInteger randomNumber = arc4random() % [ids count];
    NSInteger randomId = (NSInteger)ids[randomNumber];
    OutMood *mood = (OutMood *)[OutMood objectForId:[NSNumber numberWithInteger: randomId]];
    
    return mood;
}
@end
