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
#import "OutProgressHUD.h"
#import "TextViewHelper.h"
#import "DateHelper.h"
#import "AppDelegate.h"
#import "OutAPIManager.h"
#import "const.h"
#import "MFLHintLabel.h"

static NSString * const mood_bg_imageName = @"yellow_girl";
static CGFloat const WIND_DELAY = 3.0;

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *otherMoodTextView;
@property (weak, nonatomic) IBOutlet UIImageView *otherMoodBgImage;
@property (nonatomic, strong) InputMoodViewController *inputMoodVC;

@property (nonatomic, strong) MFLHintLabel *timeLB;
@property (nonatomic, strong) MFLHintLabel *contentLB;

@property (nonatomic, strong) UILabel *defaultTimeLB;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.otherMoodBgImage.image = nil;
    [self setupMoodTextViewWithContent:@"说出去的，就随风而去吧!" TimeString:@"--Spider" backgroundImage:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    inputMoodVC.finishMoodBlock = ^(NSDictionary *response){
//        NSString *content = @"开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。开始在内心生活得更严肃的人，也会在外表上开始生活得更朴素。";
//        NSString *timeStr = @"二0一六年八月三十一日";
        NSString *content = [response valueForKey:@"content"];
        NSString *timeStr = [response valueForKey:@"createtime"];
        timeStr = [DateHelper customeDateStr:timeStr];
        NSString *photoId = [response valueForKey:@"photoId"];
        if (photoId) {
            NSLog(@"存在photoId");
            // 设置背景图片
            [OutAPIManager downloadImageWithPhotoID:photoId completionHandler:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf goneWithTheWind:content TimeString:timeStr backgroundImage: image];
                });
            }];
        } else {
            [weakSelf goneWithTheWind:content TimeString:timeStr backgroundImage: nil];
        }
    };
    [self.navigationController pushViewController:inputMoodVC animated:YES];
//    [self showViewController:inputMoodVC sender:self];
}

// 海报式编辑器
- (IBAction)inputPictureMoodAction:(id)sender {
    InputMoodPictureViewController *inputPictureVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"InputPictureMoodViewController"];
    
    __weak typeof(self) weakSelf = self;
    inputPictureVC.finishPictureMoodBlock = ^(NSDictionary *data) {
//        NSString *content = @"守静，向光，淡然。根紧握在地下，叶相触在云里。每一阵风过，我们都互相致意，但没有人能读懂我们的语言。";
//        NSString *timeStr = @"二0一六年九月三日";
//        UIImage *image = [UIImage imageNamed:@"green_girl"];
        NSString *content = [data valueForKey:@"content"];
        NSString *timeStr = [data valueForKey:@"createtime"];
        timeStr = [DateHelper customeDateStr:timeStr];
        NSString *photoId = [data valueForKey:@"photoId"];
        if (photoId) {
            [OutAPIManager downloadImageWithPhotoID:photoId completionHandler:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf goneWithTheWind:content TimeString:timeStr backgroundImage:image];
            
                });
            }];    
        } else {
            [weakSelf goneWithTheWind:content TimeString:timeStr backgroundImage:nil];
        }
    };
//    [self presentViewController:inputPictureVC animated:YES completion:nil];
    [self showDetailViewController:inputPictureVC sender:self];
}

- (IBAction)testAnimationAction:(id)sender {
//    NSString *content = @"守静，向光，淡然。根紧握在地下，叶相触在云里。每一阵风过，我们都互相致意，但没有人能读懂我们的语言。";
//    NSString *timeStr = @"二0一六年九月三日";
//    [self goneWithTheWind:content TimeString:timeStr backgroundImage:nil];
    
//    [OutProgressHUD showHUDDetailString:@"正在发布" AddedTo:self.view animated:YES];
    
}





- (void)setupMoodTextViewWithContent:(NSString *)content TimeString:(NSString *)timeStr backgroundImage:(UIImage *)image {
    [self setDefaultContent:content];
    [self setDefaultTimeLBString:timeStr];
    if (image) {
        self.otherMoodBgImage.image = image;
    }
}



#pragma mark Default_UI
- (void)setDefaultTimeLBString:(NSString *)timeStr {
    CGRect otherMoodRect = [self.otherMoodTextView bounds];
    int leading = 8;
    int labelHeight = 36;
    if (!self.defaultTimeLB) {
        // 添加Mood时间LB
        self.defaultTimeLB = [[UILabel alloc] initWithFrame: CGRectMake(leading, otherMoodRect.origin.y + otherMoodRect.size.height - 8 - labelHeight, otherMoodRect.size.width - leading*2 - 40, labelHeight)];
        self.defaultTimeLB.textAlignment = NSTextAlignmentRight;
        self.defaultTimeLB.font = [UIFont fontWithName:@"Thonburi" size:14.0];
        self.defaultTimeLB.textColor = [UIColor whiteColor];
//        self.defaultTimeLB.font = self.otherMoodTextView.font;
//        self.defaultTimeLB.textColor = self.otherMoodTextView.textColor;
        self.defaultTimeLB.text = timeStr;
        [self.otherMoodTextView addSubview:self.defaultTimeLB];
    } else {
        self.defaultTimeLB.text = timeStr;
    }
}

- (void)setDefaultContent:(NSString *)content {
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

#pragma mark Tool

#pragma mark Animation
// 开启定时器，5s后随风而去了
- (void)goneWithTheWind:(NSString *)content TimeString:(NSString *)timeStr backgroundImage:(UIImage *)image{
    [self setupMoodTextViewWithContent:nil TimeString:nil backgroundImage:nil];
    int OnHeight = 0; // 300
    // 设置背景图片
    if (image) self.otherMoodBgImage.image = image;
    
    if (content) {
        // 设置文本的绘制区域
        CGFloat deadSpace = [self.otherMoodTextView bounds].size.height -  [TextViewHelper heightForTextView:self.otherMoodTextView];
        CGFloat inset = MAX(30, deadSpace/2.0-20.0);
        CGFloat leadingInset = 30;
        
        // 绘制动画contentLB
        self.contentLB.textColor = [UIColor whiteColor];
        CGFloat x = [self.otherMoodTextView bounds].origin.x + leadingInset;
        CGFloat y = [self.otherMoodTextView bounds].origin.y + inset;
        self.contentLB = [[MFLHintLabel alloc] createHintAnimationForText:content withFont:[UIFont fontWithName:@"Thonburi" size:14.0] beginningAt:CGPointMake(x, y-OnHeight) displayingAt:CGPointMake(x, y) endingAt:CGPointMake(x, y+370) inTargetView:self.otherMoodTextView];
        [self.contentLB setAnimateOnType:kMFLAnimateOnLinear];
        [self.contentLB setAnimateOffType:kMFLAnimateOffLinear];
        [self.contentLB setDuration:1];
        [self.contentLB setDisplayTime:WIND_DELAY];
        [self.contentLB setPhaseDelayTimeIn:.05];
        [self.contentLB setPhaseDelayTimeOut:.05];
        [self.contentLB setCharactersToMoveSimultaneouslyIn:4];
        [self.contentLB setCharactersToMoveSimultaneouslyOut:2];
        [self.contentLB prepareToRun];
        [self.contentLB run];
//        [self.contentLB runWithCompletion:^{
//            [self setupMoodTextViewWithContent:@"说出去的，就随风而去吧!" TimeString:@"--Spider" backgroundImage: nil];
//        }];
    }
    
    // Mood时间
    CGRect otherMoodRect = [self.otherMoodTextView bounds];
    int leading = 8;
    int labelHeight = 36;
    
    if (timeStr) {
        leading = leading + 60;
        self.timeLB.textColor = [UIColor whiteColor];
        CGFloat y = otherMoodRect.origin.y + otherMoodRect.size.height - 8 - labelHeight;
        self.timeLB = [[MFLHintLabel alloc] createHintAnimationForText:timeStr withFont:[UIFont fontWithName:@"Thonburi" size:14.0] beginningAt:CGPointMake(leading, y-OnHeight) displayingAt:CGPointMake(leading, y) endingAt:CGPointMake(leading, y+170) inTargetView:self.otherMoodTextView];
        self.timeLB.textColor = [UIColor whiteColor];
        [self.timeLB setAnimateOnType:kMFLAnimateOnLinear];
        [self.timeLB setAnimateOffType:kMFLAnimateOffLinear];
        
        [self.timeLB setTweakLineheight:6];
        
        // 设置显示时间
        [self.timeLB setDisplayTime: WIND_DELAY];
        
        [self.timeLB setPhaseDelayTimeIn: .05];
        [self.timeLB setPhaseDelayTimeOut:.1];
        
        [self.timeLB setCharactersToMoveSimultaneouslyIn:2];
        [self.timeLB setCharactersToMoveSimultaneouslyOut:1];
        
        [self.timeLB prepareToRun];
//        [self.timeLB run];
        [self.timeLB runWithCompletion:^{
            [self setupMoodTextViewWithContent:@"说出去的，就随风而去吧!" TimeString:@"--Spider" backgroundImage: nil];
        }];
    }
}

@end
