//
//  SearchProductsViewController.m
//  Yongai
//
//  Created by Kevin Su on 14/12/1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "SearchProductsViewController.h"
#import "CommonUtils.h"
#import "MCProductDetailViewController.h"

@interface SearchProductsViewController (){
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;

}

@end

@implementation SearchProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initlization];
    [self initNav];
    [self initProductsTableView];
    
    [self refreshProductsTableAction];
    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [self.productsTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshProductsTableAction];
    }];
    
    //上拉加载更多
    footerView = [self.productsTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        //        [weakSelf loadMoreComments];
    }];
    footerView.hidden = YES;
    //自动刷新
    footerView.autoLoadMore = YES;
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height)
    {
        [self loadMoreProductsAction];
        
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initlization{
    
    self.productsArray = [[NSMutableArray alloc] init];
    self.pageIndex = 1;
}

- (void)initNav{
    
    NAV_INIT(self, self.titleStr, @"common_nav_back_icon", @selector(back), nil, nil);
}

- (void)initProductsTableView{
    
    self.productsTableView.delegate = self;
    self.productsTableView.dataSource = self;
    
    self.productsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productsTableView.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Detail Actions
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------ 搜索商品
- (void)searchProductsWithPage:(int)page{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] searchProductsListRequestWithKeyWord:self.titleStr page:self.pageIndex withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD  dismiss];
        NSArray *resultArray = (NSArray *)response.result[@"result"];
        
        if(page == 1){
            if(resultArray.count == 0){
                self.pageIndex--;
                [SVProgressHUD showSuccessWithStatus:@"没有搜索到哟~"];
                [footerView endRefresh];
                return ;
            }else{
              [self.productsArray removeAllObjects];
            }
            
        }else {
            if(resultArray.count == 0){
               [footerView endRefresh];
                return ;
            }
        }
        [self.productsArray addObjectsFromArray:resultArray];
        [self.productsTableView reloadData];
        [headerView endRefresh];
        [footerView endRefresh];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}

- (void)refreshProductsTableAction{
    
    self.pageIndex = 1;
    [self searchProductsWithPage:self.pageIndex];
  
}

- (void)loadMoreProductsAction{
    footerView.hidden = NO;
    self.pageIndex++;
    [self searchProductsWithPage:self.pageIndex];
    
}

#pragma mark -----------  tableView Delegate && Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.productsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"SearchProductCell";
    [tableView registerNib:[UINib nibWithNibName:@"SearchProductCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    SearchProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell initWithData:self.productsArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //显示商品详情
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.gid = self.productsArray[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
