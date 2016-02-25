//
//  ReturnBackViewController.m
//  com.threeti
//
//  Created by alan on 15/11/9.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "ReturnBackViewController.h"
#import "ConfirmReceptViewController.h"
#import "SHServeController.h"
@interface ReturnBackViewController ()<UIAlertViewDelegate>

@end

@implementation ReturnBackViewController
{
    UIButton * go_onBtn;
    NSString * selfTitle;
    BOOL _isFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NAV_INIT(self,@"返修退换货", @"common_nav_back_icon", @selector(back), nil, nil);
    _isFirst = YES;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 130)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.borderColor = LINE.CGColor;
    imageView.layer.borderWidth = 0.5;
    [self.view addSubview:imageView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    label.text = @"温馨提示";
    label.textColor = BLACKTEXT;
    label.font = [UIFont systemFontOfSize:15.0];
    [imageView addSubview:label];
    UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, label.frame.origin.y+label.frame.size.height+5, UIScreenWidth-20, 40)];
    lable1.textColor = TEXT;
    lable1.text = @"点击“继续申请”系统将自动为您的整张订单确认收货，否则请取消申请";
    lable1.numberOfLines = 0;
    lable1.font = [UIFont systemFontOfSize:13.0];
    [imageView addSubview:lable1];
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(UIScreenWidth - 90, lable1.frame.origin.y+lable1.frame.size.height+5, 80, 30);
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    cancelBtn.layer.borderColor = LINE.CGColor;
    [cancelBtn setTitle:@"取消申请" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:cancelBtn];
    go_onBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    go_onBtn.frame = CGRectMake(cancelBtn.frame.origin.x-90, cancelBtn.frame.origin.y, 80, 30);
    go_onBtn.layer.masksToBounds = YES;
    go_onBtn.layer.cornerRadius = 5;
    go_onBtn.layer.borderWidth = 0.5;
    [go_onBtn setTitle:@"继续申请" forState:UIControlStateNormal];
    [go_onBtn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
    go_onBtn.layer.borderColor = LINE.CGColor;
    go_onBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [go_onBtn addTarget:self action:@selector(go_onBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:go_onBtn];

    self.view.backgroundColor = BJCLOLR;
    // Do any additional setup after loading the view.
}
- (void)go_onBtn:(UIButton *)button
{
//    if ([button.titleLabel.text isEqualToString:@"继续申请"]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[TTIHttpClient shareInstance] infoOrderRequestWithsid:g_userInfo.sid withorder_id:self.order_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            
            [SVProgressHUD dismiss];
            
            
            ConfirmReceptViewController *confirmReceptVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmReceptViewController"];
            [confirmReceptVC returnText:^(NSString *myTitle) {
                selfTitle = myTitle ;
            }];
            OrderDetailModel * orderInfo = [[OrderDetailModel alloc] initWithDictionary:response.result error:nil];
            confirmReceptVC.orderArray  = [NSArray arrayWithObjects:self.model,self.order_sn,self.order_id,self.order_Status, nil];
            confirmReceptVC.order_id = self.order_id;
            confirmReceptVC.contentStr = orderInfo.app_receipt_confirm;
            confirmReceptVC.formStr = @"returnBack";
            [self.navigationController pushViewController:confirmReceptVC animated:YES];
            
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            return;
            
        }];

//    }else if ([button.titleLabel.text isEqualToString:@"提交申请"]){
//        SHServeController * SHServe = [[SHServeController alloc] init];
//        SHServe.model = self.model;
//        SHServe.order_sn = self.order_sn;
//        SHServe.order_id = self.order_id;
//        SHServe.order_Status = self.order_Status;
//        [self.navigationController pushViewController:SHServe animated:YES];
//    }
}
- (void)cancleBtn
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您确定要取消申请"
                                                       delegate:self
                                              cancelButtonTitle:@"是"
                                              otherButtonTitles:@"否", nil];
//    Al = YES;
    [alertView show];
    
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
        break;
            
        default:
            break;
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
