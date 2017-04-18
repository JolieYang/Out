//
//  TargetLogTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetLogShowTableViewCell.h"

@implementation TargetLogShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.logLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
