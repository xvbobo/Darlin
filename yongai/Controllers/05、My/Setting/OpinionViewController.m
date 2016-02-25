//
//  OpinionViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "OpinionViewController.h"

@interface OpinionViewController ()

@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"意见反馈", @"common_nav_back_icon", @selector(backAction), nil, nil);
    self.view.backgroundColor = BJCLOLR;
    _textView.placeholder = @"请输入反馈意见，便于我们及时纠正！";
    [self.button setBackgroundColor:beijing];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5;
    [self.button setTitle:@"提交反馈" forState:UIControlStateNormal];
    self.textView.inputAccessoryView = [[UIView alloc] init];
    self.textView.textColor = BLACKTEXT;
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;

}
- (void)doneAction
{
    if(self.textView.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入反馈意见"];
        return;
    }
    
    [[TTIHttpClient shareInstance] suggestionRequestWithsid:nil withcontent:self.textView.text withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:@"反馈意见成功！"];
        [self backAction];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];

}
- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
