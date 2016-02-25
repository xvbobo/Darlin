//
//  NewOrderListController.m
//  com.threeti
//
//  Created by alan on 15/10/30.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "NewOrderListController.h"
#import "OrderCellFooterView.h"
#import "OrderCellHeaderView.h"
#import "OrderProductCell.h"
#import "NewOrderFooterCell.h"
#import "PaymentViewController.h"
@interface NewOrderListController ()<UITableViewDataSource,UITableViewDelegate,NewOrderFooterCellDelegate>

@end

@implementation NewOrderListController{
    NSInteger page;
    NSString * type;
    NSMutableArray * dataArray;
    UITableView * myTableView;
    FCXRefreshHeaderView * header;
    FCXRefreshFooterView * footerView;
    JuHuaView * flower;
    NSString * myTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    NSString * str;
    NSLog(@"%ld",self.listBtn.tag);
    if (self.listBtn.tag == 100) {
        type = @"to_pay";
        str = @"待付款";
    }else if (self.listBtn.tag == 101){
        type = @"to_deliver";
        str = @"待发货";
    }else if (self.listBtn.tag == 102){
        type = @"to_confirm";
        str = @"待收货";
    }else if (self.listBtn.tag == 103){
        type = @"to_comment";
        str = @"待评价";
    }
    myTitle = str;
     NAV_INIT(self,str, @"common_nav_back_icon", @selector(back), nil, nil);
    dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = BJCLOLR;
    [self createRequestWithPage:page];
    [self createMyTB];
    //    "to_comment" = 14;
    //    "to_confirm" = 0;
    //    "to_deliver" = 4;
    //    "to_pay" = 16;
    // Do any additional setup after loading the view.
    flower = [[JuHuaView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    flower.center = CGPointMake(self.view.center.x, self.view.center.y+20);
    [self.navigationController.view addSubview:flower];
    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    header = [myTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshOrderList];
    }];
    
    //上拉加载更多
    footerView = [myTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        //        [weakSelf loadMoreComments];
    }];
    
    //    自动刷新
    
    footerView.autoLoadMore = YES;
}
#pragma mark -- 刷新数据
- (void)refreshOrderList
{
    [self createRequestWithPage:page];
}
- (void)loadMoreComments
{
    page ++;
    [self createRequestWithPage:page];
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

- (void)createMyTB
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-60)];
    myTableView.backgroundColor = BJCLOLR;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
}
#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    OrderListModel *model = [dataArray objectAtIndex:section];
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
    if (section!= 0) {
        image.layer.borderColor = LINE.CGColor;
        image.layer.borderWidth = 0.5;
    }
    return image;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListModel *model;
    if(dataArray.count > indexPath.section)
        model = [dataArray objectAtIndex:indexPath.section];
    
    if(indexPath.row == 0)
        return 85;
    else if (indexPath.row -1 == model.goods_list.count)
        return 50;
    else
        return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self loadOrderDetailWithRow:indexPath.section];
}
#pragma mark - 订单详情

- (void)loadOrderDetailWithRow:(NSInteger)row{
    
    OrderListModel *model = [dataArray objectAtIndex:row];
    PaymentViewController *paymentController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    paymentController.bFromOrderList = YES;
    paymentController.dataInfo = model;
    paymentController.orderID = model.order_id;
    paymentController.myTitleString = myTitle;
    //    paymentController.orderInfo = [[OrderDetailModel alloc] initWithDictionary:response.result error:nil];
    [self.navigationController pushViewController:paymentController animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    OrderListModel *model;
    if(dataArray.count > section)
        model = [dataArray objectAtIndex:section];
    
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
        if(dataArray.count >section )
            [headerView initDataWithInfo:dataArray[section]];
        
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
        if (dataArray.count > section) {
            [cell initDataWithInfo:model index:section];
        }
        cell.delegate = self;
        return cell;
    }
    else
    {
        NSInteger row = indexPath.row;
        row = row -1;
        static NSString *cellIdentifier = @"OrderProductCell";
        [tableView registerNib:[UINib nibWithNibName:@"OrderProductCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        OrderProductCell *orderProductCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(dataArray.count >section &&[((OrderListModel *)dataArray[section]).goods_list  count] > row)
            [orderProductCell initDataWithInfo:((OrderListModel *)dataArray[section]).goods_list[row]];
        
        return orderProductCell;
    }
//    cell.layer.borderWidth = 0.5;
//    cell.layer.borderColor = LINE.CGColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

    
}
#pragma mark -- NewOrderFooterCellDelegate
- (void)NewOrderFooterCellButtonAction:(UIButton *)button
{
    NSLog(@"%@",button.titleLabel.text);
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    NewOrderListController * new;
    [self refreshOrderList];
    [super viewWillAppear:animated];
    [new viewWillAppear:animated];
    flower.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    NewOrderListController * new;
    [super viewWillDisappear:animated];
    [new viewWillDisappear:animated];
    flower.hidden = YES;
}
- (void)createRequestWithPage:(NSInteger)pg
{
    [flower startView];
    [[TTIHttpClient shareInstance] getOrderListMessage:g_userInfo.uid withpage:[NSString stringWithFormat:@"%ld",pg] withOrder_type:type withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        NSArray * array = [response.result objectForKey:@"result"];
        NSLog(@"%ld",array.count);
        NSLog(@"%@",response.result);
        [flower stopView];
        if(page == 1){
            
            [dataArray removeAllObjects];
        }
        
        NSArray *resultArray = [response.result  objectForKey:@"result"];        
        
        [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            OrderListModel  *model = [[OrderListModel alloc] initWithDictionary:obj error:nil];
            if(model)
                [dataArray addObject:model];
        }];
        
        [myTableView reloadData];
        [header endRefresh];
        [footerView endRefresh];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
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
