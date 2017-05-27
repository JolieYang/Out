//
//  ViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "OutHomeViewController.h"
#import "InputMoodViewController.h"
#import "InputMoodPictureViewController.h"
#import "TargetHomeViewController.h"
#import "OutMoodManager.h"
#import "OutMood.h"
#import "JYProgressHUD.h"
#import "MFLHintLabel.h"
#import "TextViewHelper.h"
#import "DateHelper.h"
#import "AppDelegate.h"
#import "const.h"
#import "UIImageView+WebCache.h"

static CGFloat const WIND_DELAY = 37.0;

@interface OutHomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *otherMoodTextView;
@property (weak, nonatomic) IBOutlet UIImageView *otherMoodBgImage;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) InputMoodViewController *inputMoodVC;

@property (nonatomic, strong) MFLHintLabel *timeLB;
@property (nonatomic, strong) MFLHintLabel *contentLB;
@property (nonatomic, strong) UILabel *defaultTimeLB;

@end

@implementation OutHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark Action
// 生辰式编辑器
- (IBAction)inputMoodAction:(id)sender {
    InputMoodViewController *inputMoodVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"InputMoodViewController"];
    inputMoodVC.hidesBottomBarWhenPushed = YES;
    __weak typeof(self) weakSelf = self;
    inputMoodVC.finishMoodBlock = ^(OutMood *mood){
        [weakSelf showRandomMood:mood];
    };
    [self.navigationController pushViewController:inputMoodVC animated:YES];
}

// 海报式编辑器
- (IBAction)inputPictureMoodAction:(id)sender {
    InputMoodPictureViewController *inputPictureVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"InputPictureMoodViewController"];
    
    __weak typeof(self) weakSelf = self;
    inputPictureVC.finishPictureMoodBlock = ^(OutMood *mood) {
        [weakSelf showRandomMood:mood];
    };
    [self presentViewController:inputPictureVC animated:YES completion:nil];
}

// Gone With The Wind
- (IBAction)testAnimationAction:(id)sender {
    OutMood *mood = [OutMoodManager getRandomOutMood];
    [self showRandomMood:mood];
}

#pragma mark UI-Config
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)setupViews {
    self.otherMoodBgImage.clipsToBounds = YES;
    self.otherMoodBgImage.contentMode = UIViewContentModeScaleAspectFill;
    [self configDefaultTextView];
}

#pragma mark UI-Update
- (void)showRandomMood:(OutMood *)mood {
    if (!mood) {
        [JYProgressHUD showNormalTextHUDWithDetailContent:@"你还没跟心情树洞说过话，快去说说吧" AddedTo:self.view completion:nil];
        return;
    }
    
    NSString *timeStr = [DateHelper ChineseYearMonthDayWithTimeInterval:mood.createTime];
    if (mood.backgroundImage) {
        [self setupMoodTextViewWithContent:mood.content TimeString:timeStr backgroundImage:mood.backgroundImage];
    } else {
        [self setupMoodTextViewWithContent:mood.content TimeString:timeStr backgroundImage:OUT_DEFAULT_BGIMAGE];
    }
}

- (void)configDefaultTextView {
    [self setupMoodTextViewWithContent:@"说出去的，就随风而去吧!" TimeString:@"--Spider" backgroundImage:OUT_DEFAULT_BGIMAGE];
}

- (void)setupMoodTextViewWithContent:(NSString *)content TimeString:(NSString *)timeStr backgroundImage:(UIImage *)image {
    [self setDefaultContent:content];
    [self setDefaultTimeLBString:timeStr];
    self.otherMoodBgImage.image = image;
}
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
//    CGFloat deadSpace = [self.otherMoodTextView bounds].size.height -  [TextViewHelper heightForTextView:self.otherMoodTextView];
    CGFloat deadSpace = [[UIScreen mainScreen] bounds].size.width -  [TextViewHelper heightForTextView:self.otherMoodTextView];
//    CGFloat inset = MAX(30, deadSpace/2.0-20.0);
    CGFloat inset = MAX(30, deadSpace/2.0);
    CGFloat leadingInset = 30;
    [self.otherMoodTextView setTextContainerInset:UIEdgeInsetsMake(inset, leadingInset, inset, leadingInset)];
    self.otherMoodTextView.textAlignment = NSTextAlignmentCenter;
}


#pragma mark Animation
// 开启定时器，5s后随风而去了
- (void)goneWithTheWind:(NSString *)content TimeString:(NSString *)timeStr backgroundImage:(UIImage *)image{
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
            [self configDefaultTextView];
        }];
    }
}


@end
