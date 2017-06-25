//
//  TargetLogHeaderTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetLogHeaderTableViewCell.h"
#import "Target.h"

@implementation TargetLogHeaderTableViewCell

+ (instancetype)initWithTarget:(Target *)target {
    TargetLogHeaderTableViewCell *cell = [self loadFromNib];
    cell.targetNameLable.text = target.targetName;
    cell.insistHoursLabel.text = [NSString stringWithFormat:@"- 坚持了%.1f小时 -", target.insistHours];
    cell.remarksLabel.text = target.remarks.length > 0 ? target.remarks : @"暂无描述";
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = Apple_Black;
    self.remarksLabel.numberOfLines = 0;
    self.targetBgImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction)backAction:(id)sender {
    if (self.popBlock) {
        self.popBlock();
    }
}
- (IBAction)editAction:(id)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}

@end
