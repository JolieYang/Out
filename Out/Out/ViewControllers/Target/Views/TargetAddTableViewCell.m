//
//  TargetAddTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//
//  [检测是否输入文字]当直接点击提示栏中的文字时，不触发任何代理，因而需要通过键值观察检测是否输入文本。
// UITextFieldTextDidChangeNotification点击词频上的字符，会调用两次，点击按键上的字符，调用一次。
// [?]添加键值观察self.inputTextField addObserver:self keyPath:@"text" 不知道为什么文本明明修改了，但是没有触发observeValueForKeyPath事件

#import "TargetAddTableViewCell.h"

@interface TargetAddTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, assign) BOOL inputed;// 标志是否输入文本
@end

@implementation TargetAddTableViewCell

+ (instancetype)reusableCellWithTableView:(UITableView *)tableView {
    TargetAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"targetAddReusableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initialization];
}

- (void)initialization {
    self.inputTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInputStatus) name:UITextFieldTextDidChangeNotification object:nil];
    // [?]  无法检测
    [self.inputTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld context:@"TargetAddTableViewCell"];
}
- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.inputTextField removeObserver:self forKeyPath:@"text" context:@"TargetAddTableViewCell"];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"observeValueForKeyPath");
    if ([keyPath isEqualToString:@"text"]) {
        if (self.inputTextField.text.length > 0) {
            _inputed = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)changeInputStatus {
    if (self.inputTextField.text.length > 0) {
        _inputed = YES;
    } else {
        _inputed = NO;
    }
    if (self.textFieldDidChangeBlock) {
        self.textFieldDidChangeBlock(_inputTextField.text);
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textFieldReturnBlock) {
        self.textFieldReturnBlock(textField.text);
    }
    return YES;
}

@end
