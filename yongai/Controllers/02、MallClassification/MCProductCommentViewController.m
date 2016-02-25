//
//  MCProductCommentViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  商品评价
#import "MCProductCommentViewController.h"
#import "CommonUtils.h"
#import "ProductCommentCell.h"
#import "TTIFont.h"

@interface MCProductCommentViewController ()
{
    ProductCommentCell *globalCell;
    FCXRefreshFooterView * footerView;
    FCXRefreshHeaderView * headerView;
}
@end

@implementation MCProductCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commentsTableView.backgroundColor = BJCLOLR;
    self.haoPingDu.textColor = TEXT;
    globalCell = [[[UINib nibWithNibName:@"ProductCommentCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self initlization];
    [self loadNavView];
    
    [self loadCommentsCollectionView];
    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [self.commentsTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshComments];
    }];
    
    //上拉加载更多
    footerView = [self.commentsTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    MCProductCommentViewController * MCP;
    [super viewWillAppear:animated];
    [MCP viewWillAppear:animated];
    [self refreshComments];
}

- (void)initlization{
    
    self.commentsArray = [[NSMutableArray alloc] init];
}

- (void)loadNavView{
    
    NAV_INIT(self, @"商品评价", @"common_nav_back_icon", @selector(back), nil, nil);
}

- (void)loadCommentsCollectionView{

   
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    self.commentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PSCollectionViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic =self.commentsArray[indexPath.row];
    float height = 90.0;
    float h = [TTIFont calHeightWithText:[dic objectForKey:@"content"] font:globalCell.commentContentLabel.font limitWidth:globalCell.commentContentLabel.frame.size.width];
    
    return height+h -16;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"ProductCommentCell";
    [tableView registerNib:[UINib nibWithNibName:@"ProductCommentCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    ProductCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell initDataWithDictionary:self.commentsArray[indexPath.row]];
    return cell;
}

- (void)refreshComments{
    
    self.commentIndex = 1;
    [self loadCommentsWithPage:self.commentIndex];

}

- (void)loadMoreComments{
    
    self.commentIndex ++;
    [self loadCommentsWithPage:self.commentIndex];
   
}

#pragma mark - Detail Actions  
#pragma mark -----------------------  获取评论列表
- (void)loadCommentsWithPage:(NSInteger)page{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] comment_listRequestWithgoods_id:self.goods_id withpage:[NSString stringWithFormat:@"%li", (long)page] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD dismiss];
        self.commentGradeLabel.text = response.result[@"good_comment"];
        NSArray *resultArray = (NSArray *)response.result[@"comment_list"];
        if(resultArray.count == 0){
            [footerView endRefresh];
//            [SVProgressHUD showSuccessWithStatus:@"没有更多~"];
            return ;
        }
        
        if(page == 1){
            
            [self.commentsArray removeAllObjects];
        }
        [self.commentsArray addObjectsFromArray:resultArray];
        [self.commentsTableView reloadData];
        [headerView endRefresh];
        [footerView endRefresh];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        
    }];
}

@end
