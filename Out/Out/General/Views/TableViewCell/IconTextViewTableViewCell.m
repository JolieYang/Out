//
//  IconTextViewTableViewCell.m
//  Spider
//
//  Created by Jolie_Yang on 2017/5/4.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "IconTextViewTableViewCell.h"

@implementation IconTextViewTableViewCell

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
