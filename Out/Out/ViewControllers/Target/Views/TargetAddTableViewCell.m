//
//  TargetAddTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//
//  [检测是否输入文字]当直接点击提示栏中的文字时，不触发任何代理，因而需要通过键值观察检测是否输入文本。

#import "TargetAddTableViewCell.h"

@interface TargetAddTableViewCell ()<UITextFieldDelegate>

@end

@implementation TargetAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.inputTextField.delegate = self;
    [self.inputTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.inputTextField selector:@selector(changeInputStatus) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)reusableCellWithTableView:(UITableView *)tableView {
    TargetAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"targetAddReusableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    
    return cell;
}

+ (instancetype)init {
    id cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    return cell;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        if (self.inputTextField.text.length > 0) {
            _inputed = YES;
        }
    }
}
- (void)changeInputStatus {
    if (self.inputTextField.text.length > 0) {
        _inputed = YES;
    } else {
        _inputed = NO;
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textFieldReturnBlock) {
        self.textFieldReturnBlock(textField.text);
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length > 0 || textField.text.length > 1) {
        _inputed = YES;
    } else {
        _inputed = NO;
    }
    
    return YES;
}

@end
