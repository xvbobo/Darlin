//
//  MyOrderListViewController.m
//  Yongai
//
//  Created by Kevin Su on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "CommonUtils.h"
#import "OrderProductCell.h"
#import "OrderCellHeaderView.h"
#import "PaymentViewController.h"
#import "DataModel.h"
#import "OrderCommentViewController.h"
#import "ConfirmReceptViewController.h"
#import "DataButton.h"
#import "NewOrderFooterCell.h"

@interface MyOrderListViewController (){
    
    NSString *selectOedertype;
    NSMutableArray  *orderArr; // 订单列表数组
    FCXRefreshHeaderView * header;
    FCXRefreshFooterView * footerView;
    UIButton * cancleBtn;
}

@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self initlization];
    [self loadNav];
    [self loadOrdersListView];
    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    header = [self.orderListTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshOrderList];
    }];
    
    //上拉加载更多
    footerView = [self.orderListTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        //        [weakSelf loadMoreComments];
    }];
    
//    自动刷新
    footerView.autoLoadMore = YES;
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (UIScreenHeight > scrollView.contentSize.height-scrollView.contentOffset.y)
    {
        [self loadMoreOrders];
        
    }
    NSLog(@"%f",scrollView.contentSize.height - scrollView.contentOffset.y);
    NSLog(@"%f",UIScreenHeight);
    
}

- (void)viewWillAppear:(BOOL)animated{
    MyOrderListViewController * MOLV;
    [super viewWillAppear:animated];
    [MOLV viewWillAppear:animated];
    [self refreshOrderList];
}

- (void)initlization{
    
    // 默认近一个月的订单
    selectOedertype = TYPE_MONTH_ONE;
    
    orderArr = [[NSMutableArray alloc] init];
}

- (void)loadNav{
    
    NAV_INIT(self, @"我的订单", @"common_nav_back_icon", @selector(back), nil, nil);
    
}
- (void)loadOrdersListView{
    
    
    self.orderListTableView.delegate = self;
    self.orderListTableView.dataSource = self;
    self.orderListTableView.backgroundColor = BJCLOLR;
    self.orderListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - TableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return orderArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    OrderListModel *model = [orderArr objectAtIndex:section];
    return  model.goods_list.count +2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * image = [[UIImageView alloc] init];
    image.backgroundColor = BJCLOLR;
    return image;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderListModel *model;
    if(orderArr.count > indexPath.section)
        model = [orderArr objectAtIndex:indexPath.section];
    
    if(indexPath.row == 0)
        return 85;
    else if (indexPath.row -1 == model.goods_list.count)
        return 50;
    else
        return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    OrderListModel *model;
    if(orderArr.count > section)
        model = [orderArr objectAtIndex:section];
    
    UITableViewCell *cell;
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell1"];
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomCell1"];
        
        
        OrderCellHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"OrderCellHeaderView" owner:self options:nil] lastObject];
        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 85);
        headerView.backgroundColor = [UIColor clearColor];
        headerView.view1.backgroundColor = BJCLOLR;
        if(orderArr.count >section )
            [headerView initDataWithInfo:orderArr[section]];
        
        for(UIView *subView in cell.contentView.subviews)
            [subView removeFromSuperview];
        
        [cell.contentView addSubview:headerView];
    }
    else if (indexPath.row -1 == [model.goods_list  count])
    {
        static NSString * footer = @"newFooter";
        NewOrderFooterCell * cell = [tableView dequeueReusableCellWithIdentifier:footer];
        if (cell == nil) {
            cell = [[NewOrderFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footer];
        }
        if (orderArr.count > section) {
            [cell initDataWithInfo:model index:section];
        }
        return cell;
    }
    else
    {
        NSInteger row = indexPath.row;
        row = row -1;
        static NSString *cellIdentifier = @"OrderProductCell";
        [tableView registerNib:[UINib nibWithNibName:@"OrderProductCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        OrderProductCell *orderProductCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(orderArr.count >section &&[((OrderListModel *)orderArr[section]).goods_list  count] > row)
            [orderProductCell initDataWithInfo:((OrderListModel *)orderArr[section]).goods_list[row]];
    
        return orderProductCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self loadOrderDetailWithRow:indexPath.section];
}

- (void)refreshOrderList{
    
    self.orderindex = 1;
    [self loadMyOrderListWithPage:self.orderindex];
   
}

- (void)loadMoreOrders{
    
    self.orderindex++;
    [self loadMyOrderListWithPage:self.orderindex];
    
}

#pragma mark - Detail Actions
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------------  我的订单列表
- (void)loadMyOrderListWithPage:(NSInteger)page{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] listOrderRequestWithsid:g_userInfo.sid
                                                  withtype:selectOedertype
                                                  withpage:[NSString stringWithFormat:@"%ld", (long)page] withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         if(page == 1){
             
             [orderArr removeAllObjects];
         }
         
         NSArray *resultArray = [response.result  objectForKey:@"result"];
         
         if(resultArray.count == 0){
             [footerView endRefresh];
             return;
         }
         
         
         
         [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             OrderListModel  *model = [[OrderListModel alloc] initWithDictionary:obj error:nil];
             if(model)
                 [orderArr addObject:model];
         }];
         
         [self.orderListTableView reloadData];
         [header endRefresh];
         [footerView endRefresh];
         
     } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
     }];
}

#pragma mark - 订单详情

- (void)loadOrderDetailWithRow:(NSInteger)row{
    
    OrderListModel *model = [orderArr objectAtIndex:row];
    PaymentViewController *paymentController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    paymentController.bFromOrderList = YES;
    paymentController.dataInfo = model;
    paymentController.orderID = model.order_id;
    paymentController.myTitleString = model.order_status_text;
    [self.navigationController pushViewController:paymentController animated:YES];


}


#pragma mark - 取消订单
- (void)cancelOrderWithOrderid:(NSString *)order_id{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认取消该订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = order_id.intValue;
    [alertView show];
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString *order_id = [NSString stringWithFormat:@"%ld", (long)alertView.tag];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[TTIHttpClient shareInstance] cancelOrderRequestWithsid:g_userInfo.sid withorder_id:order_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            
            [self refreshOrderList];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
            [SVProgressHUD showErrorWithStatus:response.error_desc];
        }];
    }

}
@end
