//
//  WebViewController.m
//  yongai
//
//  Created by myqu on 15/3/23.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BJCLOLR;
    self.myWebView.backgroundColor = BJCLOLR;
    self.myWebView.delegate = self;
//    self.myWebView.tintColor = [UIColor redColor];
    
    if(self.bShowBbsRule == YES)
    {
        //初始化导航
        NAV_INIT(self, @"Darlin社区须知", @"common_nav_back_icon", @selector(back), nil, nil);
        [self requestBbsRuleData];
    }
    else
    {
        //初始化导航
        NAV_INIT(self, @"Darlin用户协议", @"common_nav_back_icon", @selector(back), nil, nil);
        [self requestData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestBbsRuleData
{
    [[TTIHttpClient shareInstance] bbsRuleRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        NSString *stringInfo = response.responseModel;
        stringInfo = [stringInfo stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
        [self.myWebView loadHTMLString:stringInfo baseURL:nil];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
         [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

-(void)requestData
{
    [[TTIHttpClient shareInstance] registerRuleRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        NSString *stringInfo = response.responseModel;
        stringInfo = [stringInfo stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
        [self.myWebView loadHTMLString:stringInfo baseURL:nil];
  
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //字体大小
    //    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'"];
    //字体颜色
    //    [UIColor grayColor]
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#6c6155'"];
    //页面背景色
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#f5f0eb'"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
