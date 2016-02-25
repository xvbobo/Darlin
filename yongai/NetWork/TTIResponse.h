//
//  TTIResponse.h
//  iOSCodeProject
//
//  Created by Fox on 14-7-22.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTIResponse : NSObject

-(id)initWithResponseDic:(NSDictionary *)responseDic;

@property (nonatomic, strong) NSString *responseName;   //响应请求名字
@property (nonatomic, assign) BOOL isSuccess;           //是否成功
@property (nonatomic, strong) NSString *error_desc;       //错误信息
@property (nonatomic, strong) NSDictionary *result;     //结果数据
@property (nonatomic, strong) NSString     *status;
@property (nonatomic, strong) NSString     *error_code; //错误码

@property (nonatomic, strong)id responseModel; //

/**
 *  加载结果数据
 *
 *  @param resultData 结果数据
 */
- (void)loadResultData:(NSDictionary *)resultData;


/**
 *  描述当前对象
 *
 *  @return 当前对象的字符串
 */
-(NSString *)description;

@end
