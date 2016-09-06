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
// 1.[done] 点击右下角按钮相关处理:选择相册图片
// 2.[done] 修改背景图片
// 3.[done] 输入文本,文本是居中显示 Q1:[done] 第一行是居中显示，但距离上面的距离是固定的，也就是计算textView的高度时，高度不会随着行数的改变而改变
// 4.[done] 隐藏导航栏
// 5.[done] textView编辑状态的光标颜色设为白色
// 6.[done] textView编辑状态的光标调整成跟placeHolder同一水平线
// 7. 进入该页面，是从底下往上显示，即show detail效果
// 8.[done] 点击左上角按钮相关处理
// 9.[done] 点击右上角按钮逻辑处理
// 10.[done] 图标替换
// 11.[done][ing] 回收键盘: version1: 点击return按钮

// Questin LIST:
// ?1. 进入该页面使用的是"show detail"相当于什么，不是push,present. 离开该页面是应该如何. Answer: 模态 presentViewController:animated:completion。所以是present，只是之前是将[self.navigationController 调用该方法所以失败，应该是将本身的控制器发消息给presentViewController。 资料：https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/UsingSegues.html

// UI:
// 按钮图标  44 @2x #fff
#import "InputMoodPictureViewController.h"
#import "HomeViewController.h"
#import "OutAlertViewController.h"
#import "StringHelper.h"
#import "TextViewHelper.h"
#import "OutImageView.h"

// 访问相册图片
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InputMoodPictureViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@property (weak, nonatomic) IBOutlet UIImageView *inputImageView;

@property (weak, nonatomic) IBOutlet OutImageView *firstImageView;
@property (weak, nonatomic) IBOutlet OutImageView *secondImageView;
@property (weak, nonatomic) IBOutlet OutImageView *thirdImageView;

@property (nonatomic, strong) UILabel *placeHolderLB;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation InputMoodPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupInputTextView];
    [self setupImagePicker];
    self.inputTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
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
        UIAlertController *alertController = [OutAlertViewController lenghtExceedLimit];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    // TODO: 连接后台发布Out
    // ...
    if (_finishPictureMoodBlock && [StringHelper length:self.inputTextView.text] > 0) {
        _finishPictureMoodBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 从系统相册选择背景图片
- (IBAction)choosePictureAction:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Config
// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}
// 配置textView
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
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePickerController.allowsEditing = YES;
}

- (void)didEndShowKeyboard:(NSNotification *)notification {
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.inputTextView addGestureRecognizer:self.tap];
}

- (void)hideKeyboard {
    [self.inputTextView removeGestureRecognizer:self.tap];
    [self.inputTextView resignFirstResponder];
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
    int length = [StringHelper length:textView.text] - (floor)(newText.length/2.0);
    if (length > 100) {
        // 弹窗提醒“文字超出长度限制"
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
        self.placeHolderLB.hidden = YES;
        self.outBtn.hidden = NO;
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
        //压缩图片
//        NSData *fileData = UIImageJPEGRepresentation(self.inputImageView.image, 1.0);
        //保存图片至相册
//        UIImageWriteToSavedPhotosAlbum(self.inputImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //上传图片
//        [self uploadImageWithData:fileData];
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //播放视频
//        _moviePlayer.contentURL = url;
//        [_moviePlayer play];
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                
//                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
//        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //视频上传
//        [self uploadVideoWithData:videoData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
// cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Tool
- (void)adjustInputMoodText {
    CGFloat space = [self.inputTextView bounds].size.height - [TextViewHelper heightForTextView:self.inputTextView];
    CGFloat verticalInset = MAX(30, space/2.0);
    CGFloat horizontalInset = 30;
    [self.inputTextView setTextContainerInset:UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)];
}



@end
