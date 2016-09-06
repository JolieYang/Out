//
//  ViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// 从xib中加载视图

// Work LIST:
// 1.[done] 在inputmood中写完mood后，在该页面显示一条别人的mood。
// 2. 该mood在离开该页面1分钟后消失
// 3.[done] 调整文本的显示位置 ,左右各距离20px,垂直居中，水平居中显示。
// 4.[done] 在textView的右下角显示mood写下的时间
// 5. 文字显示动画
// 6. 文本也有alpha值，感觉字不是很清晰。 预想解决方案： 海报文字是一个label，而不是设置textView的文本。
// 7.[done] 图片背景遮罩效果。 r: 一开始是设置textView通过addSubview添加背景图片，但是无法实现遮罩效果。所以应该是设置image,textView设置背景颜色，再设置alpha值0.5。
// 8.[done]  设置状态栏为白色
// 9. 接入后端接口 communicate with spider-- 5th,Nov,2016 1) 发布out: content,用户昵称,时间,图片url 2) 上传图片 3) 获取一条out

// Questin LIST:
// 1. 该页面的获取otherMoodTextView的textColor和font为nil,尝试了下inputmoodViewController的textView能够获取到啊。为何啊

// 开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。

#import "HomeViewController.h"
#import "InputMoodViewController.h"
#import "InputMoodPictureViewController.h"
#import "TextViewHelper.h"
#import "AppDelegate.h"

static NSString * const mood_bg_imageName = @"yellow_girl";

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *otherMoodTextView;
@property (weak, nonatomic) IBOutlet UIImageView *otherMoodBgImage;
@property (nonatomic, strong) InputMoodViewController *inputMoodVC;

@property (nonatomic, strong) UILabel *timeLB;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupMoodTextViewWithContent:@"说出去的，就随风而去吧!" TimeString:@"--Spider" backgroundImage:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark UI

// 生辰式编辑器
- (IBAction)inputMoodAction:(id)sender {
    InputMoodViewController *inputMoodVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"InputMoodViewController"];
    
    __weak typeof(self) weakSelf = self;
    inputMoodVC.finishMoodBlock = ^ {
        NSString *content = @"开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。";
        NSString *timeStr = @"二0一六年八月三十一日";
        [weakSelf setupMoodTextViewWithContent:content TimeString:timeStr backgroundImage:nil];
    };
    [self.navigationController pushViewController:inputMoodVC animated:YES];
//    [self showViewController:inputMoodVC sender:self];
}

// 海报式编辑器
- (IBAction)inputPictureMoodAction:(id)sender {
    InputMoodPictureViewController *inputPictureVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"InputPictureMoodViewController"];
    
    __weak typeof(self) weakSelf = self;
    inputPictureVC.finishPictureMoodBlock = ^{
        NSString *content = @"守静，向光，淡然。根紧握在地下，叶相触在云里。每一阵风过，我们都互相致意，但没有人能读懂我们的语言。";
        NSString *timeStr = @"二0一六年九月三日";
        UIImage *image = [UIImage imageNamed:@"green_girl"];
        [weakSelf setupMoodTextViewWithContent:content TimeString:timeStr backgroundImage:image];
    };
//    [self presentViewController:inputPictureVC animated:YES completion:nil];
    [self showDetailViewController:inputPictureVC sender:self];
}

- (void)setupMoodTextViewWithContent:(NSString *)content TimeString:(NSString *)timeStr backgroundImage:(UIImage *)image {
    // 设置背景图片
    if (image) self.otherMoodBgImage.image = image;
    
    if (content) {
        self.otherMoodTextView.text = content;
        self.otherMoodTextView.textColor = [UIColor whiteColor];
        self.otherMoodTextView.font = [UIFont fontWithName:@"Thonburi" size:14.0];
        
        // 设置文本的绘制区域
        CGFloat deadSpace = [self.otherMoodTextView bounds].size.height -  [TextViewHelper heightForTextView:self.otherMoodTextView];
        CGFloat inset = MAX(30, deadSpace/2.0-20.0);
        CGFloat leadingInset = 30;
        [self.otherMoodTextView setTextContainerInset:UIEdgeInsetsMake(inset, leadingInset, inset, leadingInset)];
        self.otherMoodTextView.textAlignment = NSTextAlignmentCenter;
    }
    
    // Mood时间
    CGRect otherMoodRect = [self.otherMoodTextView bounds];
    int leading = 8;
    int labelHeight = 36;
    if (!self.timeLB) {
        // 添加Mood时间LB
        self.timeLB = [[UILabel alloc] initWithFrame: CGRectMake(leading, otherMoodRect.origin.y + otherMoodRect.size.height - 8 - labelHeight, otherMoodRect.size.width - leading*2 - 40, labelHeight)];
        self.timeLB.textAlignment = NSTextAlignmentRight;
        self.timeLB.font = [UIFont fontWithName:@"Thonburi" size:14.0];
        self.timeLB.textColor = [UIColor whiteColor];
//        self.timeLB.font = self.otherMoodTextView.font;
//        self.timeLB.textColor = self.otherMoodTextView.textColor;
        [self.otherMoodTextView addSubview:self.timeLB];
    }
    
    if (timeStr) self.timeLB.text = timeStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
