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
// 3. 输入文本,文本是居中显示 Q1: 第一行是居中显示，但距离上面的距离是固定的，也就是计算textView的高度时，高度不会随着行数的改变而改变
// 4.[done] 隐藏导航栏
// 5.[done] textView编辑状态的光标颜色设为白色
// 6.[done] textView编辑状态的光标调整成跟placeHolder同一水平线

// Questin LIST:
// ?1. 进入该页面使用的是"show detail"相当于什么，不是push,present. 离开该页面是应该如何


#import "InputMoodPictureViewController.h"
#import "HomeViewController.h"
#import "StringLengthHelper.h"

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
    [self adjustInputMoodText];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
// 返回
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
// 完成编辑发布心情
- (IBAction)didEndEditAction:(id)sender {
    // 发布处理
    
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
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {// 无输入字符
        self.placeHolderLB.hidden = NO;
    }
    else if (textView.text.length > 0) {// 有字符； 之前是按照输入第一个字符时，进行隐藏placeHolder,但其实可以一口气输入多个，所以目前还没找到如何判断第一次输入text
        if (!self.placeHolderLB.hidden) {
            self.placeHolderLB.hidden = YES;
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
    }
    return YES;
}
- (void)adjustInputMoodText {
    CGFloat space = [self.inputTextView bounds].size.height - [self heightForTextView:self.inputTextView];
    CGFloat verticalInset = MAX(30, space/2.0);
    CGFloat horizontalInset = 30;
    [self.inputTextView setTextContainerInset:UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)];
}

#pragma mark Tool
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - 30*2 - fPadding, CGFLOAT_MAX);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByClipping];
    NSDictionary *attributes = @{NSFontAttributeName: textView.font, NSParagraphStyleAttributeName: style};
    CGRect rect = [strText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    float fHeight = rect.size.height + fPadding;
    return fHeight;
}
- (float)heightForTextView:(UITextView *)textView {
    float fPadding = 8.0;
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding*2 - 30*2, MAXFLOAT);
    CGRect rect = [textView.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil];
    float fHeight = rect.size.height + 16.0;
    return fHeight;
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

#pragma mark Config
// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
