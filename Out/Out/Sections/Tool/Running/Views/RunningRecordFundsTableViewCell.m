//
//  RunningRecordFundsTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningRecordFundsTableViewCell.h"

@implementation RunningRecordFundsTableViewCell

- (instancetype)initWithTitle:(NSString *)title sum:(NSInteger)sum {
    RunningRecordFundsTableViewCell *cell = [RunningRecordFundsTableViewCell loadFromNib];
    cell.fundsTitleLabel.text = title;
    cell.sumLabel.text = [NSString stringWithFormat:@"%ld", (long)sum];
    
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

@end
