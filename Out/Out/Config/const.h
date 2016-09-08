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
    #define kSERVER_HOST @"http://express.mistkafka.tk"
    #define kSERVER_URL @"http://express.mistkafka.tk/api1/"
    #define kPHOTO_NAME @"photo"
    #define kPHOTO_URL @"http://express.mistkafka.tk/api1/photo?photoId="
    #define SUCCESS_STATUS @"success"
#else
    // 生产
    #define kSERVER_URL @"http://express.mistkafka.tk/api1/"
#endif 

#define OUT_NAME @"com.spider.out.developer.name"
#define OUT_TOKEN @"com.spider.out.develop.token"

#endif
