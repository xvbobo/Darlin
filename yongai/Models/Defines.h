//
//  Defines.h
//  lianguan
//
//  Created by myqu on 14-7-8.
//  Copyright (c) 2014年 myqu. All rights reserved.
//


#define  UserDefaults_Key_uuid  @"uuid"  // 设备唯一识别标识
#define  UserDefaults_Key_sid   @"sid"    // sessionid
#define  UserDefaults_Key_uid   @"uid"   // 用户id
#define  UserDefaults_Key_name  @"name"
#define  UserDefaults_Key_everLaunched  @"everLaunched"  //用于判断是否是第一次启动应用


#define Sid @"session[sid]"
#define Uid @"session[uid]"

#ifndef lianguan_Defines_h
#define lianguan_Defines_h
#endif


#ifdef DEBUG

//DEBUG模式下，信息的输出。Release模式下，将不会输出这些信息。

//输出内容
#define DLOG(...)   NSLog(__VA_ARGS__)
//输出调用对象方法
#define DLOGCALL DLOG(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
//输出函数
#define DLOGMETHOD	NSLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd));
//输出一个点
#define DLOGPOINT(p)	NSLog(@"%f,%f", p.x, p.y);
//输出一个大小
#define DLOGSIZE(p)	NSLog(@"%f,%f", p.width, p.height);
//输出一个矩阵
#define DLOGRECT(p)	NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);

#else

#define DLOG(...)
#define DLOGCALL
#define DLOGMETHOD
#define DLOGPOINT(p)
#define DLOGSIZE(p)
#define DLOGRECT(p)

#endif

#define IsiPhone5 ([UIScreen mainScreen].bounds.size.height > 480 ? YES : NO)

//是否为ios7
#ifndef isIos7
#define isIos7              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?YES:NO)
#endif

//设备屏幕高度
#ifndef MainView_Height
#define MainView_Height    [UIScreen mainScreen].bounds.size.height
#endif

//设备屏幕宽度
#ifndef MainView_Width
#define MainView_Width    [UIScreen mainScreen].bounds.size.width
#endif

//如果为ios7，则返回20的冗余
#ifndef IOS7_Y
#define IOS7_Y              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?20:0)
#endif

//是否为ios6
#ifndef IOS6
#define IOS6            ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0?YES:NO)
#endif


