//
//  ExchangeCenterViewController.m
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ExchangeCenterViewController.h"
#import "ExchangeGoodsCell.h"
#import "ExGoodsInfoViewController.h"

#import "JCTopic.h"
@interface ExchangeCenterViewController ()<ExchangeGoodsCellDelegate,JCTopicDelegate>
{
    
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *tableHeadView;
    IBOutlet UIView *scrollBgView; //轮播图背景视图
    
    IBOutlet UILabel *goldCountLabel;
    NSInteger  gPage;
    
    NSMutableArray   *goodsList;
    NSMutableArray   *scrollArr;
    NSString         *goldCountStr;
    UIImageView *newsImageView;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
    UIImageView * juhauView;
    UIActivityIndicatorView *flower;//菊花视图
    UILabel * jiaZai;
}
// 轮播图
@property (nonatomic, strong) JCTopic *topic;
@property (strong, nonatomic) UIPageControl *imagePageControl;// 系统义标签栏控制器
@property (strong, nonatomic) NSMutableArray *cycleScrollDataSource;  // 轮播图图片数组

//
@end

@implementation ExchangeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myGold.textColor = BLACKTEXT;
    jiaZai = [[UILabel alloc] initWithFrame:CGRectMake((UIScreenWidth - 100)/2, 20, 200, 20)];
    jiaZai.font = [UIFont systemFontOfSize:15];
    jiaZai.textColor = TEXT;
    jiaZai.text = @"正在用力加载，请骚等~";
    flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
              UIActivityIndicatorViewStyleGray];
    [flower startAnimating];
    juhauView = [[UIImageView alloc] initWithFrame:CGRectMake(0, UIScreenHeight - 120, UIScreenWidth, 60)];
    juhauView.backgroundColor = BJCLOLR;
    flower.frame = CGRectMake(jiaZai.frame.origin.x-50,10, 40,40);
    [juhauView addSubview:jiaZai];
    [juhauView addSubview:flower];
    [self.view insertSubview:juhauView aboveSubview:myTableView];
    NAV_INIT(self, @"兑换中心", @"common_nav_back_icon", @selector(backAction), nil, nil);
    myTableView.backgroundColor =BJCLOLR;
//    tableHeadView.backgroundColor = BJCLOLR;
    myTableView.tableFooterView = [[UIView alloc] init];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    goodsList = [NSMutableArray array];
    scrollArr = [NSMutableArray array];
    _cycleScrollDataSource = [[NSMutableArray alloc ] init];
    gPage = 1;
//    [self initScrollView];
    [self requestViewData:gPage];
    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [myTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshList];
    }];
    
    //上拉加载更多
    footerView = [myTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        //        [weakSelf loadMoreComments];
    }];
    
    //自动刷新
    footerView.autoLoadMore = YES;
    footerView.hidden = YES;
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height)
    {
        [self loadMoreList];
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    ExchangeCenterViewController * ExCVC;
    [super viewWillAppear:animated];
    [ExCVC viewWillAppear:animated];
    goldCountLabel.text = g_userInfo.pay_points;
}


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initScrollView
{
    //加载ads轮播图
    [scrollBgView addSubview:_topic];
    tableHeadView.frame = CGRectMake(0, 0, self.view.frame.size.width, scrollBgView.frame.size.height +65);
    tableHeadView.backgroundColor = BJCLOLR;
//    [tableHeadView addSubview:_topic];
    [tableHeadView addSubview:self.imagePageControl];
    myTableView.tableHeaderView = tableHeadView;
}

//添加轮播图
- (void)initCycleScrollView
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width*330)/720);
    // 初始化topic
    if(_topic == nil)
    {
        //320x135 iPhone5 375x158 iPhone6 414x175 iPhone6P
        _topic = [[JCTopic alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        _topic.JCdelegate = self;
    }
    else
    {
        [_topic releaseTimer];
    }
    
    _topic.pics = _cycleScrollDataSource;  //加入数据
    [_topic upDate];   //更新
    
    if (_imagePageControl == nil)
    {
        // 使用系统自带的标签栏
        _imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _topic.frame.size.height + 10, UIScreenWidth, 20)];
        _imagePageControl.pageIndicatorTintColor = [UIColor grayColor];
        _imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [_imagePageControl addTarget:self action:@selector(MyPageControlChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    // 轮播图小于2个时，隐藏标签栏控制器
    if(_topic.pics.count < 2)
    {
        self.imagePageControl.hidden = YES;
    }
    else
    {
        self.imagePageControl.hidden = NO;
    }
    
    self.imagePageControl.numberOfPages = [_cycleScrollDataSource count];
    self.imagePageControl.currentPage = 0;
}

/**
 *  设置当前被选中的轮播图的偏移量
 *
 *  @param sender 当前被选中的标签栏
 */

- (void)MyPageControlChange:(id)sender
{
    UIPageControl *pageControl = (UIPageControl *)sender;
    [_topic setContentOffset:CGPointMake(self.view.frame.size.width*pageControl.currentPage, 0) animated:NO];
}

#pragma mark - JCTopic  Delegate
/**
 *  点击轮播图后的响应事件
 *
 *  @param data 点击的图片信息？
 */
-(void)didClick:(id)data
{
    ScrollImgModel *info;
    if([scrollArr count] > _imagePageControl.currentPage)
        info = [scrollArr objectAtIndex:self.imagePageControl.currentPage];
    
    if([info.gid  isEqualToString:@"0"])
    {
        return;
    }
    else{
        ExGoodsInfoViewController *goodsInfoVC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExGoodsInfoViewController"];
        goodsInfoVC.goodsId = info.gid;
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
        //显示商品详情
    }
    
}

-(void)currentPage:(int)page total:(NSUInteger)total
{
    self.imagePageControl.currentPage = page;
}



-(void)requestViewData:(NSInteger)page
{   footerView.hidden = NO;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] listExchangeRequestWithsid:nil
                                                     withpage:[NSString stringWithFormat:@"%ld", (long)page]
                                              withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        NSArray *list = [response.result objectForKey:@"goods"];
        NSString *gold = [response.result objectForKey:@"gold"];
        juhauView.hidden = YES;
        if(page == 1)
        {
            NSArray  *scrollList = [response.result objectForKey:@"scrollImg"];

            [scrollArr removeAllObjects];
            [goodsList removeAllObjects];
            if ([scrollList count] > 0) {
                for(NSDictionary *dic in scrollList)
                {
                    ScrollImgModel *img = [[ScrollImgModel alloc] initWithDictionary:dic error:nil];
                    [scrollArr addObject:img];
                    [_cycleScrollDataSource addObject:img.logo];
                }
                [self initCycleScrollView];
                [self initScrollView];
            }
        }
        
        for(NSDictionary *dic in list)
        {
            ExchangeListModel *goods = [[ExchangeListModel alloc] initWithDictionary:dic error:nil];
            if(goods)
                [goodsList addObject:goods];
        }
        
        if(list.count == 0)
            gPage--;
        
        goldCountStr = gold;
        goldCountLabel.text = goldCountStr;
       
        g_userInfo.pay_points = gold;
        
        [myTableView reloadData];
        [headerView endRefresh];
        [footerView endRefresh];
                                              } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
    {
        
                                              }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = (self.view.frame.size.width-24)/2+60;
    return  height;
}

#pragma mark ---  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     NSInteger  rows =([goodsList count] / 2 + [goodsList count] % 2);
    return rows;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GoldHomeCellIdentifier = @"ExchangeGoodsCell";
    ExchangeGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GoldHomeCellIdentifier];
    if(cell == nil)
        cell = [[[UINib nibWithNibName:@"ExchangeGoodsCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BJCLOLR;
    cell.delegate = self;
    
    ExchangeListModel  *info2;
    if([goodsList count] < (indexPath.row+1)*2)
    {
        info2 = nil;
    }
    else
        info2 = [goodsList objectAtIndex:indexPath.row * 2 +1];

    
    ExchangeListModel *info1 = [goodsList objectAtIndex:indexPath.row*2];
    [cell setgoodsInfo:info1 goods2:info2];
    
    cell.goodsBtn0.tag = indexPath.row*2;
    cell.goodsBtn1.tag = indexPath.row*2 + 1;
    
    return cell;
}

#pragma mark - ExchangeGoodsCell  Delegate

/**
 *  点击某个商品的事件响应
 *
 *  @param btnTag 商品对应的事件id
 */
-(void)didClickGoodsCell:(NSInteger)btnTag
{
    NSLog(@"didClickGoodsCell: %ld", (long)btnTag);
    if([goodsList count] > btnTag)
    {
        ExchangeListModel *goods = [goodsList objectAtIndex:btnTag];
        ExGoodsInfoViewController *goodsInfoVC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExGoodsInfoViewController"];
        goodsInfoVC.goodsId = goods.goods_id;
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}

#pragma mark --  PullTableViewDelegate <NSObject>

/* After one of the delegate methods is invoked a loading animation is started, to end it use the respective status update property */
- (void)refreshList{
    
    gPage = 1;
    [self requestViewData:gPage];
   
}

- (void)loadMoreList{
    
    gPage ++;
    [self requestViewData:gPage];
  
}

@end
