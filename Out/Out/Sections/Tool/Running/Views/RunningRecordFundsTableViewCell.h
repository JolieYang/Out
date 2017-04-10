//
//  RunningRecordFundsTableViewCell.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunningRecordFundsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fundsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

- (instancetype)initWithTitle:(NSString *)title sum:(NSInteger)sum;
@end
