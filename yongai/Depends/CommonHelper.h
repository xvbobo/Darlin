//
//  CommonHelper.h
//  Yongai
//
//  Created by wangfang on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject

/**
 *  shareSdk分享
 *
 *  @param contentString 分享内容
 *  @param titleString   标题
 *  @param image         图片
 *  @param url           连接
 */
+ (void)shareSdkWithContent:(NSString *)contentString withTitle:(NSString *)titleString withImage:(UIImage *)image withUrl:(NSString *)urlString;

/**
 *  获取版本号
 *
 *  @return 版本号
 */
+ (NSString *)version;

/**
 *  将时间戳转换为时间
 *
 *  @param time 时间戳
 *  @param type YYYY-MM-dd HH:mm:ss 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 *
 *  @return 时间
 */
+ (NSString *)formatterWithTime:(NSString *)time andWithType:(NSString *)type;

/**
 *  判断内容是否包含空格
 *
 *  @param str 内容
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateSpace:(NSString *)str;

@end
