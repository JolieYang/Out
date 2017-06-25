//
//  NSString+JY.h
//  Spider
//
//  Created by Jolie_Yang on 2017/5/4.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JY)
// 去除首尾空格跟换行
- (NSString *)trim;
// 去除包含的空格
- (NSString *)stripSpace;
@end
