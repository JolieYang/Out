//
//  ScanDemoViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/15.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "ScanDemoViewController.h"
#import "ScanResultViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanDemoViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    NSTimer *timer;
    NSTimer *typeTimer;
}
@property (strong,nonatomic)AVCaptureDevice *device; // 捕捉设备
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, assign) BOOL scaning;
@property (nonatomic, retain) UIImageView * line;
@end

@implementation ScanDemoViewController
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
    self.title = @"扫一扫";
    [self configScanView];
}

- (void)configScanView {
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCAN_WIDTH, 2)];
    _line.image = [UIImage imageNamed:@"scan_line.png"];
}

- (BOOL)startScan
{
    _scaning = YES;
    NSError *error;
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
    _output.metadataObjectTypes = [NSArray arrayWithObjects:
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeQRCode,
                                   nil];
    // 设置识别范围
    if (_session.sessionPreset == AVCaptureSessionPreset1920x1080) {
        CGFloat p1 = kAppHeight / kAppWidth;
        CGFloat p2 = 1920. / 1080.;
        if (p1 < p2) {
            CGFloat fixHeight = kAppWidth * p2;
            CGFloat fixHeightPadding = (fixHeight - kAppHeight) / 2;
            _output.rectOfInterest = CGRectMake((SCAN_Y + fixHeightPadding)/fixHeight, SCAN_X/kAppWidth, SCAN_HEIGHT/fixHeight, SCAN_WIDTH/kAppWidth);
        }
    } else {
        _output.rectOfInterest = CGRectMake(SCAN_Y/kAppHeight, SCAN_X/kAppWidth, SCAN_HEIGHT/kAppHeight, SCAN_WIDTH/kAppWidth);
        
    }
    //    AVCaptureDeviceFormat
    // 预览图层
    if (!_preview) {
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = self.view.frame;
        [self.view.layer insertSublayer:self.preview atIndex:0];
    }
    
    [_session startRunning];
    
    return YES;
}

- (void)stopScan {
    _scaning = NO;
    [_session stopRunning];
    _session = nil;
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
        [self stopScan];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        ScanResultViewController *vc = [ScanResultViewController new];
        vc.resultString = stringValue;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
