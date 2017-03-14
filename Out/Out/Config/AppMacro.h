//
//  AppMacro.h
//  Out
//
//  Created by Jolie_Yang on 2017/3/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
#if DEBUG
// 开发
#define kSERVER_HOST @"http://express.mistkafka.tk"
#define kSERVER_URL @"http://express.mistkafka.tk/api1/"
#define kPHOTO_NAME @"photo"
#define kPHOTO_URL @"http://express.mistkafka.tk/api1/photo?photoId="
#define kPHOTO_DEFAULT @"http://express.mistkafka.tk/api1/photo?photoSrc=system&photoId=default"
#define SUCCESS_STATUS @"success"
#else
// 生产
#define kSERVER_HOST @"http://express.mistkafka.tk"
#define kSERVER_URL @"http://express.mistkafka.tk/api1/"
#define kPHOTO_NAME @"photo"
#define kPHOTO_URL @"http://express.mistkafka.tk/api1/photo?photoId="
#define kPHOTO_DEFAULT @"http://express.mistkafka.tk/api1/photo?photoSrc=system&photoId=default"
#define SUCCESS_STATUS @"success"
#endif

#define OUT_NICK_NAME @"com.spider.out.developer.nickname"
#define OUT_NAME_NUMBER @"com.spider.out.developer.name.number"
#define OUT_TOKEN @"com.spider.out.develop.token"

#define LIMIT_TEXT_LENGTH 100

// 颜色
#define System_Black UIColorFromRGB(0x28292B)
#define System_White UIColorFromRGB(0xECECED)
#define Apple_Gold UIColorFromRGB(0xD2C2AC)
#define Apple_Silver UIColorFromRGB(0xD5D5D8)
#define Apple_SpaceGray UIColorFromRGB(0xA4A4A8)
#define Apple_RoseGold UIColorFromRGB(0xCBB0A9)
#define Apple_Black UIColorFromRGB(0x383A3E)


#endif /* AppMacro_h */
