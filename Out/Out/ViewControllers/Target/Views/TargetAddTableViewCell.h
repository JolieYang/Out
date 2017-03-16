//
//  TargetAddTableViewCell.h
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetAddTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (nonatomic, assign) BOOL inputed;// 标志是否输入文本
+ (instancetype)reusableCellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) void (^textFieldReturnBlock)(NSString *input);
@end
