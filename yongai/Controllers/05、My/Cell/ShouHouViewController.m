//
//  ShouHouViewController.m
//  com.threeti
//
//  Created by alan on 15/10/29.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "ShouHouViewController.h"
#import "DingDanHaoViewCell.h"
#import "SHGoodsCell.h"
#import "SHServeController.h"
#import "MCProductDetailViewController.h"
#import "CheckJinDuController.h"
#import "ReturnBackViewController.h"
#import "SHHelpViewController.h"
#import "GTMBase64.h"
#import "TTIFont.h"
@interface ShouHouViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SHGoodsCellDelegate>

@end

@implementation ShouHouViewController
{
    UISearchBar * searchBar;
    UIImageView * grayView;
    UITableView * myTabelView;
    NSMutableArray * orderArr;
    NSInteger g_page;
    FCXRefreshHeaderView * header;
    FCXRefreshFooterView * footerView;
    NSString * helpStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     NAV_INIT(self,@"售后服务-订单列表", @"common_nav_back_icon", @selector(back), nil, nil);
    [self createBottomView];
    [self createUpView];
    [self createMyTableView];
    self.view.backgroundColor = BJCLOLR;
    g_page = 1;
    [self createDataSourceWithPage:g_page];
    [self addRefreshView];
}
- (void)viewWillAppear:(BOOL)animated
{
    ShouHouViewController * shouHou;
    [super viewWillAppear:animated];
    [shouHou viewWillAppear:animated];
    [self refreshOrderList];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    header = [myTabelView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshOrderList];
    }];
    
//    上拉加载更多
    footerView = [myTabelView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        //        [weakSelf loadMoreComments];
    }];
    footerView.hidden = YES;
    
//        自动刷新
    footerView.autoLoadMore = YES;
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (UIScreenHeight > scrollView.contentSize.height-scrollView.contentOffset.y)
    {
        [self loadMoreComments];
        
    }
    NSLog(@"%f",scrollView.contentSize.height - scrollView.contentOffset.y);
    NSLog(@"%f",UIScreenHeight);
    
}

- (void)refreshOrderList
{
    [self createDataSourceWithPage:g_page];
}
- (void)loadMoreComments
{
    footerView.hidden = NO;
    g_page++;
    [self createDataSourceWithPage:g_page];
}
- (void)createDataSourceWithPage:(NSInteger )page;
{
    NSString * strP = [NSString stringWithFormat:@"%ld",page];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] listOrderRequestWithsid:g_userInfo.sid
                                                  withtype:@"all"
                                                  withpage:strP withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         NSData * data = [GTMBase64 decodeString:response.error_desc];
         helpStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         if(page == 1){
             
             [orderArr removeAllObjects];
         }
         
         NSArray *resultArray = [response.result  objectForKey:@"result"];
         if (resultArray.count == 0) {
             [footerView endRefresh];
             return;
         }
         [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             OrderListModel  *model = [[OrderListModel alloc] initWithDictionary:obj error:nil];
             NSString * str = model.order_status;
            
             if(str.intValue == 3 || str.intValue == 4)
                 [orderArr addObject:model];
         }];
         
         [ myTabelView reloadData];
         [header endRefresh];
         [footerView endRefresh];
     } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
//         [SVProgressHUD showErrorWithStatus:response.error_desc];
     }];

}
- (void)createMyTableView
{
//    myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, UIScreenWidth, UIScreenHeight-120)];
    myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, UIScreenWidth, UIScreenHeight-120) style:UITableViewStylePlain];
//    myTabelView.style = UITableViewStyleGrouped;
    myTabelView.backgroundColor = BJCLOLR;
    myTabelView.delegate = self;
    myTabelView.dataSource = self;
    myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderArr = [[NSMutableArray alloc] init];
    grayView = [[UIImageView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y+searchBar.frame.size.height, UIScreenWidth, UIScreenHeight)];
    grayView.backgroundColor = [UIColor grayColor];
    grayView.alpha = 0.5;
    grayView.hidden = YES;
    [self.view addSubview:myTabelView];
    [self.view insertSubview:grayView aboveSubview:myTabelView];
    
    
}
#pragma mark -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderListModel *model = [orderArr objectAtIndex:section];
    NSInteger num = 0;
    for (int i =0 ; i< model.goods_list.count; i++) {
        CartListGoodsModel * model1 = [model.goods_list objectAtIndex:i];
        if ([model1.is_gift isEqualToString:@"0"]) {
            num ++;
        }
    }
    return num+1;
//    return  model.goods_list.count +1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return orderArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 110;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section  == orderArr.count - 1) {
//        return 0;
//    }else
//    return 7;
////   return 0.000001;
//}
//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIImageView * image= [[UIImageView alloc] init];
//    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5)];
//    lineView.backgroundColor = LINE;
//    [image addSubview:lineView];
//    image.backgroundColor = BJCLOLR;
////    image.layer.borderColor = LINE.CGColor;
////    image.layer.borderWidth = 0.5;
//    return image;
//}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListModel *model = [orderArr objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        static NSString * dingDanHao = @"dingDanHao";
        DingDanHaoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dingDanHao];
        if (cell == nil) {
            cell = [[DingDanHaoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dingDanHao];
        }
        if (model) {
            cell.statusLabel.text = model.order_status_text;
            cell.timeLabel.text  = [NSString stringWithFormat:@"下单时间：%@",model.order_time];
            cell.numberLabel.text = [NSString stringWithFormat:@"订单号：%@",model.order_sn];
            CGFloat width = [TTIFont calWidthWithText: cell.numberLabel.text font:[UIFont systemFontOfSize:15.0] limitWidth:25];
            cell.numberLabel.frame = CGRectMake(20,5, width, 25);

            
        }
        
        return cell;
    }else{
        static NSString * dingDanHao = @"shangpin";
        SHGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:dingDanHao];
        if (cell == nil) {
            cell = [[SHGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dingDanHao];
        }
        CartListGoodsModel * listModel = [model.goods_list objectAtIndex:indexPath.row-1];
        if (indexPath.row == 1) {
            cell.lineView.hidden = YES;
        }else{
            cell.lineView.hidden = NO;
        }
        if (indexPath.row == model.goods_list.count) {
            cell.footerView.hidden = NO;
        }else{
            cell.footerView.hidden = YES;
        }
        if (listModel) {
            cell.listMd = listModel;
//            cell.Order_id = model.order_id;
//            cell.Order_sn = model.order_sn;
//            cell.Order_Status = model.order_status;
            cell.OrderModel = model;
            if ([listModel.is_gift isEqualToString:@"0"]) {
                [cell initWithModel:listModel];
            }
        }
        
        cell.delegate = self;
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.section);
     NSLog(@"%ld",indexPath.row);
    if (indexPath.row != 0) {
        OrderListModel *model = [orderArr objectAtIndex:indexPath.section];
        CartListGoodsModel * listModel = [model.goods_list objectAtIndex:indexPath.row-1];
        MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.gid = listModel.goods_id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    

}
#pragma mark-- 售后服务
- (void)shouHouFuWu:(CartListGoodsModel *)button withOrderModel:(OrderListModel *) orderMD
{
    if ([orderMD.order_status isEqualToString:@"4"]) {
        //跳转到售后服务界面
        SHServeController * serve = [[SHServeController alloc] init];
        serve.order_sn = orderMD.order_sn;
        serve.order_id = orderMD.order_id;
        serve.order_Status=  orderMD.order_status;
        //    serve.app_receipt_confirm = orderMD.
        serve.model = button;
        [self.navigationController pushViewController:serve animated:YES];
    }else{
        ReturnBackViewController * returnBack = [[ReturnBackViewController alloc] init];
        returnBack.model = button;
        returnBack.order_sn = orderMD.order_sn;
        returnBack.order_id = orderMD.order_id;
        returnBack.order_Status = orderMD.order_status;
        [self.navigationController pushViewController:returnBack animated:YES];
    }
    
    
}
- (void)createUpView
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 10, UIScreenWidth-40, 30)];
    searchBar.delegate  = self;
    //去除searchBar的背景
    for (UIView *view in searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    searchBar.placeholder = @"商品名称，商品编号，订单编号";
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = BLACKTEXT;
//    [self.view addSubview:searchBar];
}
#pragma mark -- searchBarDelageta
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    grayView.hidden = NO;
    myTabelView.userInteractionEnabled = NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [searchBar resignFirstResponder];
    myTabelView.userInteractionEnabled = YES;
    grayView.hidden = YES;
}
- (void)createBottomView
{
    UIImageView * bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, UIScreenHeight-120, UIScreenWidth, 60)];
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = beijing;
    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth/2, 5, 1, 45)];
    lineView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:lineView];
    for (int i = 0; i< 2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*UIScreenWidth/2, 0, UIScreenWidth/2, 60);
        btn.tag = 100+i;
        if (i==0) {
            [btn setTitle:@"进度查询" forState:UIControlStateNormal];
//            btn.titleLabel.text = @"进度查询";
        }else{
            [btn setTitle:@"售后帮助" forState:UIControlStateNormal];
//             btn.titleLabel.text = @"售后帮助";
        }
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.textColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn];
    }
    [self.view addSubview:bottomView];
    
}
#pragma mark -- 底部按钮点击事件
- (void)action:(UIButton * ) btn
{
    if (btn.tag == 100) {
        CheckJinDuController * check = [[CheckJinDuController alloc] init];
        [self.navigationController pushViewController:check animated:YES];
        NSLog(@"进度查询");
    }else if (btn.tag == 101){
        SHHelpViewController * shHelp = [[SHHelpViewController alloc] init];
        shHelp.HelpString =  helpStr;
        [self.navigationController pushViewController:shHelp animated:YES];
        NSLog(@"售后帮助");
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
