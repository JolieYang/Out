//
//  TargetLogHeaderTableViewCell.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetLogHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *targetNameLable;
@property (weak, nonatomic) IBOutlet UILabel *insistHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;

@property (nonatomic, copy) void (^popBlock)();
@end
