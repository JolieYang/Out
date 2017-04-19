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
#define Black1 UIColorFromRGB(0x474749)
#define Black2 UIColorFromRGB(0x24252C)
#define System_Black UIColorFromRGB(0x28292B)// 导航栏设置该颜色，渲染后的颜色为Black1
#define System_White UIColorFromRGB(0xECECED)
#define White UIColorFromRGB(0xFFF)

#define Xcode_Black UIColorFromRGB(0x24252B)
#define Apple_Gold UIColorFromRGB(0xD2C2AC)
#define Apple_Silver UIColorFromRGB(0xD5D5D8)
#define Apple_SpaceGray UIColorFromRGB(0xA4A4A8)
#define Apple_RoseGold UIColorFromRGB(0xCBB0A9)
#define Apple_Black UIColorFromRGB(0x383A3E)

#define Birthday_Bg_Gray UIColorFromRGB(0x5E5E5E)
#define Birthday_Icon_Gray UIColorFromRGB(0x737373)
#define Birthday_Line_Gray UIColorFromRGB(0xC8C8C8)
#define Birthday_Gray UIColorFromRGB(0x757575) // 生辰应用

#define Alipay_Bg UIColorFromRGB(0xEBEEEC)
#define Table_Bg UIColorFromRGB(0xF1F3F5)
#define App_Bg Alipay_Bg
#define PlaceHolder_Gray UIColorFromRGB(0xBAB9BF)

#define Running_Record_Not_Achieve UIColorFromRGB(0xFFFE3C)
#define Running_Record_Take_Leave UIColorFromRGB(0x62A14E)

#define System_Nav_Black Black2
#define System_Nav_White System_White
#define HourMinute_Bg Black1

// 图片
#define White_Nav_Back_Icon_Name @"picture_back"
#define Gray_Nav_Back_Icon_Name @"nav_back"

#define Default_Image [UIImage imageNamed: @"tab_icon_01_normal"]
#endif /* AppMacro_h */
