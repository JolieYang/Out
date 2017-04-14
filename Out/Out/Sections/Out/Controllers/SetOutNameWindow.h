//
//  SetOutNameWindow.h
//  Out
//
//  Created by Jolie_Yang on 16/9/5.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetOutNameWindow : UIWindow
- (id)initWithFrame:(CGRect)frame;
+ (SetOutNameWindow *)shareInstance;
- (void)show;
- (void)hide;
@end
