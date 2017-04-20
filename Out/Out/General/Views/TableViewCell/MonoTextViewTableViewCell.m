//
//  MonoTextViewTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/20.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "MonoTextViewTableViewCell.h"

@implementation MonoTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
