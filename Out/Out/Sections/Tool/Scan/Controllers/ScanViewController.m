//
//  ScanViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//  如何实现很好的支持扫描二维码与一维码,两种思路：1是调整识别区域，2是动态修改识别类型(会在修改类型时，屏幕会闪烁以下。)
//  转场时将预览图层在本图层卸载后再回收， 但转场时本图层存在透明问题。通过设置viewDidDisappear才卸载preview图层，接近效果，但又出现了新问题，进入图层的时候会出现屏幕左侧透明右侧正常的问题.
//  还需优化： 1.扫描线; 2.一维码扫描灵明度； 20170315

#import "ScanViewController.h"
#import "ScanResultViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    NSTimer *timer;
}
@property (strong,nonatomic)AVCaptureDevice *device; // 捕捉设备
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
@property (weak, nonatomic) IBOutlet UIImageView *scanBox;
@property (nonatomic, assign) BOOL scaning;
@property (nonatomic, retain) UIImageView * line;
@end

@implementation ScanViewController
static CGFloat SCAN_X = 35;
static CGFloat SCAN_Y = 122;
static CGFloat SCAN_WIDTH = 0;
static CGFloat SCAN_HEIGHT = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SCAN_WIDTH = kAppWidth - 2*SCAN_X;
    SCAN_HEIGHT = kAppHeight - 2*SCAN_Y ;
    
    [self configView];
}

- (void)viewWillAppear:(BOOL)animated {
    //  需将原先的preview卸载后重新获取
    [self unloadPreviewLayer];
    [self startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopScan];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unloadPreviewLayer];
}
- (void)unloadPreviewLayer {
    [_preview removeFromSuperlayer];
    _preview = nil;
}

- (void)configView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫一扫";
    [self configScanView];
}

- (void)configScanView {
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCAN_WIDTH, 2)];
    _line.image = [UIImage imageNamed:@"scan_line.png"];
    [self.scanBox addSubview:_line];
}

- (BOOL)startScan
{
    _scaning = YES;
    NSError *error;
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanLineAnimation) userInfo:nil repeats:YES];
//    typeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeMetaObjectType) userInfo:nil repeats:YES];
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input 用设备创建输入流
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (!_input) {
        NSLog(@"创建输入流失败:%@", [error localizedDescription]);
        return NO;
    }
    
    // Output 输出流
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session 实例化捕捉会话
    _session = [[AVCaptureSession alloc]init];
    if (kAppHeight < 500) {
        [_session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    else {
        [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode二维码
    // 一定要先设置会话的输出为output之后，再指定输出的元数据类型！
    _output.metadataObjectTypes = [NSArray arrayWithObjects:
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeQRCode,
                                   nil];
//    _output.metadataObjectTypes = [self.output availableMetadataObjectTypes];

    //    AVCaptureDeviceFormat
    // 预览图层
    if (!_preview) {
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:self.preview atIndex:0];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock: ^(NSNotification *_Nonnull note) {
                                                      _output = self.session.outputs.firstObject;
//                                                      CGRect metadataRect = [_preview metadataOutputRectOfInterestForRect:CGRectMake(SCAN_X, SCAN_Y, SCAN_WIDTH, SCAN_HEIGHT)];
//                                                      NSLog(@"meta:%@", NSStringFromCGRect(metadataRect));
                                                  }];
    
    // 设置识别范围
    if (_session.sessionPreset == AVCaptureSessionPreset1920x1080) {
        // m1
        CGFloat fixHeight = kAppWidth * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - kAppHeight)/2;
        _output.rectOfInterest = CGRectMake((SCAN_Y + fixPadding)/fixHeight,
                                                  SCAN_X/kAppWidth,
                                                  SCAN_HEIGHT/fixHeight,
                                                  SCAN_WIDTH/kAppWidth);
        // m2
//        CGFloat p1 = kAppHeight / kAppWidth;
//        CGFloat p2 = 1920. / 1080.;
//        CGFloat fixWidth = kAppWidth * p1 / p2;
//        CGFloat padding = (fixWidth - kAppWidth)/2;// 为负值
//        CGRect myRect =  CGRectMake(0, (fixWidth - SCAN_X - SCAN_WIDTH - padding)/fixWidth, SCAN_HEIGHT/kAppHeight+0.3, SCAN_WIDTH/fixWidth);
//        _output.rectOfInterest = myRect;
        NSLog(@"selfset:%@", NSStringFromCGRect(_output.rectOfInterest));
    } else if (_session.sessionPreset == AVCaptureSessionPreset640x480) {
        CGFloat p1 = kAppHeight / kAppWidth;
        CGFloat p2 = 640 / 480.;
        CGFloat fixWidth = kAppWidth * p1 / p2;
        CGFloat padding = (fixWidth - kAppWidth)/2;// 为负值
//        CGRect myRect =  CGRectMake(SCAN_Y/kAppHeight, (fixWidth - SCAN_X - SCAN_WIDTH - padding)/fixWidth, SCAN_HEIGHT/kAppHeight, SCAN_WIDTH/fixWidth);
        CGRect myRect =  CGRectMake(SCAN_Y/kAppHeight/2, (fixWidth - SCAN_X - SCAN_WIDTH - padding)/fixWidth, SCAN_HEIGHT/kAppHeight+SCAN_Y/kAppHeight, SCAN_WIDTH/fixWidth);
        _output.rectOfInterest = myRect;
        NSLog(@"selfset:%@", NSStringFromCGRect(myRect));
    }
    
    [_session startRunning];
    
    
    return YES;
}

- (void)stopScan {
    _scaning = NO;
    [_session stopRunning];
    _session = nil;
    // 关闭定时器
    [timer invalidate];
    timer = nil;
}

-(void)scanLineAnimation {
    // 上下上下
    CGRect frame = _line.frame;
    if (_line.frame.origin.y ==  SCAN_HEIGHT) {
        frame.origin.y = 0;
        _line.frame = frame;
    } else {
        frame.origin.y += 3;
        _line.frame = frame;
    }
}

- (void)changeMetaObjectType {
    if ([_output.metadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        // 设置成一维码识别类型
        [_output setMetadataObjectTypes: [NSArray arrayWithObjects:
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode128Code,
                                       nil]];
    } else {
        // 设置成二维码
        [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue = nil;
    
    // 判断是否有数据
    if ([metadataObjects count] >0) {
        [JYProgressHUD showTextHUDWithDetailString:@"识别" AddedTo:self.view];
//        [self stopScan];
//        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
//        stringValue = metadataObject.stringValue;
//        ScanResultViewController *vc = [ScanResultViewController new];
//        vc.resultString = stringValue;
//        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [timer invalidate];
    timer = nil;
}
@end
