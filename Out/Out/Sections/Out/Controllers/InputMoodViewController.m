//
//  InputMoodViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "InputMoodViewController.h"
#import "OutAlertViewController.h"
#import "OutAPIManager.h"
#import "OutMoodManager.h"
#import "OutMood.h"
#import "JYProgressHUD.h"
#import "UITextView+JY.h"
#import "StringHelper.h"

#define YLog(formatString, ...) NSLog((@"%s" formatString), __PRETTY_FUNCTION__, ##__VA_ARGS__);

@interface InputMoodViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *textLengthLB;
@property (nonatomic, strong) UILabel *placeHolderLB;

@property (nonatomic, assign) BOOL hasAddedNavRight; // 是否已添加过导航栏右边按钮
@end

@implementation InputMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.inputTextView becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupViews {
    [self setupNavigation];
    [self setupTextView];
}
- (void)setupNavigation {
    [self setupNavTitle];
    [self addNavBackItem];
    [self addNavRightItem];
}

- (void)setupNavTitle {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    titleLabel.text = @"添加Mood";
    titleLabel.textColor = Birthday_Icon_Gray;
    self.navigationItem.titleView = titleLabel;
}


- (void)addNavBackItem {
    [self customBackItemWithImageName:Gray_Nav_Back_Icon_Name action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

// 设置导航栏右边按钮
- (void)addNavRightItem {
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    checkBtn.frame = CGRectMake(0, 0, 25,25);
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"nav_check"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(didEndEdit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    [self hideNavRightItem:YES];
}

- (void)setupTextView {
    self.inputTextView.scrollEnabled = NO;
    self.inputTextView.delegate = self;
    self.inputTextView.contentMode = UIViewContentModeTop;
    [self addInputTextViewPlaceHolder];
}
- (void)addInputTextViewPlaceHolder {
    [self.inputTextView setPlaceHolder:@"想说点什么呢?"];
}

// 发布mood
- (void)didEndEdit {
    // 超出100字限制
    if (self.inputTextView.text.length == 0) {
        [OutAlertViewController showWithTitle:@"请输入文本" actionTitle:@"知道了"];
    } else if ([StringHelper length:self.inputTextView.text] > 100) {
        UIAlertController *alertController = [OutAlertViewController lenghtExceedLimit];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self addMood];
}

- (void)addMood {
    if (!ENABLE_SERVER) {
        OutMood *mood = [OutMoodManager addOutMoodWithContent:self.inputTextView.text image:nil];
        [JYProgressHUD showQuicklyTextHUDWithDetailContent:@"发布成功" AddedTo:self.view completion:^{
            if (_finishMoodBlock) {
                _finishMoodBlock(mood);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    // markedTextRange currently marked 预输入分为两种情况: 一种是点击字母的预输入；另一种是默认的预输入字符。
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];
    NSString *text = [textView.text copy];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    int length = (int)[StringHelper length:text];
    if (length > 100) {
        NSString *limitStr = [NSString stringWithFormat:@"%d/%d", length, LIMIT_TEXT_LENGTH];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:limitStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, limitStr.length - 4)];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textLengthLB.attributedText = attStr;
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textLengthLB.text = [NSString stringWithFormat:@"%d/%d", length, LIMIT_TEXT_LENGTH];
        });
    }
    if (length >= 1) {
        [self didEnterText];
    } else if (newText.length == 0 && self.inputTextView.text.length == 0) {
        [self didEnterEmpty];
    }
}

#pragma mark UI
// 输入文字隐藏placeHolder与显示发布按钮
- (void)didEnterText {
    self.placeHolderLB.hidden = YES;
    [self hideNavRightItem:NO];
}
// 无输入内容则显示placeHolder与隐藏发布按钮
- (void)didEnterEmpty {
    self.placeHolderLB.hidden = NO;
    [self hideNavRightItem:YES];
}

- (void)hideNavRightItem:(BOOL)hided {
    self.navigationItem.rightBarButtonItem.customView.hidden = hided;
}

@end
