//
//  KEYHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里是三方key的声明/宏定义.

#ifndef Project_KEYHeader_h
#define Project_KEYHeader_h


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kGap_10 10
#define kGap_20 20
#define kGap_30 30
#define kGap_40 40
#define kGap_50 50


#define UserDefaults [NSUserDefaults standardUserDefaults]




#define NetStatus [Reachability reachabilityForInternetConnection].currentReachabilityStatus
#define NR NotReachable
#define WWAN ReachableViaWWAN
#define Wifi ReachableViaWiFi

//调Bug用
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif



#endif
