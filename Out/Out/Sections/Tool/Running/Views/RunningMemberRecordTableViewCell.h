//
//  RunningMemberRecordTableViewCell.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunningRecord.h"
@class RunningWeek;

@interface RunningMemberRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UITextField *contributionMoneyTF;
@property (weak, nonatomic) IBOutlet UITextField *remarksTF;

@property (nonatomic, strong) RunningRecord *dataModel;

- (instancetype)initWithDataModel:(RunningRecord *)model;

@property (nonatomic, copy) void (^updateContributionBlock)(NSInteger preContributionMoney, NSInteger contributionMoney);
@property (nonatomic, copy) void (^updateWeekRecordContributionBlock)(RunningWeek *week);

@property (nonatomic, copy) void (^checkBtnClickBlock)(BOOL checked);
@property (nonatomic, copy) void (^keyboardWillShowBlock)(UITextField *tf);
@end
