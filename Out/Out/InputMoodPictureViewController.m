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
// 1. 选择相册图片
// 2. 修改背景图片
// 3. 输入文本,文本是居中显示


#import "InputMoodPictureViewController.h"

@interface InputMoodPictureViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@property (nonatomic, strong) UILabel *placeHolderLB;

@end

@implementation InputMoodPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupInputTextView];
    self.inputTextView.delegate = self;
}
// 返回
- (IBAction)backAction:(id)sender {
    
}
// 完成编辑发布心情
- (IBAction)didEndEditAction:(id)sender {
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
    self.placeHolderLB = [[UILabel alloc] initWithFrame:CGRectMake(30, [self.inputTextView bounds].size.height/2.0, [self.inputTextView bounds].size.width - 60, 30)];
    self.placeHolderLB.text = @"想说点什么呢?";
    self.placeHolderLB.textColor = [UIColor whiteColor];
    self.placeHolderLB.textAlignment = NSTextAlignmentCenter;
    self.placeHolderLB.font = self.inputTextView.font;
//    [self.placeHolderLB sizeToFit];
    [self.inputTextView addSubview:self.placeHolderLB];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self adjustInputMoodText];
}

- (void)adjustInputMoodText {
    CGFloat space = [self.inputTextView bounds].size.height - self.inputTextView.contentSize.height;
    CGFloat verticalInset = MAX(1, space/2.0);
    CGFloat horizontalInset = 30;
    [self.inputTextView setTextContainerInset:UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)];
}
@end
