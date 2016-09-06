//
//  const.h
//  Out
//
//  Created by Jolie_Yang on 16/9/6.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#ifndef const_h
#define const_h

#if DEBUG
    // 开发
    #define kSERVER_URL @""

#else
    // 生产
    #define kSERVER_URL @""
#endif 

#define OUT_NAME @"com.spider.out.developer.name"
#define HAVE_SET_ONAME @"com.spider.out.developer.setoname"

#endif
