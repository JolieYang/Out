//
//  OutImageView.m
//  Out
//
//  Created by Jolie_Yang on 16/9/2.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "OutImageView.h"

@implementation OutImageView


- (void)tapGestureWithBlock:(void (^)())tapHandler {
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self addGestureRecognizer:tapGesture];
    _tapAction = [tapHandler copy];
}

- (void)tapGesture {
    if (_tapAction) {
        _tapAction();
    }
}



@end
