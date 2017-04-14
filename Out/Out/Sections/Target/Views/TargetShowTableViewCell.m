//
//  TargetShowTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/17.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetShowTableViewCell.h"
#import "Target.h"
#import "DateHelper.h"

@implementation TargetShowTableViewCell
+ (instancetype)reusableCellWithTableView:(UITableView *)tableView {
    TargetShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"targetAddReusableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setDataModel:(Target *)dataModel {
    if (dataModel.insistHours == 0) {
        self.insistDaysLabel.text = @"尚未开始";
        self.insistHoursLabel.text = @"0";
    } else {
        self.insistDaysLabel.text = [NSString stringWithFormat:@"坚持了%ld天", (long)dataModel.insistDays];
        self.insistHoursLabel.text = [NSString stringWithFormat:@"%.1f", dataModel.insistHours];
    }
    self.beginTimeLabel.text = [DateHelper dateStringFromTimeInterval: dataModel.fromUnix dateFormat:@"从yyyy年MM月dd日"];
    self.targetNameLabel.text = dataModel.targetName;
    self.iconImageView.image = dataModel.iconName == nil?Default_Image: [UIImage imageNamed:dataModel.iconName];
}

@end
