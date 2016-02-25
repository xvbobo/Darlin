//
//  TTIRequest.h
//  iOSCodeProject
//
//  Created by Fox on 14-7-21.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTIResponse.h"

@class TTIRequest;

#if NS_BLOCKS_AVAILABLE
typedef void(^TTIRequestCompletedBlock)(TTIRequest *request, TTIResponse *response);
#endif

@interface TTIRequest : NSObject


@property (nonatomic, strong) NSString *requestName;
@property (nonatomic, strong) NSString *requestPath;

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;

- (void)startRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


- (void)cancelRequest;

@end
