//
//  ConfirmReceptViewController.m
//  Yongai
//
//  Created by Kevin Su on 14/12/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ConfirmReceptViewController.h"
#import "QFControl.h"
#import "SHServeController.h"
#define QDBJ RGBACOLOR(23, 17, 26,0.7)

@interface ConfirmReceptViewController ()
{
    UIView *maskView; // 浮层视图
    UIImageView * qiandaoBj;//签到背景
    UILabel * qiandaoLB;

}

@end

@implementation ConfirmReceptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NAV_INIT(self, @"确认收货", @"common_nav_back_icon", @selector(back), nil, nil);
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    maskView.alpha = 0;
    maskView.backgroundColor = QDBJ;
    qiandaoBj = [[UIImageView alloc] initWithFrame:CGRectMake(20, (UIScreenHeight-UIScreenWidth-40)/2, UIScreenWidth-40, UIScreenWidth-40)];
    qiandaoBj.image = [UIImage imageNamed:@"领取金币"];
    qiandaoLB = [[UILabel alloc] initWithFrame:CGRectMake(50, qiandaoBj.frame.size.height/4*3-40, qiandaoBj.frame.size.width-100, 30)];
    qiandaoLB.textColor = [UIColor whiteColor];
    qiandaoLB.font = [UIFont systemFontOfSize:17];
    qiandaoLB.textAlignment = NSTextAlignmentCenter;
    [qiandaoBj addSubview:qiandaoLB];
//    [maskView addSubview:qiandaoBj];
    
    self.confirmTextView.text = self.contentStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)returnText:(myBlock)block
{
    self.Myblock = block;
}
- (IBAction)confirmAction:(id)sender {
    
    //确认收货
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] affirmReceivedOrderRequestWithsid:g_userInfo.sid withorder_id:self.order_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD dismiss];
        self.Myblock(@"确认收货");
        NSString * str = response.error_desc;
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
//            NSRange range = [response.error_desc rangeOfString:@"个"];
            if ([response.error_desc rangeOfString:@"个"].location != NSNotFound) {
                qiandaoLB.text = [NSString stringWithFormat:@"恭喜~获得%@金币",response.error_desc];
                [UIView animateWithDuration:1.5 animations:^{
                    maskView.alpha = 1;
                }];
                [maskView addSubview:qiandaoBj];
            }
            
        }
        [self.navigationController.view addSubview:maskView];
        if ([str isEqualToString:@"皇冠会员"]) {
            [self performSelector:@selector(hideView) withObject:nil afterDelay:2.5];
        }else{
            [self performSelector:@selector(hideView) withObject:nil afterDelay:1.5];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_RefreshOrderStatus object:@"4"];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}
- (void)hideView
{
    [UIView animateWithDuration:1.5 animations:^{
        maskView.alpha = 0;
    }];
    
    if ([self.formStr isEqualToString:@"returnBack"]) {
        SHServeController  * sv = [[SHServeController alloc] init];
        sv.formTitle = @"确认收货";
        sv.model = [self.orderArray objectAtIndex:0];
        sv.order_sn = [self.orderArray objectAtIndex:1];
        sv.order_id = [self.orderArray objectAtIndex:2];
        sv.order_Status = @"4";
        [self.navigationController pushViewController:sv animated:YES];
    }else{
      [self.navigationController popViewControllerAnimated:YES];  
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
            }
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
