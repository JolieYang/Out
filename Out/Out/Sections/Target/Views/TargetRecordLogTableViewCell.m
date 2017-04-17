//
//  TargetRecordLogTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetRecordLogTableViewCell.h"
#import "UITextView+PlaceHolder.h"

@interface TargetRecordLogTableViewCell ()<UITextViewDelegate>

@end

@implementation TargetRecordLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.logTextView setPlaceHolder:@"输入你想说的"];
    self.logTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    //要想在用户结束编辑时阻止文本字段消失，可以返回NO
    //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
    [self endEditing:YES];
    return YES;
}
@end
