//
//  InputMoodPictureViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/9/1.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// 界面分析:
// 无遮罩效果
// TextView,背景图片通过textView addSubview添加imageView

// 界面特点:
// 覆盖状态栏
// 提供4张图片供充当背景图片，也提供从相册选择图片充当背景

// 交互:
// 1. 点击左上角按钮离开编辑界面， 但会弹窗提醒  提示  “是否放弃编辑?" “是的” “取消”
// 2. 点击右上角图片发布mood, 涉及到网络方面，需显示”发布中..." ，发布成功离开该页面
// 3. 可点击右下角按钮 从本地相册选择图片充当文字背景


// TODO LIST:
// 1. 点击右下角按钮相关处理:选择相册图片
// 2. 修改背景图片
// 3.[done] 输入文本,文本是居中显示 Q1:[done] 第一行是居中显示，但距离上面的距离是固定的，也就是计算textView的高度时，高度不会随着行数的改变而改变
// 4.[done] 隐藏导航栏
// 5.[done] textView编辑状态的光标颜色设为白色
// 6.[done] textView编辑状态的光标调整成跟placeHolder同一水平线
// 7. 进入该页面，是从底下往上显示，即show detail效果
// 8.[done] 点击左上角按钮相关处理
// 9. 点击右上角按钮逻辑处理
// 10.[done] 图标替换

// Questin LIST:
// ?1. 进入该页面使用的是"show detail"相当于什么，不是push,present. 离开该页面是应该如何


#import "InputMoodPictureViewController.h"
#import "HomeViewController.h"
#import "OutAlertViewController.h"
#import "StringLengthHelper.h"
#import "TextViewHelper.h"

@interface InputMoodPictureViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;

@property (nonatomic, strong) UILabel *placeHolderLB;

@end

@implementation InputMoodPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupInputTextView];
    self.inputTextView.delegate = self;
    [self adjustInputMoodText];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
// 返回上一级界面
- (IBAction)backAction:(id)sender {
    UIAlertController *giveupEditAlert = [OutAlertViewController giveUpEditWithOkHandler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self presentViewController:giveupEditAlert animated:YES completion:nil];
    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
// 完成编辑发布心情
- (IBAction)didEndEditAction:(id)sender {
    // 判断字数是否超出限制
    if ([StringLengthHelper length:self.inputTextView.text] > 100) {
        UIAlertController *alertController = [OutAlertViewController lenghtExceedLimit];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    // TODO: 连接后台发布Out
    // ...
    if (_finishPictureMoodBlock && [StringLengthHelper length:self.inputTextView.text] > 0) {
        _finishPictureMoodBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
// 从系统相册选择背景图片
- (IBAction)choosePictureAction:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupInputTextView {
    // 设置placeholder
    self.placeHolderLB = [[UILabel alloc] initWithFrame:CGRectMake(30, [self.inputTextView bounds].size.height/2.0 - 23, [self.inputTextView bounds].size.width - 60, 30)];
    self.placeHolderLB.text = @"想说点什么呢?";
    self.placeHolderLB.textColor = [UIColor whiteColor];
    self.placeHolderLB.textAlignment = NSTextAlignmentCenter;
    self.placeHolderLB.font = self.inputTextView.font;
    [self.inputTextView addSubview:self.placeHolderLB];
    
    // 设置光标颜色
    self.inputTextView.tintColor = [UIColor whiteColor];
    
    //  隐藏发布按钮
    self.outBtn.hidden = YES;
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {// 无输入字符
        self.placeHolderLB.hidden = NO;
        self.outBtn.hidden = YES;
    }
    else if (textView.text.length > 0) {// 有字符； 之前是按照输入第一个字符时，进行隐藏placeHolder,但其实可以一口气输入多个，所以目前还没找到如何判断第一次输入text
        if (!self.placeHolderLB.hidden) {
            self.placeHolderLB.hidden = YES;
            self.outBtn.hidden = YES;
        }
    }
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];
    int length = [StringLengthHelper length:textView.text] - (floor)(newText.length/2.0);
    if (length > 100) {
        // 弹窗提醒“文字超出长度限制"
    }
    [self adjustInputMoodText];
}

// 点击提示栏上的字不会进入该回调
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length == 0 && text.length > 0) {
        self.placeHolderLB.hidden = YES;
        self.outBtn.hidden = NO;
    }
    return YES;
}
#pragma mark Tool
- (void)adjustInputMoodText {
    CGFloat space = [self.inputTextView bounds].size.height - [TextViewHelper heightForTextView:self.inputTextView];
    CGFloat verticalInset = MAX(30, space/2.0);
    CGFloat horizontalInset = 30;
    [self.inputTextView setTextContainerInset:UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)];
}

#pragma mark Config
// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
