//
//  MyMessageViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageViewCell.h"
#import "ChatViewController.h"

@interface MyMessageViewController ()
{
    UIView *_maskView;
    NSMutableArray *dataSource;
    int g_Page;
    FCXRefreshHeaderView * headerView;
    FCXRefreshFooterView * footerView;
    BOOL xianshijuHua;
    UIImageView * juhauView;
    UIActivityIndicatorView *flower;//菊花视图
    UILabel * jiaZai;

}

@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"我的消息", @"common_nav_back_icon", @selector(backAction), nil, nil);
    jiaZai = [[UILabel alloc] initWithFrame:CGRectMake((UIScreenWidth - 100)/2, 20, 200, 20)];
    jiaZai.font = [UIFont systemFontOfSize:15];
    jiaZai.textColor = TEXT;
    jiaZai.text = @"正在用力加载，请骚等~";
    flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
              UIActivityIndicatorViewStyleGray];
    [flower startAnimating];
    juhauView = [[UIImageView alloc] initWithFrame:CGRectMake(0, UIScreenHeight - 120, UIScreenWidth, 60)];
    juhauView.backgroundColor = [UIColor whiteColor];
    flower.frame = CGRectMake(jiaZai.frame.origin.x-50,10, 40,40);
    [juhauView addSubview:jiaZai];
    [juhauView addSubview:flower];
    [self.view insertSubview:juhauView aboveSubview:_myTableView];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor clearColor];
    g_Page = 1;
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

- (void)viewWillAppear:(BOOL)animated {
    MyMessageViewController * MMVC;
    [super viewWillAppear:animated];
    [MMVC viewWillAppear:animated];
    [self requestMessageListWithPage:1];
}

// 消息列表
-(void)requestMessageListWithPage:(int)page
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] messagelistRequestWithType:@"1"
                                                         page:[NSString stringWithFormat:@"%d", page]
                                              withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                  juhauView.hidden = YES;
                                                  if(page == 1)
                                                  {
                                                      [dataSource removeAllObjects];
            
                                                      dataSource = [[NSMutableArray alloc] init];
                                                  }
        
                                                  [dataSource addObjectsFromArray:response.responseModel];
        
                                                  [self.myTableView reloadData];
                                                  [headerView endRefresh];
                                                  [footerView endRefresh];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}
- (void)backAction {
    
    _myTableView.editing = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MessageLongPressDelegate
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataSource count];
//    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMessageViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if([dataSource count] > indexPath.row)
    {
        MessageModel *model = [dataSource objectAtIndex:indexPath.row];
        [cell setMessageInfo:model];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatViewController *chatVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatVC.hidesBottomBarWhenPushed = YES;
    MessageModel *model = [dataSource objectAtIndex:indexPath.row];
    chatVC.message = model;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 78;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

#pragma mark 删除/插入操作
// 实现了此方法向左滑动就会显示删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MessageModel *model = [dataSource objectAtIndex:indexPath.row];
        [[TTIHttpClient shareInstance] messageDelRequestWithMesuid:model.mesu_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            
            [dataSource removeObject:model];
            [_myTableView reloadData];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
            [SVProgressHUD showErrorWithStatus:response.error_desc];
        }];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}


- (void)refreshComments{
    
    g_Page = 1;
    [self requestMessageListWithPage:g_Page];
   
}

- (void)loadMoreComments{
    
    g_Page ++;
    [self requestMessageListWithPage:g_Page];

}

#pragma mark - getter

@end