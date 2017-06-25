//
//  UIImageView+JY.m
//  Spider
//
//  Created by Jolie_Yang on 2017/5/4.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "UIImageView+JY.h"

@implementation UIImageView (JY)
- (void)round {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = Apple_Silver.CGColor;
}
@end
