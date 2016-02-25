//
//  SendGoldListViewController.m
//  yongai
//
//  Created by wangfang on 15/1/22.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "SendGoldListViewController.h"
#import "SendGoldListCell.h"
#import "HisTopicViewController.h"
//#import "OtherInfoViewController.h"
#import "MyInfoViewController.h"
//#import "PullTableView.h"
@interface SendGoldListViewController ()<SendGoldListCellDelegate>
{
    NSMutableArray *dataSource;
    NSInteger  g_page;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
}

@end

@implementation SendGoldListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NAV_INIT(self, @"送金币的人", @"common_nav_back_icon", @selector(backAction), nil, nil);
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = BJCLOLR;
    
    
    g_page = 1;
    [self initTableDataWithPage:g_page];
    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [self.myTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshComments];
    }];
    
    //上拉加载更多
    footerView = [self.myTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        //        [weakSelf loadMoreComments];
    }];
    
    //自动刷新
    footerView.autoLoadMore = YES;
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height)
    {
        [self loadMoreComments];
        
    }
    
    
    
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableDataWithPage:(NSInteger)page
{
    [[TTIHttpClient shareInstance] userGoldListRequestWithUserId:self.userId
                                                        WithPage:[NSString stringWithFormat:@"%d", page]
                                                 withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
                                                     if(page == 1)
                                                     {
                                                         [dataSource removeAllObjects];
                                                         
                                                         dataSource = [[NSMutableArray alloc] init];
                                                     }
                                                     NSDictionary *dict = response.result;
                                                     [dataSource addObjectsFromArray:dict[@"gold_list"]];
                                                     
                                                     [self.myTableView reloadData];
                                                     
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [dataSource objectAtIndex:indexPath.row];
    
    SendGoldListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendGoldListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.tag = indexPath.row;
    cell.delegate =self;
    
    [cell updateCellWithDic:dict];
    
    return cell;
}

#pragma mark -- SendGoldListCellDelegate <NSObject>

-(void)showOtherInfoWithRow:(NSInteger)row
{
    NSDictionary *dict = [dataSource objectAtIndex:row];
    NSString *userId = [dict objectForKey:@"user_id"];
    // 判断泡友榜列表是否显示的时自己
    if ([userId isEqualToString:g_userInfo.uid]) {
        
        MyInfoViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        myInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myInfoVC animated:YES];
        
    } else {
        
        HisTopicViewController *otherVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
        otherVC.hidesBottomBarWhenPushed = YES;
        otherVC.userId = userId;
        [self.navigationController pushViewController:otherVC animated:YES];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (void)refreshComments{
    
    g_page = 1;
    [self initTableDataWithPage:g_page];
  }

- (void)loadMoreComments{
    
    g_page ++;
    [self initTableDataWithPage:g_page];
   
}

@end
