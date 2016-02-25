//
//  ModifyNickNameViewController.m
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ModifyNickNameViewController.h"

@interface ModifyNickNameViewController ()

@end

@implementation ModifyNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NAV_INIT(self, @"编辑", @"common_nav_back_icon", @selector(backAction), nil, nil);
    self.view.backgroundColor = BJCLOLR;
    _nickNameTextFiled.text = g_userInfo.nickname;
    _nickNameTextFiled.textColor = BLACKTEXT;
    _nameLable.textColor = BLACKTEXT;
    _baoCunBtn.backgroundColor = beijing;
    _baoCunBtn.layer.masksToBounds = YES;
    _baoCunBtn.layer.cornerRadius = 5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveNameBtnClick:(id)sender {
    if(self.nickNameTextFiled.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return;
    }
    [[TTIHttpClient shareInstance] userEditnicknameRequestWithNickname:_nickNameTextFiled.text  withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
         [self.navigationController popViewControllerAnimated:YES];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
   
}
@end
