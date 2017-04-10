//
//  const.h
//  Out
//
//  Created by Jolie_Yang on 16/9/6.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#ifndef const_h
#define const_h

// 尺寸
#define kAppWidth [[UIScreen mainScreen] bounds].size.width
#define kAppHeight [[UIScreen mainScreen] bounds].size.height
#define kStatusHeight   [[UIApplication sharedApplication] statusBarFrame].size.height // 20
#define kNavigationBarHeight  (self.navigationController.navigationBar.frame.size.height) // 44
#define kTabbarHeight    (self.tabBarController.tabBar.frame.size.height)
#define InvalidViewHeight (kStatusHeight + kNavigationBarHeight)
#define ValidViewHeight (kAppHeight - INVALID_VIEW_HEIGHT)
// 颜色
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Arc4randomColor      RGBA(arc4random() % 256,arc4random() % 256,arc4random() % 256,1.0f)  //获取随机色
#endif
