//
//  GoldCustomViewController.m
//  Yongai
//
//  Created by myqu on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "GoldCustomViewController.h"
#import "MyInfoViewController.h"
#import  "CommonHelper.h"
#import "BubbleFriendsController.h"
#import "YongaiYabbarController.h"
#import "QFControl.h"
#define QDBJ RGBACOLOR(23, 17, 26,0.7)
@interface GoldCustomViewController ()<UIWebViewDelegate>
{
    NSArray *titleArr;
    NSArray *actionBtnArr;
    
    UIImageView *maskView; // 浮层视图
    
    IBOutlet NSLayoutConstraint *webHeightConstraint;
    NSInteger customType; // 根据索引决定时间的跳转
    YongaiYabbarController * yongai;
    
    
}

@end

@implementation GoldCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    yongai = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil]instantiateViewControllerWithIdentifier:@"YongaiYabbarController"];
    // Do any additional setup after loading the view.
    maskView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = QDBJ;
    maskView.alpha = 0;
    self.jinBiLable.textColor = beijing;
    self.myScrollView.backgroundColor = BJCLOLR;
    self.myWebView.backgroundColor = BJCLOLR;
    self.myWebView.delegate = self;
    self.viewContent.backgroundColor = BJCLOLR;
    self.doneLable.textColor = beijing;
    self.goldDescpLabel.textColor = TEXT;
    self.titleLabel.textColor = RGBACOLOR(108, 97, 85, 1);
    self.gotoBtn.backgroundColor = beijing;
    self.gotoBtn.layer.masksToBounds = YES;
    self.gotoBtn.layer.cornerRadius = 5;
    titleArr = [[NSArray alloc] initWithObjects:@"完善个人资料", @"每日签到", @"邀请好友", @"泡友榜排行前50", @"话题加精华", @"商城购物", @"商品评价", nil];
    actionBtnArr = [[NSArray alloc] initWithObjects:@"去完善个人资料", @"去签到", @"去邀请好友", @"进入我的圈子", @"去发帖", @"去逛逛", @"商品评价", nil];
    
    [self initViewData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationHobby:)
                                                 name:@"NOTIFI_MyInfoViewControllerHobby"
                                               object:nil];
   
    
}
-(void)notificationHobby:(NSNotification *)notification {
    
    int num = [_ruleInfo.completed intValue] + 1;
    self.goldRatioLabel.text = [NSString stringWithFormat:@"%d/%@", num, _ruleInfo.total];
}

-(void)initViewData
{
    NAV_INIT(self, _ruleInfo.name, @"common_nav_back_icon", @selector(backAction), nil, nil);
    
    self.viewImgView.image = [UIImage imageNamed:self.imgTagName];
    
    customType = [titleArr indexOfObject:_ruleInfo.name];
    if([actionBtnArr count] > customType)
        [self.gotoBtn setTitle:[actionBtnArr objectAtIndex:customType] forState:UIControlStateNormal];
    else
        customType = GoldViewType_Ranking;
    
    self.titleLabel.text = _ruleInfo.name;
    
    [self updateViewData];
}

-(void)updateViewData
{
    NSString *total;
    NSString *complete;
    
    if([_ruleInfo.name hasPrefix:@"泡友榜排行"] || [_ruleInfo.name hasPrefix:@"话题加精华"]|| [_ruleInfo.name hasPrefix:@"商城购物"])
    {
        self.goldRatioLabel.text = @"";
        self.goldDescpLabel.text = @"无次数限制";
    }
    else
    {
        total = _ruleInfo.total;
        complete =_ruleInfo.completed;
        self.goldRatioLabel.text = [NSString stringWithFormat:@"%@/%@", _ruleInfo.completed, _ruleInfo.total];
        self.goldDescpLabel.text = [NSString stringWithFormat:@"(还有%d次待完成)", (total.intValue - complete.intValue)];

    }
    
    self.goldNumLabel.text = _ruleInfo.num;
    [self.myWebView loadHTMLString:self.ruleInfo.desc baseURL:nil];
    self.myWebView.tintColor = beijing;
    // 每日签到
    if(customType == GoldViewType_Attendance)
    {
        [self.gotoBtn setTitle:@"已签到" forState:UIControlStateDisabled];
        if([total isEqualToString:complete])
            self.gotoBtn.enabled = NO;
        else
            self.gotoBtn.enabled = YES;
    }
    else if (customType == GoldViewType_Ranking)
    {
        [self.gotoBtn setTitle:[actionBtnArr objectAtIndex:3] forState:UIControlStateNormal];
    }
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

//GoldViewType_Personal = 0,  // 完善个人资料
//GoldViewType_Attendance,
//GoldViewType_Invite,
//GoldViewType_Ranking,      //泡友排行榜
//GoldViewType_Topic,        //话题加精华
//GoldViewType_Mall,         //商城购物
//GoldViewType_Evaluation,   //商品评价
- (IBAction)gotoBtnClick:(id)sender {
    
    switch (customType) {
        case GoldViewType_Personal: // 完善个人资料
        {
            [self showPersonalInfoView];
        }
            break;
        case GoldViewType_Attendance:  //每日签到
        {
            [self showAttendanceModelView];
        }
            break;
        case GoldViewType_Invite://邀请好友
        {
            [self inviteFriendsView];
        }
            break;
        case GoldViewType_Ranking://泡友排行榜
        {
            self.titleString = @"泡友排行榜";
            [self showReceiveRewardView];
        }
            break;
        case GoldViewType_Topic: // 话题加精华  发帖----》 泡友圈
        {
            [self showReceiveRewardView];
        }
            break;
            case GoldViewType_Mall:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_ShowBottom object:nil];
                yongaiVC.selectedIndex = 0;
                [self.navigationController popViewControllerAnimated:YES];
                    
                    return;
        }
        default:
            break;
    }
}
-(void)showPersonalInfoView
{
    MyInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
    [self.navigationController pushViewController:infoVC animated:YES];
}

//每日签到
-(void)showAttendanceModelView
{
    NSString *str = @"daily_signin";
    [[TTIHttpClient shareInstance] get_integralRequestWithsid:nil withtask_type:str fid:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
         g_userInfo.pay_points = [response.result objectForKey:@"pay_points"];
         
         NSString  *goldNum = [response.result objectForKey:@"daily_signin"];
//         maskView = nil;
        
        NSString * str = [response.result objectForKey:@"rank_up"];
        if ([str isEqualToString:@"皇冠会员"]) {
            NSString * string = @"恭喜您，升级为皇冠会员 !";
            NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:string];
            NSRange range1 = [string rangeOfString:str];
            NSRange redRange = NSMakeRange(range1.location, range1.length);
            [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
            UILabel * lable = [[UILabel alloc] init];
            [lable setAttributedText:string1];
            UIImageView * shengjiView = [QFControl createUIImageFrame:CGRectMake(30, (UIScreenHeight-UIScreenWidth+100)/2, UIScreenWidth-60, UIScreenHeight/3) imageName:@"升级" withStr1:string1 withStr: @"您可到个人中心“我的等级”页面查看详情" withStr3:@"么么哒~"];
            [UIView animateWithDuration:1.5 animations:^{
                maskView.alpha = 1;
            }];
            [maskView addSubview:shengjiView];
        }else{
//            maskView.backgroundColor = QDBJ;
            UIImageView *qiandaoBj = [[UIImageView alloc] initWithFrame:CGRectMake(20, (UIScreenHeight-UIScreenWidth-40)/2, UIScreenWidth-40, UIScreenWidth-40)];
            qiandaoBj.image = [UIImage imageNamed:@"领取金币"];
            UILabel *qiandaoLB = [[UILabel alloc] initWithFrame:CGRectMake(50, qiandaoBj.frame.size.height/4*3-40, qiandaoBj.frame.size.width-100, 30)];
            qiandaoLB.textColor = [UIColor whiteColor];
            qiandaoLB.font = [UIFont systemFontOfSize:17];
            qiandaoLB.textAlignment = NSTextAlignmentCenter;
            qiandaoLB.text = [NSString stringWithFormat:@"恭喜~获得%@个金币",goldNum];
            [qiandaoBj addSubview:qiandaoLB];
            [UIView animateWithDuration:1.5 animations:^{
                maskView.alpha = 1;
            }];

            [maskView addSubview:qiandaoBj];
            
        }
        
         [self.navigationController.view addSubview:maskView];
         
         [self performSelector:@selector(hideView) withObject:nil afterDelay:1.5];
         
         _ruleInfo.completed = [NSString stringWithFormat:@"%d", _ruleInfo.completed.intValue +1];
         [self updateViewData];
         
     } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
         
     }];
}
- (void)hideView
{
    [UIView animateWithDuration:1.5 animations:^{
        maskView.alpha = 0;
    }];
}
// 邀请好友
-(void)inviteFriendsView
{
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
                                                                                       withTitle:[NSString stringWithFormat:@"泡泡堂 %@", code]
                                                                                       withImage:[UIImage imageNamed:@"share_Default"]
                                                                                         withUrl:url];
                                                               
                                       }
                                                           
       } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
           
       }];
}

// 领取金币奖励 ==> 进入我的圈子
-(void)showReceiveRewardView
{
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//-(void)showMaskView:(NSString *)dailySignin
//{
//    maskView = nil;
//    maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
//    [maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
//    [self.navigationController.view addSubview:maskView];
//    
//    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((maskView.frame.size.width-300)/2, (maskView.frame.size.height-150)/2, 300, 150)];
//    centerView.backgroundColor = [UIColor whiteColor];
//    [maskView addSubview:centerView];
//    
//    
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 60)];
//    lable.numberOfLines = 0 ;
//    lable.textAlignment = NSTextAlignmentCenter;
//    
//    lable.text =[NSString stringWithFormat:@"恭喜你，成功获得%@枚金币，赞一个！", dailySignin];
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 90, 280, 40)];
//    [btn setTitle:@"取消" forState:UIControlStateNormal];
//    [btn setBackgroundColor:Color_236];
//    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(maskViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [centerView addSubview:lable];
//    [centerView addSubview:btn];
//}

#pragma mark --- maskView Action
//-(void)maskViewBtnAction:(id)sender
//{
//    [maskView removeFromSuperview];
//}


#pragma mark --- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{ //webview 自适应高度
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    
    webHeightConstraint.constant = fittingSize.height;
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
}
@end
