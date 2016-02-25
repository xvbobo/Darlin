//
//  NSDate+Utils.h
//  iOSCodeProject
//
//  Created by Fox on 14-7-18.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  时间NSDate扩展类别
 */
@interface NSDate (Utils)

#pragma mark - Date Property

/**
 *  当前日期的年
 *
 *  @return 年
 */
-(NSInteger)year;

/**
 *  当前月
 *
 *  @return 月
 */
-(NSInteger)month;

/**
 *  当前天
 *
 *  @return 天
 */
-(NSInteger)day;

/**
 *  当月对应的天数
 *
 *  @return 天数
 */
-(NSInteger)numDaysInMonth;

#pragma mark - Format Date

/**
 *  当前时间字符串，年、月、日
 *
 *  @return 时间字符串
 */
+ (NSString *)currentTimeString;

/**
 *  当前时间字符串，除了年、月和日，还包含小时、分钟和秒
 *
 *  @return 时间字符串
 */
+ (NSString *)currentFullTimeString;

/**
 *  当前时间字符串，只包含小时、分钟和秒
 *
 *  @return 时间字符串
 */
+ (NSString *)currentDetailTimeString;

/**
 *  通过一定格式的字符串转换为NSDate时间对象
 *
 *  @param dateString          时间字符串
 *  @param dateFormatterString 时间格式字符串
 *
 *  @return 时间对象
 */
+ (NSDate*)dateWithString:(NSString*)dateString
             formatString:(NSString*)dateFormatterString;

/**
 *  通过'yyyy-MM-dd HH:mm:ss' 格式的字符串获取NSDate时间对象
 *
 *  @param str 时间字符串
 *
 *  @return 时间对象
 */
+ (NSDate*)dateWithDateString:(NSString*)str;

/**
 *  通过'yyyy-MM-dd HH:mm:ss' 格式的字符串获取NSDate时间对象
 *
 *  @param str 时间字符串
 *
 *  @return 时间对象
 */
+ (NSDate*)dateWithDateTimeString:(NSString*)str;

/**
 *  将时间戳修改为时间对象
 *
 *  @param timestamp 时间戳
 *
 *  @return 时间对象
 */
+ (NSString *)dateFormTimestampString:(NSString *)timestamp;

/**
 *  将时间戳修改为时间对象
 *
 *  @param formatterStr 转换后的对象
 *  @param timestamp    时间戳
 *
 *  @return 时间对象
 */
+ (NSString *)dateFormTimestampStringByFormatter:(NSString *)formatterStr timeStamp:(NSString *)timestamp;

/**
 *  将秒数转换为天、小时、分和秒；例如111230转换为3天5小时42分12秒
 *
 *  @param count 秒
 *
 *  @return 描述文字
 */
+ (NSString *)dateFormmterFormSecond:(int)count;

/**
 *  将时间修改为刚刚、2分钟前、2小时前和2天前描述的字符串
 *
 *  @return 结果字符串
 */
- (NSString*)formattedExactRelativeDate;

/**
 *  过去多少天对应的时间
 *
 *  @param pageDays 天数
 *
 *  @return 时间描述字符串
 */
+ (NSString *)pastDateString:(int )pageDays;

/**
 *  未来的多少天
 *
 *  @param pageDays 天数
 *
 *  @return 时间描述字符串
 */
+ (NSString *)addDateString:(int )pageDays;

/**
 *  未来的多少月
 *
 *  @param pastMonth 过去月数
 *
 *  @return 时间描述字符串
 */
+ (NSString *)pastMonthDateString:(int )pastMonth;

#pragma mark - Time comparison

/**
 *  是否早于现在
 *
 *  @return 计较结果
 */
- (BOOL)isPastDate;

/**
 *  是否为今天
 *
 *  @return 比较结果
 */
- (BOOL)isDateToday;

/**
 *  是否为昨天
 *
 *  @return 比较结果
 */
- (BOOL)isDateYesterday;

@end
