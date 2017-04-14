//
//  TargetShowTableViewCell.h
//  Out
//
//  Created by Jolie_Yang on 2017/3/17.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Target;

@interface TargetShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *insistDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *insistHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

+ (instancetype)reusableCellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) Target *dataModel;
@end
