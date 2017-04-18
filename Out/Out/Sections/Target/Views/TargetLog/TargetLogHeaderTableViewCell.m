//
//  TargetLogHeaderTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetLogHeaderTableViewCell.h"

@implementation TargetLogHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = Apple_Black;
    self.remarksLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)backAction:(id)sender {
    if (self.popBlock) {
        self.popBlock();
    }
}
- (IBAction)detailAction:(id)sender {
}

@end
