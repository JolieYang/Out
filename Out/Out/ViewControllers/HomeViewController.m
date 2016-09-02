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

// Questin LIST:
// 1. 该页面的获取otherMoodTextView的textColor和font为nil,尝试了下inputmoodViewController的textView能够获取到啊。为何啊

// 开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。

#import "HomeViewController.h"
#import "InputMoodViewController.h"
#import "InputMoodPictureViewController.h"


static NSString * const mood_bg_imageName = @"yellow_girl";

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *otherMoodTextView;
@property (weak, nonatomic) IBOutlet UIImageView *otherMoodBgImage;
@property (nonatomic, strong) InputMoodViewController *inputMoodVC;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @" ";
    [self setupMoodTextView];
    self.otherMoodTextView.hidden = YES;
    self.otherMoodBgImage.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (IBAction)inputMoodAction:(id)sender {
    InputMoodViewController *inputMoodVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"InputMoodViewController"];
    
    __weak typeof(self) weakSelf = self;
    inputMoodVC.finishMoodBlock = ^(NSString *date) {
        weakSelf.otherMoodTextView.hidden = NO;
        weakSelf.otherMoodBgImage.hidden = NO;
    };
    [self.navigationController pushViewController:inputMoodVC animated:YES];
}
// 海报式编辑器
- (IBAction)inputPictureMoodAction:(id)sender {
    InputMoodPictureViewController *inputPictureVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"InputPictureMoodViewController"];
    [self.navigationController pushViewController:inputPictureVC animated:YES];
//    [self.navigationController presentViewController:inputPictureVC animated:YES completion:nil];
//    [self.navigationController showViewController:inputPictureVC sender:self];
}

- (void)setupMoodTextView {
    // 设置背景图片
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame: [self.otherMoodTextView bounds]];
//    imageView.image = [UIImage imageNamed: mood_bg_imageName];
//    [self.otherMoodTextView addSubview:imageView];
//    [self.otherMoodTextView sendSubviewToBack:imageView];
    
    // Mood时间
    CGRect otherMoodRect = [self.otherMoodTextView bounds];
    int leading = 8;
    int labelHeight = 36;
    UILabel *timeLB = [[UILabel alloc] initWithFrame: CGRectMake(leading, otherMoodRect.origin.y + otherMoodRect.size.height - 8 - labelHeight, otherMoodRect.size.width - leading*2, labelHeight)];
    timeLB.textAlignment = NSTextAlignmentRight;
    timeLB.text = @"二0一六年八月三十一日";
//    timeLB.font = self.otherMoodTextView.font;
    timeLB.font = [UIFont fontWithName:@"Thonburi" size:14.0];
//    timeLB.textColor = self.otherMoodTextView.textColor;
    timeLB.textColor = [UIColor whiteColor];
    [self.otherMoodTextView addSubview:timeLB];
    
    // 设置文本的绘制区域
    CGFloat deadSpace = [self.otherMoodTextView bounds].size.height -  [self.otherMoodTextView contentSize].height;
    CGFloat inset = MAX(0, deadSpace/2.0);
    CGFloat leadingInset = 30;
    [self.otherMoodTextView setTextContainerInset:UIEdgeInsetsMake(inset, leadingInset, inset, leadingInset)];
    
    // m2
//    UITextView *tv = self.otherMoodTextView;
//    CGFloat leadingInset = 30;
//    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height*[tv zoomScale])/2.0;
//    [self.otherMoodTextView setTextContainerInset:UIEdgeInsetsMake(topCorrect, leadingInset, 0, leadingInset)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end