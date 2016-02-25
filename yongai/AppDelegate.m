//
//  AppDelegate.m
//  Yongai
//
//  Created by Kevin Su on 14-10-27.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "GuideNavViewController.h"
#import "YongaiYabbarController.h"
#import "MallNavViewController.h"
#import "APService.h"
#import <AlipaySDK/AlipaySDK.h>
#define APP_ShareKEY    @"448aca64e828"
#define WeChat_AppId   @"wxe5282d6de0837e1d"
#define UMeng_Key1 @"5588e4e967e58eb7d0002a08" //xvboboAM02
#define Schemes url @"alan://paopaotang.alan"
@interface AppDelegate ()<WXApiDelegate>//<THPinViewControllerDelegate>
{
    NSTimer *connectionTimer;
    BOOL done;
    UIImageView *imageView;
    UIWindow * mainWindow;
    NSInteger isGetAds; //是否取到广告业
}
@property (nonatomic, assign) NSUInteger remainingPinEntries;

@end

@implementation AppDelegate

//static const NSUInteger THNumberOfPinEntries = 6;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

    // 配置app
    [self saveAppVersion];
    [self configApplication];//分享
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSLog(@"xvbobo === %@",launchOptions);
    // 添加极光推送

    [self initJupush:launchOptions];
    
    g_userInfo = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_Userinfo];
     g_version = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_Version];
    isGetAds = -1;
    [self configGuideView];
    [self saveAppVersion];
    // 设置状态栏颜色
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    return YES;
}
- (void)initJupush:(NSDictionary*)launchOptions
{
    [APService setTags:nil alias:@"pushtest2" callbackSelector:nil target:nil];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];

}

- (void)configGuideView {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Yongai" bundle:nil];
    //配置引导页
//    [self saveAppVersion];
    GuideNavViewController *guideNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"GuideNavViewController"];
    
    self.window.rootViewController = guideNavVC;
    [self.window makeKeyAndVisible];
}

-(void)saveAppVersion
{
    [[TTIHttpClient shareInstance] updateVersionRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        g_version = [response.result objectForKey:@"new_version"];
        [[LocalStoreManager shareInstance] setValueInDefault:g_version withKey:DefaultKey_Version];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
    
};

-(void)configApplication {

    // 添加友盟
    [MobClick startWithAppkey:UMeng_Key1 reportPolicy:BATCH channelId:nil];
    
    /**
     *  分享
     */
    [ShareSDK registerApp:APP_ShareKEY];
    
    [ShareSDK connectWeChatTimelineWithAppId:WeChat_AppId
                                   wechatCls:[WXApi class]];
    
    [ShareSDK connectWeChatSessionWithAppId:WeChat_AppId
                                  wechatCls:[WXApi class]];
    
    [ShareSDK ssoEnabled:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    [application setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [APService setBadge:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//    [application setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [APService setBadge:0];
    
    // 判断当前用户是否登录 且 当前是否设置偷窥密码 且 判断当前是否打开防偷窥密码
    UserInfo *info  = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword];
    if (![g_userInfo.loginStatus isEqualToString:@"0"] && !ICIsStringEmpty(info.account) && [info.pwd isEqualToString:@"1"]) {
            
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationWillEnter" object:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)removeSuperview {
  
    // 判断当前是否设置偷窥密码 且 判断当前是否打开防偷窥密码
    UserInfo *info  = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword];
    if (!ICIsStringEmpty(info.account) && [info.pwd isEqualToString:@"1"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationWillEnter" object:nil];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
}
// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification  completionHandler:(void (^)())completionHandler
{
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler
{
    
    
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
   
    [APService handleRemoteNotification:userInfo];
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
        [self HandleNotification:userInfo];
    NSLog(@"激光==%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler
{
    //点击通知时调用
    [APService handleRemoteNotification:userInfo];
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
        [self HandleNotification:userInfo];
    
    DLOG(@"xvbobo = %@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    NSLog(@"adc");
//    aps =     {
//        alert = vv;
//    };
//    "goods_id" = 100;
//    "goods_name" = "-1";
//    type = 3;
}

// 极光推送处理方法
-(void)HandleNotification:(NSDictionary *)info
{

     DLOG(@"xvbobo = %@", info);
    NSString *type = [info objectForKey:@"type"];
    NSLog(@"type = %@",type);
    if(type.intValue == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showGoodsDetailView object:info];
    }
    else if(type.intValue == 2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showPostDetailView object:info];
    }else {

        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showTuiSongView object:info];
    }
}

#pragma mark --- alipay New SDK 
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    return [WXApi handleOpenURL:url delegate:self];
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@",resultDic);
              [[NSNotificationCenter defaultCenter] postNotificationName:AlipayResultURLNotify object:resultDic];
         }];
    }
     if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic)
        {
            NSLog(@"result = %@",resultDic);
             [[NSNotificationCenter defaultCenter] postNotificationName:AlipayResultURLNotify object:resultDic];
        }];
    }
    
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
  
    return YES;
}
//微信支付回调
-(void)onResp:(BaseResp *)resp{
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
       
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notify_weiXinSuccess object:nil];
            }
                break;
            default:
                break;
        }
    }
     NSLog(@"%@",strTitle);
}


//#pragma mark--- alipay
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    
//    [self parse:url application:application];
//    return YES;
//}
//
//// 支付宝服务器通知
//- (void)parse:(NSURL *)url application:(UIApplication *)application {
//    
//    //结果处理
//    AlixPayResult* result = [self handleOpenURL:url];
//    
//    if (result)
//    {
//        
//        if (result.statusCode == 9000)
//        {
//            /*
//             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//             
//             result = {
//             statusCode=9000
//             statusMessage=支付结束
//             signType=RSA
//             signString=FtnVCNnXCoORiuFvDeszpRbWcuoKRxmwib+6zD6Ltb6QwFO9IWOPAPx75FcXJto0imnv82ID2ouEZdEyqQnHHPmS1VWUx4bm01UNChK1pB0PIJzE0dokVUlOm5CFJqy73Nv2GdC0qAOy8qQSVqkE1YLR6Ti++24ZYB3e6L6MXQE=
//             }
//             
//             */
//            
//            //交易成功
////            NSString* key = AlipayPubKey; //@"签约帐户后获取到的支付宝公钥";
////            id<DataVerifier> verifier;
////            verifier = CreateRSADataVerifier(key);
////            
////            if ([verifier verifyString:result.resultString withSign:result.signString])
////            {
////                //验证签名成功，交易结果无篡改
////            }
//        }
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:AlipayResultURLNotify object:result];
//    }
//    else
//    {
//        //失败
//    }
//    
//}
//
//- (AlixPayResult *)resultFromURL:(NSURL *)url
//{
//    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//#if ! __has_feature(objc_arc)
//    return [[[AlixPayResult alloc] initWithString:query] autorelease];
//#else
//    return [[AlixPayResult alloc] initWithString:query];
//#endif
//}
//
///**
// *  应用外快捷支付返回结果
// */
//- (AlixPayResult *)handleOpenURL:(NSURL *)url
//{
//    AlixPayResult * result = nil;
//    
//    if (url != nil && [[url host] compare:@"safepay"] == 0) {
//        result = [self resultFromURL:url];
//    }
//    
//    return result;
//}


@end
