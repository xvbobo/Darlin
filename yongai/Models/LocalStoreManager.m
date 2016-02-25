//
//  LocalStoreManager.m
//  ZJWR
//
//  Created by myqu on 14-8-31.
//  Copyright (c) 2014年 3TI. All rights reserved.
//

#import "LocalStoreManager.h"

@implementation UserInfo

@synthesize account;
@synthesize pwd;
@synthesize bRememberPwd;
@synthesize loginInterval;

#pragma mark- NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.account forKey:@"UserInfo_account"];
    [aCoder encodeObject:self.pwd forKey:@"UserInfo_pwd"];
    [aCoder encodeInt32:self.bRememberPwd forKey:@"UserInfo_bRememberPwd"];
    [aCoder encodeInt32:self.loginInterval forKey:@"UserInfo_loginInterval"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    account=[aDecoder decodeObjectForKey:@"UserInfo_account"];
    pwd=[aDecoder decodeObjectForKey:@"UserInfo_pwd"];
    bRememberPwd=[aDecoder decodeInt32ForKey:@"UserInfo_bRememberPwd"];
    loginInterval = [aDecoder decodeInt32ForKey:@"UserInfo_loginInterval"];
    
    return self;
    
}

@end

@implementation LocalStoreManager

static LocalStoreManager *_instance = nil;

+(LocalStoreManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LocalStoreManager alloc] init];
        
    });
    return _instance;
}


/**
 *  根据文件名称获取缓存的沙盒路径
 *
 *  @param filename 文件名称
 *
 *  @return 沙盒路径
 */
-(NSString *)applicationDocumentsDirectory:(NSString*)filename
{
    NSArray *paths;
//    if ([filename isEqualToString:CachePath]) {
        paths= NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                   NSUserDomainMask,
                                                   YES);
//    }
//    else if([filename isEqualToString:UserInfoPath])
//        paths= NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,
//                                                   NSUserDomainMask,
//                                                   YES);

    
    NSString *basePath = ([paths count] >0)?[paths objectAtIndex:0]:nil;
    NSString *appendPath = filename;
    return [basePath stringByAppendingPathComponent:appendPath];
}


#pragma mark -  get请求接口的缓存数据读取与更新

/**
 *   存储get请求接口返回的数据
 *
 *  @param dic [key:url    value:[key:@"ETag"  value:etagStr;  key:@"content"  value:operation]]
 */
-(void)replaceCurrentData:(NSDictionary *)dic
{
    NSString *path = [self applicationDocumentsDirectory:CachePath];
    NSMutableDictionary *tempDic= [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]];
    if(tempDic == nil)
        tempDic = [[NSMutableDictionary alloc] init];
    [tempDic addEntriesFromDictionary:dic];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tempDic];
    [data writeToFile:path atomically:YES];
}

/**
 *  根据url获取接口返回的json数据
 *
 *  @param url 查找的key值
 *
 *  @return 接口返回的json数据内容
 */
-(id)getDataFromeCacheWithUrl:(NSURL *)url
{
    NSMutableDictionary *tempDic= [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[self applicationDocumentsDirectory:CachePath]]];
    
    NSDictionary *dataDic = [tempDic objectForKey:url];
    id operation = [dataDic objectForKey:@"content"];
    return operation;
}

-(NSString*)getEtagFromeCacheWithUrl:(NSURL *)url
{
    NSString* filename= [self applicationDocumentsDirectory:CachePath];
    NSMutableDictionary *tempDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    NSDictionary *etagDic = [tempDic objectForKey:url];
    NSString *etag = [etagDic objectForKey:ETag];
    
    return etag;
}



#pragma mark --- 存储用户登录数据［历史五个］

/**
 *  获取历史登录用户信息
 *
 *  @return 用户信息arrar<UserInfo *>最多五个
 */
-(NSArray *)getHistoryAccountList
{
    NSString *path = [self applicationDocumentsDirectory:UserInfoPath];
    NSArray *tempArr= [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]];
    
    return tempArr;
}

/**
 *  增加最新登录的用户信息
 *
 *  @param userInfo 用户信心
 *
 *  @return 返回成功、失败
 */
-(BOOL)addNewAccountInfo:(UserInfo *)userInfo
{
    NSString *path = [self applicationDocumentsDirectory:UserInfoPath];
    NSMutableArray *tempArr= [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]];
    if(tempArr == nil)
        tempArr = [[NSMutableArray alloc] init];
    
    
    BOOL bFind = NO; // 是否存在该历史用户
    for(UserInfo *info in tempArr)
    {
        if([info.account isEqualToString:userInfo.account])
        {
            info.pwd = userInfo.pwd;
            info.bRememberPwd = userInfo.bRememberPwd;
            info.loginInterval = userInfo.loginInterval;
            bFind = YES;
            break;
        }
    }
    
    if(bFind == NO)
    {
        if(tempArr.count>4)
            [tempArr removeLastObject];
        
        [tempArr addObject:userInfo];
    }
    
    // 将数组进行排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"loginInterval" ascending:NO];
    NSArray *tempArrary = [tempArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSMutableArray *accountArr = [NSMutableArray arrayWithArray:tempArrary];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accountArr];
    BOOL ret = [data writeToFile:path atomically:YES];
    
    return ret;
}


/**
 *  根据用户账号获取用户信息
 *
 *  @param account 用户账号
 *
 *  @return 用户信息
 */
-(UserInfo *)getAccountFromListByAccount:(NSString *)account
{
    NSString *path = [self applicationDocumentsDirectory:UserInfoPath];
    NSMutableArray *tempArr= [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]];
    for(UserInfo *info in tempArr)
    {
        if([info.account isEqualToString:account])
        {
            return info;
        }
    }
    
     // 不存在该历史用户
    return nil;
}


/**
 *  在defualt中设置key和value值
 *
 *  @param value 值
 *  @param key   关键字
 *
 */
-(void)setValueInDefault:(id)value withKey:(NSString *)key
{
    NSData *object = [NSKeyedArchiver archivedDataWithRootObject:value];
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  根据key获取对应的defualt中的value值
 *
 *  @param key
 *
 *  @return
 */
-(id)getValueFromDefaultWithKey:(NSString *)key
{
    id value;
    if ([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys containsObject:key])
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return value;
}
@end
