//
//  TieBaViewController.m
//  com.threeti
//
//  Created by alan on 15/7/7.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "TieBaViewController.h"
#import "TieBaCell.h"
#import "TTIFont.h"
#import "MyTopicDetailViewController.h"
#import "ConvertToCommonEmoticonsHelper.h"
@interface TieBaViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView * myTableView;
    NSMutableArray * dataSouce;
    NSInteger page;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
}

@end

@implementation TieBaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = BJCLOLR;
    dataSouce = [[NSMutableArray alloc] init];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-64)];
    myTableView.backgroundColor = BJCLOLR;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    myTableView.tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
    [self.view addSubview:myTableView];
    page = 1;
    [self createRequestWithPage:page];
    NAV_INIT(self,@"通知", @"common_nav_back_icon", @selector(back), nil, nil);
   
    // Do any additional setup after loading the view.
    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [myTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshComments];
    }];
    
    //上拉加载更多
    footerView = [myTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
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
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createRequestWithPage:(NSInteger)page
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] tieBaWithUser_id:g_userInfo.uid withPage:[NSString stringWithFormat:@"%ld",page] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
//        NSLog(@"%@",response.responseModel);
        NSMutableArray * resultArr = response.responseModel;
        if (page == 1) {
            dataSouce = resultArr;
            
    
        }else{
           [dataSouce addObjectsFromArray:resultArr]; 
        }
        [myTableView reloadData];
        [headerView endRefresh];
        [footerView endRefresh];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}
#pragma tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return dataSouce.count;
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSouce.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tongzhi * model = [dataSouce objectAtIndex:indexPath.section];
        model.message = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:model.message];
        CGFloat cellH = [TTIFont calHeightWithText:model.message font:font(17) limitWidth:UIScreenWidth-20];
    return 160+cellH-15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == dataSouce.count-1) {
        return 0;
    }else{
       return 7; 
    }
    
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView * image = [[UIImageView alloc] init];
    image.backgroundColor = BJCLOLR;
    return image;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellStr = @"tieba";
    TieBaCell * cell = [myTableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[TieBaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    Tongzhi * model = [dataSouce objectAtIndex:indexPath.section];
    [cell cellWithTiebaModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tongzhi * model = [dataSouce objectAtIndex:indexPath.section];
    MyTopicDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyTopicDetailViewController"];
    detailVC.quanString = model.forum_name;
    detailVC.string = @"贴吧";
    detailVC.fid = model.fid;
    detailVC.isJoic = model.is_join;
    detailVC.tid = model.tid;
    detailVC.dingwei = model.porder.intValue;
    detailVC.pageT = model.page;
    detailVC.number = model.reply_num;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)refreshComments{
    
    page = 1;
    [self createRequestWithPage:page];
  }

- (void)loadMoreComments{
    
    page ++;
    [self createRequestWithPage:page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
