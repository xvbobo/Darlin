//
//  SettingViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "CommonHelper.h"
#import "PeepPasswordViewController.h"
#import "CommonHelper.h"
#import "OpinionViewController.h"
#import "AboutViewController.h"
#import "LoginNavViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SettingViewController ()<UIActionSheetDelegate, CacheViewDelegate, UIAlertViewDelegate>
{
    UIView *_maskView;
    NSString *_versionUrl;
}

@property (strong, nonatomic) NSArray *setArray;
@property (strong, nonatomic) UserInfo *userInfo;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"设置", @"common_nav_back_icon", @selector(backAction), nil, nil);
    
    self.view.backgroundColor = BJCLOLR;
    
//    _setArray = @[@"防偷窥密码",@"清除缓存", @"图片设置", @"应用分享", @"意见反馈", @"关于我们"];
    _setArray = @[@"清除缓存", @"图片设置", @"应用分享", @"意见反馈", @"关于我们"];
    self.myTableView.dataSource  = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor clearColor];
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 判断是否登录
    if(!g_LoginStatus)
    {
        return 1;
    }
    else
        return 2;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)
        return 5;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section == 0)
    {
        cell.titleLable.text = self.setArray[indexPath.row];
        cell.titleLable.textColor = BLACKTEXT;
        if (indexPath.row == 1)
        {// 图片设置
            
            _userInfo = [[UserInfo alloc] init];
            if (!ICIsObjectEmpty([[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword])) {
                
                _userInfo = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword];
            }

            if (_userInfo.bRememberPwd == NO) {
                
                cell.pointLable.text = @"默认";
            }
            else
            {
                cell.pointLable.text = @"关闭";
            }
            
            cell.pointLable.textColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:236/255.0 alpha:1.0];
        }

    }
    else
    {
        cell.titleLable.text = [NSString stringWithFormat:@"退出当前账号"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
//        if (indexPath.row == 0) {// 防偷窥密码
//        
//            PeepPasswordViewController *peepVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"PeepPasswordViewController"];
//            peepVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:peepVC animated:YES];
//        }else
        if (indexPath.row == 0)// 清除缓存
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定清空" otherButtonTitles: nil];
            actionSheet.actionSheetStyle  = UIActionSheetStyleBlackOpaque;
            
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
        else if (indexPath.row == 1)// 图片设置
        {
            if (_maskView == nil) {
                
                _maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
                [_maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
            }
            
            [self.view addSubview:_maskView];
            
            CGPoint center;
            center.x = _maskView.center.x;
            center.y = _maskView.center.y - 64;
            self.cacheView.center = center;
            [_cacheView.cancelButton addTarget:self action:@selector(cacheViewBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_cacheView.sureButton addTarget:self action:@selector(cacheViewBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_maskView addSubview:self.cacheView];
        }
        else if (indexPath.row == 2)// 应用分享
        {
            // 判断是否登录
            if(!g_LoginStatus)
            {
                [self showLoginView];
                return;
            }
            
            [self invitationCode];
        }
        else if (indexPath.row == 3)// 意见反馈
        {
            // 判断是否登录
            if(!g_LoginStatus)
            {
                [self showLoginView];
                return;
            }
            
            OpinionViewController *opinionVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"OpinionViewController"];
            opinionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:opinionVC animated:YES];
            
        }
        else if (indexPath.row == 4)// 关于我们
        {
            AboutViewController *aboutVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutViewController"];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出当前账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 52;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag == 100) {// 版本更新
        return;
    }
    else// 用户注销
    {
        if(buttonIndex == 0)
        {
        }
        else
        {
            [[TTIHttpClient shareInstance] userLogoutRequestWithsid:g_userInfo.sid
                                                    withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                
                                                        [self backAction];
                                                        
            } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
                
                [SVProgressHUD showErrorWithStatus:response.error_desc];
            }];
        }
    }
}

- (void)cacheViewBtn:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {// 取消
        
        
    }
    else if (button.tag == 1)// 确定
    {
        if (!ICIsObjectEmpty([[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword])) {
            
            _userInfo = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword];
        }
        
        if (_cacheView.button1.selected == YES) {
            
            // 默认
            _userInfo.bRememberPwd = NO;
        }
        else
        {
            // 关闭
            _userInfo.bRememberPwd = YES;
        }
        
        [[LocalStoreManager shareInstance] setValueInDefault:_userInfo withKey:DefaultKey_PeepPassword];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [_maskView removeFromSuperview];
}

- (void)updateVersion {

    [[TTIHttpClient shareInstance] updateVersionRequestWithnow_version:[CommonHelper version]
                                                       withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
         
         if ([response.result isKindOfClass:[NSDictionary class]])
         {
             
             NSString *newVersion = [response.result objectForKey:@"new_version"];
             
             // 判断是否有新版本
             if ( ![newVersion isEqualToString:[CommonHelper version] ]) {
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新版本" message:@"发现新的版本，是否更新?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
                 alert.tag = 100;
                 [alert show];
                 
                 _versionUrl = [response.result objectForKey:@"url"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"亲，你已经是最新版本了"];
             }
         }
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
       
    }];
}

// 生成邀请码
- (void)invitationCode {
    
    [[TTIHttpClient shareInstance] invitationCodeRequestWithsid:g_userInfo.sid
                                                withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                    
                                                    [self shareUrlWithCode:[NSString stringWithFormat:@"邀请码：%@", [response.result objectForKey:@"code"]]];
                                                    
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}

// 生成分享连接
- (void)shareUrlWithCode:(NSString *)code {
    
    [[TTIHttpClient shareInstance] updateVersionRequestWithnow_version:[CommonHelper version]
                                                       withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                           
           if ([response.result isKindOfClass:[NSDictionary class]]) {
               
               NSString * url = [response.result objectForKey:@"url"];
               
               [CommonHelper shareSdkWithContent:@"使用邀请码注册可获金币，情趣交友、女神自拍，请点击下载APP"
                                       withTitle:[NSString stringWithFormat:@"Darlin %@", code]
                                       withImage:[UIImage imageNamed:@"share_Default"]
                                         withUrl:url];
           }
                                                           
   } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
       
   }];
}

// 登录
-(void)showLoginView {
    
    LoginNavViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - CacheViewDelegate

- (void)changeCacheViewBtn:(id)sender {

    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        
        self.cacheView.button1.selected = YES;
        self.cacheView.button2.selected = NO;
    }
    else
    {
        self.cacheView.button1.selected = NO;
        self.cacheView.button2.selected = YES;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        
        // 清除缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictionary = [ud dictionaryRepresentation];
        for(NSString* key in [dictionary allKeys]){
            [ud removeObjectForKey:key];
            [ud synchronize];
        }
        [SVProgressHUD showSuccessWithStatus:@"缓存清空成功"];
    }
    else if (buttonIndex == 1)
    {
        // 取消
    }
}

#pragma mark - getter

- (CacheView *)cacheView {

    if (_cacheView == nil) {
        
        _cacheView = [[[NSBundle mainBundle] loadNibNamed:@"CacheView" owner:self options:nil] lastObject];
        _cacheView.frame = CGRectMake(0, 0, 294, 165);
        _cacheView.delegate = self;
    }
    return _cacheView;
}

@end
