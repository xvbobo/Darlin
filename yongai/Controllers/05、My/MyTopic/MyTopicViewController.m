//
//  MyTopicViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//删除帖子按钮调用API：/user/remove_thread.php
//传回变量: $tid
//返回值:0 成功；4，失败
#import "MyTopicViewController.h"
#import "MyTopicDetailViewController.h"
#import "MyInfoViewController.h"

#import "TopicViewCell.h"
#define QDBJ RGBACOLOR(23, 17, 26,0.5)
@interface MyTopicViewController ()
{
    NSInteger g_Page;
    UIImageView * maskView;
    NSString * cancelTid;
    FCXRefreshHeaderView * headerView;
    FCXRefreshFooterView * footerView;
    CGFloat CellHeight;
    UIImageView * juhauView;
    UIActivityIndicatorView *flower;//菊花视图
    UILabel * jiaZai;

}

@property (strong, nonatomic) NSMutableArray *topicListArray;

@end

@implementation MyTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    jiaZai = [[UILabel alloc] initWithFrame:CGRectMake((UIScreenWidth - 100)/2, 20, 200, 20)];
    jiaZai.font = [UIFont systemFontOfSize:15];
    jiaZai.textColor = TEXT;
    jiaZai.text = @"正在用力加载，请骚等~";
    flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
              UIActivityIndicatorViewStyleGray];
    [flower startAnimating];
    juhauView = [[UIImageView alloc] initWithFrame:CGRectMake(0, UIScreenHeight -120, UIScreenWidth, 60)];
    juhauView.backgroundColor = BJCLOLR;
    flower.frame = CGRectMake(jiaZai.frame.origin.x-50,10, 40,40);
    [juhauView addSubview:jiaZai];
    [juhauView addSubview:flower];
    [self.view insertSubview:juhauView aboveSubview:_myTableView];
    // Do any additional setup after loading the view.
    maskView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    maskView.backgroundColor = QDBJ;
    maskView.hidden = YES;
    maskView.userInteractionEnabled = YES;
    UIImageView * whiteBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth-40, 170)];
    whiteBackView.center = CGPointMake(self.view.center.x, self.view.center.y-64);
    whiteBackView.layer.masksToBounds = YES;
    whiteBackView.layer.cornerRadius = 3;
    whiteBackView.userInteractionEnabled = YES;
    whiteBackView.backgroundColor = [UIColor whiteColor];
    UILabel *tishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100,25)];
    tishiLabel.text = @"提示";
    tishiLabel.font = font(23);
    tishiLabel.textColor = BLACKTEXT;
    [whiteBackView addSubview:tishiLabel];
    UILabel * sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, tishiLabel.frame.origin.y+tishiLabel.frame.size.height+30, 150, 20)];
    sureLabel.font = font(20);
    sureLabel.textColor = BLACKTEXT;
    sureLabel.text = @"确定删除吗？";
    UIButton * quxiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat jiange = (UIScreenWidth-40-200)/3;
    quxiaoBtn.frame = CGRectMake(jiange, whiteBackView.frame.size.height-50, 100, 25);
    [quxiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoBtn setTitleColor:beijing forState:UIControlStateNormal];
    [quxiaoBtn addTarget:self action:@selector(quxiaoAction) forControlEvents:UIControlEventTouchUpInside];
    quxiaoBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [whiteBackView addSubview:quxiaoBtn];
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(jiange*2+100, whiteBackView.frame.size.height-50, 100, 25);
     sureBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:beijing forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBackView addSubview:sureBtn];
    [whiteBackView addSubview:sureLabel];
    [maskView addSubview:whiteBackView];
    [self.view addSubview:maskView];
    NAV_INIT(self, @"我的话题", @"common_nav_back_icon", @selector(backAction), @"", nil);
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = BJCLOLR;
    _topicListArray = [NSMutableArray array];
    g_Page = 1;
    
    [self initTableDataWithPage:1];
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
- (void)quxiaoAction
{
    maskView.hidden = YES;
}
- (void)sureBtn:(UIButton*)btn
{

    [[TTIHttpClient shareInstance] myTopicCancelwithTid:cancelTid withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        [self  refreshComments];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
    maskView.hidden = YES;
}
- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initTableDataWithPage:(NSInteger)page
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] bbsThreadRequestWithPage:[NSString stringWithFormat:@"%ld", page]
                                            WithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                juhauView.hidden = YES;
                                                if(page == 1)
                                                {
                                                    [self.topicListArray removeAllObjects];
                                                    
                                                    self.topicListArray = [[NSMutableArray alloc] init];
                                                }
                                
                                                    [self.topicListArray addObjectsFromArray:response.responseModel];
                                                                            
                                                [self.myTableView reloadData];
                                                [headerView endRefresh];
                                                [footerView endRefresh];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.topicListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *GoldFigureCellIdentifier = @"TopicViewCell";
    
    TopicViewCell *cell = (TopicViewCell*)[tableView dequeueReusableCellWithIdentifier:GoldFigureCellIdentifier];
    if(cell == nil)
    {
        cell =[[[UINib nibWithNibName:@"TopicViewCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    PostListModel *post = [self.topicListArray objectAtIndex:indexPath.row];
    [cell initWith:CellHeight];
    cell.postInfo = post;
    
//    cell.backgroundColor = beijing;
    
    
    return cell;
}
- (void)cancelBtnClick:(UIButton*)btn
{
    cancelTid = [NSString stringWithFormat:@"%ld",btn.tag];
    maskView.hidden  = NO;
    
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostListModel *info = [self.topicListArray objectAtIndex:indexPath.row];
    
    MyTopicDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyTopicDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.tid = info.tid;
    detailVC.isJoic = info.is_join;
    detailVC.fid = info.fid;
    detailVC.number = info.reply_num;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostListModel *post = [self.topicListArray objectAtIndex:indexPath.row];
    if([post.is_pic isEqualToString:@"0"])
    {
        CellHeight = 110;
        return 110;
    }
    else
    {
        CellHeight = 195;
       return 185;
    }
    
    
}

// 点击用户头像， 查看对方用户的个人中心
- (void)headBtn {
    
    MyInfoViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
    myInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myInfoVC animated:YES];
}
- (void)refreshComments{
    
    g_Page = 1;
    [self initTableDataWithPage:g_Page];
   
}

- (void)loadMoreComments{
    
    g_Page ++;
    [self initTableDataWithPage:g_Page];
    
}

@end
