//
//  UIView+JY.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/19.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "UIView+JY.h"

@implementation UIView (JY)
+ (id)loadFromNib {
    NSString *xibName = NSStringFromClass([self class]);
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:xibName owner:self options:nil];
    UIView *tmpCustomView = [nib objectAtIndex:0];
    return tmpCustomView;
}
@end
