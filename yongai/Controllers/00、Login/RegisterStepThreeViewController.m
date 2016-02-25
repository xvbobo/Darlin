//
//  RegisterStepThreeViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-10-31.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "RegisterStepThreeViewController.h"
#import "CommonUtils.h"
#import "KeychainItemWrapper.h"

#define SEXUAL_MALE @"1"// 男
#define SEXUAL_FEMALE @"0"// 女

@interface RegisterStepThreeViewController (){
    
    UIView *maskView;
    ProvinceSelectView *selectView;
    
    RegionModel *provinceModel; //选择的省
    RegionModel *cityModel; //选择的市
}

@end

@implementation RegisterStepThreeViewController{
    
    UIPickerView *cityPickerView;
    NSString *sexual;
    
    //省市县
    NSString *province;
    NSString *city;
    NSString *county;
    
    NSMutableArray *provinceList;
    NSMutableArray *cityList;
    NSMutableArray *countyList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BJCLOLR;
    self.finishButton.layer.masksToBounds = YES;
    self.finishButton.layer.cornerRadius = 5;
    self.finishButton.backgroundColor = beijing;
    [self initlization];
    [self loadBaseUI];
    self.sexLable.textColor = BLACKTEXT;
    self.nanLable.textColor = BLACKTEXT;
    self.nvLable.textColor = BLACKTEXT;
    self.gengGaiLabel.textColor = TEXT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initlization{
    
    //默认男
    sexual = SEXUAL_MALE;
}

- (void)loadBaseUI{
    
    //初始化导航
    NAV_INIT(self, @"注册（2/2）", @"common_nav_back_icon", @selector(back), nil, nil);
    
    [_finishButton addTarget:self action:@selector(finishRegistering) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *maleTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectMaleAction:)];
    self.maleView.userInteractionEnabled = YES;
    [self.maleView addGestureRecognizer:maleTapGest];
    
    UITapGestureRecognizer *femaleTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFemaleAction:)];
    self.femaleView.userInteractionEnabled = YES;
    [self.femaleView addGestureRecognizer:femaleTapGest];
    
}

#pragma mark - Detail Actions
- (void)selectMaleAction:(UITapGestureRecognizer *)gesture{
    
    sexual = SEXUAL_MALE;
    
    self.maleSelectIcon.image = [UIImage imageNamed:@"common_selected_button"];
    self.femaleSelectIcon.image = [UIImage imageNamed:@"common_disselected_button"];
}

- (void)selectFemaleAction:(UITapGestureRecognizer *)gesture{
    
    sexual = SEXUAL_FEMALE;
    
    self.maleSelectIcon.image = [UIImage imageNamed:@"common_disselected_button"];
    self.femaleSelectIcon.image = [UIImage imageNamed:@"common_selected_button"];
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishRegistering{
//    [[TTIHttpClient shareInstance] userNameExistRequestWithUserName:self.nickNameTextField.text withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
//
//    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
//        [SVProgressHUD showErrorWithStatus:@"该昵称已被注册啦~"];
//    }];
//
    NSString * str = [self.nickNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[TTIHttpClient shareInstance] registerRequestWithemail:self.registerModel.account
                                                       password:self.registerModel.password
                                                     invitecode:self.registerModel.vercode
                                                       nickname:str
                                                            sex:sexual
                                                      equipment:[self uuid]
                                                          equip:[self uuid]
                                                           page:@"2"
                                                withSucessBlock:^(TTIRequest *request, TTIResponse *response)
         {
             [self autoLogin];
             [SVProgressHUD showSuccessWithStatus:@"注册成功"];
             
         } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
             
             [SVProgressHUD showErrorWithStatus:response.error_desc];
         }];
 
    }

}


    
-(void)autoLogin
{
    [[TTIHttpClient shareInstance] userLoginRequestWithusername:self.registerModel.account withuserpswd:self.registerModel.password withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

// iOS中获取UUID
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


/**
 *  初始化选择省市的view
 */
-(void)initMaskView
{
    if (maskView == nil) {
        
        maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
        [maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        
        selectView = [[[UINib nibWithNibName:@"ProvinceSelectView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        selectView.frame = CGRectMake((MainView_Width -200)/2,( MainView_Height -300)/2, 200, 300);
        selectView.delegate = self;
        selectView.selectViewType = SelectView_Province;
        
        CGPoint center;
        center.x = maskView.center.x;
        center.y = maskView.center.y - 64;
        selectView.center = center;
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 200, selectView.myFootView.frame.size.height);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hideMaskView) forControlEvents:UIControlEventTouchUpInside];
        
        
        [selectView.myFootView addSubview:btn];
        [maskView addSubview:selectView];
        [self.view addSubview:maskView];
        maskView.hidden = YES;
    }
}

-(void)hideMaskView
{
    maskView.hidden = YES;
}

@end
