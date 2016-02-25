//
//  ChangePeepPasswordViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ChangePeepPasswordViewController.h"

@interface ChangePeepPasswordViewController ()

@end

@implementation ChangePeepPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"修改密码", @"common_nav_back_icon", @selector(backAction), nil, nil);
    
    self.view.backgroundColor = BJCLOLR;
    
    // don't want to add automatic toolbar over keyboard
    self.oldPassowrd.inputAccessoryView = [[UIView alloc] init];
    self.passowrd.inputAccessoryView = [[UIView alloc] init];
    self.passowrd2.inputAccessoryView = [[UIView alloc] init];
    self.makeSureBtn.backgroundColor = beijing;
    self.makeSureBtn.layer.masksToBounds = YES;
    self.makeSureBtn.layer.cornerRadius = 5;
    self.shuruMiMa.textColor = BLACKTEXT;
    self.sureMiMa.textColor = BLACKTEXT;
    self.shuRuNewMiMa.textColor = BLACKTEXT;
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureBtn:(id)sender {

    if (ICIsStringEmpty(_oldPassowrd.text)) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
        return;
    }
    if (ICIsStringEmpty(_passowrd.text)) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if (ICIsStringEmpty(_passowrd2.text)) {
        
        [SVProgressHUD showErrorWithStatus:@"请确认新密码"];
        return;
    }
    
    [[TTIHttpClient shareInstance] userEditPasswordRequestWithold_password:_oldPassowrd.text
                                                              withpassword:_passowrd.text
                                                             withpassword2:_passowrd2.text
                                                           withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
                                                               [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                               
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

@end
