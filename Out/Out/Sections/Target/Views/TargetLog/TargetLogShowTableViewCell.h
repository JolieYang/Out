//
//  TargetLogTableViewCell.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TargetRecord;

#define LogShowLineSpacing 5.0
#define LogShowSize 14.0
#define LeftSpacing 20
#define RightSpacing 20
#define TopSpacing 43
#define BottomSpacing 18

@interface TargetLogShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *insistHoursLabel;

+ (instancetype)initWithTargetRecord:(TargetRecord *)targetRecord;
+ (CGFloat)heightForCellWithText:(NSString *)text;
@end
