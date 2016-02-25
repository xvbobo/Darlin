//
//  MallNavViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MallNavViewController.h"

@interface MallNavViewController ()

@end

@implementation MallNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = BJCLOLR;
//    self.shangCheng.title = @"ad";
    // Do any additional setup after loading the view.
    [self.navigationBar setTranslucent:NO];
    isHideLoadingMore = YES;
    [[TTIHttpClient shareInstance] mallshopHomeRequestWithType:@"1" withVersion:VERSION withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        if (response.result) {
            NSDictionary *dic = response.result;
          NSArray *  qianggouArray = (NSArray *)dic[@"count_down"];
            if (qianggouArray.count == 0) {
                self.shangCheng.title = @"特卖";
            }else{
                self.shangCheng.title = @"商城";
            }
        
        }else{
            return ;
        }
       
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
//        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];

}


@end
