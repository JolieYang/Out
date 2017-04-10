//
//  TargetShowTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/17.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetShowTableViewCell.h"

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

- (void)setDataModel:(TargetShowModel *)dataModel {
    self.insistDaysLabel.text = [NSString stringWithFormat:@"坚持了%@天", dataModel.insistDays==nil?@"0":dataModel.insistDays];
    self.insistHoursLabel.text = dataModel.insistHours==nil?@"0":dataModel.insistHours;
    self.beginTimeLabel.text = [NSString stringWithFormat:@"从%@", dataModel.beginTime];
    self.targetNameLabel.text = dataModel.targetName;
    if (dataModel.iconName) {
        self.iconImageView.image = [UIImage imageNamed:dataModel.iconName];
    }
    self.iconImageView.image = dataModel.iconName == nil?Default_Image: [UIImage imageNamed:dataModel.iconName];
}

@end
