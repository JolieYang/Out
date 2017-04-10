//
//  RunningMemberRecordTitleTableViewCell.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunningRecordTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSString *title;
+ (instancetype)initWithTitle:(NSString *)title;
@end
