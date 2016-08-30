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

// TODO:
// 1. TextView里有文本就显示导航栏勾选，无则不显示
// 2. TextView明明设置距离上边是2，运行后则调到下面去了。字数多的时候又会顶到之前设置的约束上
// 3. 主页面进入该页面是会有点卡顿
// 4. 上网看到资料说在textViewDidChange统计会导致输入时卡卡的，有待进一步测试看看是否这样
// 5.[done] 计算字数时特殊情况处理: 1) emoji 使用length为2 ,通过[str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4 为1； 2) 英文字母字符数字为两个代表一个长度。
#import "InputMoodViewController.h"

#define LIMIT_TEXT_LENGTH 100

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
    NSString *newText = [textView textInRange:selectedRange];
    // ?2. 去除空格失败
//    NSString *failedStrip = [newText stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *textStr = newText;
    NSString *stripSpaceStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    int length = [self strLength:textView.text] - [self strLength:newText] + [self strLength:stripSpaceStr];
    self.textLengthLB.text = [NSString stringWithFormat:@"%d/%d", length, LIMIT_TEXT_LENGTH];
    YLog();
}

// 点击键盘上的
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *selectedText = [textView textInRange:selectedRange];
    NSLog(@"rose: %@, %@, %@", textView.text, selectedText, text);
    return YES;
}

- (int)strLength:(NSString *)str {
    NSUInteger length = [str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    int len = (int)length;
    
    int blankCount = 0, asciiCount = 0, otherCount = 0;
    unichar c;
    for (int i = 0; i < len; i++) {
        c = [str characterAtIndex:i];
        if (isblank(c)) {
            blankCount++;
        } else if (isascii(c)) {
            asciiCount++;
        } else {
            otherCount++;
        }
    }
    len = (int)ceilf((float)(blankCount+asciiCount)/2.0) + otherCount;
    
    return len;
}

@end
