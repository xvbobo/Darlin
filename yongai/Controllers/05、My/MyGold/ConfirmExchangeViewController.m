//
//  ConfirmExchangeViewController.m
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ConfirmExchangeViewController.h"
#import "ConfirmGoodsCell.h"
#import "ConsigneeAddrCell.h"
#import "AddressListController.h"
#import "GoldRuleViewController.h"
#import "AddAddressController.h"
@interface ConfirmExchangeViewController ()
{
    IBOutlet UITableView *myTableView;
    IBOutlet UILabel *goldCountLabel;
    
    __weak IBOutlet UILabel *nowGoldLabel;
    UIView *maskView; // 浮层视图
    ConfirmExchangeViewController * CEVC;
    GoldModel *goldInfo;
    BOOL xianshiJUhua;
}

- (IBAction)confirmExBtnClick:(id)sender;

@end

@implementation ConfirmExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    xianshiJUhua = YES;
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"确认兑换", @"common_nav_back_icon", @selector(backAction), nil, nil);
    myTableView.backgroundColor = BJCLOLR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    nowGoldLabel.textColor = BLACKTEXT;
    //改变地址状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAddress:) name:Notify_updateAddressList object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notify_updateAddressList object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
//    ConfirmExchangeViewController
    [super viewWillAppear:animated];
    [CEVC viewWillAppear:animated];
   
    goldCountLabel.text = g_userInfo.pay_points;
}

#pragma ------------notices

- (void)updateAddress:(NSNotification*)notice
{
    AddressModel *current = notice.object;
    self.address = current;
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        NSString *cellIdentifier = @"ConfirmGoodsCell";
        ConfirmGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.goodsImageView setImageWithURL:[NSURL URLWithString:_goodsInfo.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        [cell.goodsNameLabel setText:_goodsInfo.goods_name];
        [cell.goodsGoldLabel setText:_goodsInfo.exchange_integral];
        
        return cell;
    }
    else
    {
        NSString *cellIdentifier = @"ConsigneeAddrCell";
        ConsigneeAddrCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[[UINib nibWithNibName:@"ConsigneeAddrCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.nameLabel.text = _address.consignee;
        cell.cellPhoneLabel.text = _address.mobile;
        
        if(_address.province_name.length!=0 && _address.city_name.length !=0 && _address.address.length !=0)
        {
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@", _address.province_name, _address.city_name, _address.address];
            xianshiJUhua = YES;
        }else{
            cell.addressLabel.text = @"";
            xianshiJUhua = NO;
        }
        
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        AddressListController *addVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil]  instantiateViewControllerWithIdentifier:@"AddressListController"];
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

// 确认兑换
- (IBAction)confirmExBtnClick:(id)sender
{
    if (xianshiJUhua == NO) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    [[TTIHttpClient shareInstance] submitExchangeRequestWithGoodsId:_goodsInfo.goods_id
                                                      withAddressId:_address.address_id
                                                    withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                        
                                                        g_userInfo.pay_points = [NSString stringWithFormat:@"%d", g_userInfo.pay_points.intValue - _goodsInfo.exchange_integral.intValue];
                                                        [self showResultView];
         
     }
     withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
         
         //[SVProgressHUD showErrorWithStatus:response.error_desc];
         
         [self requestViewDataWithMsg:response.error_desc];
     }];
}

-(void)requestViewDataWithMsg:(NSString *)msg
{
    if ([msg isEqualToString:@"必填参数：address_id 丢失！"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请填写收货地址"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
        alert.tag = 100;
        [alert show];
        return;
    }
    else
    {
        [[TTIHttpClient shareInstance] goldruleRequestWithtype:@"1" withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            
            goldInfo = response.responseModel;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"了解金币规则", nil];
            alert.tag = 200;
            [alert show];
            
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
//            [SVProgressHUD showErrorWithStatus:response.error_desc];
        }];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 200) {
        
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
            {
                GoldRuleViewController *ruleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"GoldRuleViewController"];
                ruleVC.type = ExplainType_GoldRule;
                ruleVC.content = goldInfo.gold_rule;
                [self.navigationController pushViewController:ruleVC animated:YES];
            }
                
                break;
                
            default:
                break;
        }

    }
    else if (alertView.tag == 100)
    {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
            {
                [self showAddressListView];
            }
                break;
                
            default:
                break;
        }

    }
}
#pragma mark--填写收货地址
-(void)showAddressListView
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    AddAddressController *addressVC = [board instantiateViewControllerWithIdentifier:@"AddAddressController"];
    //    addressVC.bEdit = YES;
    [self.navigationController pushViewController:addressVC animated:YES];
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
//    AddressListController *addressVC = [board instantiateViewControllerWithIdentifier:@"AddressListController"];
//    [self.navigationController pushViewController:addressVC animated:YES];
}

// 如何兑换结果页面
-(void)showResultView
{
    maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
    [maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.navigationController.view addSubview:maskView];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((maskView.frame.size.width-300)/2, (maskView.frame.size.height-150)/2, 300, 200)];
    centerView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:centerView];
    
    
    CGSize size = CGSizeMake(51, 51);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((centerView.frame.size.width-size.width)/2, 10, size.width, size.height)];
    [imageView setImage:[UIImage imageNamed:@" OK"]];
    
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 300, 60)];
    lable.numberOfLines = 0 ;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"兑换已成功，请注意查收，谢谢!";
    
//    UIButton *lestBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 150, 135, 40)];
//    [lestBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [lestBtn setBackgroundColor:Color_236];
//    [lestBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [lestBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 150, centerView.frame.size.width-80, 40)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.backgroundColor = beijing;
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"cart_sureBgd"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [centerView addSubview:imageView];
    [centerView addSubview:lable];
//    [centerView addSubview:lestBtn];
    [centerView addSubview:rightBtn];
}

-(void)cancleBtnClick:(id)sender
{
    [maskView removeFromSuperview];
    maskView = nil;
}

-(void)confirmBtnClick:(id)sender
{
    [maskView removeFromSuperview];
    maskView = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
