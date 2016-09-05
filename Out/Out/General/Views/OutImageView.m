//
//  OutImageView.m
//  Out
//
//  Created by Jolie_Yang on 16/9/2.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "OutImageView.h"

@implementation OutImageView

- (void)drawRect:(CGRect)rect {
//    Drawing code
//    [self setUserInteractionEnabled: YES];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureWithBlock:)];
//    [self addGestureRecognizer:tapGesture];
    NSLog(@"OutimageView drawRect");
}

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
