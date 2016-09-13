//
//  AppDelegate.m
//  Out
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "AppDelegate.h"
#import "SetOutNameWindow.h"
#import "const.h"
#import "AFNetworking.h"

@interface AppDelegate ()
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:OUT_NAME];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] valueForKey:OUT_NICK_NAME];
    if (!nickName) {
        [[SetOutNameWindow shareInstance] show];
    }
    
    // 用于ping
//    NSURL *baseURL = [NSURL URLWithString: kSERVER_HOST];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
//    NSOperationQueue *operationQueue = manager.operationQueue;
//    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"AFNetworkReachabilityStatusUnknown");
//                // 发送系统通知，通知无网络
//                [operationQueue setSuspended:YES];
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//                NSLog(@"AFNetworkReachabilityStatusNotReachable");
//                [operationQueue setSuspended:YES];
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
//                // 通知有网络
//                [operationQueue setSuspended:NO];
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
//                [operationQueue setSuspended:NO];
//                break;
//            default:
//                break;
//        }
//    }];
//    [manager.reachabilityManager startMonitoring];
    
    
    
    
    // m2: 监测的不是很准确，会进入两次通知，并且有时命名有网络，但是显示AFNetworkReachabilityStatusNotReachable
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
//    self.manager = [AFNetworkReachabilityManager managerForDomain:kSERVER_HOST];
//    [self.manager startMonitoring];
    
    // m3:
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"AFNetworkReachabilityStatusUnknown");
                // 发送系统通知，通知无网络
                //            [operationQueue setSuspended:YES];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"AFNetworkReachabilityStatusNotReachable");
                //            [operationQueue setSuspended:YES];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
                // 通知有网络
                //            [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
                //            [operationQueue setSuspended:NO];
                break;
            default:
                break;
        }
 
    }];
    
    return YES;
}

- (void)reachabilityStatusDidChanged:(NSNotification *)notification {
    AFNetworkReachabilityStatus status = self.manager.networkReachabilityStatus;
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@"AFNetworkReachabilityStatusUnknown");
            // 发送系统通知，通知无网络
//            [operationQueue setSuspended:YES];
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"AFNetworkReachabilityStatusNotReachable");
//            [operationQueue setSuspended:YES];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
            // 通知有网络
//            [operationQueue setSuspended:NO];
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
//            [operationQueue setSuspended:NO];
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.manager stopMonitoring];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
