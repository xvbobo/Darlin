//
//  PostMenuDetailController.m
//  Yongai
//
//  Created by arron on 14/11/11.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PostMenuDetailController.h"
#import "PostMenuDetailCell.h"
#import "PostDetailHeadCell.h"
#import "MyTextImageButton.h"
#import "PublishViewController.h"
#import "FriendsChartViewController.h"
#import "MyTopicDetailViewController.h"
#import "MyInfoViewController.h"
#import "LoginNavViewController.h"
#import "MyPageControl.h"
#import "QFControl.h"
#import "PostsCell.h"
#import "TieZiLieBiaoCell.h"
#define  SortType_All   @"all"  // 全部
#define  SortType_New   @"new"  // 最新
#define  SortType_Hot   @"hot"  // 最热
#define  SortType_Jing  @"jing"  // 精华
#define space  5
#define QDBJ RGBACOLOR(23, 17, 26,0.7)
@interface PostMenuDetailController ()<PostDetailHeadCellDelegate, UIAlertViewDelegate,UIScrollViewDelegate>
{
    BOOL bShowTagsView;  // 是否显示 标签 cell 的标识
    
    BOOL bShowTitleChangeView; // 切换标题的 标识
     //切换标题时显示的浮层
    
    UIImageView * qiandaoBj;//签到背景
    UILabel * qiandaoLB;
    NSInteger g_Page; // 页面
    NSString  *g_OrderType; // 排序类型 默认为全部
    PostMenuDetailController * PMD;
    BbsModel       *bbsInfo;
    NSMutableArray *dingArr;
    NSMutableArray *listArr;
    int a;
    PostDetailHeadCell * Cell;
    PostMenuDetailCell *g_PostCell;
    NSInteger number;//标签的个数
    NSMutableArray * BiaoQianArr;
    UIView *goldMaskView; // 浮层视图
    BOOL _isfisrt;
    CGFloat height;
    MyPageControl * myPageControl;
    BOOL yes;//是否创建标签
    UIImageView * footerViewimage;
    NSIndexSet * set1;
    NSString * verSion;
    UIBarButtonItem * item;
    BOOL AlertView;
    CGFloat CellHeight;
    UIImageView * qianDaoView;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
    //请求图片的任务队列
    NSOperationQueue * _taskQueue;
    BOOL xianshiJuhua;
    JuHuaView * flower;
    BOOL click;//按钮在没有数据前不能点击
}
@property (nonatomic,strong)MyTextImageButton *myMenuButton;
@end

@implementation PostMenuDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//************************
 
    _taskQueue = [[NSOperationQueue alloc] init];
 //设置最大并发个数
    [_taskQueue setMaxConcurrentOperationCount:4];
// *****************************
    qianDaoView  = [[UIImageView alloc] initWithFrame:self.view.bounds];
    qianDaoView.alpha = 0;
    qianDaoView.backgroundColor = QDBJ;
    verSion = VERSION;
    _isfisrt = YES;
    yes = YES;
    click = NO;
    xianshiJuhua = YES;
    BiaoQianArr = [[NSMutableArray alloc ] init];
    height = 7;
    set1 = [[NSIndexSet alloc] initWithIndex:3];
    // 获取评论详情cell的宽高
    //添加背景色
    self.postMenuDetailTable.backgroundColor = BJCLOLR;
    [self.navigationController.navigationBar setTranslucent:NO];
    //消除导航栏边界线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

    self.navigationController.navigationBar.barTintColor = beijing;
    
    NAV_INIT(self, nil, @"common_nav_back_icon", @selector(back), nil, nil);
    if (![g_version isEqualToString:VERSION]) {
         [self createRightButton];
    }
   
    [self createSletment];
    self.postMenuDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    flower = [[JuHuaView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    flower.center = CGPointMake(self.view.center.x, self.view.center.y+20);
    [self.navigationController.view addSubview:flower];
    dingArr = [[NSMutableArray alloc] init];
    listArr = [[NSMutableArray alloc] init];
    g_OrderType = SortType_All;
    g_Page = 1;
//    [self initTableDataWithPage:g_Page];
    footerViewimage.hidden = YES;
    //创建刷新
    [self addRefreshView];
    [self refreshComments];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
//    [self refreshComments];
    headerView = [self.postMenuDetailTable addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshComments];
        
    }];
    
    //上拉加载更多
    footerView = [self.postMenuDetailTable addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
//        [weakSelf loadMoreComments];
    }];
    footerView.hidden = YES;
    footerView.autoLoadMore = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!_bShowTabBar)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottom" object:nil];
    }
//    if (g_Page == 1) {
//        [self initTableDataWithPage:g_Page];
//    }
    if ([bbsInfo.is_join isEqualToString:@"1"]) {
        NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:0];
        [self.postMenuDetailTable reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    }

//    [self initTableDataWithPage:g_Page];
    
    [super viewWillAppear:animated];
    [PMD viewWillAppear:animated];
    flower.hidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [PMD viewWillDisappear:animated];
//    [flower stopView];
    flower.hidden = YES;

}
- (void)createRightButton
{
    item = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"发帖-1"] style:UIBarButtonItemStyleDone target:self action:@selector(doReleasePost)];
    item.enabled = NO;
    [item setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = item;
    
}
- (void)reloadItem
{
    if (click == NO) {
        item.enabled = NO;
    }else{
        item.enabled = YES;
    }

}
- (void)createSletment
{
    UIFont * font = [UIFont systemFontOfSize:16];
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"全部",@"新鲜",@"精华",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0.0, 0.0, 170, 30.0);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  font,UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [segmentedControl addTarget:self  action:@selector(indexDidChangeForSegmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];

   
}

//选择菜单
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *) segmentedControl
{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {
          
            g_OrderType = SortType_All;
        }
            break;
        case 1:
        {
           
            g_OrderType = SortType_New;
        }
            break;
        case 2:
        {
    
            g_OrderType = SortType_Jing;
        }
            break;
        default:
            break;
    }
    g_Page = 1;
    self.tag_id = @"";
    [self initTableDataWithPage:g_Page];

}

-(void)initTableDataWithPage:(NSInteger)page
{
    __weak FCXRefreshHeaderView *weakHeaderView = headerView;
    __weak FCXRefreshFooterView *weakFooterView = footerView;
//    if (xianshiJuhua == YES) {
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    }else{
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
//    }
    
    if (xianshiJuhua == YES) {
        [flower startView];
        xianshiJuhua = NO;
    }else{
        NSLog(@"不是第一次");
    }
    
    [[TTIHttpClient shareInstance] circleInfoRequestWithFid:_fid
                                              withOrderType:g_OrderType
                                                   withPage:[NSString stringWithFormat:@"%ld",(long)page]
                                                 withTag_id:self.tag_id
                                                withVersion:verSion
                                            withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        [flower stopView];
        click = YES;
        [self reloadItem];
        NSMutableArray *returnArr = [response.responseModel objectForKey:@"list"];
        if (![[response.result objectForKey:@"tag_list"] isKindOfClass:[NSNull class]]) {
            BiaoQianArr = [response.result objectForKey:@"tag_list"];

        }
            if(page == 1)
            {
                bbsInfo = [response.responseModel objectForKey:@"info"];
                dingArr = [response.responseModel objectForKey:@"ding"];
                listArr = returnArr;
            }
            else
            {
                 [listArr addObjectsFromArray:returnArr];
            }
        if (!yes) {
            [_postMenuDetailTable reloadSections:set1 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [_postMenuDetailTable reloadData];
            
            footerView.hidden = NO;
        }
        [weakFooterView endRefresh];
        [weakHeaderView endRefresh];
        
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
    {
//        [flower startView];
        [weakFooterView endRefresh];
        [weakHeaderView endRefresh];
    }];
    
}



#pragma mark - Detail Delegate

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  发布帖子
 */
- (void)doReleasePost
{
    
    if(g_LoginStatus == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"登录后才可发布帖子"];
        [self showLoginView];
        return;
    }
      else if (![bbsInfo.is_join isEqualToString:@"1"])// 判断是否加入当前圈子
    {
        [self createAlertView];
    }
    else
    {
        PublishViewController *publishVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PublishViewController"];
        publishVC.isShenHe = g_userInfo.verify_config;
        publishVC.fid = bbsInfo.fid;
        publishVC.biaoQianArr = BiaoQianArr;
        [self.navigationController pushViewController:publishVC animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            if (AlertView == NO) {
                MyInfoViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
                myInfoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myInfoVC animated:YES];
            }else{
                [self joinBtnClick];
            }
           
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 1)
    {
        return height;

    }
    else if(section == 2){
//        return 5.0;
        if ( listArr.count == 0) {
            return 0;
        }else{
           return 5.0;
        }
        
    }else
        return 0.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        footerViewimage = [[UIImageView alloc ] init];
        //        footerViewimage.backgroundColor = BJCLOLR;
        footerViewimage.userInteractionEnabled = YES;
        if (height == 110) {
            [self createBiaoQian];
        }
        return footerViewimage;
    }else if(section == 2){
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = BJCLOLR;
        return imageView;
    }else {
        return nil;
    }
   
    
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    int current = scrollView.contentOffset.x/UIScreenWidth;
//    
//    //根据scrollView 的位置对page 的当前页赋值
//    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
//    page.currentPage = current;
//    NSLog(@"%f",UIScreenHeight);
//    NSLog(@"%f",scrollView.contentSize.height -scrollView.contentOffset.y );
//    __weak __typeof(self)weakSelf = self;
    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height)
    {
        [self loadMoreComments];
        //自动刷新

        
    }
//    [self loadImageOnScreen];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
//        [self loadImageOnScreen];
    }
}
//创建标签
- (void )createBiaoQian
{
    
   
    self.myScrollerView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0, 1, UIScreenWidth, height-9)];
    self.myScrollerView.delegate = self;
    //            [self createBiaoQian];
    myPageControl = [[MyPageControl alloc ] initWithFrame:CGRectMake(-UIScreenWidth/2,height-19, UIScreenWidth,4)];
    myPageControl.backgroundColor = [UIColor whiteColor];
    myPageControl.numberOfPages = (1+BiaoQianArr.count/9);
    myPageControl.currentPage = 0;
    myPageControl.tag = 201;
    [footerViewimage addSubview:self.myScrollerView];
    [footerViewimage addSubview:myPageControl];
    int btnW = (UIScreenWidth - 5*space)/4;
    UIButton * quanBU = [UIButton buttonWithType:UIButtonTypeCustom];
    quanBU.frame = CGRectMake(space, 10, btnW, 30);
    [quanBU setBackgroundImage:[UIImage imageNamed:@"标签分类1"] forState:UIControlStateNormal];
    [quanBU setBackgroundImage:[UIImage imageNamed:@"选中标签1"] forState:UIControlStateSelected];
    [quanBU setTitle:@"全 部" forState:UIControlStateNormal];
    [quanBU setTitleColor:RGBACOLOR(108, 97, 85, 1) forState:UIControlStateNormal];
    quanBU.titleLabel.font = [UIFont systemFontOfSize:13];
    quanBU.tag = 1000;
    [quanBU addTarget:self action:@selector(biaoQianAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollerView addSubview:quanBU];
    for (int i = 0; i < BiaoQianArr.count; i++) {
        NSDictionary * dict = BiaoQianArr[i];
        int j = i+1;
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space+(j/2)*(btnW+space), 10+40*(j%2), btnW, 30);
        btn.tag =[[dict objectForKey:@"tag_id"]integerValue];
        [btn setBackgroundImage:[UIImage imageNamed:@"标签分类1"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"选中标签1"] forState:UIControlStateSelected];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:[dict objectForKey:@"tag_name"] forState:UIControlStateNormal];
        [btn setTitleColor:RGBACOLOR(108, 97, 85, 1) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(biaoQianAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollerView addSubview:btn];
        
    }
    self.myScrollerView.contentSize = CGSizeMake(UIScreenWidth*(1+BiaoQianArr.count/9), 0);
    self.myScrollerView.pagingEnabled = YES;
    self.myScrollerView.backgroundColor = [UIColor whiteColor];
}
- (void)biaoQianAction:(UIButton *) btn
{
    
    if (btn.tag == 1000) {
        self.tag_id = @"";
    }else{
        self.tag_id = [NSString stringWithFormat:@"%ld",btn.tag];
    }
    for (int i = 0; i< BiaoQianArr.count; i++) {
        UIButton * button1 = (UIButton *)[self.myScrollerView viewWithTag:1000];
        button1.selected = NO;
        NSDictionary * dict = BiaoQianArr[i];
        UIButton * button = (UIButton *)[self.myScrollerView viewWithTag:[[dict objectForKey:@"tag_id"]integerValue]];
        button.selected = NO;
    }
    [self changeCell:YES];
    btn.selected = !btn.selected;
     [self refreshComments];
}
#pragma mark - UITableView Actions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0)
    {
//        return 1;
        if(bShowTagsView) // 展示标签选项
            return 2;
        else
            return 1;
    }else if (section == 1)
    {
        return 1;
    }
    else if (section==2)
    {
        return [dingArr count];
    }
    else // (section==2)
        return [listArr count];
}
//标签的大小
- (void)changeCell:(BOOL)YN
{
    if (_isfisrt == YES) {
        height =110;
    }else{
        height = 7;
    }
    yes = !yes;
    _isfisrt = !_isfisrt;
    NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:1];
    [self.postMenuDetailTable reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}
//每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 120;
    }else if (indexPath.section == 1)
    {
        return 0;
    }
    else if (indexPath.section == 2)
    {
        return 41;
    }else{
        int imageW = (UIScreenWidth - 40)/3;
        
        PostListModel * list = [listArr objectAtIndex:indexPath.row];
        NSArray * array = list.attachment;
       
        if (array.count == 0) {
            return 74;

        }else{
          return 70+imageW;
        }
        
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return;
    
    // 帖子详情
    MyTopicDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyTopicDetailViewController"];
    detailVC.tabBarController.hidesBottomBarWhenPushed = YES;
    detailVC.string = @"泡友圈";
//    detailVC.quanString = bbsInfo.name;
    detailVC.MyBlock = ^(NSString * string){
        self.str = string;
        bbsInfo.is_join = string;
    };
    detailVC.fid = self.fid;
    detailVC.isJoic = bbsInfo.is_join;
    
    if (indexPath.section == 1) {
        //标签
    }
    // 置顶帖子
    else if(indexPath.section == 2)
    {
         PostDingModel *ding = [dingArr objectAtIndex:indexPath.row];
        detailVC.tid = ding.tid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    // 帖子详情
    else if (indexPath.section == 3)
    {
        PostListModel *list = [listArr objectAtIndex:indexPath.row];
        detailVC.number = list.reply_num;
        detailVC.tid = list.tid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
     return nil;
    }
//    return nil;
    return indexPath;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if(indexPath.row == 0)
        {
            Cell = [tableView dequeueReusableCellWithIdentifier:@"headCell"];
            if (Cell==nil) {
                Cell  = [[[UINib nibWithNibName:@"PostDetailHeadCell" bundle:nil]
                          instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            
            [Cell.headImgView setImageWithURL:[NSURL URLWithString:bbsInfo.icon] placeholderImage:[UIImage imageNamed:Default_UserHead]];
            [Cell.nickNameLabel setText:bbsInfo.name];
            [Cell.descpLabel setText:bbsInfo.descp];
            Cell.descpLabel.textColor = RGBACOLOR(160, 154, 149, 1);
            
            if (click == NO) {
                Cell.isJoinBtn.enabled = NO;
                
            }else{
                Cell.delegate =self;
                Cell.isJoinBtn.enabled = YES;
            }
            if([bbsInfo.is_join isEqualToString:@"1"])
            {
                Cell.isJoinBtn.selected = YES;
            }
            else{
               Cell.isJoinBtn.selected = NO;
            }
            
            if([bbsInfo.is_signin isEqualToString:@"1"])
            {
                Cell.qianDaoBtn.enabled = NO;
                Cell.qiandaoLabel.text = @"已签到";
                Cell.imageQiandao.image = [UIImage imageNamed:@"已签到"];
            }
            else if([bbsInfo.is_signin isEqualToString:@"0"])
            {
                Cell.qianDaoBtn.enabled = YES;
                Cell.qiandaoLabel.text = @"签到";
                Cell.imageQiandao.image = [UIImage imageNamed:@"签到"];
            }
            
            return Cell;
        }
        else if (indexPath.row == 1 && bShowTagsView)
        {
            PostMenuDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostMenuDetailCellForTags"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            return cell;
        }
    }else if (indexPath.section == 1)
    {//没有用处
        PostMenuDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"biaoqiancell"];
        cell.backgroundColor = BJCLOLR;
        return cell;
    }
    else if (indexPath.section ==2) // 置顶帖子
    {

            PostDingModel *ding = [dingArr objectAtIndex:indexPath.row];
            PostMenuDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostMenuDetailCell"];
            cell.dingDescpLabel.text = ding.subject;
            cell.dingDescpLabel.textColor = [UIColor colorWithRed:108/255.0 green:97/255.0 blue:85/255.0 alpha:1];
            //字体加粗
//        cell.backgroundColor = BJCLOLR;
            cell.dingDescpLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
             return cell;
       
    }
    else if(indexPath.section == 3)// 帖子详情
    {
        
        static NSString * strCell = @"tiezi";
        TieZiLieBiaoCell * cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if (cell == nil) {
            cell = [[TieZiLieBiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
            NSLog(@"第%ld个cell",indexPath.row);
        }
        PostListModel *info = [listArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (info) {
            [cell setPostInfo:info];
        }
        return cell;

    }
   
    
    return nil;
}
- (void)createAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您需要先加入圈子哟~"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:@"加入圈子", nil];
    AlertView = YES;
    [alertView show];
}
#pragma mark -  签到按钮点击事件
-(void)showSignPromptView
{
   
    if(bbsInfo.is_join.intValue == 0)
    {
        if (click == YES) {
            [self createAlertView];
        }
        return;
    }
    
    [[TTIHttpClient shareInstance] bbsSigninRequestWithFid:bbsInfo.fid
                                                  withCode:@"rule_signin"
                                           withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        qianDaoView.hidden = NO;
        NSString * str = response.error_desc;
        NSRange range = [str rangeOfString:@"LV"];
        if (range.length == 2) {
            //可以升级
            NSArray * arrar = [str componentsSeparatedByString:@"LV"];
            NSString * shengJiStr = [NSString stringWithFormat:@"恭喜您，升为LV%@",arrar[0]];
            NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:shengJiStr];
            NSRange range1 = [shengJiStr rangeOfString:[NSString stringWithFormat:@"LV%@",arrar[0]]];
            NSRange redRange = NSMakeRange(range1.location, range1.length);
            [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
            UILabel * lable = [[UILabel alloc] init];
            [lable setAttributedText:string1];
            UIImageView *shengjiView = [QFControl createUIImageFrame:CGRectMake(30, (UIScreenHeight-UIScreenWidth+100)/2, UIScreenWidth-60, UIScreenHeight/3) imageName:@"升级" withStr1:string1 withStr: @"您可到个人中心“我的等级”页面查看详情" withStr3:@"么么哒~"];
            [UIView animateWithDuration:1.5 animations:^{
                qianDaoView.alpha = 1;
            }];
            [qianDaoView addSubview:shengjiView];
        }else if (![response.error_desc isEqualToString:@"分"]) {
            qiandaoBj = [QFControl createUIImageViewWithFrame:CGRectMake(20, (UIScreenHeight-UIScreenWidth-40)/2, UIScreenWidth-40, UIScreenWidth-40) imageName:@"圈贡献" withlableText:[NSString stringWithFormat:@"恭喜~月贡献加%@分",[response.result objectForKey:@"point"]] withlableFrame:CGRectMake(50, (UIScreenWidth-40)/4*3-30, UIScreenWidth-40-100, 30)];
            
            [qianDaoView addSubview:qiandaoBj];
            [UIView animateWithDuration:1.5 animations:^{
                qianDaoView.alpha = 1;
            }];
            }
        [self.navigationController.view addSubview:qianDaoView];
        bbsInfo.is_signin = @"1";
        [_postMenuDetailTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (range.length == 2) {
            [self performSelector:@selector(hideMaskView) withObject:nil afterDelay:2.5];
        }else{
            [self performSelector:@selector(hideMaskView) withObject:nil afterDelay:1.5];
        }
        
        
                                                  } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
    {
//        [SVProgressHUD showErrorWithStatus:response.error_desc];
                                                  }];
  
}

-(void)hideMaskView
{
    [UIView animateWithDuration:1.5 animations:^{
        qianDaoView.alpha = 0;
    }];
}

#pragma mark -  PostDetailHeadCell Delegate

/**
 *  显示事件触发的页面
 *
 *  @param tag 0:泡友榜 1:签到 2:精华区 3:标签
 */
-(void)showActionViewWithTag:(int)tag
{
    switch (tag) {
        case 0:
        {
            if ([self.fid isEqualToString:@"32"]) {
                [SVProgressHUD showSuccessWithStatus:@"匿名区不开放此功能"];
            }else{
                if (g_LoginStatus == 0) {
                    [SVProgressHUD showErrorWithStatus:@"登录后才可查看达人榜"];
                    [self showLoginView];
                    return;
                }
            FriendsChartViewController *chartVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FriendsChartViewController"];
            chartVC.fid = self.fid;
            [self.navigationController pushViewController:chartVC animated:YES];
            }
        }
            break;
        case 1:
        {
            if ([self.fid isEqualToString:@"32"]) {
                [SVProgressHUD showSuccessWithStatus:@"匿名区不开放此功能"];
            }else{
            [self showSignPromptView];
            }
        }
            break;
        case 2:
        {
            g_OrderType = SortType_Jing;
            g_Page = 1;
            [self initTableDataWithPage:g_Page];
        }
            break;
        case 3:
        {
            if ([self.fid isEqualToString:@"32"]) {
                [SVProgressHUD showSuccessWithStatus:@"匿名区不开放此功能"];
            }else{
                
                [self getGold];
            
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)getGold
{
   
    if(bbsInfo.is_join.intValue == 0)
    {
        [self createAlertView];
        return;
    }
    
    [[TTIHttpClient shareInstance] get_integralRequestWithsid:nil
                                                withtask_type:nil
                                                          fid:bbsInfo.fid
                                              withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        
        g_userInfo.pay_points = [response.result objectForKey:@"pay_points"];
        NSString  *goldNum = [response.result objectForKey:@"gold_num"];
        qianDaoView.hidden = NO;
        NSString * str = [response.result objectForKey:@"rank_up"];
        if ([str isEqualToString:@"皇冠会员"]) {
            NSString * string = @"恭喜您，升级为皇冠会员 !";
            NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:string];
            NSRange range1 = [string rangeOfString:str];
            NSRange redRange = NSMakeRange(range1.location, range1.length);
            [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
            UILabel * lable = [[UILabel alloc] init];
            [lable setAttributedText:string1];
           UIImageView * shengjiView = [QFControl createUIImageFrame:CGRectMake(30, (UIScreenHeight-UIScreenWidth+100)/2, UIScreenWidth-60, UIScreenHeight/3) imageName:@"升级" withStr1:string1 withStr: @"您可到个人中心“我的等级”页面查看详情" withStr3:@"么么哒~"];
            [UIView animateWithDuration:1.5 animations:^{
                qianDaoView.alpha = 1;
            }];
            [qianDaoView addSubview:shengjiView];
        }else{
           
            
            qiandaoBj = [QFControl createUIImageViewWithFrame:CGRectMake(20, (UIScreenHeight-UIScreenWidth-40)/2, UIScreenWidth-40, UIScreenWidth-40) imageName:@"领取金币" withlableText:[NSString stringWithFormat:@"恭喜~获得%@个金币",goldNum] withlableFrame:CGRectMake(50, (UIScreenWidth-40)/4*3-40, UIScreenWidth-40-100, 30)];
            [UIView animateWithDuration:1.5 animations:^{
                qianDaoView.alpha = 1;
            }];
            [qianDaoView addSubview:qiandaoBj];
        }

        
        [self.navigationController.view addSubview:qianDaoView];
        if ([str isEqualToString:@"皇冠会员"]) {
            [self performSelector:@selector(hideMaskView) withObject:nil afterDelay:2.5];
        }else{
            [self performSelector:@selector(hideMaskView) withObject:nil afterDelay:1.5];
        }
    }withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         [SVProgressHUD showErrorWithStatus:response.error_desc];
     }];
}
-(void)showLoginView
{
    //判断用户是否登录
    LoginNavViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
    
    [self presentViewController:loginViewController animated:YES completion:nil];
    
    return;
}

/// 关注/取消关注
-(void)joinBtnClick
{
    if(g_LoginStatus == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"登录后才可加入圈子"];
        [self showLoginView];
        return;
    }
    
    if([bbsInfo.is_join isEqualToString:@"1"])
    {
        [[TTIHttpClient shareInstance] cancleCircleRequestWithFid:_fid
                                                     withSucessBlock:^(TTIRequest *request, TTIResponse *response)
         {
             bbsInfo.is_join = @"0";
             [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功退出%@", bbsInfo.name]];
             
             [_postMenuDetailTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
             
         } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
         {
//             [SVProgressHUD showErrorWithStatus:response.error_desc];
         }];
    }
    else
    {
        [[TTIHttpClient shareInstance] addCircleRequestWithFid:_fid
                                                  withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                      
             bbsInfo.is_join = @"1";
             [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功加入%@", bbsInfo.name]];
             
             [_postMenuDetailTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                      
         } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
         {
//             [SVProgressHUD showErrorWithStatus:response.error_desc];
         }];
    }
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
