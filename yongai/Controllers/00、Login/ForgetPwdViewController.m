//
//  ForgetPwdViewController.m
//  yongai
//
//  Created by myqu on 15/1/12.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "ForgetPwdViewController.h"

@interface ForgetPwdViewController ()
{
    NSTimer  *timer;
    NSInteger  timeSecond;
}
@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航
    self.baocunBtn.backgroundColor = beijing;
    self.baocunBtn.layer.masksToBounds = YES;
    self.baocunBtn.layer.cornerRadius = 5;
    self.sendVcodeBtn.backgroundColor = beijing;
    self.view.backgroundColor = BJCLOLR;
    NAV_INIT(self, @"忘记密码", @"common_nav_back_icon", @selector(back), nil, nil);
    
}

- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendVcodeBtnClick:(id)sender
{
    if(_usernameTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您注册的邮箱"];
        return;
    }
    
    [[TTIHttpClient shareInstance] fpwCodeRequestWithEmail:_usernameTextField.text withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
       
        _sendVcodeBtn.enabled = NO;
        timeSecond = 60;
        timer =[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updatebBtnTitle) userInfo:nil repeats:YES];
        //使用NSRunLoopCommonModes模式，把timer加入到当前Run Loop中。
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
    
}

-(void)updatebBtnTitle
{
    if(timeSecond<0)
    {
        [timer invalidate];
        timer = nil;
        _sendVcodeBtn.enabled = YES;
    }
    [_sendVcodeBtn setTitle:[NSString stringWithFormat:@"剩余%d秒", timeSecond] forState:UIControlStateDisabled];
    timeSecond--;
}

- (IBAction)savePwdBtn:(id)sender
{
    if(_usernameTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您注册的邮箱"];
        return;
    }
    else if(_vcodeTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    else if(_passwordTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }

    

    [[TTIHttpClient shareInstance] fpwResetRequestWithusername:_usernameTextField.text
                                                  withuserpswd:_passwordTextField.text
                                                      withcode:_vcodeTextField.text withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         [SVProgressHUD showSuccessWithStatus:@"修改密码成功！"];
         [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:1.0];
         
                                                      } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
    {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}
@end
