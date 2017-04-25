//
//  UIColor+JY.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/25.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "UIColor+JY.h"

@implementation UIColor (JY)
+ (UIColor *)randomColor {
    CGFloat red = arc4random()%255/255.0;
    CGFloat green = arc4random()%255/255.0;
    CGFloat blue = arc4random()%255/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}
@end
