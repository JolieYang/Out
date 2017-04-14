//
//  JYPermissionsManager.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/13.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "JYPermissionsManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation JYPermissionsManager
- (void)checkCameraAuthorizationStatusWithBlock:(void(^)(BOOL granted))block
{
    NSString *mediaType = AVMediaTypeVideo;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (!granted){
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera disabled"
//                                                                message:@"This app doesn't have permission to use the camera, please go to the Settings app > Privacy > Camera and enable access."
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:@"Settings", nil];
//                alert.delegate = self;
//                [alert show];
            });
        }
        if(block)
            block(granted);
    }];
}

#pragma mark - UIAlertViewDelegate methods
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 1){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    }
//}
@end
