//
//  RunningMemberRecordTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningMemberRecordTableViewCell.h"
#import "UIView+LoadFromNib.h"
#import "RunningRecordManager.h"
#import "RunningRecord.h"

@interface RunningMemberRecordTableViewCell ()<UITextFieldDelegate>

@end
@implementation RunningMemberRecordTableViewCell

- (instancetype)initWithDataModel:(RunningRecord *)model {
    RunningMemberRecordTableViewCell *cell = [RunningMemberRecordTableViewCell loadFromNib];
    
    cell.dataModel = model;
    cell.memberNameLabel.text = model.memberName;
    [cell updateCheckButtonWithTag:model.isAchieve];
    cell.contributionMoneyTF.text = model.contributionMoney == 0? @"" : [NSString stringWithFormat:@"%ld", (long)model.contributionMoney];
    cell.remarksTF.text = model.remarks;
    [cell updateCellBgColor];
    
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
    [self endEditing:YES];// ps: 无法成功回收键盘,当点击其他cell的check按钮时
    [self updateCheckButtonWithTag:!sender.tag];
    
    // 更新数据
    self.dataModel.isAchieve = sender.tag;
    [self.dataModel save];// 保存缓存
}

- (void)updateCheckButtonWithTag:(BOOL)isAchieve {
    self.checkBtn.tag = isAchieve;
    if (self.checkBtn.tag == 0) {
        [self.checkBtn setImage:[UIImage imageNamed:@"check_unselected"] forState:UIControlStateNormal];
    } else {
        [self.checkBtn setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateNormal];
    }
}

- (void)updateCellBgColor {
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
    [self endEditing:YES];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.contributionMoneyTF && [textField.text integerValue] < 1000) {// 粗略过滤中文值
        if (self.dataModel.contributionMoney != [textField.text integerValue] && self.updateContributionBlock) {
            self.updateContributionBlock(self.dataModel.contributionMoney, [textField.text integerValue]);
        }
        self.dataModel.contributionMoney = [textField.text integerValue] ;
    } else if (textField == self.remarksTF) {
        self.dataModel.remarks = textField.text;
    }
    [self updateCellBgColor];
    [self.dataModel save];
}

@end
