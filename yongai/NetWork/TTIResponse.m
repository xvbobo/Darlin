//
//  TTIResponse.m
//  iOSCodeProject
//
//  Created by Fox on 14-7-22.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import "TTIResponse.h"
#import "TTIHttpClient.h"

@implementation TTIResponse

#pragma mark - Init
-(id)initWithResponseDic:(NSDictionary *)response{
    self = [super init];
    
    if (self) {
        [self initializeWithDic:response];
    }
    
    return self;
}

- (void)initializeWithDic:(NSDictionary *)response{
    
    //数据初始化
    _isSuccess = NO;
    
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]
        || [response objectForKey:@"status"] == nil) {
        self.error_desc = DATA_FORMAT_ERROR;
        return;
    }
    _isSuccess = [[response objectForKey:@"status"] boolValue];
    
    if (_isSuccess == NO && [response objectForKey:@"resultMsg"]!= nil ) {
        self.error_desc = [NSString stringWithFormat:@"%@",[response objectForKey:@"resultMsg"]];
        
        return;
    }
    
    if (_isSuccess == NO && [response objectForKey:@"resultMsg"]== nil ) {
        self.error_desc = DATA_FORMAT_ERROR;
        return;
    }
    
    if (_isSuccess == YES && [response objectForKey:@"data"] == nil) {
        self.error_desc = DATA_FORMAT_ERROR;
        return;
    }
    
    NSDictionary *result = [response objectForKey:@"data"];
    
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        _isSuccess = YES;
        self.result = result;
       
    }else if ([result isKindOfClass:[NSArray class]]){
        _isSuccess = YES;
        self.result = [NSDictionary dictionaryWithObject:result forKey:@"result"];
        
    }else if(result != nil){
        self.result = [NSDictionary dictionaryWithObject:result forKey:@"result"];
    }
    else{
        _isSuccess = NO;
        self.error_desc = DATA_FORMAT_ERROR;
    }
}

- (void)loadResultData:(NSDictionary *)resultData{
    
    _isSuccess = NO;
    
    if (resultData == nil || ![resultData isKindOfClass:[NSDictionary class]]
        || [resultData objectForKey:@"status"] == nil) {
        self.error_desc = DATA_FORMAT_ERROR;
        return;
    }
    
    if ([[[resultData objectForKey:@"status"] stringValue] isEqualToString:@"1"]) {
        _isSuccess = YES;
    }else{
        self.error_code = [resultData objectForKey:@"error_code"];
        _isSuccess = NO;
    }
    
    if (_isSuccess == NO && [resultData objectForKey:@"error_desc"]!= nil ) {
        self.error_desc = [NSString stringWithFormat:@"%@",[resultData objectForKey:@"error_desc"]];
        return;
    }
    
    if (_isSuccess == NO && [resultData objectForKey:@"error_desc"]== nil ) {
        self.error_desc = [NSString stringWithFormat:@"%@",[resultData objectForKey:@"error_desc"]];
        return;
    }
    
    if (_isSuccess == YES && [resultData objectForKey:@"data"] == nil) {
        self.error_desc = [NSString stringWithFormat:@"%@",[resultData objectForKey:@"error_desc"]];
        return;
    }
    
    NSDictionary *result = [resultData objectForKey:@"data"];
    self.error_desc = [resultData objectForKey:@"error_desc"];
    if ([result isKindOfClass:[NSDictionary class]]) {
        _isSuccess = YES;
        self.result = result;
        self.error_desc = [resultData objectForKey:@"error_desc"];
    }
    else if ([result isKindOfClass:[NSArray class]]){
        _isSuccess = YES;
        self.result = [NSDictionary dictionaryWithObject:result forKey:@"result"];
    }else if(result != nil){
        self.result = [NSDictionary dictionaryWithObject:result forKey:@"result"];
    }
    else{
        _isSuccess = NO;
//        self.error_desc = [resultData objectForKey:@"error_desc"];
        self.error_desc = DATA_FORMAT_ERROR;
    }
}


#pragma mark - Detail action
-(NSString *)description{
    
    NSMutableString *descripString = [NSMutableString stringWithFormat:@""];
    [descripString appendString:@"\n========================Response Info===========================\n"];
    [descripString appendFormat:@"Response Name:%@\n",self.responseName];
    [descripString appendFormat:@"Response Content:\n%@\n",self.result];
    [descripString appendString:@"===============================================================\n"];
    return descripString;
}

@end
