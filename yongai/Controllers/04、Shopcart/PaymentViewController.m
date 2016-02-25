//
//  PaymentViewController.m
//  Yongai
//
//  Created by myqu on 14/12/2.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentCell.h"
#import "MCProductDetailViewController.h"
#import "InvoiceInfoCell.h"
#import "ShoppingCartController.h"
#import "ConfirmReceptViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "OrderProductCell.h"
#import "ExGoodsInfoViewController.h"
#import "PersonMessageCell.h"
#import "GoodsMessageCell.h"
#import "OrderCommentViewController.h"
#import "YunDanDetailViewController.h"
#import "TTIFont.h"
#import "FaPiaoHeadCell.h"
#define WeChat_AppId   @"wxe5282d6de0837e1d"
@interface PaymentViewController ()<WXApiDelegate>
{
    IBOutlet UITableView *myTableView;
    BOOL isAlipay;//支付宝支付
    NSString * weiStr;
    NSString * dataTime;
    NSString * nonceStr;
    NSString * transaction_id;//微信订单号
    NSString * stringSta;
    NSMutableArray * buttonArray;
    NSString * selfTitle;
    UIImageView * buttonView;
    UIImageView * buttonNewView;
    CGFloat CellHeight;
    BOOL change;
}
@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    buttonArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.weixinStr = @"1";
    // 添加支付宝完成后，客户端页面跳转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alixPayResultWithInfo:) name:AlipayResultURLNotify object:nil];
    isAlipay = [self.orderInfo.pay_code isEqualToString:@"alipay"]?YES:NO;
//    isAlipay = NO;
    change = NO;
//     if(self.dataInfo.order_status.intValue == 1)
//     {
//         stringSta = @"待付款";
//         if ([_orderInfo.pay_code isEqualToString:@"cod"]) {
//             [buttonArray addObject:@"取消订单"];
//         }else{
//            [buttonArray addObjectsFromArray:@[@"取消订单",@"去支付"]];
//         }
//         
//     }else if(self.dataInfo.order_status.intValue == 2){
//         stringSta = @"待发货";
//         [buttonArray addObject:@"取消订单"];
//     }else if (self.dataInfo.order_status.intValue == 3){
//         stringSta = @"待收货";
//         [buttonArray addObject:@"确认收货"];
//     }else if (self.dataInfo.order_status.intValue == 4){
//        
//         if (self.dataInfo.order_comment.intValue == 1) {
//              stringSta  = @"已评价";
//             [buttonArray addObjectsFromArray:@[@"删除",@"再次购买"]];
//         }else if (self.dataInfo.order_comment.intValue == 0){
//              stringSta  = @"待评价";
//             [buttonArray addObjectsFromArray:@[@"删除",@"去评价",@"再次购买"]];
//         }
//         NSLog(@"%@",_dataInfo.order_amount);
//     }else if (self.dataInfo.order_status.intValue == 5){
//         stringSta = @"已取消";
//         [buttonArray addObjectsFromArray:@[@"删除",@"再次购买"]];
//     }
    
    NAV_INIT(self, self.myTitleString, @"common_nav_back_icon", @selector(back), nil, nil);
    myTableView.backgroundColor = BJCLOLR;
    //默认没有取消订单
    UIBarButtonItem *cancelOrderBtn = [[UIBarButtonItem alloc] init];
    self.navigationItem.rightBarButtonItem = cancelOrderBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderStatus:) name:Notify_RefreshOrderStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinAction:) name:Notify_weiXinSuccess object:nil];
//    [self createButtonView];
    [self createRequest];
    
    
}
- (void)createRequest
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] infoOrderRequestWithsid:g_userInfo.sid withorder_id:self.orderID withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD dismiss];
        self.orderInfo = [[OrderDetailModel alloc] initWithDictionary:response.result error:nil];
        if(self.orderInfo.order_status.intValue == 1)
        {
            stringSta = @"待付款";
            if ([_orderInfo.pay_code isEqualToString:@"cod"]) {
                [buttonArray addObject:@"取消订单"];
            }else{
                [buttonArray addObjectsFromArray:@[@"取消订单",@"去支付"]];
            }
            
        }else if(self.orderInfo.order_status.intValue == 2){
            stringSta = @"待发货";
            [buttonArray addObject:@"取消订单"];
        }else if (self.orderInfo.order_status.intValue == 3){
            stringSta = @"待收货";
            [buttonArray addObject:@"确认收货"];
        }else if (self.orderInfo.order_status.intValue == 4){
            
            if (self.dataInfo.order_comment.intValue == 1) {
                stringSta  = @"已评价";
                [buttonArray addObjectsFromArray:@[@"删除",@"再次购买"]];
            }else if (self.dataInfo.order_comment.intValue == 0){
                stringSta  = @"待评价";
                [buttonArray addObjectsFromArray:@[@"删除",@"去评价",@"再次购买"]];
            }
            NSLog(@"%@",_dataInfo.order_amount);
        }else if (self.orderInfo.order_status.intValue == 5){
            stringSta = @"已取消";
            [buttonArray addObjectsFromArray:@[@"删除",@"再次购买"]];
        }
//        NAV_INIT(self, stringSta, @"common_nav_back_icon", @selector(back), nil, nil);
        [self createButtonView];
        [myTableView reloadData];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
        
    }];

}
- (void)createButtonView
{
    buttonView = [[UIImageView alloc] initWithFrame:CGRectMake(0,UIScreenHeight-124, UIScreenWidth, 60)];
    buttonView.layer.borderWidth = 0.5;
    buttonView.layer.borderColor = LINE.CGColor;
    buttonView.backgroundColor = BJCLOLR;
    buttonView.userInteractionEnabled = YES;
    for (int i= 0; i< buttonArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(UIScreenWidth- 100*(i+1) ,15, 90, 30);
        [btn setTitle:[buttonArray objectAtIndex:buttonArray.count-1-i] forState:UIControlStateNormal];
        if (i == buttonArray.count-1) {
            [btn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
        }else{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:beijing];
        }
        
        
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        btn.tag = 200+i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = LINE.CGColor;
        btn.layer.borderWidth = 0.5;
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:btn];
    }
    [self.view insertSubview:buttonView aboveSubview:myTableView];
}
//获取用户手机IP
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
            address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
             }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
- (NSString *)ret32bitString

{
    
    char data[32];
    
    for (int x=0;x < 32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}
- (NSString*)getCurrentTime{
     return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}
- (void)weixinZhifu:(NSString*)productName and:(NSString*)order_sn and:(NSString*)amount
{
    NSString * IPStr = [self getIPAddress];
    nonceStr  = [self ret32bitString];
    dataTime = [self getCurrentTime];
    [[TTIHttpClient shareInstance]wixinZhiFuWith:productName with:order_sn with:amount with:IPStr withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        NSLog(@"%@",response.result);
        weiStr  = [response.result objectForKey:@"prepay_id"];
        NSString * string = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%@",WeChat_AppId,nonceStr,@"Sign=WXPay",@"1236827101",weiStr,dataTime];
        [self againWith:string];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        NSLog(@"失败");
    }];
}
- (void)againWith:(NSString*)str
{
    [[TTIHttpClient shareInstance] wixinZhiFuWith:str withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = WeChat_AppId;
        req.partnerId           = @"1236827101";
        req.prepayId            = weiStr;
        req.nonceStr            = nonceStr;
        req.timeStamp           = dataTime.intValue;
        req.package             = @"Sign=WXPay";
        req.sign                = [response.result objectForKey:@"str"];
        [WXApi safeSendReq:req];

    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
         NSLog(@"失败");
    }];
}


// 更新订单状态
-(void)updateOrderStatus:(NSNotification *)notify
{
    NSString *str = [notify object];
    if(str.length == 1)
    {
        _orderInfo.order_status = str;
    }
    else
    {
        _dataInfo.order_comment = str;
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    //尚未分配运单号
    [myTableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {

        PaymentViewController * pvc;
        [super viewWillAppear:animated];
        [pvc viewWillAppear:animated];
   
        // 在线支付和待发货可以取消订单
        // if(isAlipay || self.orderInfo.order_status.intValue == 2)
//        if(self.orderInfo.order_status.intValue == 1 || self.orderInfo.order_status.intValue == 2) {
//            
//            // 货到付款且 待发货 可以取消订单
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
//            [button setTitle:@"取消订单" forState:UIControlStateNormal];
//            button.titleLabel.textColor = [UIColor whiteColor];
//            button.titleLabel.textAlignment = NSTextAlignmentCenter;
//            button.titleLabel.font = [UIFont systemFontOfSize:17];
//            [button addTarget:self action:@selector(cancelOrderAction) forControlEvents:UIControlEventTouchUpInside];
//        }
    if ([selfTitle isEqualToString:@"评价"]) {
        change = YES;
        [buttonArray removeAllObjects];
        [buttonArray addObjectsFromArray:@[@"删除",@"再次购买"]];
        [self reloadButtonView];
    }else if ([selfTitle isEqualToString:@"确认收货"]){
        [buttonArray removeAllObjects];
        [buttonArray addObjectsFromArray:@[@"删除",@"去评价",@"再次购买"]];
         change = YES;
        [self reloadButtonView];
    }else if (self.dataInfo.order_status.intValue == 2){
         [buttonArray removeAllObjects];
        [buttonArray addObjectsFromArray:@[@"取消订单"]];
        change = YES;
        [self reloadButtonView];
    }
    
    [myTableView reloadData];
}
- (void)reloadButtonView
{
    buttonNewView = [[UIImageView alloc] initWithFrame:CGRectMake(0,UIScreenHeight-124, UIScreenWidth, 60)];
    buttonNewView.layer.borderWidth = 0.5;
    buttonNewView.layer.borderColor = LINE.CGColor;
    buttonNewView.backgroundColor = BJCLOLR;
    buttonNewView.userInteractionEnabled = YES;
    for (int i= 0; i< buttonArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(UIScreenWidth- 100*(i+1) ,15, 90,30);
        [btn setTitle:[buttonArray objectAtIndex:buttonArray.count-1-i] forState:UIControlStateNormal];
        if (i == buttonArray.count-1) {
            [btn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
        }else{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:beijing];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        btn.tag = 200+i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = LINE.CGColor;
        btn.layer.borderWidth = 0.5;
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [buttonNewView addSubview:btn];
    }
    buttonView.hidden = YES;
    [self.view insertSubview:buttonNewView aboveSubview:myTableView];
}
- (void)weixinAction:(NSNotification *)notificationObj
{
    [self huoQuYunDanZhuangTai];

}
- (void)huoQuYunDanZhuangTai
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] infoOrderRequestWithsid:g_userInfo.sid withorder_id:self.orderInfo.order_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
       OrderDetailModel * model = [[OrderDetailModel alloc] initWithDictionary:response.result error:nil];
        _orderInfo.order_status = model.order_status;
        if (self.orderInfo.order_status.intValue == 2){
            [buttonArray removeAllObjects];
            [buttonArray addObjectsFromArray:@[@"取消订单"]];
            change = YES;
            [self reloadButtonView];
        }
        [myTableView reloadData];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
        
    }];

}
-(void)back
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notify_RefreshOrderStatus object:nil];
    if(_bFromOrderList)
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        // 向前返回两层页面
        NSMutableArray *views =[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [views removeLastObject];
        [views removeLastObject];
        self.navigationController.viewControllers = views;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4 || section == 6 || section == 5) {
        return 0;
    }else{
     return 10;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView * image = [[UIImageView alloc ] init];
    image.backgroundColor = BJCLOLR;
    if (section == 3 || section == 2 || section == 1) {
        image.layer.borderColor = LINE.CGColor;
        image.layer.borderWidth = 0.5;
    }
    return image;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 2){
       return _orderInfo.goods_list.count+1;
    }else if (section == 1){
        return 2;
    }
    else
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        if(indexPath.row == _orderInfo.goods_list.count)
            return 44;
        else
            return 120;
    }
    
    if (indexPath.section==0)
    {
            return 40;
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row == 0) {
            AddressModel * model = _orderInfo.consignee;
            CGFloat PersonHeight = [TTIFont calHeightWithText:model.consignee font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth/2];
            NSString * AddString = [NSString stringWithFormat:@"收货地址：%@ %@ %@",model.province_name,model.city_name,model.address];
            CGFloat Height = [TTIFont calHeightWithText:AddString font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth - 70]-40;
            CellHeight = 80+Height+PersonHeight;
            return 80+Height+PersonHeight;
        }else{
            NSString * str = _orderInfo.order_status;
            NSString * string;
            switch (str.intValue) {
                case 1://代付款
                    string = @"物流信息：暂无";
                    break;
                case 2://代发货
                    string = @"您已提交订单，请等待系统确认";
                    break;
                case 3://代收货
                    string = [NSString stringWithFormat:@"您的订单已经拣货完毕，已出库交付%@，运单号为：%@",_orderInfo.shipping_name,_orderInfo.invoice_no];
                    break;
                case 4://已完成
                    string = [NSString stringWithFormat:@"您的订单已经拣货完毕，已出库交付%@，运单号为：%@",_orderInfo.shipping_name,_orderInfo.invoice_no];
                    break;
                case 5://已取消
                   string = @"物流信息：暂无";
                    break;
                default:
                    break;
            }
            CGFloat LabelH = [TTIFont calHeightWithText:string font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth];
            return LabelH+20;
        }
//        return 160;
    }
    else if (indexPath.section==3)
    {
        return 150;
    }
    else if (indexPath.section==4)
    {
        return 50;
    }
    else if (indexPath.section==5)
    {
         if([_orderInfo.invoice.need_inv isEqualToString:@"0"])
         {
           return 50;
         }else{
             CGFloat Height = [TTIFont calHeightWithText:_orderInfo.invoice.inv_payee font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth - 90]-20;
              return 120+Height;
        }
        
    }else{
        return 60;
    }
}

#pragma mark -----------  查看商品详情

- (void)loadProductDetailWithGoodsId:(NSString *)goods_id{
    
    //显示商品详情
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.gid = goods_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 2)
    {
        if(indexPath.row ==0)
        {
            if([_orderInfo.pay_code isEqual:@"cod"] ||  [_orderInfo.pay_code isEqual:@"alipay"]||[_orderInfo.pay_code isEqual:@"weixin"])
            {
                GoodModel *goods = [_orderInfo.goods_list objectAtIndex:indexPath.row];
                //跳转到商品详情
                [self loadProductDetailWithGoodsId:goods.goods_id];
            }
            else // @"金币支付";
            {
                // 兑换商品详情页面
                GoodModel *goods = [_orderInfo.goods_list objectAtIndex:indexPath.row];
                
                ExGoodsInfoViewController *goodsInfoVC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExGoodsInfoViewController"];
                goodsInfoVC.goodsId = goods.goods_id;
                [self.navigationController pushViewController:goodsInfoVC animated:YES];
            }
            
        }
    }
    if (indexPath.section == 1) {
        NSString * str = _orderInfo.invoice_no;
        if (indexPath.row == 1 && ![str isEqualToString:@""]) {
            //查看物流信息
            YunDanDetailViewController * yundan = [[YunDanDetailViewController alloc] init];
            yundan.kuaiDiType = _orderInfo.shipping_name;
            yundan.yundanHao = _orderInfo.invoice_no;
            [self.navigationController pushViewController:yundan animated:YES];
        }
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * StrCell = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StrCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StrCell];
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, UIScreenWidth, 30)];
            imageView.layer.borderColor = LINE.CGColor;
            imageView.layer.borderWidth = 0.5;
            imageView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:imageView];
            cell.backgroundColor = BJCLOLR;
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UIScreenWidth-10, 30)];
            label.font = [UIFont systemFontOfSize:13];
            label.text =[NSString stringWithFormat:@"订单号：%@",self.dataInfo.order_sn];
            label.textColor = BLACKTEXT;
            [imageView addSubview:label];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            static NSString * strCell = @"cell2";
            PersonMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:strCell];
            if (cell  == nil) {
                cell = [[PersonMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
            }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            AddressModel * model = _orderInfo.consignee;
            [cell initWithModel:model withAdressString:self.adString];
            [cell upDateCellWith:CellHeight];;
            return cell;
        }else{
            static NSString * strCell = @"cell2-1";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strCell];
            if (cell == nil) {
                cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
                }
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            cell.textLabel.textColor = BLACKTEXT;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            UILabel * label = (UILabel *)[cell viewWithTag:1000];
            NSString * str = self.orderInfo.order_status;
            NSString * string;
            switch (str.intValue) {
                case 1://代付款
                    string = @"物流信息：暂无";
                    break;
                case 2://代发货
                    string = @"您已提交订单，请等待系统确认";
                    break;
                case 3://代收货
                    string = [NSString stringWithFormat:@"您的订单已经拣货完毕，已出库交付%@，运单号为：%@",_orderInfo.shipping_name,_orderInfo.invoice_no];
                    break;
                case 4://已完成
                    string = [NSString stringWithFormat:@"您的订单已经拣货完毕，已出库交付%@，运单号为：%@",_orderInfo.shipping_name,_orderInfo.invoice_no];
                    break;
                case 5://已取消
                    string = @"物流信息：暂无";
                    break;
                default:
                    break;
            }
            if (_orderInfo.invoice_no == nil) {
                _orderInfo.invoice_no = @"";
            }else{
                NSLog(@"%@",_orderInfo.invoice_no);
            }
            if (self.orderInfo) {
                if ([string rangeOfString:_orderInfo.invoice_no].location != NSNotFound ) {
                    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:string];
                    [attributeString addAttribute:NSForegroundColorAttributeName value:beijing range:NSMakeRange([string rangeOfString:_orderInfo.invoice_no].location ,_orderInfo.invoice_no.length)];
                    [attributeString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([string rangeOfString:_orderInfo.invoice_no].location ,_orderInfo.invoice_no.length)];
                    
                    [cell.textLabel setAttributedText:attributeString];
                }else{
                    cell.textLabel.text = string;
                }
                CGFloat LabelH = [TTIFont calHeightWithText:label.text font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth-20];
                label.frame = CGRectMake(10,10, UIScreenWidth-20, LabelH);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:label];
                
            }

                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row ==  _orderInfo.goods_list.count) {
            static NSString * strCell = @"cell3-1";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strCell];
            if (cell == nil) {
                cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"订单状态：%@",stringSta];
            cell.textLabel.textColor = beijing;
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            PaymentCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell2"];
            CartListGoodsModel *goods = [_orderInfo.goods_list objectAtIndex:indexPath.row];
            [cell setGoodsInfo:goods];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
 
        }
    }else if (indexPath.section == 3){
        PaymentCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell1"];
        cell.orderPriceLabel.text =[NSString stringWithFormat:@"￥%.2f",_orderInfo.order_amount.floatValue];
        cell.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderInfo.goods_amount.floatValue];
        cell.shippingfeeLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderInfo.shipping_fee.floatValue];
        cell.discountGoldLabel.text =[NSString stringWithFormat:@"-￥%.2f", _orderInfo.integral_money.floatValue];
        cell.integralMoneyLabel.text = [NSString stringWithFormat:@"-￥%.2f", _orderInfo.discount.floatValue];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 4){
        PaymentCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell4"];
        NSString * orderSn = _orderInfo.order_sn;
        if ([orderSn rangeOfString:@"-"].location != NSNotFound) {
            cell.payWayLabel.text = @"在线支付";
        }else{
            if([_orderInfo.pay_code isEqual:@"alipay"])
                cell.payWayLabel.text = @"支付宝支付";
            else  if([_orderInfo.pay_code isEqual:@"cod"])
                cell.payWayLabel.text = @"货到付款";
            else  if([_orderInfo.pay_code isEqual:@"weixin"])
            {
                cell.payWayLabel.text = @"微信支付";
            }else{
                cell.payWayLabel.text = @"金币支付";
            }
  
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section == 5){
        if([_orderInfo.invoice.need_inv isEqualToString:@"0"])
        {
            static  NSString * str = @"customCell";
            UITableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:str];
            
            if (cell1 == nil) {
             cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
                UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
                lable1.font = [UIFont systemFontOfSize:15.0];
                lable1.textColor = BLACKTEXT;
                lable1.text = @"发票信息:";
                [cell1.contentView addSubview:lable1];
                UILabel * lable2 = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth - 80, 10, 70, 30)];
                lable2.textColor = TEXT;
                lable2.font = [UIFont systemFontOfSize:15.0];
                lable2.text =@"不开发票";
                [cell1.contentView addSubview:lable2];
            }
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell1;
        }
        else
        {
            //  发票类型 1：个人  2：单位
            //发票内容 1：详情  2：办公用品
            // 发票抬头信息
            static  NSString * str = @"fapiao";
            FaPiaoHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (cell == nil) {
                cell = [[FaPiaoHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            NSString * string;
            NSString * string1;
            if([_orderInfo.invoice.inv_type isEqualToString:@"1"])
            {
                string = @"个人";
            }
            else if([_orderInfo.invoice.inv_type isEqualToString:@"2"])
            {
                string = @"单位";
            }
            if([_orderInfo.invoice.inv_content isEqualToString:@"1"])
            {
                string1 = @"详情";
            }
            else if([_orderInfo.invoice.inv_content isEqualToString:@"2"])
            {
                string1 = @"办公用品";
            }
                

            [cell updataWith:string andString:_orderInfo.invoice.inv_payee andString1:string1];
            return cell;

        }

    }else{
        static NSString * StrCell = @"cell0";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StrCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StrCell];
            UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5)];
            imageview.backgroundColor = LINE;
            [cell addSubview:imageview];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BJCLOLR;
        return cell;
 
    }

}
#pragma mark -- 点击事件
- (void)action:(UIButton *)btn
{
    NSString * str = btn.titleLabel.text;
    if ([str isEqualToString:@"去支付"]) {
        //去支付
        [self paymentAction:btn];
    }else if ([str isEqualToString:@"取消订单"]){
        //取消订单
        [self cancelOrderAction];
    }else if ([str isEqualToString:@"确认收货"]){
        //确认收货
        [self confirmReceiptAction:btn];
    }else if ([str isEqualToString:@"去评价"]){
        //去评价
        [self gotoComment];
    }else if ([str isEqualToString:@"再次购买"]){
        //再次购买
        [self gotoShopingCar];
    }else if ([str isEqualToString:@"删除"]){
        //删除
        [self removeOrder];
    }
   
}
- (void)removeOrder
{
    [[TTIHttpClient shareInstance] cancleOrder:g_userInfo.uid withorder_sn:_orderInfo.order_sn withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}
- (void)gotoShopingCar
{
//   CartListGoodsModel * model = [_orderInfo.goods_list objectAtIndex:0];
    NSString * goods_id = @"";
    NSString * goods_num = @"";
    NSString * product_id = @"";
    for ( CartListGoodsModel * model in _orderInfo.goods_list) {
        if ([model.is_gift isEqualToString:@"0"]) {
            goods_id = [NSString stringWithFormat:@"%@,%@",model.goods_id,goods_id];
            goods_num = [NSString stringWithFormat:@"%@,%@",model.goods_number,goods_num];
            product_id = [NSString stringWithFormat:@"%@,%@",model.product_id,product_id];
        }
        
    }
    [[TTIHttpClient shareInstance]buyAgain:goods_id withgoods_number:goods_num withSid:g_userInfo.sid withproduct_id:product_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
        self.tabBarController.selectedIndex = 3;
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}
#pragma mark----查看运单详情
- (void)checkDetail:(UIButton *) btn
{
    YunDanDetailViewController * yundan = [[YunDanDetailViewController alloc] init];
    yundan.yundanHao = _orderInfo.invoice_no;
    [self.navigationController pushViewController:yundan animated:YES];
}

#pragma mark - 支付宝回调方法

//// 处理支付宝支付后返回客户端的页面跳转的通知
-(void)alixPayResultWithInfo:(NSNotification *)notificationObj
{
    NSDictionary *resultDic = [notificationObj object];
    NSLog(@"reslut = %@",resultDic);
    NSString  *str = [resultDic objectForKey:@"resultStatus"];
    if (str.intValue == 9000)
    {
        _orderInfo.order_status = @"2";
        [myTableView reloadData];
        
    }
    else
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
}



#pragma mark -- paymentAction 立即支付

/**
 *  立即支付
 *
 *  @param sender 
 */
-(void)paymentAction:(id)sender
{
    
    CartListGoodsModel *goods = [_orderInfo.goods_list objectAtIndex:0];
    
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = _orderInfo.order_sn; //订单ID(由商家□自□行制定)
    order.productName = goods.goods_name; //商品标题
    order.productDescription = goods.goods_name; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",_orderInfo.order_amount.floatValue]; //商 品价格
    order.notifyURL = NOTIFYURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    if ([_orderInfo.pay_code isEqualToString:@"weixin"]) {
        
        if ([WXApi isWXAppInstalled]) {
            [self weixinZhifu:order.productName and:_orderInfo.order_sn and:order.amount];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您尚未安装微信"];
        }
        
    }else{
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = myAppScheme;
    
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
        //partner="2088701805117259"&seller_id="terry@ultraprinting.cn"&out_trade_no="2015102163568"&subject="冈奈 和风奢日式避孕套安全套 超薄体贴舒适"&body="冈奈 和风奢日式避孕套安全套 超薄体贴舒适"&total_fee="8.37"&notify_url="http://103.20.249.101/paopaotang/app/alipay/respond.php"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&sign="oaQA69W41w9iO0Zq9y7fh3PVu1lFDqYI3Fl81%2Btd43lxtn59QQmVme4DHzKSYX%2FUV99YX4XBU2bGGUNeToRZtdJZx3Ucmuovy2kfTT9Y76lUg0G2Z6ExwkwgLVug5DIWYFJwBbgq%2Fw84If%2BMz4Z3BHdkAWUB1urJ5tr6BpXztBk%3D"&sign_type="RSA"

    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
            NSLog(@"reslut = %@",resultDic);
             NSString  *str = [resultDic objectForKey:@"resultStatus"];
             if (str.intValue == 9000)
             {
                 _orderInfo.order_status = @"2";
                 if (self.orderInfo.order_status.intValue == 2){
                     [buttonArray removeAllObjects];
                     [buttonArray addObjectsFromArray:@[@"取消订单"]];
                     change = YES;
                     [self reloadButtonView];
                 }
                 [myTableView reloadData];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"支付失败"];
             }
        }];
//        [AlipaySDK defaultService]processOrderWithPaymentResult:<#(NSURL *)#> standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//            NSString  *str = [resultDic objectForKey:@"resultStatus"];
//            if (str.intValue == 9000)
//            {
//                _orderInfo.order_status = @"2";
//                [myTableView reloadData];
//            }
//            else
//            {
//                [SVProgressHUD showErrorWithStatus:@"支付失败"];
//            }
//
//        }
    }
    }
}

/**
 *  确认收货按钮
 */
-(void)confirmReceiptAction:(id)sender {
    
    //待收货 确认收货
    ConfirmReceptViewController *confirmReceptVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmReceptViewController"];
    [confirmReceptVC returnText:^(NSString *myTitle) {
        selfTitle = myTitle ;
    }];
    confirmReceptVC.order_id = self.orderInfo.order_id;
    confirmReceptVC.contentStr = self.orderInfo.app_receipt_confirm;
    [self.navigationController pushViewController:confirmReceptVC animated:YES];
    
}

//已完成 去评价
-(void)gotoComment
{
     OrderCommentViewController *orderCommentVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderCommentViewController"];
    [orderCommentVC returnText:^(NSString *myTitle) {
        selfTitle = myTitle;
      
    }];
    NSMutableArray *gooldList = [NSMutableArray array];
    
    for(CartListGoodsModel *model  in _orderInfo.goods_list)
    {
        if([model isKindOfClass:[CartListGoodsModel class]] && model)
            [gooldList addObject:model];
        else if(model)
        {
            CartListGoodsModel *modelTemp = [[CartListGoodsModel alloc] initWithDictionary:model error:nil];
            [gooldList addObject:modelTemp];
        }
    }
  
    orderCommentVC.productsArray = gooldList;
    orderCommentVC.order_id =_orderInfo.order_id ;
    [self.navigationController pushViewController:orderCommentVC animated:YES];
}

- (void)cancelOrderAction{
    
    [self cancelOrderWithOrderid:self.orderInfo.order_id];
}

#pragma mark ------------------------- 取消订单
- (void)cancelOrderWithOrderid:(NSString *)order_id{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认取消该订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = order_id.intValue;
    [alertView show];
    
}


#pragma mark -----UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString *order_id = [NSString stringWithFormat:@"%ld", (long)alertView.tag];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[TTIHttpClient shareInstance] cancelOrderRequestWithsid:g_userInfo.sid withorder_id:order_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
            
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            [SVProgressHUD showErrorWithStatus:response.error_desc];
        }];
    }
}


@end
