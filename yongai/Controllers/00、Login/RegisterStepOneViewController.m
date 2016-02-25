//
//  RegisterStepOneViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "RegisterStepOneViewController.h"
#import "CommonUtils.h"
#import "RegisterStepThreeViewController.h"
#import "KeychainItemWrapper.h"
@interface RegisterStepOneViewController ()

@end

@implementation RegisterStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BJCLOLR;
    self.oneScroller.backgroundColor = BJCLOLR;
    self.scrollerContentView.backgroundColor = BJCLOLR;
    self.nextStepButton.layer.masksToBounds = YES;
    self.nextStepButton.layer.cornerRadius = 5;
    self.nextStepButton.backgroundColor = beijing;
    [self.yongHuXieYiLable setTitleColor:beijing forState:UIControlStateNormal];
    self.zhangHao.textColor = BLACKTEXT;
    self.miMa.textColor = BLACKTEXT;
    self.yaoQingMa.textColor = BLACKTEXT;
    self.nextLabel.textColor = BLACKTEXT;
    self.oneTop.constant = UIScreenHeight - 400;
    [self initlization];
    [self loadBaseUI];
}

- (void)initlization{
    
    
}

- (void)loadBaseUI{
    
    //初始化导航
    NAV_INIT(self, @"注册（1/2）", @"common_nav_back_icon", @selector(back), nil, nil);
    
    [_nextStepButton addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Detail Actions

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextStepAction{
    
    //下一步
    if(ICIsObjectEmpty(self.accountTextField.text)){
        
        [SVProgressHUD showErrorWithStatus:@"请输入邮箱"];
        return;
    }
    
    if(self.passwordTextField.text.length ==0 ){
        
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if(self.passwordTextField.text.length < 6)
    {
        [SVProgressHUD showErrorWithStatus:@"密码不足6位"];
        return;
    }
    
    if(!VERIFY_EMAIL(self.accountTextField.text)){
        
        [SVProgressHUD showErrorWithStatus:@"邮箱格式不正确"];
        return;
    }
    
    // 验证邮箱是否注册过
    [[TTIHttpClient shareInstance]registerRequestWithemail:_accountTextField.text password:_passwordTextField.text invitecode:_vercodeTextField.text nickname:nil sex:nil equipment:[self uuid] equip:nil page:@"1" withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                          RegisterStepThreeViewController *twoVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterStepThreeViewController"];;
                                                          RegisterModel *model = [[RegisterModel alloc] init];
                                                          [model setAccount:self.accountTextField.text];
                                                          [model setPassword:self.passwordTextField.text];
                                                          [model setVercode:self.vercodeTextField.text];
                                                          twoVC.registerModel = model;
                                                          [self.navigationController pushViewController:twoVC animated:YES];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
//        [SVProgressHUD showErrorWithStatus:@"该邮箱已被注册过！"];
        NSLog(@"%@",response.error_desc);
    }];
}
- (NSString *)uuid {
    
    /** 初始化一个保存用户帐号的KeychainItemWrapper */
    KeychainItemWrapper *wrapper=[[KeychainItemWrapper alloc] initWithIdentifier:@"Yongai" accessGroup:nil];
    
    //从keychain里取出帐号密码
    NSString *uuid = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    
    // 判断本地是否有uuid
    if (ICIsStringEmpty(uuid)) {
        
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        
        // 保存数据
        [wrapper setObject:result forKey:(__bridge id)kSecAttrAccount];
        
        return result;
    }
    else
    {
        return uuid;
    }
}


@end
