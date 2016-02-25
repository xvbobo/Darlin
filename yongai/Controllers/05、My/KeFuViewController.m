//
//  KeFuViewController.m
//  com.threeti
//
//  Created by alan on 15/10/8.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "KeFuViewController.h"
#import "ZaiXianKeFuViewController.h"
#import "OpinionViewController.h"
#import "LoginNavViewController.h"
@interface KeFuViewController (){
     UIView *_maskView;
    UIImageView * redPoint;
    NSString * kefuString;
}

@end

@implementation KeFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BJCLOLR;
     NAV_INIT(self,@"Darlin客服", @"common_nav_back_icon", @selector(back), nil, nil);
    [self createRequest];
    [self createInterFace];
    // Do any additional setup after loading the view.
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createInterFace
{
    UIImageView * imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, UIScreenWidth, 50)];
    imageView0.userInteractionEnabled = YES;
    imageView0.backgroundColor =[UIColor whiteColor];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(zaiXianAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, UIScreenWidth, 50);
    [imageView0 addSubview:btn];
    UIImageView * zaixian = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 23, 23)];
    zaixian.image = [UIImage imageNamed:@"在线客服"];
    [imageView0 addSubview:zaixian];
    UILabel * kefuLabel = [[UILabel alloc] initWithFrame:CGRectMake(zaixian.frame.origin.x+zaixian.frame.size.width+10, 13,UIScreenWidth, 25)];
    kefuLabel.text = @"在线客服";
    kefuLabel.tag = 1000;
    kefuLabel.font = [UIFont systemFontOfSize:16];
    kefuLabel.textColor = BLACKTEXT;
    [imageView0 addSubview:kefuLabel];
    redPoint = [[UIImageView alloc] initWithFrame:CGRectMake(kefuLabel.frame.origin.x+kefuLabel.frame.size.width, kefuLabel.frame.origin.y, 10, 10)];
    redPoint.layer.masksToBounds = YES;
    redPoint.backgroundColor = [UIColor redColor];
    redPoint.layer.cornerRadius = 5;
    if (self.if_new_message == YES) {
        [imageView0 addSubview:redPoint];
    }
    UIImageView * sanjiao = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-20, 15, 10, 20)];
    sanjiao.image = [UIImage imageNamed:@"SettingViewCell_right"];
    [imageView0 addSubview:sanjiao];
    [self.view addSubview:imageView0];
    for (int i = 0; i< 2; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (imageView0.frame.origin.y+imageView0.frame.size.height+15)+i*51, UIScreenWidth, 50)];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, UIScreenWidth, 50);
        [imageView addSubview:button];
        UIImageView * image = [[UIImageView alloc] initWithFrame:zaixian.frame];
        [imageView addSubview:image];
        UILabel * label = [[UILabel alloc] initWithFrame:kefuLabel.frame];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = BLACKTEXT;
        [imageView addSubview:label];
        UIImageView * sanjiao1 = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-20, 15, 10, 20)];
        sanjiao1.image = [UIImage imageNamed:@"SettingViewCell_right"];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height, UIScreenWidth, 0.5)];
        [imageView addSubview:sanjiao1];
        if (i==0) {
            
            image.image = [UIImage imageNamed:@"电话客服"];
            label.text = @"电话客服";
            line.backgroundColor= LINE;
            [self.view addSubview:line];
        }else{
            image.image = [UIImage imageNamed:@"意见反馈"];
            label.text = @"意见反馈";
        }
        [self.view addSubview:imageView];
    }
    
}
- (void)createRequest
{
    [[TTIHttpClient shareInstance] kefuisOnlinewithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        kefuString  = response.error_desc;
        UILabel * lable = (UILabel*)[self.view viewWithTag:1000];
        if ([kefuString isEqualToString:@"获取成功"]) {
            lable.text = @"在线客服（在线）";
        }else if ([kefuString isEqualToString:@"客服下线"])
        {
            lable.text = @"在线客服（下线）";
        }else{
            lable.text = @"在线客服（离开）";
        }
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}
#pragma 在线客服
- (void)zaiXianAction
{
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    ZaiXianKeFuViewController  * zaiXian = [[ZaiXianKeFuViewController alloc] init];
    zaiXian.keFuZaiXian = kefuString;
    [self.navigationController pushViewController:zaiXian animated:YES];
    redPoint.hidden = YES;
}
- (void)buttonAction:(UIButton *) btn
{
    NSLog(@"%ld",btn.tag);
    if (btn.tag == 101) {
        if(!g_LoginStatus)
        {
            [self showLoginView];
            return;
        }
        
        OpinionViewController *opinionVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"OpinionViewController"];
        [self.navigationController pushViewController:opinionVC animated:YES];
    }else{
                    if (_maskView == nil) {
        
                        _maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
                        [_maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
                    }
        
                    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
                    [window addSubview:_maskView];
        
                    CGPoint center;
                    center.x = _maskView.center.x;
                    center.y = _maskView.center.y;
                    self.serviceView.center = center;
                    _serviceView.sureButton.backgroundColor = blueBtn;
                    [_serviceView.cancelButton addTarget:self action:@selector(longPressViewBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [_serviceView.sureButton addTarget:self action:@selector(longPressViewBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [_maskView addSubview:self.serviceView];
    }
}
- (void)longPressViewBtn:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {// 取消
        
        
    }
    else if (button.tag == 1)// 确定
    {
        NSString *phone = [NSString stringWithFormat:@"tel://%@", @"4008000021"];
        NSURL *telURL =[NSURL URLWithString:phone];
        
        if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
            
            [[UIApplication sharedApplication] openURL:telURL];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"该设备不支持电话功能！"];
        }
    }
    
    [_maskView removeFromSuperview];
}

#pragma mark - getter

- (ServiceView *)serviceView {
    
    if (_serviceView == nil) {
        
        _serviceView = [[[NSBundle mainBundle] loadNibNamed:@"ServiceView" owner:self options:nil] lastObject];
        _serviceView.frame = CGRectMake(0, 0, 294, 165);
    }
    return _serviceView;
}
#pragma 登陆
-(void)showLoginView
{
    LoginNavViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
    [self presentViewController:loginVC animated:YES completion:nil];
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

@end
