//
//  UIView+LoadFromNib.m
//  CIB
//
//  Created by Jolie_Yang on 2016/11/25.
//  Copyright © 2016年 China Industrial Bank. All rights reserved.
//

#import "UIView+LoadFromNib.h"

@implementation UIView(LoadFromNib)

+ (id)loadFromNib {
    NSString *xibName = NSStringFromClass([self class]);
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:xibName owner:self options:nil];
    UIView *tmpCustomView = [nib objectAtIndex:0];
    return tmpCustomView;
}

@end
