//
//  InputMoodPictureViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/9/1.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "InputMoodPictureViewController.h"
#import "OutHomeViewController.h"
#import "OutAlertViewController.h"
#import "JYProgressHUD.h"
#import "OutMoodManager.h"
#import "OutMood.h"
#import "StringHelper.h"
#import "TextViewHelper.h"
#import "DateHelper.h"
#import "OutImageView.h"
#import "UIImageView+WebCache.h"
#import "const.h"
#import <Photos/Photos.h>

// 访问相册图片
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InputMoodPictureViewController ()<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,PHPhotoLibraryChangeObserver>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@property (weak, nonatomic) IBOutlet UIImageView *inputImageView;

@property (weak, nonatomic) IBOutlet OutImageView *firstImageView;
@property (weak, nonatomic) IBOutlet OutImageView *secondImageView;
@property (weak, nonatomic) IBOutlet OutImageView *thirdImageView;

@property (nonatomic, strong) UILabel *placeHolderLB;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UICollectionView *photoCollectionView;

@property (nonatomic, strong) UIGestureRecognizer *tap;
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipe;

@end

@implementation InputMoodPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    self.inputTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

#pragma mark PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_sync(dispatch_get_main_queue(), ^{
        // 对UI进行更新
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 点击返回上一级界面按钮
- (IBAction)backAction:(id)sender {
    [self.inputTextView resignFirstResponder];
    UIAlertController *giveupEditAlert = [OutAlertViewController giveUpEditWithOkHandler:^(UIAlertAction *action) {
        //  确定离开该页面
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:giveupEditAlert animated:YES completion:nil];
}
// 完成编辑发布心情
- (IBAction)didEndEditAction:(id)sender {
    // 判断字数是否超出限制
    if ([StringHelper length:self.inputTextView.text] > 100) {
        [JYProgressHUD showNormalTextHUDWithDetailContent:@"文字超出100字限制" AddedTo:self.view completion: nil];
        return;
    }
    // 判断字符非空
    if ([StringHelper length:self.inputTextView.text] == 0) {
        // 正常是不会进入这里
        [JYProgressHUD showNormalTextHUDWithDetailContent:@"程序跑到火星去了吧" AddedTo:self.view completion: nil];
        return;
    }
    // 回收键盘
    [self.inputTextView resignFirstResponder];
    
    [self addMood];
}

- (void)addMood {
    if (!ENABLE_SERVER) {
        OutMood *mood = [OutMoodManager addOutMoodWithContent:self.inputTextView.text image:self.inputImageView.image];
        [JYProgressHUD showQuicklyTextHUDWithDetailContent:@"发布成功" AddedTo:self.view completion:^{
            if (_finishPictureMoodBlock) {
                _finishPictureMoodBlock(mood);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

// 从系统相册选择背景图片
- (IBAction)choosePictureAction:(id)sender {
    // UIImagePickerControllerDelegate
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        // 无图片访问权限 "请在iPhone的“设置-隐私-照片"选项中，允许微信访问你的手机相册"
        [JYProgressHUD showLongerTextHUDWithContent:@"请在iPhone的“设置-隐私-照片“选项中，允许Out访问你的手机相册" AddedTo:self.view completion: nil];
    } else {
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

#pragma mark Photos


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UI-Config
// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)setupViews {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self setupDefaultImage];
        [self setupImagePicker];
    });
    [self setupInputTextView];
}
// 配置默认图片: 从服务器获取三张默认图片
- (void)setupDefaultImage {
    NSMutableArray *defaultPhotoArray = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        NSString *photoStr = [kPHOTO_DEFAULT stringByAppendingFormat:@"%d", i];
        [defaultPhotoArray addObject:photoStr];
    }
    [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:defaultPhotoArray[0]] placeholderImage:nil];
    [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:defaultPhotoArray[1]] placeholderImage:nil];
    [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:defaultPhotoArray[2]] placeholderImage:nil];
}
// 配置textView
- (void)setupInputTextView {
    // 设置placeholder
    self.placeHolderLB = [[UILabel alloc] initWithFrame:CGRectMake(30, [[UIScreen mainScreen] bounds].size.width/2.0 - 23, [self.inputTextView bounds].size.width - 60, 30)];
    self.placeHolderLB.text = @"想说点什么呢?";
    self.placeHolderLB.textColor = [UIColor whiteColor];
    self.placeHolderLB.textAlignment = NSTextAlignmentCenter;
    self.placeHolderLB.font = self.inputTextView.font;
    [self.inputTextView addSubview:self.placeHolderLB];
    
    // 设置光标颜色
    self.inputTextView.tintColor = [UIColor whiteColor];
    // 调整编辑光标所在位置
    [self adjustInputMoodText];
    
    //  隐藏发布按钮
    self.outBtn.hidden = YES;
    
    
    [self.firstImageView tapGestureWithBlock:^{
        self.inputImageView.image = self.firstImageView.image;
    }];
    [self.secondImageView tapGestureWithBlock:^{
        self.inputImageView.image = self.secondImageView.image;
    }];
    [self.thirdImageView tapGestureWithBlock:^{
        self.inputImageView.image = self.thirdImageView.image;
    }];
}

- (void)setupImagePicker {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePickerController.allowsEditing = YES;
}

- (void)didEndShowKeyboard:(NSNotification *)notification {
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    // ?2
//    self.swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    self.swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.inputTextView addGestureRecognizer:self.swipe];
    [self.inputTextView addGestureRecognizer:self.tap];
}
- (void)hideKeyboard {
    [self.inputTextView removeGestureRecognizer:self.tap];
    [self.inputTextView resignFirstResponder];
}

// 输入文字隐藏placeHolder与显示发布按钮
- (void)didEnterText {
    self.placeHolderLB.hidden = YES;
    self.outBtn.hidden = NO;
}
// 无输入内容则显示placeHolder与隐藏发布按钮
- (void)didEnterEmpty {
    self.placeHolderLB.hidden = NO;
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
    int length = [StringHelper length:textView.text] - (floor)([StringHelper length:newText]/2.0);
    if (length > 100) {
        // 弹窗提醒“文字超出长度限制"
    }
    if (newText.length == 0 && self.inputTextView.text.length == 0) {
        [self didEnterEmpty];
    }
    if (length == 1) {
        [self didEnterText];
    }
    [self adjustInputMoodText];
}

// 点击提示栏上的字不会进入该回调
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (textView.text.length == 0 && text.length > 0) {
        [self didEnterText];
    }
    NSString *resultStr = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if ([StringHelper length:resultStr] > 100) {
        [OutAlertViewController lenghtExceedLimit];
    }
    return YES;
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    self.inputImageView.image = image;
}
// choose
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        self.inputImageView.image = info[UIImagePickerControllerEditedImage];
    }else{
        NSURL *url = info[UIImagePickerControllerMediaURL];

        NSString *urlStr = [url path];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            }
        });
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
// cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Tool
- (void)adjustInputMoodText {
//    CGFloat space = [self.inputTextView bounds].size.height - [TextViewHelper heightForTextView:self.inputTextView];
    CGFloat space = [[UIScreen mainScreen] bounds].size.width - [TextViewHelper heightForTextView:self.inputTextView];
    CGFloat verticalInset = MAX(30, space/2.0);
    CGFloat horizontalInset = 30;
    [self.inputTextView setTextContainerInset:UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)];
}



@end
