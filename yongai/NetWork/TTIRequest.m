//
//  TTIRequest.m
//  iOSCodeProject
//
//  Created by Fox on 14-7-21.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import "TTIRequest.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"
#import "TTIHttpClient.h"
#import "TTIResponse.h"


@interface TTIRequest (){

    AFHTTPRequestOperation *opera;
    SVProgressHUD * svp;
    
}

@property (nonatomic, assign) BOOL isManualCancel;      //是否为手动取消，默认为NO

@end

@implementation TTIRequest

#pragma mark - Init
-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize{
    
    //数据初始化
    self.params = [[NSMutableDictionary alloc] init];
    self.isManualCancel = NO;
}

- (void)startRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock{
//菊花视图
    NSLog(@"%@",self.requestName);
//    [SVProgressHUD dismiss];
    if (![self.requestName isEqualToString:@"版本检测"]) {
        if ([self.requestName isEqualToString:@"商城首页"]||[self.requestName isEqualToString:@"泡友圈-首页"]||[self.requestName isEqualToString:@"商城分类"]||[self.requestName isEqualToString:@"泡友圈-现有金币"]||[self.requestName isEqualToString:@"购物车列表"]||[self.requestName isEqualToString:@"获取个人信息"]||[self.requestName isEqualToString:@"个人中"]||[self.requestName isEqualToString:@"泡友圈-圈子详情"]||[self.requestName isEqualToString:@"客服在线"]){
            [SVProgressHUD dismiss];
        }else{
           [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        }
        
    }

    
    opera = [[AFHTTPRequestOperation alloc] initWithRequest:self.urlRequest];
    
    __block TTIRequest *blockSelf = self;
    
    //开始请求
    [opera setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSString * cachepath = [self filePath:@"缓存"];
            [blockSelf processSucessBlockwithOperation:operation
                                    withResponseObject:responseObject
                                       WithSucessBlock:sucessBlock
                                       withFailedBlock:failedBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [blockSelf processFailureBlockwithOperation:operation
                                         withError:error
                                   withFailedBlock:failedBlock];
    }];
    
    [opera start];
    
    NSLog(@"%@",self);
}


- (void)cancelRequest{

    self.isManualCancel = YES;
    [opera cancel];
}

#pragma mark - Process Data
- (void)processSucessBlockwithOperation:(AFHTTPRequestOperation *)operation
                     withResponseObject:(id )responseObject
                        WithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock{
    
    //处理成功时的请求
//    [SVProgressHUD dismiss];
//    [SVProgressHUD showUIActivityIndicatorView];
    NSMutableDictionary *responseData = [NSMutableDictionary dictionary];
    
    @try {
        [responseData addEntriesFromDictionary:[responseObject  objectFromJSONData]];
    }
    @catch (NSException *exception) {
        [SVProgressHUD showErrorWithStatus:DATA_FORMAT_ERROR];
    }
    TTIResponse *response = [[TTIResponse alloc] init];
    response.responseName = [NSString stringWithFormat:@"%@响应",self.requestName];
    [response loadResultData:responseData];
    
    NSLog(@"%@",response);
    
    if (response.isSuccess == YES) {
        //请求成功
        NSLog(@"请求成功");
        [SVProgressHUD dismiss];
        sucessBlock(self,response);
        
    }else{
        //请求失败，会自动输出错误信息
        if ([self.requestName isEqualToString:@"更新会话"]) {
            return;
        }else{
//            [SVProgressHUD showErrorWithStatus:response.error_desc];
            NSLog(@"请求失败");
            failedBlock(self,response);
        }
        
    }
}

- (void)processFailureBlockwithOperation:(AFHTTPRequestOperation *)operation
                         withError:(NSError *)error
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock{
    
    TTIResponse *response = [[TTIResponse alloc] initWithResponseDic:nil];
    response.responseName = [NSString stringWithFormat:@"%@响应",self.requestName];
    response.error_desc = REQUEST_FAILE;
    
    NSLog(@"%@",response);
    
    //手动取消的不弹出错误
    if (self.isManualCancel == NO) {
        if ([self.requestName isEqualToString:@"更新会话"]) {
            return;
        }else{
//          [SVProgressHUD showErrorWithStatus:REQUEST_FAILE];
        }
        //REQUEST_FAILE
    }else{
//        [SVProgressHUD dismiss];
       
    }

    failedBlock(self,response);
    
}

#pragma mark - 

-(NSString *)description{
    
    NSMutableString *descripString = [NSMutableString stringWithFormat:@""];
    [descripString appendString:@"\n========================Request Info==========================\n"];
    [descripString appendFormat:@"Request Name:%@\n",self.requestName];
    [descripString appendFormat:@"Request Url:%@%@\n",HTTPBASEURL,self.requestPath];
    [descripString appendFormat:@"Request Methods:%@\n",[self.urlRequest HTTPMethod]];
    [descripString appendFormat:@"Request params:\n%@\n",self.params];
    [descripString appendString:@"===============================================================\n"];
    return descripString;
}

@end
