//
//  CommonHelper.m
//  Yongai
//
//  Created by wangfang on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "CommonHelper.h"
#import <ShareSDK/ShareSDK.h>

@implementation CommonHelper

+ (void)shareSdkWithContent:(NSString *)contentString withTitle:(NSString *)titleString withImage:(UIImage *)image withUrl:(NSString *)urlString {

    id<ISSContainer> container = [ShareSDK container];
    
    // 定义菜单分享列表
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline, nil];
    
//    NSString *contentString = [NSString stringWithFormat:@"邀请码：%@", code];// 内容
//    NSString *titleString   = @"泡泡堂";// 标题
//    NSString *urlString     = @"";// url地址
//    UIImage *image          = [UIImage imageNamed:@"Icon-60"];// 图片
    
    // 构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentString
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:titleString
                                                  url:urlString
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    // 定制微信好友内容
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                         content:contentString
                                           title:titleString
                                             url:urlString
                                           image:[ShareSDK pngImageWithImage:image]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    // 定制微信朋友圈内容
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:contentString
                                            title:titleString
                                              url:urlString
                                            image:[ShareSDK pngImageWithImage:image]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    // 构造分享视图
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"分享"
                                                              oneKeyShareList:nil
                                                               qqButtonHidden:NO
                                                        wxSessionButtonHidden:NO
                                                       wxTimelineButtonHidden:NO
                                                         showKeyboardOnAppear:YES
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    // 弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type,
                                     SSResponseState state,
                                     id<ISSPlatformShareInfo> statusInfo,
                                     id<ICMErrorInfo> error, BOOL end)
     {
         NSString *name = nil;
         switch (type)
         {
             case ShareTypeWeixiSession:
                 name = @"微信好友";
                 break;
             case ShareTypeWeixiTimeline:
                 name = @"微信朋友圈";
                 break;
             default:
                 name = @"某个平台";
                 break;
         }
         
         NSString *notice = nil;
         if (state == SSPublishContentStateSuccess)
         {
             notice = [NSString stringWithFormat:@"分享到%@成功！", name];
             
             UIAlertView *view =
             [[UIAlertView alloc] initWithTitle:@"提示"
                                        message:notice
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles: nil];
             [view show];
         }
         else if (state == SSPublishContentStateFail)
         {
             //notice = [NSString stringWithFormat:@"分享到%@失败,错误码:%ld,错误描述:%@", name, (long)[error errorCode], [error errorDescription]];
             notice = [NSString stringWithFormat:@"%@", [error errorDescription]];
             
             UIAlertView *view =
             [[UIAlertView alloc] initWithTitle:@"提示"
                                        message:notice
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles: nil];
             [view show];
         }
     }];
}

+ (NSString *)version {
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* version =[infoDict objectForKey:@"CFBundleShortVersionString"];
    
    return version;
}

+ (NSString *)formatterWithTime:(NSString *)time andWithType:(NSString *)type {

    double timeNum = [time doubleValue];
    
    NSDateFormatter *formatter;
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setDateFormat:type];
    }
    NSDate *majorDate = [NSDate dateWithTimeIntervalSince1970:timeNum];
    NSString *nowtime = [formatter stringFromDate:majorDate];
    
    return nowtime;
}

+ (BOOL)validateSpace:(NSString *)str
{
//    NSString *str1 = str;
//    NSString *string = @" ";
    // 在str1这个字符串中搜索空格，判断有没有
//    if ([str1 rangeOfString:string].location != NSNotFound) {
//        
//        //return YES;
//    }
    
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strUrl.length == 0) {
        
        return YES;
    }
    return NO;
}

@end
