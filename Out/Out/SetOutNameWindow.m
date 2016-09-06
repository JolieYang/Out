//
//  SetOutNameWindow.m
//  Out
//
//  Created by Jolie_Yang on 16/9/5.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "SetOutNameWindow.h"
#import "SetOutNameViewController.h"

@interface SetOutNameWindow()
@end

@implementation SetOutNameWindow

+ (SetOutNameWindow *)shareInstance {
    static SetOutNameWindow *shareSetOutNameWindowInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareSetOutNameWindowInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return shareSetOutNameWindowInstance;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)show {
    SetOutNameViewController *setOutNameVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetOutNameViewController"];
    self.windowLevel = UIWindowLevelNormal + 93;
    [self setRootViewController:setOutNameVC];
    [self makeKeyAndVisible];
}

- (void)hide {
    [self resignKeyWindow];
    self.hidden = YES;
}

@end
