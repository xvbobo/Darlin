//
//  LocalStoreManager.h
//  ZJWR
//
//  Created by myqu on 14-8-31.
//  Copyright (c) 2014年 3TI. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ETag           @"Etag"
#define IfNoneMatch  @"If-None-Match"
#define CachePath                       @"cache"   // 存储接口请求数据的缓存路径文件名称
#define UserInfoPath                    @"userInfo"   // 存储用户登录数据的路径文件名称


#pragma mark --- 定义本地存储文件中的key
#define DefaultKey_Provicen  @"DefaultKey_Provicen"  //省份更新
#define DefaultKey_AreaId  @"DefaultKey_AreaId"  // 省份id
#define DefaultKey_Userinfo  @"DefaultKey_Userinfo"  // 用户信息
#define DefaultKey_hobby  @"DefaultKey_hobby"  // 用户爱好
#define DefaultKey_PeepPassword  @"DefaultKey_PeepPassword"  // 防偷窥密码信息
#define DefaultKey_Advertise  @"DefaultKey_Advertise"  // 广告业
#define DefaultKey_Vercode  @"DefaultKey_Vercode"  // 邀请码
#define DefaultKey_Comment  @"DefaultKey_Comment"  // 评论该App

#define DefaultKey_Version  @"DefaultKey_Version"  // 版本号
#define DefaultKey_VersionUrl  @"DefaultKey_VersionUrl"  // 版本号Url

#define Default_UserHead   @"defaultHeader"
#define Default_GoodsHead   @"defaultProduct"

@interface UserInfo : NSObject<NSCoding>

@property (nonatomic, strong)NSString *account;    // 防偷窥密码（四位数字）
@property (nonatomic, strong)NSString *pwd;       // 是否打开防偷窥密码：0、关闭  1 、打开
@property (nonatomic, assign)BOOL bRememberPwd;  // 是否打开防偷窥密码：YES、关闭  NO 、打开
@property (nonatomic, assign)int loginInterval; // 登录的时间戳，用于排序

@end


LoginModel *g_userInfo;  // 用户信息的全局对象

/**
 *  用户的数据操作的读取类，定义了一些公共属性和方法
 */
@interface LocalStoreManager : NSObject

+(LocalStoreManager *)shareInstance;

#pragma mark -  get请求接口的缓存数据读取与更新

/**
 *   存储get请求接口返回的数据
 *
 *  @param dic [key:url    value:[key:@"ETag"  value:etagStr;  key:@"content"  value:operation]]
 */
-(void)replaceCurrentData:(NSDictionary *)dic;

/**
 *  根据url获取接口返回的json数据
 *
 *  @param url 查找的key值
 *
 *  @return 接口返回的json数据内容
 */
-(id)getDataFromeCacheWithUrl:(NSURL *)url;

/**
 *  根据请求的url获取etag数据
 *
 *  @param url 请求的url
 *
 *  @return 请求对应的etag值
 */
-(NSString *)getEtagFromeCacheWithUrl:(NSURL*)url;


#pragma mark --- 存储用户登录数据［历史五个］

/**
 *  获取历史登录用户信息
 *
 *  @return 用户信息arrar<UserInfo *>最多五个
 */
-(NSArray *)getHistoryAccountList;

/**
 *  增加最新登录的用户信息
 *
 *  @param userInfo 用户信心
 *
 *  @return 返回成功、失败
 */
-(BOOL)addNewAccountInfo:(UserInfo *)userInfo;


/**
 *  根据用户账号获取用户信息
 *
 *  @param account 用户账号
 *
 *  @return 用户信息
 */
-(UserInfo *)getAccountFromListByAccount:(NSString *)account;

/**
 *  在defualt中设置key和value值
 *
 *  @param value 值
 *  @param key   关键字
 *
 */
-(void)setValueInDefault:(id)value withKey:(NSString *)key;



/**
 *  根据key获取对应的defualt中的value值
 *
 *  @param key
 *
 *  @return
 */
-(id)getValueFromDefaultWithKey:(NSString *)key;

@end
