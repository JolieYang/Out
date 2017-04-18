//
//  TargetLogTableViewCell.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TargetRecord;

@interface TargetLogShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *insistHoursLabel;

+ (instancetype)initWithTargetRecord:(TargetRecord *)targetRecord;
@end
