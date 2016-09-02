//
//  OutImageView.h
//  Out
//
//  Created by Jolie_Yang on 16/9/2.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapAction)(void);
@interface OutImageView : UIImageView

@property (nonatomic, strong) TapAction tapAction;

- (void)tapGestureWithBlock:(void (^)())tapHandler;
@end
