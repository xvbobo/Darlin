//
//  ChartRuleViewController.m
//  Yongai
//
//  Created by myqu on 14-11-18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ChartRuleViewController.h"

@interface ChartRuleViewController ()
{

}
@end

@implementation ChartRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentTextView.textColor = BLACKTEXT;
    self.contentTextView.backgroundColor = BJCLOLR;
    self.view.backgroundColor = BJCLOLR;
    self.contentTextView.font = [UIFont systemFontOfSize:14.5];
    // Do any additional setup after loading the view.
    if ([self.titleStr isEqualToString:@"经验规则"]) {
         NAV_INIT(self, self.titleStr, @"common_nav_back_icon", @selector(backView), nil, nil);
    }else{
        NAV_INIT(self,@"达人规则", @"common_nav_back_icon", @selector(backView), nil, nil);
    }
   

    [self initData];
}

-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData
{
    [[TTIHttpClient shareInstance] ruleBbsRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        NSString *content = [response.result objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        _contentTextView.text = content;
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

@end
