//
//  TTIHttpClient.m
//  iOSCodeProject
//
//  Created by Fox on 14-7-21.
//  Copyright (c) 2014年 GMI. All rights reserved.
//

#import "TTIHttpClient.h"
#import "NSMutableDictionary+Utils.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworkActivityLogger.h"
#import "JSONKit.h"
#import "GTMBase64.h"
@interface TTIHttpClient ()

@end

@implementation TTIHttpClient

#pragma mark - Singleton

static TTIHttpClient *g_instance = nil;

+ (TTIHttpClient *)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_instance = [[TTIHttpClient alloc] init];
        [g_instance initialize];
    });
    return g_instance;
}
//2015-10-21 新添加缓存
+ (NSString *)filePath:(NSString *)fileName
{
    NSString * homePath = NSHomeDirectory();
    homePath = [homePath stringByAppendingPathComponent:@"Documents"];
    homePath = [homePath stringByAppendingPathComponent:@"DataCache"];
    NSFileManager * fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:homePath]) {
        [fm createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (fileName && [fileName length] != 0) {
        homePath = [homePath stringByAppendingPathComponent:fileName];
    }
    NSLog(@"%@文件的保存路径：%@",fileName,homePath);
    return homePath;
}

- (void)initialize{
    
    //数据初始化
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
}
- (TTIRequest*)wixinZhiFuWith:(NSString *)goods_name with:(NSString *)order_no with:(NSString *)fee with:(NSString *)IP withSucessBlock:(TTIRequestCompletedBlock)sucessBlock withFailedBlock:(TTIRequestCompletedBlock)failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter addUnEmptyString:goods_name forKey:@"goods_name"];
    [parameter addUnEmptyString:order_no forKey:@"order_no"];
    
//    NSString * jianGe = [NSString stringWithFormat:@"%f",fee.doubleValue*100];
//    NSString * jiaGe = [NSString stringWithFormat:@"%d",jianGe.intValue];
    NSString * jiaGe = [fee stringByReplacingOccurrencesOfString:@"." withString:@""];
    [parameter addUnEmptyString:jiaGe forKey:@"fee"];
    [parameter addUnEmptyString:IP forKey:@"ip"];
    TTIRequest *request = [self requestWithName:@"微信支付" withPath:@"/app/?url=wxpay/prepay" withParameters:parameter  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {

         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
- (TTIRequest *)wixinZhiFuWith:(NSString*)string withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
               withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter addUnEmptyString:string forKey:@"str"];
    TTIRequest *request = [self requestWithName:@"微信支付" withPath:@"/app/?url=wxpay/getsign" withParameters:parameter  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         //         NSString  *content = [response.result objectForKey:@"content"];
         //         response.responseModel = content;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark - Request Engine
- (TTIRequest *)requestWithName:(NSString *)requestName withPath:(NSString *)path
                 withParameters:(NSDictionary *)parameters withisPost:(BOOL)isPost{
    
    //普通请求
    TTIRequest *request = [[TTIRequest alloc] init];
    
    request.requestName = [NSString stringWithFormat:@"%@",requestName];
    request.requestPath = [NSString stringWithFormat:@"%@",path];
    [request.params addEntriesFromDictionary:parameters];
    
    
    if (isPost) {
        request.urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:parameters error:nil];
    }else{
        request.urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:parameters error:nil];
    }
    request.urlRequest.timeoutInterval = RequestTimeOut;
    
    return request;
}

- (TTIRequest *)uploadRequestWithName:(NSString *)requestName withPath:(NSString *)path
                       withParameters:(NSDictionary *)parameters withImageArr:(NSArray *)uploadImageArray
{
    //包含文件
    
    TTIRequest *request = [[TTIRequest alloc] init];
    request.requestName = [NSString stringWithFormat:@"%@",requestName];
    request.requestPath = [NSString stringWithFormat:@"%@",path];
    [request.params addEntriesFromDictionary:parameters];
    request.urlRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                          
    {
        // 添加多张图片
        __block int i = 0;
        for(UIImage *eachImage in uploadImageArray)
        {
            NSData *imageData = UIImageJPEGRepresentation(eachImage, 0.5);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"photos%d",i ] fileName:[NSString stringWithFormat:@"photos%d.jpg",i ] mimeType:@"image/jpeg"];
            i++;
        }
        
    }error:nil];
    
    request.urlRequest.timeoutInterval = RequestTimeOut;
    
    return request;
}

#pragma mark --- 验证手机号唯一性
-(TTIRequest *)phoneExistRequestWithEmail:(NSString *)email
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter addUnEmptyString:email forKey:@"email"];
    
    TTIRequest *request = [self requestWithName:@"验证手机号唯一性" withPath:@"/app/?url=user/phone_exist" withParameters:parameter withisPost:YES];
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    return request;

}

#pragma mark ---  手机号验证码发送
-(TTIRequest *)phoneCodeRequestWithEmail:(NSString *)email
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter addUnEmptyString:email forKey:@"email"];
    
    TTIRequest *request = [self requestWithName:@"手机号验证码发送" withPath:@"/app/?url=user/phone_code" withParameters:parameter withisPost:YES];
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         response.responseModel = [response.result objectForKey:@"code"];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    return request;
}


#pragma mark --- 版本检测
- (TTIRequest *)updateVersionRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter addUnEmptyString:@"1" forKey:@"type"];
    
    TTIRequest *request = [self requestWithName:@"版本检测" withPath:@"/app/?url=user/update_version" withParameters:parameter withisPost:YES];
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_version = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_Version];
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    return request;

}


#pragma mark --- 广告页
- (TTIRequest *)actAdRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    TTIRequest *request = [self requestWithName:@"广告页" withPath:@"/app/?url=home/system&act=ad" withParameters:nil withisPost:YES];
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSString *logo = [response.result objectForKey:@"logo"];
         [[LocalStoreManager shareInstance] setValueInDefault:logo withKey:DefaultKey_Advertise];
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    return request;

}

/**用户管理**/
#pragma mark ---用户注册
- (TTIRequest *)registerRequestWithemail:(NSString *)email
                                password:(NSString*)password
                              invitecode:(NSString *)invitecode
                                nickname:(NSString*)nickname
                                     sex:(NSString*)sex
                               equipment:(NSString *)equipment
                                   equip:(NSString *)equip
                                    page:(NSString *)page
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:email forKey:@"email"];
    [parames addUnEmptyString:password forKey:@"password"];
    [parames addUnEmptyString:invitecode forKey:@"invitecode"];
    [parames addUnEmptyString:page forKey:@"page"];
    [parames addUnEmptyString:equipment forKey:@"equipment"];
    if ([page isEqualToString:@"2"]) {
        [parames addUnEmptyString:sex forKey:@"sex"];
        [parames addUnEmptyString:nickname forKey:@"nickname"];
        

    }
    // user/new_reg
//    TTIRequest *request = [self requestWithName:@"用户注册" withPath:@"/app/?url=user/register" withParameters:parames withisPost:YES];
    TTIRequest *request = [self requestWithName:@"用户注册" withPath:@"/app/?url=user/new_reg" withParameters:parames withisPost:YES];

    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         LoginModel *login = [[LoginModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = login;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    return request;
}


#pragma mark ----发送验证码
- (TTIRequest *)fpwCodeRequestWithEmail:(NSString *)email
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:email forKey:@"email"];
    
    TTIRequest *request = [self requestWithName:@"发送验证码" withPath:@"/app/?url=user/fpw_code" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    return request;

}

#pragma mark ----重置密码
- (TTIRequest *)fpwResetRequestWithusername:(NSString *)email
                               withuserpswd:(NSString *)newPwd
                                   withcode:(NSString *)code
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:email forKey:@"email"];
    [parames addUnEmptyString:newPwd forKey:@"newPwd"];
    [parames addUnEmptyString:code forKey:@"code"];
    
    TTIRequest *request = [self requestWithName:@"重置密码" withPath:@"/app/?url=user/fpw_reset" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
    
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    return request;

}


#pragma mark - 用户登录
- (TTIRequest *)userLoginRequestWithusername:(NSString *)email
                                withuserpswd:(NSString *)password
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:email forKey:@"email"];
    [parames addUnEmptyString:password forKey:@"password"];
    
    TTIRequest *request = [self requestWithName:@"用户登录" withPath:@"/app/?url=user/signin" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_LoginStatus = 1;
         
         NSArray *hobby = [response.result objectForKey:@"hobby"];
         NSMutableArray *arr = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in hobby)
         {
             HobbyModel *hobby = [[HobbyModel alloc] initWithDictionary:dic error:nil];
             if(hobby != nil)
                 [arr addObject:hobby];
         }
         
         LoginModel *login = [[LoginModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = login;
         
         g_userInfo = login;
         g_userInfo.loginStatus = @"1";
         g_userInfo.pwd = password;
         if (![login.sex isEqualToString:@"1"]) {
             g_userInfo.sex = @"0";
         }
         
         [[LocalStoreManager shareInstance] setValueInDefault:arr withKey:DefaultKey_hobby];
         [[LocalStoreManager shareInstance] setValueInDefault:g_userInfo withKey:DefaultKey_Userinfo];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    return request;
}


#pragma mark ---- 注册协议
- (TTIRequest *)registerRuleRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                   withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    TTIRequest *request = [self requestWithName:@"注册协议" withPath:@"/app/?url=user/register_rule" withParameters:nil  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSString  *content = [response.result objectForKey:@"content"];
         response.responseModel = content;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ---- 泡泡堂社区须知
- (TTIRequest *)bbsRuleRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                              withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    TTIRequest *request = [self requestWithName:@"泡泡堂社区须知" withPath:@"/app/?url=user/bbs_rule" withParameters:nil  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSString  *content = [response.result objectForKey:@"content"];
         response.responseModel = content;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark ----用户注销
- (TTIRequest *)userLogoutRequestWithsid:(NSString *)sid
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    
    TTIRequest *request = [self requestWithName:@"用户注销" withPath:@"/app/?url=user/logout" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_LoginStatus = 0;
         g_userInfo.loginStatus = @"0";
         
         [[LocalStoreManager shareInstance] setValueInDefault:g_userInfo withKey:DefaultKey_Userinfo];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----获取个人信息
- (TTIRequest *)userInfoRequestWithsid:(NSString *)sid
                       withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    
    TTIRequest *request = [self requestWithName:@"获取个人信息" withPath:@"/app/?url=user/info" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_userInfo.user_photo = [response.result objectForKey:@"user_photo"];
         g_userInfo.user_rank = [response.result objectForKey:@"user_rank"];
         g_userInfo.rank_name = [response.result objectForKey:@"rank_name"];
         g_userInfo.cart_num = [response.result objectForKey:@"cart_num"];
         g_userInfo.pay_points = [response.result objectForKey:@"pay_points"];
         g_userInfo.red_dot = [response.result objectForKey:@"red_dot"];
         g_userInfo.message_red = [response.result objectForKey:@"message_red"];
         g_userInfo.isOpen = [response.result objectForKey:@"on_off"];
         g_userInfo.latest_msg_photo = [response.result objectForKey:@"latest_msg_photo"];
         g_userInfo.dengji = [response.result objectForKey:@"level"];
         g_userInfo.verify_config = [response.result objectForKey:@"verify_config"];
         g_userInfo.if_new_chatting = [response.result objectForKey:@"if_new_chatting"];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----编辑个人资料-昵称
- (TTIRequest *)userEditnicknameRequestWithNickname:(NSString *)nickname
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:nickname forKey:@"nickname"];
    
    TTIRequest *request = [self requestWithName:@"编辑个人资料-昵称" withPath:@"/app/?url=user/edit" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_userInfo.nickname = nickname;
         [[LocalStoreManager shareInstance] setValueInDefault:g_userInfo withKey:DefaultKey_Userinfo];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----编辑个人资料-生日
- (TTIRequest *)userEditbirthdayRequestWithconstellation:(NSString *)constellation
                                  withBirthday:(NSString *)birthday
                                       withAge:(NSString *)age
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:birthday forKey:@"birthday"];
    [parames addUnEmptyString:age forKey:@"age"];
    [parames addUnEmptyString:constellation forKey:@"constellation"];
    
    TTIRequest *request = [self requestWithName:@"编辑个人资料-生日" withPath:@"/app/?url=user/edit" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_userInfo.constellation = constellation;
         g_userInfo.birthday = birthday;
         g_userInfo.age = age;
         [[LocalStoreManager shareInstance] setValueInDefault:g_userInfo withKey:DefaultKey_Userinfo];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----编辑个人资料-兴趣爱好
- (TTIRequest *)userEdithobbyRequestWithsid:(NSString *)sid
                                  withHobby:(NSString *)hobby
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:hobby forKey:@"hobby"];
    
    TTIRequest *request = [self requestWithName:@"编辑个人资料-兴趣爱好" withPath:@"/app/?url=user/edit" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ----编辑个人资料-是否公开信息
- (TTIRequest *)userEditRequestWithOnOff:(NSString *)on_off
                       withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:on_off forKey:@"on_off"];
    
    TTIRequest *request = [self requestWithName:@"编辑个人资料-是否公开信息" withPath:@"/app/?url=user/edit" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark ----编辑个人资料-修改密码
- (TTIRequest *)userEditPasswordRequestWithold_password:(NSString *)old_password
                                           withpassword:(NSString *)password
                                          withpassword2:(NSString *)password2
                                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:old_password forKey:@"old_password"];
    [parames addUnEmptyString:password forKey:@"password"];
    [parames addUnEmptyString:password2 forKey:@"password2"];
    
    TTIRequest *request = [self requestWithName:@"编辑个人资料-修改密码" withPath:@"/app/?url=user/edit" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_userInfo.peepPassword = password;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----编辑个人资料-所在城市
- (TTIRequest *)userEditprovinceRequestWithsid:(NSString *)sid
                                  withProvince:(NSString *)province
                                      withCity:(NSString *)city
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:province forKey:@"province"];
    [parames addUnEmptyString:city forKey:@"city"];
    
    TTIRequest *request = [self requestWithName:@"编辑个人资料-所在城市" withPath:@"/app/?url=user/edit" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----收藏商品添加
- (TTIRequest *)goodsEditprovinceRequestWithsid:(NSString *)sid
                                  withGoods_id:(NSString *)goods_id
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:@"create" forKey:@"action"];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    
    TTIRequest *request = [self requestWithName:@"收藏商品添加" withPath:@"/app/?url=user/collect" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----收藏商品列表
- (TTIRequest *)goodsEditlistRequestWithsid:(NSString *)sid
                                   withpage:(NSString *)page
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:@"list" forKey:@"action"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"收藏商品列表" withPath:@"/app/?url=user/collect" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
      
         NSMutableArray *resultArr = [response.result objectForKey:@"result"];
         NSMutableArray *result = [NSMutableArray array];
      
         [resultArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             
             GoodModel *model = [[GoodModel alloc] initWithDictionary:obj error:nil];
             [result addObject:model];
         }];
        
         response.responseModel = result;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----收藏商品删除
- (TTIRequest *)goodsEditdeleteRequestWithsid:(NSString *)sid
                                  withrec_id:(NSString *)rec_id
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:@"delete" forKey:@"action"];
    [parames addUnEmptyString:rec_id forKey:@"rec_id"];
    
    TTIRequest *request = [self requestWithName:@"收藏商品删除" withPath:@"/app/?url=user/collect" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----取消收藏商品
- (TTIRequest *)goodsCancelRequestWithsid:(NSString *)sid
                             withgoods_id:(NSString *)goods_id
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:@"cancel" forKey:@"action"];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    
    TTIRequest *request = [self requestWithName:@"取消收藏商品" withPath:@"/app/?url=user/collect" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----我的金币
- (TTIRequest *)goldruleRequestWithtype:(NSString *)type
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:type forKey:@"type"];
    
    TTIRequest *request = [self requestWithName:@"我的金币" withPath:@"/app/?url=user/gold_rule" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         GoldModel *gold = [[GoldModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = gold;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark -- 金币明细
- (TTIRequest *)goldMingxiRequestWithtype:(NSString *)page
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.uid forKey:@"uid"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"我的金币" withPath:@"/app/?url=user/mycoindetail" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         GoldMingModel *gold = [[GoldMingModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = gold;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ----获取金币
- (TTIRequest *)get_integralRequestWithsid:(NSString *)sid
                             withtask_type:(NSString *)task_type
                                       fid:(NSString *)fid
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:task_type forKey:@"rule_code"];
    [parames addUnEmptyString:fid forKey:@"fid"];
    
    TTIRequest *request = [self requestWithName:@"获取金币" withPath:@"/app/?url=user/get_integral" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_userInfo.pay_points = [response.result objectForKey:@"pay_points"];
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----上传头像
- (TTIRequest *)upload_headRequestWithsid:(NSString *)sid
                                 withfile:(UIImage *)file
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    
    TTIRequest *request = [self uploadHeadWithName:@"上传头像" withPath:@"/app/?url=user/upload_head" withParameters:parames withImage:file];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

- (TTIRequest *)uploadHeadWithName:(NSString *)requestName withPath:(NSString *)path
                       withParameters:(NSDictionary *)parameters withImage:(UIImage *)image{
    
    //包含文件
    
    TTIRequest *request = [[TTIRequest alloc] init];
    
    request.requestName = [NSString stringWithFormat:@"%@",requestName];
    request.requestPath = [NSString stringWithFormat:@"%@",path];
    [request.params addEntriesFromDictionary:parameters];
    
    request.urlRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"pic"] fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
    }error:nil];
    
    request.urlRequest.timeoutInterval = RequestTimeOut;
    
    
    return request;
}


#pragma mark ----意见反馈
- (TTIRequest *)suggestionRequestWithsid:(NSString *)sid
                             withcontent:(NSString *)content
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:content forKey:@"content"];
    
    TTIRequest *request = [self requestWithName:@"意见反馈" withPath:@"/app/?url=user/suggestion" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----我的消息
- (TTIRequest *)messageRequestWithsid:(NSString *)sid
                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    
    TTIRequest *request = [self requestWithName:@"我的消息" withPath:@"/app/?url=user/message" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----邀请码
- (TTIRequest *)invitationCodeRequestWithsid:(NSString *)sid
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    
    TTIRequest *request = [self requestWithName:@"邀请码" withPath:@"/app/?url=user/invitation_code" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----等级说明
- (TTIRequest *)descriptionwithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    
    TTIRequest *request = [self requestWithName:@"等级说明" withPath:@"/app/?url=user/description" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----获取兴趣爱好
- (TTIRequest *)hobbyRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    
    TTIRequest *request = [self requestWithName:@"获取兴趣爱好" withPath:@"/app/?url=user/hobby" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSArray *hobby = [response.result objectForKey:@"result"];
         NSMutableArray *arr = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in hobby)
         {
             HobbyModel *hobby = [[HobbyModel alloc] initWithDictionary:dic error:nil];
             [arr addObject:hobby];
         }

         response.responseModel = arr;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----版本更新
- (TTIRequest *)updateVersionRequestWithnow_version:(NSString *)now_version
                                    withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:now_version forKey:@"now_version"];
    [parames addUnEmptyString:@"1" forKey:@"type"];
    
    TTIRequest *request = [self requestWithName:@"版本更新" withPath:@"/app/?url=home/get_version" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----注册时邮箱唯一性校验
- (TTIRequest *)emailExistRequestWithEmail:(NSString *)email
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:email forKey:@"email"];
    
    TTIRequest *request = [self requestWithName:@"注册时邮箱唯一性校验" withPath:@"/app/?url=user/email_exist" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark ----注册时用户名唯一性校验
- (TTIRequest *)userNameExistRequestWithUserName:(NSString *)userName
                                 withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                 withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:userName forKey:@"nickname"];
    
    TTIRequest *request = [self requestWithName:@"注册时用户名唯一性校验" withPath:@"/app/?url=user/nicknamecheck" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark - 商城

#pragma mark ----首页
- (TTIRequest *)homeRequestWithtype:(NSString *)type
                    withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:type forKey:@"type"];
    
    TTIRequest *request = [self requestWithName:@"首页" withPath:@"/app/?url=home/index" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----分类列表
- (TTIRequest *)categoryRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    
    TTIRequest *request = [self requestWithName:@"分类列表" withPath:@"/app/?url=home/category" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ----限时抢购列表
- (TTIRequest *)group_listRequestWithgroup_list:(NSString *)group_list
                                       withpage:(NSString *)page
                                withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:group_list forKey:@"group_list"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"限时抢购列表" withPath:@"/app/?url=home/group_list" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----赠品列表
- (TTIRequest *)comment_listRequestWithgoods_id:(NSString *)goods_id
                                       withpage:(NSString *)page
                                withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"赠品列表" withPath:@"/app/?url=home/comment_list" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----评论列表
- (TTIRequest *)gift_listRequestWithgoods_id:(NSString *)goods_id
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    
    TTIRequest *request = [self requestWithName:@"评论列表" withPath:@"/app/?url=home/gift_list" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----关于我们
- (TTIRequest *)systemRequestWithact:(NSString *)act
                     withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                     withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

//    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
//    [parames addUnEmptyString:@"aboutus" forKey:@"act"];
    
    TTIRequest *request = [self requestWithName:@"关于我们" withPath:@"/app/?url=home/system&act=aboutus" withParameters:nil  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSString *str = [response.result objectForKey:@"about_us"];
         response.responseModel = str;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----应用广告
- (TTIRequest *)systemAdRequestWithact:(NSString *)act
                       withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:@"ad" forKey:@"act"];
    
    TTIRequest *request = [self requestWithName:@"应用广告" withPath:@"/app/?url=home/system" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----新增收获地址
- (TTIRequest *)addAddressRequestWithsid:(NSString *)sid
                           withconsignee:(NSString *)consignee
                              withmobile:(NSString *)mobile
                            withprovince:(NSString *)province
                                withcity:(NSString *)city
                             withaddress:(NSString *)address
                             withzipcode:(NSString *)zipcode
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:consignee forKey:@"consignee"];
    [parames addUnEmptyString:mobile forKey:@"mobile"];
    [parames addUnEmptyString:province forKey:@"province"];
    [parames addUnEmptyString:city forKey:@"city"];
    [parames addUnEmptyString:address forKey:@"address"];
    [parames addUnEmptyString:zipcode forKey:@"zipcode"];
    
    TTIRequest *request = [self requestWithName:@"新增收货地址" withPath:@"/app/?url=address/add" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         AddressModel *address = [[AddressModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = address;

         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----修改收获地址
- (TTIRequest *)updateAddressRequestWithsid:(NSString *)sid
                             withaddress_id:(NSString *)address_id
                              withconsignee:(NSString *)consignee
                                 withmobile:(NSString *)mobile
                               withprovince:(NSString *)province
                                   withcity:(NSString *)city
                                withaddress:(NSString *)address
                                withzipcode:(NSString *)zipcode
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:address_id forKey:@"address_id"];
    [parames addUnEmptyString:consignee forKey:@"consignee"];
    [parames addUnEmptyString:mobile forKey:@"mobile"];
    [parames addUnEmptyString:province forKey:@"province"];
    [parames addUnEmptyString:city forKey:@"city"];
    [parames addUnEmptyString:address forKey:@"address"];
    [parames addUnEmptyString:zipcode forKey:@"zipcode"];
    
    TTIRequest *request = [self requestWithName:@"修改收获地址" withPath:@"/app/?url=address/update" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         AddressModel *address = [[AddressModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = address;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----删除收货地址
- (TTIRequest *)deleteAddressRequestWithsid:(NSString *)sid
                             withaddress_id:(NSString *)address_id
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:address_id forKey:@"address_id"];
    
    TTIRequest *request = [self requestWithName:@"删除收货地址" withPath:@"/app/?url=address/delete" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----收获地址列表
- (TTIRequest *)getAddressRequestWithsid:(NSString *)sid
                                   withpage:(NSString *)page
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"收获地址列表" withPath:@"/app/?url=address/list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSArray *resultArr = [response.result objectForKey:@"result"];
         NSMutableArray *arr = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in resultArr)
         {
             AddressModel *model = [[AddressModel alloc] initWithDictionary:dic error:nil];
             if(model != nil)
                 [arr addObject:model];
             
         }
         response.responseModel = arr;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----设置默认收获地址
- (TTIRequest *)setDefaultAddressRequestWithsid:(NSString *)sid
                                 withaddress_id:(NSString *)address_id
                                withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:address_id forKey:@"address_id"];
    
    TTIRequest *request = [self requestWithName:@"设置默认收获地址" withPath:@"/app/?url=address/setDefault" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----收货地址详细信息
- (TTIRequest *)infoAddressRequestWithsid:(NSString *)sid
                           withaddress_id:(NSString *)address_id
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:address_id forKey:@"address_id"];
    
    TTIRequest *request = [self requestWithName:@"收货地址详细信息" withPath:@"/app/?url=address/info" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----获取省份城市地区
- (TTIRequest *)regionAddressRequestWithparent_id:(NSString *)parent_id
                                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:parent_id forKey:@"parent_id"];
    
    TTIRequest *request = [self requestWithName:@"获取省份城市地区" withPath:@"/app/?url=address/region" withParameters:parames  withisPost:YES];
    if(_regionArr != nil && [parent_id isEqualToString:@"1"])
    {
        TTIResponse *response = [[TTIResponse alloc] init];
        response.responseModel = _regionArr;
        sucessBlock(request, response);
    }
    else
    {
        [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
         {
             NSArray *resultArr = [response.result objectForKey:@"result"];
             
             NSMutableArray *regionArr =[[NSMutableArray alloc] init];
             if([resultArr isKindOfClass:[NSArray class]])
             {
                 for(NSDictionary *dic in resultArr)
                 {
                     RegionModel *model = [[RegionModel alloc] initWithDictionary:dic error:nil];
                     if(model != nil)
                         [regionArr addObject:model];
                 }
                 
                 response.responseModel = regionArr;
                 
                 if([parent_id isEqualToString:@"1"])
                     _regionArr = regionArr;
             }
             sucessBlock(request, response);
         }
                             withFailedBlock:^(TTIRequest *request, TTIResponse *response)
         {
             failedBlock(request, response);
         }];

    }
    
    return request;
}

#pragma mark ----兑换中心
- (TTIRequest *)listExchangeRequestWithsid:(NSString *)sid
                                  withpage:(NSString *)page
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"兑换中心" withPath:@"/app/?url=exchange/list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----兑换商品详情
- (TTIRequest *)infoExchangeRequestWithsid:(NSString *)sid
                              withgoods_id:(NSString *)goods_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    
    TTIRequest *request = [self requestWithName:@"兑换商品详情" withPath:@"/app/?url=exchange/info" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         ExchangeInfoModel *info = [[ExchangeInfoModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = info;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ----去兑换商品
- (TTIRequest *)changingExchangeRequestWithGoods_id:(NSString *)goods_id
                                    withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    
    TTIRequest *request = [self requestWithName:@"去兑换商品" withPath:@"/app/?url=exchange/changing" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----确认兑换商品
- (TTIRequest *)submitExchangeRequestWithGoodsId:(NSString *)goods_id
                                   withAddressId:(NSString *)address_id
                                 withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                 withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    [parames addUnEmptyString:address_id forKey:@"address_id"];
    
    TTIRequest *request = [self requestWithName:@"确认兑换商品" withPath:@"/app/?url=exchange/submit" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ----订单金额计算
- (TTIRequest *)calculateOrderRequestWithsid:(NSString *)sid
                                 withcart_id:(NSString *)cart_id
                              withaddress_id:(NSString *)address_id
                            withpayment_code:(NSString *)payment_code
                             withshipping_id:(NSString *)shipping_id
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:cart_id forKey:@"cart_id"];
    [parames addUnEmptyString:address_id forKey:@"address_id"];
    [parames addUnEmptyString:payment_code forKey:@"payment_code"];
    [parames addUnEmptyString:shipping_id forKey:@"shipping_id"];
    
    TTIRequest *request = [self requestWithName:@"订单金额计算" withPath:@"/app/?url=order/calculate" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----订单提交
- (TTIRequest *)doneOrderRequestWithsid:(NSString *)sid
                            withcart_id:(NSString *)cart_id
                         withaddress_id:(NSString *)address_id
                       withpayment_code:(NSString *)payment_code
                        withshipping_id:(NSString *)shipping_id
                         withpostscript:(NSString *)postscript// 订单备注可为空，不为空时限50字以内
                           withintegral:(NSString *)integral
                           withneed_inv:(NSString *)need_inv
                           withinv_type:(NSString *)inv_type
                          withinv_payee:(NSString *)inv_payee// 发票抬头信息
                        withinv_content:(NSString *)inv_content
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:cart_id forKey:@"cart_id"];
    [parames addUnEmptyString:address_id forKey:@"address_id"];
    [parames addUnEmptyString:payment_code forKey:@"payment_code"];
    [parames addUnEmptyString:shipping_id forKey:@"shipping_id"];
    [parames addUnEmptyString:postscript forKey:@"postscript"];
    [parames addUnEmptyString:need_inv forKey:@"need_inv"];
    [parames addUnEmptyString:inv_content forKey:@"inv_content"];
    [parames addUnEmptyString:integral forKey:@"integral"];
    [parames addUnEmptyString:inv_type forKey:@"inv_type"];
    [parames addUnEmptyString:inv_payee forKey:@"inv_payee"];
    
    TTIRequest *request = [self requestWithName:@"订单提交" withPath:@"/app/?url=order/done" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         OrderResponseModel *model = [[OrderResponseModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = model;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----订单取消
- (TTIRequest *)cancelOrderRequestWithsid:(NSString *)sid
                             withorder_id:(NSString *)order_id
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:order_id forKey:@"order_id"];
    
    TTIRequest *request = [self requestWithName:@"订单取消" withPath:@"/app/?url=order/cancel" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;

}

#pragma mark ----确认收货
- (TTIRequest *)affirmReceivedOrderRequestWithsid:(NSString *)sid
                                     withorder_id:(NSString *)order_id
                                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:order_id forKey:@"order_id"];
    
    TTIRequest *request = [self requestWithName:@"确认收货" withPath:@"/app/?url=order/confirm" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----我的订单
- (TTIRequest *)listOrderRequestWithsid:(NSString *)sid
                               withtype:(NSString *)type
                               withpage:(NSString *)page
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:type forKey:@"type"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"我的订单" withPath:@"/app/?url=order/list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----订单详情
- (TTIRequest *)infoOrderRequestWithsid:(NSString *)sid
                           withorder_id:(NSString *)order_id
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:order_id forKey:@"order_id"];
    
    TTIRequest *request = [self requestWithName:@"订单详情" withPath:@"/app/?url=order/info" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----订单商品清单
- (TTIRequest *)goodsOrderRequestWithsid:(NSString *)sid
                            withorder_id:(NSString *)order_id
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:order_id forKey:@"order_id"];
    
    TTIRequest *request = [self requestWithName:@"订单商品清单" withPath:@"/app/?url=order/goods" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----评论商品
- (TTIRequest *)goods_commentsOrderRequestWithsid:(NSString *)sid
                                     withorder_id:(NSString *)order_id
                                      withcontent:(NSString *)content
                                 withcomment_rank:(NSString *)comment_rank
                                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:order_id forKey:@"order_id"];
    [parames addUnEmptyString:content forKey:@"content"];
    [parames addUnEmptyString:comment_rank forKey:@"comment_rank"];
    
    TTIRequest *request = [self requestWithName:@"评论商品" withPath:@"/app/?url=order/goods_comments" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----评论订单
- (TTIRequest *)commentsOrderRequestWithsid:(NSString *)sid
                                   order_id:(NSString *)order_id
                                    comment:(NSArray *)comment
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:order_id forKey:@"order_id"];
    [parames addUnEmptyString:[comment JSONString] forKey:@"comment"];
    
    TTIRequest *request = [self requestWithName:@"评论订单" withPath:@"/app/?url=order/docomment" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ----商品评论列表
- (TTIRequest *)comments_listOrderRequestWithgoods_id:(NSString *)goods_id
                                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    
    TTIRequest *request = [self requestWithName:@"商品评论列表" withPath:@"/app/?url=order/comments_list" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----购物车添加
- (TTIRequest *)addCartRequestWithsid:(NSString *)sid
                         withgoods_id:(NSString *)goods_id
                    withgoods_attr_id:(NSString *)goods_attr_id
                     withgoods_number:(NSString *)goods_number
                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    [parames addUnEmptyString:sid forKey:@"sid"];
    [parames addUnEmptyString:goods_attr_id forKey:@"goods_attr_id"];
    [parames addUnEmptyString:goods_number forKey:@"goods_number"];
    
    TTIRequest *request = [self requestWithName:@"购物车添加" withPath:@"/app/?url=cart/add" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----购物车数量修改
- (TTIRequest *)editCartRequestWithsid:(NSString *)sid
                           withcart_id:(NSString *)cart_id
                      withgoods_number:(NSString *)goods_number
                       withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:cart_id forKey:@"cart_id"];
    [parames addUnEmptyString:goods_number forKey:@"goods_number"];
    
    TTIRequest *request = [self requestWithName:@"购物车数量修改" withPath:@"/app/?url=cart/edit" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----购物车删除
- (TTIRequest *)deleteCartRequestWithsid:(NSString *)sid
                             withcart_id:(NSArray *)cart_id
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    
    NSString *json;
    if([NSJSONSerialization isValidJSONObject:cart_id])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cart_id options:NSJSONWritingPrettyPrinted error:nil];
        json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json data:%@",json);
    }
    if (json) {
        [parames setObject:json  forKey:@"cart_id"];
    }
    
    
    TTIRequest *request = [self requestWithName:@"购物车删除" withPath:@"/app/?url=cart/delete" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         [SVProgressHUD showSuccessWithStatus:@"删除成功"];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----购物车列表
- (TTIRequest *)cartListRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    
    TTIRequest *request = [self requestWithName:@"购物车列表" withPath:@"/app/?url=cart/list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSMutableArray *goodsList = [response.result objectForKey:@"goods_spec_list"];
         NSMutableArray *resultList = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in goodsList)
         {
             CartListGoodsModel *model = [[CartListGoodsModel alloc] initWithDictionary:dic error:nil];
             if(model != nil)
                 [resultList addObject:model];
         }
         
         NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:resultList, @"data", [response.result objectForKey:@"eight_free"], @"eight_free", nil];
         response.responseModel = resultDic;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ----立即购买
- (TTIRequest *)buyRequestWithsid:(NSString *)sid
                         goods_id:(NSString *)goods_id
                    goods_attr_id:(NSString *)goods_attr_id
                     goods_number:(NSInteger)goods_number
                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    [parames addUnEmptyString:goods_attr_id forKey:@"goods_attr_id"];
    [parames addUnEmptyString:[NSString stringWithFormat:@"%li", (long)goods_number] forKey:@"goods_number"];
    
    TTIRequest *request = [self requestWithName:@"立即购买" withPath:@"/app/?url=cart/buy" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         SettlementModel *settlement = [[SettlementModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = settlement;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}

#pragma mark ----购物车结算
- (TTIRequest *)settleCartRequestWithsid:(NSString *)sid
                             withcart_id:(NSString *)cart_id
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:cart_id forKey:@"cart_id"];
    
    TTIRequest *request = [self requestWithName:@"购物车结算" withPath:@"/app/?url=cart/settle" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         SettlementModel *settlement = [[SettlementModel alloc] initWithDictionary:response.result error:nil];
         response.responseModel = settlement;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;

}

#pragma mark - 商城首页
- (TTIRequest *)mallshopHomeRequestWithType:(NSString *)type withVersion:(NSString *)version withSucessBlock:(TTIRequestCompletedBlock)sucessBlock withFailedBlock:(TTIRequestCompletedBlock)failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:type forKey:@"type"];
     [parames addUnEmptyString:VERSION forKey:@"versionN"];
    TTIRequest *request = [self requestWithName:@"商城首页" withPath:@"/app/?url=home/index" withParameters:parames  withisPost:NO];
    
        [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
         {
             
             sucessBlock(request, response);
         }
                             withFailedBlock:^(TTIRequest *request, TTIResponse *response)
         {
             failedBlock(request, response);
         }];
        return request;
    
}

#pragma mark - 商城分类
- (TTIRequest *)mallshopCategoryRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString * str =  VERSION;
    [parames addUnEmptyString:@"1" forKey:@"type"];
    [parames addUnEmptyString:str forKey:@"versionN"];
    TTIRequest *request = [self requestWithName:@"商城分类" withPath:@"/app/?url=home/category_list" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}

#pragma mark - 商品列表
- (TTIRequest *)productsListRequestWithId:(NSString *)id
                                     page:(NSString *)page
                                    order:(NSString *)order
                                priceOrder:(NSString *)price_order
                                    user_id:(NSString *)user_id
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:id forKey:@"id"];
    [parames addUnEmptyString:page forKey:@"page"];
    [parames addUnEmptyString:order forKey:@"order"];
    [parames addUnEmptyString:price_order forKey:@"price_order"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
                                [parames addUnEmptyString:VERSION forKey:@"versionN"];
                                [parames addUnEmptyString:@"1" forKey:@"type"];
    TTIRequest *request = [self requestWithName:@"商品列表" withPath:@"/app/?url=home/goods_list" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}

#pragma mark - 商品详情
- (TTIRequest *)productsDetailRequestWithGoodsId:(NSString *)goods_id
                                         user_id:(NSString *)user_id
                                 withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                 withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    [parames addUnEmptyString:VERSION forKey:@"versionN"];
    [parames addUnEmptyString:@"1" forKey:@"type"];
    TTIRequest *request = [self requestWithName:@"商品详情" withPath:@"/app/?url=home/goods_info" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}

#pragma mark - 限时抢购列表
- (TTIRequest *)flashSaleRequestWithPage:(NSString *)page
                                 withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                 withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"限时抢购列表" withPath:@"/app/?url=home/group_list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}

#pragma mark - 赠品列表
- (TTIRequest *)giftListRequestWithGoodsid:(NSString *)goods_id
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    
    TTIRequest *request = [self requestWithName:@"赠品列表" withPath:@"/app/?url=home/gift_list" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}

#pragma mark - 评论列表
- (TTIRequest *)commentsListRequestWithGoodsid:(NSString *)goods_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    
    TTIRequest *request = [self requestWithName:@"评论列表" withPath:@"/app/?url=home/comment_list" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}

#pragma mark - 搜索商品
- (TTIRequest *)searchProductsListRequestWithKeyWord:(NSString *)keyword
                                                  page:(int)page
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock {
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:keyword forKey:@"keyword"];
    [parames addUnEmptyString:[NSString stringWithFormat:@"%i", page] forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"搜索商品" withPath:@"/app/?url=home/search_goods" withParameters:parames  withisPost:NO];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}

#pragma mark ---- 我的消息列表
-(TTIRequest *)messagelistRequestWithType:(NSString *)type
                                     page:(NSString *)page
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:type forKey:@"type"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"我的消息列表" withPath:@"/app/?url=user/message_list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSMutableArray *resultArr = [response.result objectForKey:@"result"];
         NSMutableArray *arr = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in resultArr)
         {
             MessageModel *message = [[MessageModel alloc] initWithDictionary:dic error:nil];
             if(message != nil)
                 [arr addObject:message];
         }
         response.responseModel = arr;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ---- 我的消息内容
-(TTIRequest *)messagecontentRequestWithMessageid:(NSString *)message_id
                                       withpage:(NSString *)page
                                withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:message_id forKey:@"message_id"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"我的消息内容" withPath:@"/app/?url=user/message_content" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSMutableArray *resultArr = [response.result objectForKey:@"result"];
         NSMutableArray *arr = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in resultArr)
         {
             MessageContentModel *message = [[MessageContentModel alloc] initWithDictionary:dic error:nil];
             if(message != nil)
                 [arr addObject:message];
         }
         response.responseModel = arr;
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 我的消息删除
-(TTIRequest *)messageDelRequestWithMesuid:(NSString *)mesu_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:mesu_id forKey:@"mesu_id"];
    
    TTIRequest *request = [self requestWithName:@"我的消息删除" withPath:@"/app/?url=user/message_delete" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 我的消息发送
-(TTIRequest *)messageSendRequestWithTo_user:(NSString *)to_user
                                withtcontent:(NSString *)content
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock {

    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:to_user forKey:@"to_user"];
    [parames addUnEmptyString:content forKey:@"content"];
    
    TTIRequest *request = [self requestWithName:@"我的消息发送" withPath:@"/app/?url=user/message_send" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark - 泡友圈
#pragma mark ---- 首页
- (TTIRequest *)indexBbsRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
//    ScrollImgModel * sim;
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
//    [parames addUnEmptyString:sim.id forKey:@"tid"];
    if(g_LoginStatus)
        [parames addUnEmptyString:g_userInfo.uid forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-首页" withPath:@"/app/?url=bbs/index" withParameters:parames  withisPost:YES];
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    return request;
}

#pragma mark ---- 分类
- (TTIRequest *)categoryBbsRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    if(g_LoginStatus)
        [parames addUnEmptyString:g_userInfo.uid forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-分类" withPath:@"/app/?url=bbs/category" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark -- 贴吧
- (TTIRequest *)tieBaWithUser_id:(NSString *)user_id withPage:(NSString *)page withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                 withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.uid forKey:@"uid"];
    [parames addUnEmptyString:page forKey:@"page"];
    TTIRequest *request = [self requestWithName:@"" withPath:@"/app/?url=user/forum_notification" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
         
         NSMutableArray  *arr= [response.result objectForKey:@"result"];
         for(NSDictionary *dic in arr)
         {
             Tongzhi *model = [[Tongzhi alloc] initWithDictionary:dic error:nil];
             model.message = [self base64Decode:model.message];
             model.my_message = [self base64Decode:model.my_message];
             if(model.fid)
             {
                 [resultArr addObject:model];
             }
         }
         response.responseModel = resultArr;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark ---- 圈子
- (TTIRequest *)circleBbsRequestWithFid:(NSString *)fid
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:fid forKey:@"fid"];
    if(g_LoginStatus)
        [parames addUnEmptyString:g_userInfo.uid forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-圈子" withPath:@"/app/?url=bbs/circle" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
         
         NSMutableArray  *arr= [response.result objectForKey:@"result"];
         for(NSDictionary *dic in arr)
         {
             BbsModel *model = [[BbsModel alloc] initWithDictionary:dic error:nil];
             if(model)
             {
                 [resultArr addObject:model];
             }
         }
         response.responseModel = resultArr;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 规则
- (TTIRequest *)ruleBbsRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                              withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    TTIRequest *request = [self requestWithName:@"泡友圈-规则" withPath:@"/app/?url=bbs/rule" withParameters:nil  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
        
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 发帖
- (TTIRequest *)addBbsRequestWithFid:(NSString *)fid
                             withTid:(NSString *)tid
                             withPup:(NSString *)pup
                         withSubject:(NSString *)subject
                         withMessage:(NSString *)message
                         withPhotos0:(UIImage *)photos0
                         withPhotos1:(UIImage *)photos1
                         withPhotos2:(UIImage *)photos2
                         withPhotos3:(UIImage *)photos3
                         withPhotos4:(UIImage *)photos4
                         withPhotos5:(UIImage *)photos5
                         withPhotos6:(UIImage *)photos6
                         withPhotos7:(UIImage *)photos7
withTag_ids:(NSArray *)tag_ids withVersion:(NSString *)version
                      withSex_Choose:(NSString *)sex_chose withSucessBlock:(TTIRequestCompletedBlock)sucessBlock withFailedBlock:(TTIRequestCompletedBlock)failedBlock

{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:fid forKey:@"fid"];
    [parames addUnEmptyString:tid forKey:@"tid"];
    [parames addUnEmptyArray:tag_ids forKey:@"tag_ids"];
    [parames addUnEmptyString:version forKey:@"versionN"];
    [parames addUnEmptyString:sex_chose forKey:@"sex_chose"];
    subject =[self base64Encode:subject];
    message = [self base64Encode:message];
    [parames addUnEmptyString:subject forKey:@"subject"];
    [parames addUnEmptyString:message forKey:@"message"];
    [parames addUnEmptyString:pup forKey:@"pup"];

    NSArray *imgArray = [NSArray arrayWithObjects:photos0, photos1, photos2, photos3, photos4, photos5, photos6, photos7, nil];
    
    TTIRequest *request = [self uploadRequestWithName:@"泡友圈-发帖" withPath:@"/app/?url=bbs/add" withParameters:parames withImageArr:imgArray];

    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];

    return request;
}

#pragma mark ---- 泡友榜
- (TTIRequest *)rankingBbsRequestWithFid:(NSString *)fid
                             withVersion:(NSString *)version
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:fid forKey:@"fid"];
    [parames addUnEmptyString:version forKey:@"versionN"];
    if(g_LoginStatus)
        [parames addUnEmptyString:g_userInfo.uid forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-泡友榜" withPath:@"/app/?url=bbs/ranking" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSArray *rankArr = [response.result objectForKey:@"ranking"];
         
         NSMutableArray *rankingArr = [NSMutableArray array];
         RankModel *my = [[RankModel alloc] initWithDictionary:[response.result objectForKey:@"my_info"] error:nil];
         for(NSDictionary *dic in rankArr)
         {
             RankModel *rank = [[RankModel alloc] initWithDictionary:dic error:nil];
             if(rank)
                 [rankingArr addObject:rank];
         }
         
         response.responseModel = [[NSDictionary alloc] initWithObjectsAndKeys: rankingArr, @"ranking", my, @"myinfo",  nil];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 我的关注看人列表
- (TTIRequest *)userFollowRequestWithPage:(NSString *)page
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-我的关注看人列表" withPath:@"/app/?url=user/follow" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSMutableArray *personArr = [NSMutableArray array];
          
         NSArray *resultArr =[response.result objectForKey:@"result"];
         for(NSDictionary *dic in resultArr)
         {
             RankModel  *person = [[RankModel alloc] initWithDictionary:dic error:nil];
             if(person)
             {
                 [personArr addObject:person];
             }
         }
         
         response.responseModel = personArr;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 我的关注看帖子列表
- (TTIRequest *)bbsFollowRequestWithPage:(NSString *)page
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-我的关注看帖子列表" withPath:@"/app/?url=bbs/follow" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSMutableArray *resultArr = [response.result objectForKey:@"result"];
         
         NSMutableArray *arr = [NSMutableArray array];
         for(NSDictionary *dic in resultArr)
         {
             PostListModel *model = [[PostListModel alloc] initWithDictionary:dic error:nil];
             if(model!= nil && ![g_userInfo.uid isEqualToString:model.user_id])
             {
                 model.subject = [self base64Decode:model.subject];
                 model.message = [self base64Decode:model.message];
                 [arr addObject:model];
             }
             
         }
         
         response.responseModel = arr;
             sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ---- 圈子签到加分
- (TTIRequest *)bbsSigninRequestWithFid:(NSString *)fid
                               withCode:(NSString *)code
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:fid forKey:@"fid"];
    [parames addUnEmptyString:code forKey:@"code"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-圈子签到加分" withPath:@"/app/?url=bbs/signin" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 送金币
- (TTIRequest *)giveGoldRequestWithUserid:(NSString *)user_id
                              WithGoldnum:(NSString *)gold_num
                              WithContent:(NSString *)content
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    [parames addUnEmptyString:gold_num forKey:@"gold_num"];
    [parames addUnEmptyString:content forKey:@"content"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-送金币" withPath:@"/app/?url=user/give_gold" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_userInfo.pay_points = [NSString stringWithFormat:@"%d", g_userInfo.pay_points.intValue - gold_num.intValue];
         [[LocalStoreManager shareInstance] setValueInDefault:g_userInfo withKey:DefaultKey_Userinfo];
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 加入黑名单
- (TTIRequest *)addBlackRequestWithUserid:(NSString *)user_id
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-加入黑名单" withPath:@"/app/?url=user/add_black" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 移除黑名单
- (TTIRequest *)cancelBlackRequestWithUserid:(NSString *)user_id
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-移除黑名单" withPath:@"/app/?url=user/cancel_black" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}



#pragma mark ---- 添加关注
- (TTIRequest *)addFollowRequestWithUserid:(NSString *)user_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-添加关注" withPath:@"/app/?url=user/add_follow" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark ---- 举报帖子
- (TTIRequest *)reportPostRequestWithTid:(NSString *)tid withreport_note:(NSString *)report_note withReport_type:(NSString *)report_type withSucessBlock:(TTIRequestCompletedBlock)sucessBlock withFailedBlock:(TTIRequestCompletedBlock)failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:tid forKey:@"tid"];
    [parames addUnEmptyString:report_type forKey:@"report_type"];
    [parames addUnEmptyString:report_note forKey:@"report_note"];
    TTIRequest *request = [self requestWithName:@"泡友圈-举报帖子" withPath:@"/app/?url=user/report_post" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark ---- 举报用户
- (TTIRequest *)reportPostRequestWithuserid:(NSString *)user_id withreport_note:(NSString *)report_note withReport_type:(NSString *)report_type withSucessBlock:(TTIRequestCompletedBlock)sucessBlock withFailedBlock:(TTIRequestCompletedBlock)failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:user_id forKey:@"rp_user_id"];
    [parames addUnEmptyString:report_type forKey:@"report_type"];
    [parames addUnEmptyString:report_note forKey:@"report_note"];
    TTIRequest *request = [self requestWithName:@"泡友圈-举报用户" withPath:@"/app/?url=user/report_user" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 圈子详情
- (TTIRequest *)circleInfoRequestWithFid:(NSString *)fid
                           withOrderType:(NSString *)order_type
                                withPage:(NSString *)page
withTag_id:(NSString *)tag_id   withVersion:(NSString *)version withSucessBlock:(TTIRequestCompletedBlock)sucessBlock withFailedBlock:(TTIRequestCompletedBlock)failedBlock

{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:fid forKey:@"fid"];
    [parames addUnEmptyString:order_type forKey:@"order_type"];
    [parames addUnEmptyString:page forKey:@"page"];
    [parames addUnEmptyString:tag_id forKey:@"tag_id"];
    [parames addUnEmptyString:version forKey:@"versionN"];
    if(g_LoginStatus)
        [parames addUnEmptyString:g_userInfo.uid forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-圈子详情" withPath:@"/app/?url=bbs/circle_info" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSArray *post_list = [response.result objectForKey:@"post_list"];
         NSArray *post_ding = [response.result objectForKey:@"post_ding"];
         
         BbsModel *info = [[BbsModel alloc] initWithDictionary:[response.result objectForKey:@"circle_info"] error:nil];
         
         NSMutableArray *dingArr = [NSMutableArray array];
         for(NSDictionary *dic in post_ding)
         {
             PostDingModel *model = [[PostDingModel alloc] initWithDictionary:dic error:nil];
             if(model)
             {
                 [dingArr addObject:model];
                 
                 model.subject = [self base64Decode:model.subject]; 
             }
         }
         
         NSMutableArray *listArr = [NSMutableArray array];
         BOOL image = YES;
         for(NSDictionary *dic in post_list)
         {
             PostListModel *model = [[ PostListModel alloc] initWithDictionary:dic error:nil];
             for (ImgInfoModel * imageModel in model.attachment) {
                 if (imageModel.width) {
                     image = YES;
                 }else{
                     image = NO;
                 }
             }
             if (image == YES) {
                 if ([info.if_thread_thumb isEqualToString:@"1"]) {
                     model.attachment = nil;
                 }
                 if(model)
                 {
                     [listArr addObject:model];
                     
                     model.subject = [self base64Decode:model.subject];
                     model.message = [self base64Decode:model.message];
                     
                 }
             }
             
         }
         
         response.responseModel = [NSMutableDictionary dictionaryWithObjectsAndKeys:info, @"info", dingArr, @"ding", listArr, @"list", nil];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ---- 加入圈子
- (TTIRequest *)addCircleRequestWithFid:(NSString *)fid
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:fid forKey:@"fid"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-加入圈子" withPath:@"/app/?url=user/add_circle" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 帖子详情
- (TTIRequest *)bbsPostRequestWithTid:(NSString *)tid
                             withPage:(NSString *)page
                      withSearchOrder:(NSString *)search_order
                              withFid:(NSString *)fid
                     withFromnotepage:(NSString *)fromnotepage
                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:tid forKey:@"tid"];
    [parames addUnEmptyString:page forKey:@"page"];
    [parames addUnEmptyString:fid forKey:@"fid"];
    [parames addUnEmptyString:search_order forKey:@"search_order"];
    [parames addUnEmptyString:fromnotepage forKey:@"fromnotepage"];
    if(g_LoginStatus)
        [parames addUnEmptyString:g_userInfo.uid forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-帖子详情" withPath:@"/app/?url=bbs/post" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSDictionary * dict = [response.result objectForKey:@"thread_info"];
         NSString * str = [dict objectForKey:@"message"];
         NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
         data = [GTMBase64 decodeData:data];
         NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//         NSLog(@"%@",string);
         PostListModel *info =[[PostListModel alloc] initWithDictionary:[response.result objectForKey:@"thread_info"]  error:nil];
        info.subject = [self base64Decode:info.subject];
         info.message = string;
         
         
         NSArray *postArr = [response.result objectForKey:@"post_info"];
         
         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in postArr)
         {
             PostDetailModel *detail =[[PostDetailModel alloc] initWithDictionary:dic error:nil];
             NSDictionary  *temp = [dic objectForKey:@"sub_post"];
             if([temp isKindOfClass:[NSDictionary class]])
             {
                detail.subPost = [[PostListModel alloc] initWithDictionary:temp error:nil];
             }
             if(detail!=nil)
             {
                 
                  if(detail.subPost != nil)
                  {
                      detail.subPost.subject = [self base64Decode:detail.subPost.subject];
                      detail.subPost.message = [self base64Decode:detail.subPost.message];
                  }
 
                  detail.message = [self base64Decode:detail.message];
                 [resultArr addObject:detail];
             }
         }
         
         response.responseModel = [NSMutableDictionary dictionaryWithObjectsAndKeys:info, @"thread_info",  resultArr, @"post_info", nil];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark -- 打赏
- (TTIRequest *)bbsPostRequestWithTid:(NSString *)tid
                              withFid:(NSString *)user_id
                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:tid forKey:@"tid"];
    [parames addUnEmptyString:g_userInfo.uid forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-帖子详情" withPath:@"/app/?url=bbs/thread_coin" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
- (TTIRequest *)bbsPostRequestWithTid:(NSString *)tid
                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:tid forKey:@"tid"];
    TTIRequest *request = [self requestWithName:@"泡友圈-帖子详情" withPath:@"/app/?url=bbs/thread_coin_list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ---- 我的话题
- (TTIRequest *)bbsThreadRequestWithPage:(NSString *)page
                         WithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:page forKey:@"page"];
    if(g_LoginStatus)
        [parames addUnEmptyString:g_userInfo.uid forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-我的话题" withPath:@"/app/?url=user/thread" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
         
         NSArray *postArr = [response.result objectForKey:@"post_list"];
         for(NSDictionary *dic in postArr)
         {
             PostListModel *model = [[PostListModel alloc] initWithDictionary:dic error:nil];
             if(model != nil)
             {
                model.subject = [self base64Decode:model.subject];
                model.message = [self base64Decode:model.message];
                 
                 [resultArr addObject:model];
             }
         }
         
         response.responseModel = resultArr;
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}



#pragma mark ---- Ta的话题
- (TTIRequest *)userThreadRequestWithUserId:(NSString *)user_id
                                   withPage:(NSString *)page
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-Ta的话题" withPath:@"/app/?url=user/thread" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         MessageModel  *userInfo = [[MessageModel alloc] initWithDictionary:[response.result objectForKey:@"user_info"] error:nil];
         
         NSArray *postArr = [response.result objectForKey:@"post_list"];
         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in postArr)
         {
             PostListModel *model = [[PostListModel alloc] initWithDictionary:dic error:nil];
             if(model != nil)
             {
                 model.subject = [self base64Decode:model.subject];
                 model.message = [self base64Decode:model.message];
                 [resultArr addObject:model];
             }
         }
         
         response.responseModel =[NSDictionary dictionaryWithObjectsAndKeys:resultArr, @"post_list",userInfo, @"user_info", nil];
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ---- Ta的资料
- (TTIRequest *)bbsFriendRequestWithUserId:(NSString *)user_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    if(g_LoginStatus)
        [parames addUnEmptyString:g_userInfo.uid forKey:@"my_user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-Ta的资料" withPath:@"/app/?url=user/firend" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         ContactInfoModel  *userInfo = [[ContactInfoModel alloc] initWithDictionary:[response.result objectForKey:@"user_info"] error:nil];
         NSMutableArray *hobbyArr = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in userInfo.hobby)
         {
             HobbyModel *hobby = [[HobbyModel alloc] initWithDictionary:dic error:nil];
             [hobbyArr addObject:hobby];
         }
         userInfo.hobby = hobbyArr;
         
         NSArray *postArr = [response.result objectForKey:@"gold_list"];
         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in postArr)
         {
             GoldListModel *model = [[GoldListModel alloc] initWithDictionary:dic error:nil];
             if(model != nil)
                 [resultArr addObject:model];
         }
         
         response.responseModel =[NSDictionary dictionaryWithObjectsAndKeys:resultArr, @"gold_list",userInfo, @"user_info", nil];

         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ---- 取消加入圈子
- (TTIRequest *)cancleCircleRequestWithFid:(NSString *)fid
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:fid forKey:@"fid"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-取消加入圈子" withPath:@"/app/?url=user/cancel_circle" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- 取消关注
- (TTIRequest *)cancelFollowRequestWithUserId:(NSString *)user_id
                              withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                              withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-取消关注" withPath:@"/app/?url=user/cancel_follow" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ---- 现有金币
- (TTIRequest *)nowGoldRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                              withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈-现有金币" withPath:@"/app/?url=user/now_gold" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         response.responseModel = [response.result objectForKey:@"pay_points"];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark ---- Ta的话题 - 赠送金币人物列表
- (TTIRequest *)userGoldListRequestWithUserId:(NSString *)user_id
                                     WithPage:(NSString *)page
                              withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                              withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    [parames addUnEmptyString:page forKey:@"page"];
    
    TTIRequest *request = [self requestWithName:@"Ta的话题 - 赠送金币人物列表" withPath:@"/app/?url=user/gold_list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         response.responseModel = [response.result objectForKey:@"pay_points"];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


#pragma mark ---- 泡友圈左侧消息 - 消息红点校验
- (TTIRequest *)messageRedRequestwithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                 withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:g_userInfo.sid forKey:@"sid"];
    
    TTIRequest *request = [self requestWithName:@"泡友圈左侧消息 - 消息红点校验" withPath:@"/app/?url=user/message_red" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         response.responseModel = [response.result objectForKey:@"message_red"];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}

#pragma mark -- 我的话题删除
- (TTIRequest *)myTopicCancelwithTid:(NSString *) tid withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                     withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:tid forKey:@"tid"];
    
    TTIRequest *request = [self requestWithName:@"我的话题删除" withPath:@"/app/?url=user/remove_thread" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
        sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}


- (NSString *)base64Encode:(NSString *)plainString
{
    if(plainString == nil)
        return nil;
    
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSLog(@"%@", base64String); // Zm9v
    return base64String;
}

- (NSString *)base64Decode:(NSString *)base64String
{
    if(base64String == nil)
        return nil;

    NSData *decodedData = [GTMBase64 decodeData:[base64String dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}
#pragma mark - -推送
- (TTIRequest*)tuisongRequestWith:(NSString *)uid withtype:(NSString *)type  withSucessBlock:(TTIRequestCompletedBlock)sucessBlock withFailedBlock:(TTIRequestCompletedBlock)failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:uid forKey:@"uid"];
    [parames addUnEmptyString:type forKey:@"flag"];
    
    TTIRequest *request = [self requestWithName:@"我的话题删除" withPath:@"/app/?url=user/push_mix_page" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSArray *postArr = [response.result objectForKey:@"thread_info"];
         NSArray *goodArr = [response.result objectForKey:@"goods"];
         NSMutableArray *resultArr = [[NSMutableArray alloc] init];
          NSMutableArray *goods = [[NSMutableArray alloc] init];
         for(NSDictionary *dic in postArr)
         {
             PostListModelTui *model = [[PostListModelTui alloc] initWithDictionary:dic error:nil];
             if(model != nil)
             {
                 model.subject = [self base64Decode:model.subject];
                 [resultArr addObject:model];
             }
         }
         for(NSDictionary *dic in goodArr)
         {
             GoodModelTui *model = [[GoodModelTui alloc] initWithDictionary:dic error:nil];
             if(model != nil)
             {
                 [goods addObject:model];
             }
         }

         
         response.responseModel =[NSDictionary dictionaryWithObjectsAndKeys:resultArr, @"thread_info",goods,@"goods", nil];
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma 在线客服
- (TTIRequest *)kefuChat:(NSString *)uid withcontent:(NSString*)content withNick_name:(NSString*)nick_name withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
         withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:uid forKey:@"user_id"];
    [parames addUnEmptyString:content forKey:@"content"];
    [parames addUnEmptyString:nick_name forKey:@"nickname"];
    TTIRequest *request = [self requestWithName:@"发送会话" withPath:@"/app/?url=chat/chatreceiver" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}
- (TTIRequest *)shuxinLiaotian:(NSString *)uid withlinenum:(NSString*)linenum withPage:(NSString*)page withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
               withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:uid forKey:@"user_id"];
    [parames addUnEmptyString:linenum forKey:@"linenum"];
    [parames addUnEmptyString:page forKey:@"page"];
    TTIRequest *request = [self requestWithName:@"更新会话" withPath:@"/app/?url=chat/chatrefresh" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
    
}
#pragma 获取客服未读消息
- (TTIRequest *)getUnReadMessageWithUserid:(NSString *)user_id withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    TTIRequest *request = [self requestWithName:@"获取客服未读消息" withPath:@"/app/?url=chat/chat_log" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark -- 我的订单列表（我的个人中心）
- (TTIRequest *)MyOrderList:(NSString *)user_id
            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
            withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    TTIRequest *request = [self requestWithName:@"个人中" withPath:@"/app/?url=user/order_info" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;

}
#pragma 我的订单列表
- (TTIRequest *)getOrderListMessage:(NSString *)user_id withpage:(NSString *)page withOrder_type:(NSString *)type withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
     //order/type_list  page  user_id  order_type
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    [parames addUnEmptyString:page forKey:@"page"];
    [parames addUnEmptyString:type forKey:@"order_type"];
    TTIRequest *request = [self requestWithName:@"个人中" withPath:@"/app/?url=order/type_list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
  
}
#pragma mark -- 提交售后服务
- (TTIRequest *)postSHServeWithuser_id:(NSString *)user_id
                          withorder_sn:(NSString *)order_sn
                          withgoods_id:(NSString *)goods_id
                        withproduct_id:(NSString *)product_id
                      withAmount_apply:(NSString *)amount_apply
                           withMessage:(NSString *)service_type
                          withOrder_id:(NSString *)order_id
                           withPhotos0:(UIImage *)photos0
                           withPhotos1:(UIImage *)photos1
                           withPhotos2:(UIImage *)photos2
                        withdescript:(NSString *)descript
                       withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    [parames addUnEmptyString:order_id forKey:@"order_id"];
    [parames addUnEmptyString:order_sn forKey:@"order_sn"];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    [parames addUnEmptyString:service_type forKey:@"service_type"];
    [parames addUnEmptyString:product_id forKey:@"product_id"];
    [parames addUnEmptyString:amount_apply forKey:@"amount_apply"];
    [parames addUnEmptyString:descript forKey:@"descript"];
    //amount_apply
    NSArray *imgArray = [NSArray arrayWithObjects:photos0, photos1, photos2, nil];
    
    TTIRequest *request = [self uploadRequestWithName:@"提交售后服务" withPath:@"/app/?url=after_sale/after_sale" withParameters:parames withImageArr:imgArray];
    
//    TTIRequest *request = [self requestWithName:@"提交售后服务" withPath:@"/app/?url=after_sale/after_sale" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;

}
#pragma mark -- 进度查询
- (TTIRequest *)checkJinDu:(NSString *)user_id withpage:(NSString *)page withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
           withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    [parames addUnEmptyString:page forKey:@"page"];
    TTIRequest *request = [self requestWithName:@"进度查询" withPath:@"/app/?url=after_sale/after_sale_list" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
}
#pragma mark -- 删除订单
- (TTIRequest *)cancleOrder:(NSString *)user_id withorder_sn:(NSString *)order_sn withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
            withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    [parames addUnEmptyString:order_sn forKey:@"order_sn"];
    TTIRequest *request = [self requestWithName:@"删除订单" withPath:@"/app/?url=order/remove_order" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;
 
}
#pragma mark -- 再次购买
- (TTIRequest *)buyAgain:(NSString *)goods_id withgoods_number:(NSString *)goodsNum withSid:(NSString *)sid withproduct_id:(NSString *)product_id withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
         withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:goods_id forKey:@"goods_id"];
    [parames addUnEmptyString:goodsNum forKey:@"goods_number"];
    [parames addUnEmptyString:product_id forKey:@"product_id"];
    [parames addUnEmptyString:sid forKey:@"sid"];
    TTIRequest *request = [self requestWithName:@"再次购买" withPath:@"/app/?url=order/buy_again" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;

}
#pragma mark -- 取消审核
- (TTIRequest *)cancelServeListWithuser_id:(NSString *)user_id withservice_id:(NSString *)service_id withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    [parames addUnEmptyString:service_id forKey:@"service_id"];
    TTIRequest *request = [self requestWithName:@"取消审核" withPath:@"/app/?url=after_sale/after_sale_cancel" withParameters:parames  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;

}
#pragma mark -- 客服在线
- (TTIRequest *)kefuisOnlinewithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    
    TTIRequest *request = [self requestWithName:@"客服在线" withPath:@"/app/?url=chat/if_online" withParameters:nil  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;

}
#pragma mark -- 运单查询
- (TTIRequest *)shouhuoDiZhiChaXun:(NSString *)yunDanHao withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                   withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    TTIRequest *request = [self requestWithName:@"客服在线" withPath:@"/app/?url=chat/if_online" withParameters:nil  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;

}
- (TTIRequest *)postMovie:(NSString *)user_id withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
          withFailedBlock:(TTIRequestCompletedBlock )failedBlock
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionaryWithCapacity:0];
    [parames addUnEmptyString:user_id forKey:@"user_id"];
    TTIRequest *request = [self requestWithName:@"上传视频" withPath:@"/app/?url=media/get_token" withParameters:nil  withisPost:YES];
    
    [request startRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         sucessBlock(request, response);
     }
                         withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         failedBlock(request, response);
     }];
    
    return request;

}
//Unicode转UTF-8

//-(NSString *)encodeToPercentEscapeString:(NSString *)input
//
//{
//    if(!input)
//        return input;
//    // Encode all the reserved characters, per RFC 3986     // (<http://www.ietf.org/rfc/rfc3986.txt>)
//    
//    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                              (CFStringRef)input,
//                                                                              NULL,
//                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                              kCFStringEncodingUTF8));
//    
//    return outputStr;
//     
//}
//
//
//-(NSString *)decodeFromPercentEscapeString:(NSString *)input
//{
//    if(!input)
//        return input;
//    
//    NSMutableString *outputStr = [NSMutableString stringWithString:input];
//    [outputStr replaceOccurrencesOfString:@"+"
//                               withString:@" "
//                                  options:NSLiteralSearch
//                                    range:NSMakeRange(0, [outputStr length])];  
//    
//    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//}

@end
