//
//  CommonUtils.h
//  SinaWeibo
//
//  Created by Kevin Su on 14-7-29.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#import <SystemConfiguration/SystemConfiguration.h>

#pragma mark 常用值定义
#define TOP_HEIGHT 44
#define TOP_WIDTH 44
#define VIEW_SPACE  5
#define SELVIEW_HEIGHT  self.view.frame.size.height
#define SELVIEW_WIDTH self.view.frame.size.width

//系统版本
#define SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//系统状态栏
#define SYS_STATUSBAR_H [UIApplication sharedApplication].statusBarFrame.size.height
//程序版本
#define APP_VERSION [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue]
//程序运行临时文件目录
#define APP_TMPPATH NSTemporaryDirectory()
//app文件根目录
#define APP_DOCPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]
//程序根window
#define APP_WINDOW [UIApplication sharedApplication].keyWindow
//屏幕宽度
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
//定义颜色
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define beijing RGBACOLOR(250,70,70, 1)
#define TEXTCOLOR RGBACOLOR(194, 165, 133, 1)
#define BJCLOLR RGBACOLOR(245, 240, 235, 1)
//#define BJCLOLR RGBACOLOR(0,0,0,1)
#define MEN RGBACOLOR(88, 176, 240, 1)
#define FEMEN RGBACOLOR(255, 81, 155, 1)
#define TEXT RGBACOLOR(160, 154, 149, 1)
#define BLACKTEXT RGBACOLOR(108, 97, 85, 1)
//#define beijing RGBACOLOR(220,32,41, 1)
//#define beijing RGBACOLOR(255, 97, 46, 1)
#define blueBtn RGBACOLOR(70, 174, 245, 1)
#define LINE RGBACOLOR(230, 220,213,1)
#define QDBJ RGBACOLOR(23, 17, 26,0.7)
#define HUIFUCOLOR RGBACOLOR(246, 244,239, 1)
#define font(a) [UIFont fontWithName:@"Helvetica-Bold" size:(a)]
//经验背景色
#define expBJ RGBACOLOR(255,168, 140, 1)
//随机颜色
#define RANDOMCOLOR [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1.0]
//版本号
#define VERSION  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#pragma mark 控件属性
//view布局后的X坐标
#define XPOS(p) VIEW_XPOS(p)
CGFloat VIEW_XPOS(CGRect p);

//view布局后的Y坐标
#define YPOS(p) VIEW_YPOS(p)
CGFloat VIEW_YPOS(CGRect p);

//隐藏键盘
#define HIDEKEYBOARD(p) HIDE_KEYBOARD(p)
void HIDE_KEYBOARD(UIView *p);

//渲染控件阴影
#define VIEWRENDER(p,c) VIEW_RENDER(p,c)
void VIEW_RENDER(UIView *p,UIColor *color);

#pragma mark 文件操作
//创建文件夹
#define CREATEFOLDER(p) APP_CREATEFOLDER(p)
BOOL APP_CREATEFOLDER(NSString *p);

//创建文件
#define CREATEFILE(p) APP_CREATEFILE(p)
BOOL APP_CREATEFILE(NSString *p);

//删除文件
#define DELETEFILE(p) APP_DELETEFILE(p)
BOOL APP_DELETEFILE(NSString *p);

//拷贝文件
#define COPYFILE(f,t) APP_COPYFILE(f,t)
BOOL APP_COPYFILE(NSString *f,NSString *t);

//移动文件
#define MOVEFILE(f,t) APP_MOVEFILE(f,t)
BOOL APP_MOVEFILE(NSString *f,NSString *t);

//文件夹下的所有文件
#define LISTFILES(p) APP_LISTFILES(p)
NSArray* APP_LISTFILES(NSString *p);

#pragma mark 设备信息
//设备可用内存
#define FREEMOMERY SYS_FREEMOMERY()
CGFloat SYS_FREEMOMERY();

//设备网络状态
#define NETSTATE SYS_NETSTATE()
BOOL SYS_NETSTATE();

//设备网络地址
#define NETADDRESS SYS_NETADDRESS()
NSString* SYS_NETADDRESS();

#pragma mark 图片处理
//图片缩放(等比)
#define IMGZOOM(o,w,h) IMG_IMGZOOM(o,w,h)
UIImage* IMG_IMGZOOM(UIImage *o,CGFloat w,CGFloat h);

//图片修剪
#define IMGTRIM(o,s,r) IMG_IMGTRIM(o,s,r)
UIImage* IMG_IMGTRIM(UIImage *o,CGSize s,CGRect r);

//截屏
#define SCREENSHOT UTIL_SCREENSHOT()
UIImage* UTIL_SCREENSHOT();

//导航视图titleview
#define NAVTITLE NAV_TITLE(s,f)
UIView* NAV_TITLE(NSString* s,CGRect f);

//初始化导航
void NAV_INIT(UIViewController *vc ,NSString *title, NSString *left ,SEL leftObj, NSString *right, SEL rightObj);
//手机号码校验
#define VERIFYPHONE(p) VERIFY_PHONE(p)
BOOL VERIFY_PHONE(NSString* p);

//邮箱地址校验
#define VERIFYEMAIL(p) VERIFY_EMAIL(p)
BOOL VERIFY_EMAIL(NSString* p);

//金额校验
#define VERIFYPRICE(p) VERIFY_PRICE(p)
BOOL VERIFY_PRICE(NSString* p);

//邮政编码校验
#define VERIFYZIPCODE(p) VERIFY_ZIPCODE(p)
BOOL VERIFY_ZIPCODE(NSString* p);

//身份证号码校验
#define VERIFYIDENTITY(p) VERIFY_IDENTITY(p)
BOOL VERIFY_IDENTITY(NSString* p);

//姓名校验
#define VERIFYSINGLE(p) VERIFY_SINGLE(p)
BOOL VERIFY_SINGLE(NSString* p);

//密码校验
#define VERIFYPASSWORD(p) VERIFY_PASSWORD(p)
BOOL VERIFY_PASSWORD(NSString* p);

//显示圆形头像
UIImageView *SHOW_CIRCLE_IMAGE(UIImageView *view, NSInteger borderWidth, UIColor *borderColor);

//计算Label高度
CGSize COUNTVIEWSIZE(NSString *content, UIFont *font, CGFloat width, CGFloat height);

@interface CommonUtils : NSObject

@end
