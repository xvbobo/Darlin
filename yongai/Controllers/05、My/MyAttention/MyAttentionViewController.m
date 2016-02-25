//
//  MyAttentionViewController.m
//  Yongai
//
//  Created by myqu on 14/11/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "AttentionPersonCell.h"
#import "PostsCell.h"
#import "TieZiLieBiaoCell.h"
#import "MyTopicDetailViewController.h"
#import "MyInfoViewController.h"
#import "HisTopicViewController.h"
@interface MyAttentionViewController () <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UISegmentedControl *segmentCtrl;
    UITableView *myTableView;
    UITableView * newTabelView;
    NSInteger  segmentedIndex; //选择的segmented标号  0:看帖  1：看人
    
    NSMutableArray *dataSource;
    NSMutableArray * dataSource1;
    NSInteger  g_Page;
    NSInteger  g_Page1;
    // table head view
    BbsModel       *bbsInfo;
    
//    PostsCell *g_PostCell;
    FCXRefreshHeaderView * headerView;
    FCXRefreshFooterView * footerView;
    FCXRefreshHeaderView * headerView1;
    FCXRefreshFooterView * footerView1;
    BOOL Scroll;
    
}
- (IBAction)segmentCtrlClick:(id)sender;

@end

@implementation MyAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, nil, @"common_nav_back_icon", @selector(backAction), nil, nil);
    self.view.backgroundColor = BJCLOLR;
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 60) style:UITableViewStylePlain];
//    myTableView.backgroundColor = BJCLOLR;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.hidden = YES;
    [self.view addSubview:myTableView];
//    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    newTabelView.tableFooterView = [[UIView alloc] init];
    [self createNewTabelView];
    g_Page = 1;
    g_Page1 = 1;
    segmentedIndex = 0;
    Scroll = YES;
    dataSource = [[NSMutableArray alloc] init];
    dataSource1 = [[NSMutableArray alloc] init];
    myTableView.backgroundColor = BJCLOLR;
    [self requestBbsFollowWithPage:g_Page1];
    [self requestUserFollowWithPage:1];
    
    
    [self addRefreshView];
}
- (void)createNewTabelView
{
    newTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 60) style:UITableViewStylePlain];
    newTabelView.backgroundColor = BJCLOLR;
    newTabelView.delegate = self;
    newTabelView.dataSource = self;
    newTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:newTabelView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView1 = [myTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshComments];
    }];
    
    //上拉加载更多
    footerView1 = [myTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        //        [weakSelf loadMoreComments];
    }];
    footerView1.autoLoadMore = YES;
    headerView = [newTabelView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshComments];
    }];
    
    //上拉加载更多
    footerView = [newTabelView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
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
    Scroll = YES;
    
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    Scroll = NO;
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 点击用户头像， 查看对方用户的个人中心



-(void)requestUserFollowWithPage:(NSInteger)page
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] userFollowRequestWithPage:[NSString stringWithFormat:@"%ld", (long)page]
                                             withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         if(page == 1)
         {
             dataSource1 = response.responseModel;
         }
         else
         {
             [dataSource1 addObjectsFromArray:response.responseModel];
         }
        NSLog(@"**************datasource = %@",dataSource1);
        [myTableView reloadData];
         [headerView1 endRefresh];
         [footerView1 endRefresh];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response){
        
       
    }];
}
-(void)requestBbsFollowWithPage:(NSInteger)page
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] bbsFollowRequestWithPage:[NSString stringWithFormat:@"%ld", (long)page] withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        
        if(page == 1)
        {
            dataSource = response.responseModel;
        }
        else
        {
            [dataSource addObjectsFromArray:response.responseModel];
        }
//        NSLog(@"**************datasource = %@",dataSource);
        [newTabelView reloadData];
        [headerView endRefresh];
        [footerView endRefresh];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (segmentedIndex == 0) {
        return 6;
    }else{
        return 0;
    }
   
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * imageView = [[UIImageView alloc ] init];
    imageView.backgroundColor = BJCLOLR;
    return imageView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(segmentedIndex == 0)
    {
        int imageW = (UIScreenWidth - 40)/3;
        if (dataSource.count != 0 && indexPath.row < dataSource.count) {
            PostListModel * list = [dataSource objectAtIndex:indexPath.row];
            NSArray * array = list.attachment;
            
            if (array.count == 0) {
                return 74;
                
            }else{
                return 70+imageW;
            }
        }else{
            return 0;
        }

       
    }
    else
    return 85.0;
}

#pragma mark ---  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segmentedIndex == 0) {
       return [dataSource count];
    }else{
        return [dataSource1 count];
    }

    
//    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * cellStr = @"cell";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
//    }
//    return cell;
    if(segmentedIndex == 0)
    {
        NSString * strCell = @"Cell";
        TieZiLieBiaoCell * cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if (cell == nil) {
            cell = [[TieZiLieBiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (dataSource.count != 0 && indexPath.row < dataSource.count) {
            NSLog(@"%ld",(long)indexPath.row);
            PostListModel *post = [dataSource objectAtIndex:indexPath.row];
            cell.adTime = YES;
            NSLog(@"post = %@, array = %@",post, post.attachment);
            [cell setPostInfo:post];
        }
        
        return cell;
    }
    else if (segmentedIndex == 1)
    {
        static NSString *reuseIdentifier = @"AttentionPersonCell";
        
        AttentionPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[AttentionPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        if (dataSource1.count != 0 && indexPath.row < dataSource1.count) {
            NSLog(@"%ld",(long)indexPath.row);
            RankModel *person = [dataSource1 objectAtIndex:indexPath.row];
            [cell  setInfo:person];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }else{
       return  nil; 
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(segmentedIndex == 0)
    {
        /**
         *  显示话题详情页面
         */
        PostListModel *post = [dataSource objectAtIndex:indexPath.row];
        NSLog(@"用户昵称 = %@，帖子内容 = %@，帖子图片路径 = %@",post.nickname,post.message,post.attachment);
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
        MyTopicDetailViewController *PostMenuDetailVC = [board instantiateViewControllerWithIdentifier:@"MyTopicDetailViewController"];
        PostMenuDetailVC.tid = post.tid;
        PostMenuDetailVC.isJoic = post.is_join;
        PostMenuDetailVC.fid = post.fid;
        PostMenuDetailVC.number = post.reply_num;
        [self.navigationController pushViewController:PostMenuDetailVC animated:YES];
    }
    else
    {
        /**
         *  显示ta的信息详情页面
         */
        RankModel * dict = [dataSource1 objectAtIndex:indexPath.row];
        HisTopicViewController * his = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
        his.userId = dict.user_id;
        [self.navigationController pushViewController:his animated:YES];
    }
}


- (IBAction)segmentCtrlClick:(id)sender {
    
    
//    [dataSource removeAllObjects]; 
//    [myTableView reloadData];
    
    segmentedIndex = segmentCtrl.selectedSegmentIndex;
    
    if(segmentedIndex == 1)
    {
        myTableView.hidden = NO;
        newTabelView.hidden =YES;
        [myTableView reloadData];
//        [self requestUserFollowWithPage:g_Page1];
    }
    else
    {
        myTableView.hidden = YES;
        newTabelView.hidden = NO;
        myTableView.tableHeaderView = nil;
        [newTabelView reloadData];
//        [self requestBbsFollowWithPage:g_Page];
    }
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    MyAttentionViewController * Attentio ;
//    [super viewWillAppear:animated];
//    [Attentio viewWillAppear:animated];
//    [self refreshComments];
//}
- (void)refreshComments
{
   
    if(segmentedIndex == 1)
    {
//        myTableView.tableHeaderView = nil;
        [self requestUserFollowWithPage:1];
    }
    else
    {
//         g_Page = 1;
//        myTableView.tableHeaderView = nil;
        [self requestBbsFollowWithPage:1];
    }

   
}

- (void)loadMoreComments{
    
   
    
    if(segmentedIndex == 1)
    {
        g_Page1++;
//        myTableView.tableHeaderView = nil;
        [self requestUserFollowWithPage:g_Page1];
    }
    else
    {
         g_Page ++;
//        myTableView.tableHeaderView = nil;
        [self requestBbsFollowWithPage:g_Page];
    }
    
    
}

@end
