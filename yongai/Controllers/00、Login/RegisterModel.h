//
//  RegisterModel.h
//  Yongai
//
//  Created by Kevin Su on 14/12/1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "JSONModel.h"

/**
 *  注册Model
 */
@interface RegisterModel : JSONModel

@property (nonatomic ,strong) NSString *account;//账号
@property (nonatomic ,strong) NSString *password;
@property (nonatomic ,strong) NSString *repassword;
@property (nonatomic ,strong) NSString *vercode;//邀请码
@property (nonatomic ,strong) NSString *nickname;
@property (nonatomic ,strong) NSString *birthday;
@property (nonatomic ,strong) NSString *age;
@property (nonatomic ,strong) NSString *constellation;// 星座
@property (nonatomic ,strong) NSString *sexual;
@property (nonatomic ,strong) NSString *location;//所在城市

@end
