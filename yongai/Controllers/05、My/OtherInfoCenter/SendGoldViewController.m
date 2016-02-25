//
//  SendGoldViewController.m
//  Yongai
//
//  Created by myqu on 14/11/11.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "SendGoldViewController.h"
#import "TTITextView.h"

@interface SendGoldViewController ()
{
    IBOutlet UILabel *nowGoldLabel;
    IBOutlet UITextField *goldNumTextField;
    IBOutlet TTITextView *contentTextView;
    
}
// 确认赠送
- (IBAction)sureSendBtnClick:(id)sender;

@end

@implementation SendGoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"送金币", @"common_nav_back_icon", @selector(backAction), nil, nil);
    self.sureBtn.backgroundColor = beijing;
    contentTextView.placeholder = @"跟他说几句悄悄话吧...";
    contentTextView.placeholderColor = TEXT;
    self.xianYou.textColor = BLACKTEXT;
    self.zengSong.textColor = BLACKTEXT;
    self.view.backgroundColor = BJCLOLR;
    goldNumTextField.textColor = TEXT;
    [self initData];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData
{
    [[TTIHttpClient shareInstance] nowGoldRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        nowGoldLabel.text = response.responseModel;
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

- (IBAction)sureSendBtnClick:(id)sender {
    
    if(goldNumTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入你要赠送的金币值"];
        return;
    }
    
    [[TTIHttpClient shareInstance] giveGoldRequestWithUserid:self.receiverId
                                                 WithGoldnum:goldNumTextField.text
                                                 WithContent:contentTextView.text
                                             withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        
        [SVProgressHUD showSuccessWithStatus:@"赠送成功"];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.0];
                                             } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
    {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
                                                 
    }];
}

@end
