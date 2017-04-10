//
//  RunningMemberRecordTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningMemberRecordTableViewCell.h"
#import "UIView+LoadFromNib.h"

@interface RunningMemberRecordTableViewCell ()<UITextFieldDelegate>

@end
@implementation RunningMemberRecordTableViewCell

- (instancetype)initWithDataModel:(RunningRecord *)model {
    RunningMemberRecordTableViewCell *cell = [RunningMemberRecordTableViewCell loadFromNib];
    
    cell.dataModel = model;
    cell.memberNameLabel.text = model.memberName;
    cell.checkBtn.tag = model.isAchieve;
    cell.contributionMoneyTF.text = model.contributionMoney == 0? @"" : [NSString stringWithFormat:@"%ld", (long)model.contributionMoney];
    cell.remarksTF.text = model.remarks;
    [cell updateBgColor];
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contributionMoneyTF.delegate = self;
    self.remarksTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}

- (IBAction)checkAction:(UIButton *)sender {
    if (sender.tag == 1) {
        sender.tag = 0;
        [sender setImage:[UIImage imageNamed:@"check_unselected"] forState:UIControlStateNormal];
    } else {
        sender.tag = 1;
        [sender setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateNormal];
    }
    
    // 更新数据
    self.dataModel.isAchieve = sender.tag;
}

- (void)updateBgColor {
    if (self.contributionMoneyTF.text.length > 0) {
        self.backgroundColor = Running_Record_Not_Achieve;
    } else if (self.remarksTF.text.length > 0) {
        self.backgroundColor = Running_Record_Take_Leave;
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.contributionMoneyTF) {
        self.dataModel.contributionMoney = [textField.text integerValue];
    } else if (textField == self.remarksTF) {
        self.dataModel.remarks = textField.text;
    }
    [self endEditing:YES];
    [self updateBgColor];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"didEndEditing");
}

@end
