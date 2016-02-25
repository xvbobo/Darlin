//
//  AboutViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"关于我们", @"common_nav_back_icon", @selector(backAction), nil, nil);
    
    // 设置webView透明背景
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    
    self.view.backgroundColor = BJCLOLR;
    [self initDataView];
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initDataView
{
    [[TTIHttpClient shareInstance] systemRequestWithact:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [self.webView loadHTMLString:response.responseModel baseURL:[NSURL URLWithString:HTTPBASEURL]];

    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        
    }];
}
@end
