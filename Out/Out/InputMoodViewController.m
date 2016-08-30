//
//  InputMoodViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// 问题列表:
// ?1.预输入时打印textView s s s。 字符为ssss时，打印长度为4，而微博是按2来算。
// ?2.去除空格失败
// ?3. 主页面进入该页面是会有点卡顿

#import "InputMoodViewController.h"

#define YLog(formatString, ...) NSLog((@"%s" formatString), __PRETTY_FUNCTION__, ##__VA_ARGS__);

@interface InputMoodViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *textLengthLB;

@end

@implementation InputMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputTextView.delegate = self;
    self.navigationItem.title = @"InputMood";
    // 设置导航栏右边按钮
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_check"] style:UIBarButtonItemStylePlain target:self action:@selector(didEndEdit)];
    self.navigationItem.rightBarButtonItem = checkItem;
    // 设置导航栏返回(左边)按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.inputTextView becomeFirstResponder];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didEndEdit {
    NSLog(@"show:%@", self.inputTextView.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];// print: "S s"
    // ?2. 去除空格失败
    NSString *failedStrip = [newText stringByReplacingOccurrencesOfString:@" " withString:@""];// print "S s"
    NSLog(@"failedStrip:%@", failedStrip);
    NSString *textStr = newText;
    NSString *stripSpaceStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.textLengthLB.text = [NSString stringWithFormat:@"%lu/100", (unsigned long)textView.text.length - newText.length + stripSpaceStr.length];
}

// 键盘弹出,进入该回调1.
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    YLog();
    return YES;
}

// 点击键盘上的
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}

// 输入字符
- (void)textViewDidChangeSelection:(UITextView *)textView {
    YLog(@"changeSelection:%@", textView.text);
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    YLog();
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    YLog();
    
    return YES;
}



@end
