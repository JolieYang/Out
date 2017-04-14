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
// 12. 使用应用提供图片，则不做图片上传处理，直接获取图片id。

// Questin LIST:
// ?1. 进入该页面使用的是"show detail"相当于什么，不是push,present. 离开该页面是应该如何. Answer: 模态 presentViewController:animated:completion。所以是present，只是之前是将[self.navigationController 调用该方法所以失败，应该是将本身的控制器发消息给presentViewController。 资料：https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/UsingSegues.html
// ?2. 手势方向只能支持上下或者左右，不能同时支持上下左右，但没道理啊，不知道哪里出了问题.
// UI:
// 按钮图标  44 @2x #fff
#import "InputMoodPictureViewController.h"
#import "OutHomeViewController.h"
#import "OutAlertViewController.h"
#import "JYProgressHUD.h"
#import "OutAPIManager.h"
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
        [JYProgressHUD showTextHUDWithDetailString:@"文字超出100字限制" AddedTo:self.view];
        return;
    }
    // 判断字符非空
    if ([StringHelper length:self.inputTextView.text] == 0) {
        // 正常是不会进入这里
        [JYProgressHUD showTextHUDWithDetailString:@"程序跑到火星去了吧" AddedTo:self.view];
        return;
    }
    // 回收键盘
    [self.inputTextView resignFirstResponder];
    [JYProgressHUD showIndicatorHUDWithDetailString:@"正在发布" AddedTo:self.view animated:YES];
    [OutAPIManager uploadImage:self.inputImageView.image succeed:^(NSString *photoId) {
        NSString *apiName = @"mind";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.inputTextView.text forKey:@"content"];
        [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:OUT_TOKEN] forKey:@"token"];
        [params setValue:photoId forKey:@"photoId"];
        [OutAPIManager startRequestWithApiName:apiName params:params successed:^(NSDictionary *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_finishPictureMoodBlock) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    _finishPictureMoodBlock(response);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } failed:^(NSString *errMsg) {
            [JYProgressHUD changeToTextHUDWithDetailString:@"发布失败" AddedTo:self.view];
        }];
    } failed:^(NSString *errMsg) {
        [JYProgressHUD changeToTextHUDWithDetailString:@"上传图片失败" AddedTo:self.view];
    }];
}

// 从系统相册选择背景图片
- (IBAction)choosePictureAction:(id)sender {
    // UIImagePickerControllerDelegate
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        // 无图片访问权限 "请在iPhone的“设置-隐私-照片"选项中，允许微信访问你的手机相册"
        [JYProgressHUD showLongerTextHUDWithString:@"请在iPhone的“设置-隐私-照片“选项中，允许Out访问你的手机相册" AddedTo:self.view];
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
//    CGFloat space = [self.inputTextView bounds].size.height - [TextViewHelper heightForTextView:self.inputTextView];
    CGFloat space = [[UIScreen mainScreen] bounds].size.width - [TextViewHelper heightForTextView:self.inputTextView];
    CGFloat verticalInset = MAX(30, space/2.0);
    CGFloat horizontalInset = 30;
    [self.inputTextView setTextContainerInset:UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)];
}



@end