//
//  LoginViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterStepOneViewController.h"
#import "CommonUtils.h"
#import "ForgetPwdViewController.h"

@interface LoginViewController ()
- (IBAction)forgetPwdBtnClick:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initlization];
    [self loadBaseUI];
    self.view.backgroundColor = BJCLOLR;
    self.navigationController.navigationBar.barTintColor = beijing;
    [self.forgetBtn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
    // don't want to add automatic toolbar over keyboard
    self.usernameTextField.inputAccessoryView = [[UIView alloc] init];
    self.passwordTextField.inputAccessoryView = [[UIView alloc] init];
    self.registerButton.layer.masksToBounds = YES;
    self.loginButton.layer.masksToBounds = YES;
    self.registerButton.layer.cornerRadius = 5;
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.backgroundColor = blueBtn;
    self.registerButton.backgroundColor = beijing;
    //点击屏幕任意位置取消键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed)];
    [self.view addGestureRecognizer:tapGesture];
    tapGesture.cancelsTouchesInView = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    LoginViewController * LVC;
    [super viewWillAppear:animated];
    [LVC viewWillAppear:animated];
    if(g_LoginStatus == 1)
        [self back];
}

-(void)tapPressed
{
    [self.view endEditing:YES];
}

- (void)initlization{
    
    
}

- (void)loadBaseUI {
    
    //导航
    NAV_INIT(self, @"登录", @"common_nav_back_icon", @selector(back), nil, nil);
    
    [_registerButton addTarget:self action:@selector(showRegisterStepOneView) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginButton addTarget:self action:@selector(loginApp) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(g_userInfo.nickname.length != 0)
        _usernameTextField.text = g_userInfo.email;
//    if(g_userInfo.pwd.length != 0)
//        _passwordTextField.text = g_userInfo.pwd;
}

#pragma mark - Detail Actions

- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showRegisterStepOneView {
    
    //跳转到注册页
    [self performSegueWithIdentifier:@"RegisterStepOne" sender:self];
}

-(void)loginApp
{
    if(_usernameTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号/邮箱"];
        return;
    }
    else if (_passwordTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    [[TTIHttpClient shareInstance] userLoginRequestWithusername:_usernameTextField.text  withuserpswd:_passwordTextField.text withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_updateLoginState object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

- (IBAction)forgetPwdBtnClick:(id)sender
{
    ForgetPwdViewController  *forgetVC =[[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgetPwdViewController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
@end
