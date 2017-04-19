//
//  InputMoodViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// 问题列表:
// ?1.[ok] 预输入时打印textView s s s。 字符为ssss时，打印长度为4，而微博是按2来算。Reply: 只是一个约定而已，将字母，数字等按两个字符为一个长度而已。
// ?2.去除空格失败
// ?3. 主页面进入该页面是会有点卡顿

// BUG:
// 1. 字数统计还是有bug,比如 中文输入法时，输入'u'，长度为0, 

// TODO:
// 1.[done] #隐藏导航栏右边按钮#TextView里有文本就显示导航栏勾选，无则不显示 1) 第一次进入界面是默认隐藏还是等输入后再添加导航栏右边按钮呢
// 2. TextView明明设置距离上边是2，运行后则调到下面去了。字数多的时候又会顶到之前设置的约束上
// 3. 主页面进入该页面是会有点卡顿
// 4. 上网看到资料说在textViewDidChange统计会导致输入时卡卡的，有待进一步测试看看是否这样
// 5.[done] 计算字数时特殊情况处理: 1) emoji 使用length为2 ,通过[str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4 为1； 2) 英文字母字符数字为两个代表一个长度。
// 6.[done] 输入文字后去除placeholder
// 7.[done] 输入文字时textView是垂直居中左对齐，而不是顶部左对齐  [new]默认为顶部左对齐，之前在textView区域拖了一个Label，设置完约束后就是这样了。
// 8.[done] 更改导航栏返回图标和右边图标
// 9.[done] 字数统计时超过100字符时统计的字符数显示为红色
// 10.[done]  字数统计超过100字符弹框显示“超出100字限制”

//  UI:
// 1. 导航栏图标尺寸 58 @2x  #757575
#import "InputMoodViewController.h"
#import "OutAlertViewController.h"
#import "JYProgressHUD.h"
#import "StringHelper.h"
#import "OutAPIManager.h"
#import "UITextView+JY.h"

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
    [JYProgressHUD showIndicatorHUDWithDetailString:@"正在发布" AddedTo:self.view animated:YES];
    NSString *apiName = @"mind";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.inputTextView.text forKey:@"content"];
    [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:OUT_TOKEN] forKey:@"token"];
    [OutAPIManager startRequestWithApiName:apiName params: params successed:^(NSDictionary *response) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (_finishMoodBlock) {
                [JYProgressHUD hideHUDForView:self.view animated:YES];
                _finishMoodBlock(response);
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failed:^(NSString *errMsg) {
        // 弹窗显示 发布失败
        dispatch_async(dispatch_get_main_queue(), ^{
            [JYProgressHUD changeToTextHUDWithDetailString:errMsg AddedTo:self.view];
        });
        return ;
    }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    // markedTextRange currently marked 预输入分为两种情况: 一种是点击字母的预输入；另一种是默认的预输入字符。
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];
    NSLog(@"textView:%@ newText:%@", textView.text, newText);
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
