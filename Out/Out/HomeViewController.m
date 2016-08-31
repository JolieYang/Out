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
// 3. 调整文本的显示位置 ,左右各距离20px,垂直居中，水平居中显示。
// 4.[done] 在textView的右下角显示mood写下的时间

// Questin LIST:
// 1. 该页面的获取otherMoodTextView的textColor和font为nil,尝试了下inputmoodViewController的textView能够获取到啊。为何啊


#import "HomeViewController.h"
#import "InputMoodViewController.h"


static NSString * const mood_bg_imageName = @"yellow_girl";

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *otherMoodTextView;
@property (nonatomic, strong) InputMoodViewController *inputMoodVC;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @" ";
    [self setupMoodTextView];
    self.otherMoodTextView.hidden = YES;
}


- (void)setupMoodTextView {
    // 设置背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: [self.otherMoodTextView bounds]];
    imageView.image = [UIImage imageNamed: mood_bg_imageName];
    [self.otherMoodTextView addSubview:imageView];
    [self.otherMoodTextView sendSubviewToBack:imageView];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)inputMoodAction:(id)sender {
    InputMoodViewController *inputMoodVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"InputMoodViewController"];
    
    __weak typeof(self) weakSelf = self;
    inputMoodVC.finishMoodBlock = ^(NSString *date) {
        weakSelf.otherMoodTextView.hidden = NO;
    };
//    [self performSegueWithIdentifier:@"jumpToInputMood" sender:self];
    [self.navigationController pushViewController:inputMoodVC animated:YES];
}

@end
