//
//  UILabel+JY.h
//  Out
//
//  Created by Jolie_Yang on 2017/4/19.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JY)
// 设置行间距
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;
// 计算行高
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
@end
