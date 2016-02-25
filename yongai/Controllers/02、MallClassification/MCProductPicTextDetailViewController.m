//
//  MCProductPicTextDetailViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductPicTextDetailViewController.h"
#import "CommonUtils.h"

@interface MCProductPicTextDetailViewController ()<UIWebViewDelegate>

@end

@implementation MCProductPicTextDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentWebView.delegate = self;
    [self initlization];
    [self loadNavView];
    [self loadContentWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initlization{
    
    
}

- (void)loadNavView{
    
    NAV_INIT(self, @"图文详情", @"common_nav_back_icon", @selector(back), nil, nil);
}

- (void)loadContentWebView{
    
    self.contentWebView.scalesPageToFit = YES;
//    [self.contentWebView loadHTMLString:[NSString stringWithFormat:@"<color = '#c2a585'>%@",self.contentHtmlStr] baseURL:nil];
    [self.contentWebView loadHTMLString:self.contentHtmlStr baseURL:nil];
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.contentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#f5f0eb'"];
}
@end
