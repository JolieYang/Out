//
//  RunningMemberRecordTitleTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "CenterTitleTableViewCell.h"

@implementation CenterTitleTableViewCell

+ (instancetype)initWithTitle:(NSString *)title {
    CenterTitleTableViewCell *cell = [self loadFromNib];
    cell.titleLabel.text = title;
    
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
