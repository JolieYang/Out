//
//  ScanViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanResultViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer *timer;
}
@property (strong,nonatomic)AVCaptureDevice *device; // 捕捉设备
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
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
    self.title = @"扫一扫";
}

- (void)viewWillAppear:(BOOL)animated {
    [self startScan];
}
- (void)configScanView {
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(SCAN_X, SCAN_Y, SCAN_WIDTH, 2)];
    _line.image = [UIImage imageNamed:@"scan_line"];
    [self.view addSubview:_line];
}

-(void)animation1 {
    // 上下上下
    if (2*num == SCAN_HEIGHT) {
        _line.frame = CGRectMake(SCAN_X, SCAN_Y, SCAN_WIDTH, 2);
        num = 0;
    }
    else {
        _line.frame = CGRectMake(SCAN_X, SCAN_Y+2*num, SCAN_WIDTH, 2);
    }
    num ++;
}
- (void)startScan
{
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input 用设备创建输入流
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output 输出流
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session 实例化捕捉会话
    _session = [[AVCaptureSession alloc]init];
    if (kAppHeight < 500) {
        [_session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    else {
        //        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    //    AVCaptureDeviceFormat
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = [NSArray arrayWithObjects:
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeQRCode,
                                   nil];
    // 设置识别范围
    if (_session.sessionPreset == AVCaptureSessionPreset1920x1080) {
        NSLog(@"x:%f,y:%f,scanWidth:%f, scanHeight:%f", SCAN_X, SCAN_Y, SCAN_WIDTH, SCAN_HEIGHT);
        CGFloat p1 = kAppHeight / kAppWidth;
        CGFloat p2 = 1920. / 1080.;
        if (p1 < p2) {
            CGFloat fixHeight = kAppWidth * p2;
            CGFloat fixHeightPadding = (fixHeight - kAppHeight) / 2;
            _output.rectOfInterest = CGRectMake((SCAN_Y + fixHeightPadding)/fixHeight, SCAN_X/kAppWidth, SCAN_HEIGHT/fixHeight, SCAN_WIDTH/kAppWidth);
            //            _output.rectOfInterest = CGRectMake(SCAN_Y/kAppHeight, SCAN_X/kAppWidth, SCAN_HEIGHT/kAppHeight, SCAN_WIDTH/kAppWidth);
        }
        else {
            _output.rectOfInterest = CGRectMake(SCAN_Y/kAppHeight, SCAN_X/kAppWidth, SCAN_HEIGHT/kAppHeight, SCAN_WIDTH/kAppWidth);
            
        }
    }
    //    AVCaptureDeviceFormat
    // 预览图层
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    _preview.frame =CGRectMake(SCAN_X, SCAN_Y, SCAN_WIDTH, SCAN_HEIGHT);
    _preview.frame = self.view.frame;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [_session startRunning];
}

#pragma --mark AVCaptureMetadataOutputObjectsDelegate
- (void)stopScan {
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
    // 关闭定时器
    [timer invalidate];
    timer = nil;
}



#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue = nil;
    
    // 判断是否有数据
    if ([metadataObjects count] >0)
    {
        [self stopScan];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        ScanResultViewController *vc = [ScanResultViewController new];
        vc.resultString = stringValue;
        [self.navigationController pushViewController:vc animated:YES];
        NSLog(@"rose show %@",stringValue);
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
