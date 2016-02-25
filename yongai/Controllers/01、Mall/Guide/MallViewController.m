//
//  MallViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MallViewController.h"
#import "MyOrderListViewController.h"
//#import "FlashSaleViewController.h"
#import "MallClassficationDetailViewController.h"
#import "MCProductDetailViewController.h"
#import "TTIHttpClient.h"
#import "SVProgressHUD.h"
#import "SearchProductsViewController.h"
#import "DataModel.h"
#import "FlashSaleCell.h"
#import "LoginNavViewController.h"
#import "JCTopic.h"
#import "CommonHelper.h"
#import "MiaoShaViewController.h"
#import "PostMenuDetailController.h"
#import "MallClassificationViewController.h"
#import "MallNavViewController.h"
#import "MyTopicDetailViewController.h"
#import "TuiSongController.h"
#import "QFControl.h"
@interface MallViewController ()<HotCircleCellDelegate, JCTopicDelegate,FlashSaleDelegate,UISearchBarDelegate>
{
    
    //首页广告
    NSArray *adsArray;
    //分类
    NSArray *fenleiArray;
    //抢购
    NSArray *qianggouArray;
    
    //热卖
    NSArray *remai1Array;
    
    NSArray *remai2Array;
    
    NSArray *remai3Array;
    
    NSArray *remai4Array;
    NSArray * jinXuanArray;
    //圈子
    NSArray *quanziArray;
    ProductCell * neiYiCell;
    ProductCell * taoTaoCell;
    ProductCell * menCell;
    ProductCell * felmanCell;
    ProductCell * jingXuanCell;
    //是否存在限时抢购
    BOOL hasFlashSale;
     BOOL neiyi;
    
    //导航栏搜索框
    UITextField *searchTextFiled;
    UISearchBar * searchBar;
    MallViewController * MVC;
    LoginModel *userModel;
    
    BOOL bShowSearchView; //是否显示搜索背景
    UIButton   *closeSearchBtn; // 关闭搜索背景的按钮
    BOOL _isfirst;
    UIImageView * imageDing;//顶部红色
    NSString * endTime;
    UIImageView * newImageView;
    MallNavViewController * mallNv;
    FCXRefreshHeaderView *header;
    UIImageView * grayView;
    JuHuaView * flower;
}

// 轮播图
@property (nonatomic, strong) JCTopic *topic;
@property (strong, nonatomic) UIPageControl *imagePageControl;// 系统义标签栏控制器
@property (strong, nonatomic) NSMutableArray *cycleScrollDataSource;  // 轮播图图片数组

@end

#define TABLE_PRODUCTS_TAG 1

@implementation MallViewController{
    
    //导航上得搜索View
    UIView *navSearchView;
    LoadingView * loadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    flower = [[JuHuaView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    flower.center = CGPointMake(self.view.center.x, self.view.center.y+20);
    [self.navigationController.view addSubview:flower];
    _isfirst = YES;
     self.navigationController.navigationBar.barTintColor = beijing;
    grayView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    grayView.userInteractionEnabled = YES;
    grayView.backgroundColor = [UIColor grayColor];
    grayView.alpha = 0.5;
    grayView.hidden = YES;
    loadView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    
    [loadView addSubview:[QFControl createButtonWithFrame:loadView.frame title:nil target:self action:@selector(actionTouch) tag:0]];
    loadView.hidden = YES;
    [self.navigationController.view addSubview:loadView];
    if ([g_version isEqualToString:VERSION]) {
         [self showClassification:@"4" title:@"限时特卖"];
    }else{
       
        qianggouArray = [[NSMutableArray alloc] init];
        NAV_INIT(self, @"情趣商城",nil,nil, nil, nil);
        _Vstr = VERSION;
        newImageView.userInteractionEnabled = YES;
        _cycleScrollDataSource = [[NSMutableArray alloc] init];
        self.view.backgroundColor = BJCLOLR;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,20, UIScreenWidth, UIScreenHeight)];
        _tableView.backgroundColor = BJCLOLR;
        [self.view addSubview:_tableView];
        [self initlization];
        [self loadHomeIndexData];
        [self loadTableView];
        [self initNavView];
        [self createZhiView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGoodsDetailView:) name:Notify_showGoodsDetailView object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPostDetailView:) name:Notify_showPostDetailView object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTuiSongView:) name:Notify_showTuiSongView object:nil];
        self.tableView.backgroundColor = BJCLOLR;
        [self.view insertSubview:grayView aboveSubview:self.tableView];
        [self addtTableFooterView];
    }
//    [self addRefreshView];
}
#pragma --mark 重新加载
- (void)actionTouch
{
    loadView.hidden = YES;
    [self loadHomeIndexData];
}
- (void)addRefreshView {
    
//
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    header = [self.tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadHomeIndexData];
    }];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    grayView.hidden = YES;
    [searchBar resignFirstResponder];
}
#pragma mark -- searchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    grayView.hidden = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    SearchProductsViewController *searchProductsViewController = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchProductsViewController"];
    searchProductsViewController.titleStr = searchBar.text;
    searchProductsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchProductsViewController animated:YES];
}
-(void)showPostDetailView:(NSNotification *)notify
{
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    NSDictionary *dic = notify.object;
    [self performSelector:@selector(showPostDetailViewContoller:) withObject:dic afterDelay:0.2];
    
}
#pragma mark -- 推送进入推送页面新加
- (void)showTuiSongView:(NSNotification*)notify
{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    TuiSongController * tuiSong = [[TuiSongController alloc] init];
    NSDictionary * dic = notify.object;
    tuiSong.type = [dic objectForKey:@"goods_id"];
//    NSLog(@"%@",dic);
    [self.navigationController pushViewController:tuiSong animated:YES];
}
#pragma mark -- 推送进入帖子详情
-(void)showPostDetailViewContoller:(NSDictionary *)dic
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    MyTopicDetailViewController *PostMenuDetailVC = [board instantiateViewControllerWithIdentifier:@"MyTopicDetailViewController"];
    PostMenuDetailVC.tid = [dic objectForKey:@"goods_id"];
    PostMenuDetailVC.bShowTabBar = YES;
    
    if([self.tabBarController.selectedViewController isKindOfClass:[UINavigationController class]])
        [(UINavigationController *)self.tabBarController.selectedViewController pushViewController:PostMenuDetailVC animated:YES];
    
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
    //显示圈子详情
    //    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showPostDetailViewContoller object:fid];
}
//没问题
- (void)createZhiView
{
    imageDing = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 20)];
    imageDing.userInteractionEnabled = YES;
    imageDing.backgroundColor = RGBACOLOR(255, 1, 2, 1);
    UIButton * chaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chaBtn setBackgroundImage:[UIImage imageNamed:@"叉1"] forState:UIControlStateNormal];
    chaBtn.frame = CGRectMake(UIScreenWidth-25, 2.5, 15, 15);
    [chaBtn addTarget:self action:@selector(chaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * laba = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth/5, 2.5, 15, 15)];
        laba.image = [UIImage imageNamed:@"喇叭"];
    [imageDing addSubview:laba];
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(laba.frame.origin.x+laba.frame.size.width, 2.5, UIScreenWidth, 15)];
    lable.text = @"2000城市货到付款、100%保密发送";
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:13];
    [imageDing addSubview:lable];
    [imageDing addSubview:chaBtn];
    [self.view addSubview:imageDing];
    [UIView animateWithDuration:10 animations:^{
        imageDing.alpha = 0;
    } completion:^(BOOL finished) {
        _tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    }];

    
}

- (void)chaBtnAction
{
    imageDing.hidden = YES;
    _tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
}
- (void)addtTableFooterView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    view.backgroundColor = BJCLOLR;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 推送进入商品详情
-(void)showGoodsDetailView:(NSNotification *)notify
{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    NSDictionary *dic = notify.object;
    //显示商品详情
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.gid = [dic objectForKey:@"goods_id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MVC viewWillAppear:animated];
    grayView.hidden = YES;
    flower.hidden = NO;
    if ([g_version isEqualToString:VERSION]) {
        return;
    }else{

        [self createZhiView];
        [self loadHomeIndexData];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MVC viewWillDisappear:animated];
    loadView.hidden = YES;
    flower.hidden = YES;
    if(bShowSearchView == YES)
    {
        [self closeSearchView:nil];
    }
}

- (void)initlization{
    
    adsArray = [[NSArray alloc] init];
    fenleiArray = [[NSArray alloc] init];
    remai1Array = [[NSArray alloc] init];
    remai2Array = [[NSArray alloc] init];
    remai3Array = [[NSArray alloc] init];
    remai4Array = [[NSArray alloc] init];
    quanziArray = [[NSArray alloc] init];
    jinXuanArray = [[NSArray alloc] init];
    //默认存在限时抢购
    neiYiCell = [[ProductCell alloc] init];
    neiYiCell.delegate = self;
    taoTaoCell = [[ProductCell alloc] init];
    taoTaoCell.delegate = self;
    menCell = [[ProductCell alloc] init];
    menCell.delegate = self;
    felmanCell = [[ProductCell alloc] init];
    felmanCell.delegate  = self;
    jingXuanCell = [[ProductCell alloc] init];
    jingXuanCell.delegate = self;
    hasFlashSale = YES;
    neiyi = YES;
    
    userModel = g_userInfo;
}
//没问题
- (void)initNavView{
    
    navSearchView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.25, 6,self.view.frame.size.width/2, 33)];
    navSearchView.backgroundColor = [UIColor whiteColor];
    UIImageView *navSearchIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 16)];
    navSearchIconView.image = [UIImage imageNamed:@"common_search_icon"];
    searchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(XPOS(navSearchIconView.frame) + 5, 3, navSearchView.frame.size.width - XPOS(navSearchIconView.frame), 30)];
    searchTextFiled.borderStyle = UITextBorderStyleNone;
    searchTextFiled.placeholder = @"请输入搜索内容";
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,5, navSearchView.frame.size.width, 25)];
    searchBar.placeholder = @"大家都在搜";
    searchBar.delegate  = self;
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = BLACKTEXT;
   //    UITextField * text = searchBar.subviews
    [navSearchView addSubview:searchBar];
    
    [self.searchButton setImage:[UIImage imageNamed:@"searchBtnTag"] forState:UIControlStateNormal];
    [self.searchButton setTitle:nil forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    closeSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 7, 30, 30)];
    [closeSearchBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
    [closeSearchBtn addTarget:self action:@selector(closeSearchView:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 初始化  JCTopic
/**
 *  添加轮播图
 */
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
    
    // 初始化imagePageControl
    if (_imagePageControl == nil)
    {
        // 使用系统自带的标签栏
        _imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _topic.frame.size.height - 25, UIScreenWidth, 20)];
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
    if([adsArray count] > _imagePageControl.currentPage)
        info = [adsArray objectAtIndex:self.imagePageControl.currentPage];
    
    if([info.id  isEqualToString:@"0"])
    {
        return;
    }
    else{
        //显示商品详情
        MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.gid = info.id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

-(void)currentPage:(int)page total:(NSUInteger)total
{
    self.imagePageControl.currentPage = page;
}

- (void)loadTableView{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - TableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        if (hasFlashSale == NO) {
            return 0;
        }else{
            return 50;
        }
    }else if(section == 0){
        return 0;
    }else if(section == 2){
        if (remai1Array.count == 0) {
            return 0;
        }else{
           return 50;
        }
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat With = UIScreenWidth-4*2;
    CGFloat H = (With * 215)/703;
    NSInteger section =indexPath.section;

    if(section == 0){
        return (self.view.frame.size.width*330)/720;
    }else if (section == 1){
        if (hasFlashSale == NO) {
            return 0;
        }else{
           return (UIScreenWidth - 30)/3+80;
        }
    }else if (section == 2){
        if (neiyi == NO) {
            return 0;
        }else{
            return self.view.frame.size.width*0.76;
        }
    }else if (section == 6){

            return H* jinXuanArray.count+130;
    }
    else {
         return self.view.frame.size.width*0.76;
    }
}
//没问题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView * headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
    headerView.userInteractionEnabled = YES;
    UIImageView * headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 25, 25)];
    [headerView addSubview:headImage];
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+5, 15, 200, 20)];
    titleLable.textColor = TEXT;
    [headerView addSubview:titleLable];
    headerView.backgroundColor = BJCLOLR;
    if (section == 1)
    {
        NSArray * array = @[@"新品",@"性知识",@"评测"];
    for (int i = 0; i< 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000+i;
        button.frame = CGRectMake(20+i * UIScreenWidth/3, 10, UIScreenWidth/3-20, 30);
        [headerView addSubview:button];
        UIImageView * image2 = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*(UIScreenWidth-20)/3,0,(UIScreenWidth-20)/3-10,50)];
        image2.backgroundColor = beijing;
//        [headerView addSubview:image2];
        UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        if (i==0) {
            image1.center = CGPointMake(UIScreenWidth/8-20, 25);
        }
        if (i==1) {
            image1.center = CGPointMake(UIScreenWidth/2-25, 25);
        }
        if (i==2) {
            image1.center = CGPointMake(UIScreenWidth/4*3+20, 25);
        }
        image1.image = [UIImage imageNamed:array[i]];
        [headerView addSubview:image1];
        UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(image1.frame.origin.x+image1.frame.size.width+5, image1.frame.origin.y+image1.frame.size.height/4-2,60, 20)];
        if (i==1) {
            lable1.text = @"解惑";
        }else{
         lable1.text = array[i];
        }
        lable1.textColor = BLACKTEXT;
        lable1.font = [UIFont systemFontOfSize:17.5];
        [headerView addSubview:lable1];
        }
    }
    else if(section == 2){
        headImage.image = [UIImage imageNamed:@"mall_neiyi_icon"];
        titleLable.text  = @"内衣热卖";
    }else if(section == 3){
        headImage.image = [UIImage imageNamed:@"mall_taotao_icon"];
        titleLable.text  = @"套套热卖";
    }else if(section == 4){
            headImage.image = [UIImage imageNamed:@"mall_nanyong_icon"];
            titleLable.text = @"男用热卖";
    }else if(section == 5){
            headImage.image = [UIImage imageNamed:@"mall_nvyong_icon"];
            titleLable.text = @"女用热卖";
    }else if(section == 6){
        headImage.image = [UIImage imageNamed:@"精选1"];
        titleLable.text = @"精选";
    }

    return headerView;
}
- (void)buttonAction:(UIButton *) btn
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    PostMenuDetailController *PostMenuDetailVC = [board instantiateViewControllerWithIdentifier:@"PostMenuDetailController"];
    if (btn.tag == 1000) {
        MallClassficationDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MallClassficationDetailViewController"];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.categoryId = @"79";
        detailVC.myTitle = @"新品速递";
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (btn.tag == 1001){
        PostMenuDetailVC.fid = @"66";
         PostMenuDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:PostMenuDetailVC animated:YES];
    }else{
        PostMenuDetailVC.fid = @"67";
        PostMenuDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:PostMenuDetailVC animated:YES];

    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 0) {
        static NSString * lunbo = @"luobo";
        UITableViewCell * cell0 = [tableView dequeueReusableCellWithIdentifier:lunbo];
        if (cell0 == nil) {
            cell0 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lunbo];
        }
        [cell0.contentView addSubview:_topic];
        [cell0.contentView addSubview:_imagePageControl];
        return cell0;
    }else if(section == 1){
        static NSString *cellIdentifier = @"FlashSaleCell";
        FlashSaleCell * cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell1 == nil) {
            cell1 = [[FlashSaleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell1.delegate = self;
        if (qianggouArray.count != 0) {
            [cell1 initWithArray:qianggouArray];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
           
        }
        if (endTime) {
            [cell1 createEndTime:endTime];
        }
         return cell1;

    }else if(section == 2){
        //内衣热卖
       
        if (remai1Array.count != 0) {
            [neiYiCell initDataWithArray:remai1Array andSectionTitle:@"内衣热卖"];
        }
       
        return neiYiCell;
    }else if(section == 3){
        //套套热卖
        
        if (remai2Array.count !=0) {
            [taoTaoCell initDataWithArray:remai2Array andSectionTitle:@"套套热卖"];
        }
        return taoTaoCell;
    }else if(section == 4){
        //男用热卖
        if (remai3Array.count !=0) {
            [menCell initDataWithArray:remai3Array andSectionTitle:@"男用热卖"];
        }
        
        return menCell;
    }else if (section == 5){
        if (remai4Array.count !=0) {
            [felmanCell initDataWithArray:remai4Array andSectionTitle:@"女用热卖"];
        }
        return felmanCell;
        
    }else if (section == 6){
        if (jinXuanArray.count !=0) {
            [jingXuanCell initDataWithArray:jinXuanArray andSectionTitle:@"精选"];
        }
        return jingXuanCell;
        
    }
    else{
        static NSString * cell1 =@"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
        }
        cell.contentView.backgroundColor = BJCLOLR;
        return cell;
    }
   
}
- (void)imageClick:(NSString *)good_id
{
    MiaoShaViewController *fsVC = [[MiaoShaViewController alloc] init];
    [fsVC returnText:^(NSString *showText) {
        endTime = showText;
    }];
    fsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fsVC animated:YES];
}

#pragma mark ---------  HotCircleCellDelegate <NSObject>
/**
 *  点击最热圈子的事件跳转
 *
 *  @param index button下标 从0开始
 */

// 登录
-(void)showLoginView
{
    LoginNavViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
    [self presentViewController:loginVC animated:YES completion:nil];
}
#pragma mark - Detail Action
- (void)searchAction:(id)sender{
//    TuiSongController * tuiSong = [[TuiSongController alloc] init];
//    [self.navigationController pushViewController:tuiSong animated:YES];
    if(bShowSearchView == NO)
    {
        bShowSearchView = YES;
        searchBar.text = @"";
        [self.searchButton setImage:nil forState:UIControlStateNormal];
        [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [self.navigationController.navigationBar addSubview:navSearchView];
        [self.navigationController.navigationBar addSubview:closeSearchBtn];
    }
    else
    {
        NSString *content = searchBar.text;
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        //关键字搜索商品
        if(ICIsObjectEmpty(content)){
            
            [SVProgressHUD showErrorWithStatus:@"请输入搜索内容"];
            return;
        }
        
        SearchProductsViewController *searchProductsViewController = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchProductsViewController"];
        searchProductsViewController.titleStr = searchBar.text;
        searchProductsViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchProductsViewController animated:YES];
    }

}


-(void)closeSearchView:(id)sender
{
    bShowSearchView = NO;
    [navSearchView removeFromSuperview];
    [closeSearchBtn removeFromSuperview];
    
    searchTextFiled.text = nil;
    [self.searchButton setImage:[UIImage imageNamed:@"searchBtnTag"] forState:UIControlStateNormal];
    [self.searchButton setTitle:nil forState:UIControlStateNormal];
}

- (void)loadHomeIndexData{
    
    //加载首页数据

    [flower startView];
    [[TTIHttpClient shareInstance] mallshopHomeRequestWithType:@"1" withVersion:_Vstr withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
//        [SVProgressHUD dismiss];
        [flower stopView];
        if (response.result) {
            NSDictionary *dic = response.result;
            adsArray = (NSArray *)dic[@"lunbo"];
            fenleiArray = (NSArray *)dic[@"fenlei"];
            qianggouArray = (NSArray *)dic[@"count_down"];
            remai1Array = (NSArray *)dic[@"remai1"];
            remai2Array = (NSArray *)dic[@"remai2"];
            remai3Array = (NSArray *)dic[@"remai3"];
            remai4Array = (NSArray *)dic[@"remai4"];
            jinXuanArray = (NSArray*)dic[@"ad"];
            quanziArray = (NSArray *)dic[@"quan"];
            
        }else{
            return ;
        }
        
        NSMutableArray *scrollImgArr = [NSMutableArray array];
        [_cycleScrollDataSource removeAllObjects];
        
        [adsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            if([obj isKindOfClass: [NSDictionary class]])
            {
                ScrollImgModel *scroll = [[ScrollImgModel alloc] initWithDictionary:obj error:nil];
                [scrollImgArr addObject:scroll];
                [_cycleScrollDataSource addObject:scroll.logo];
            }
        }];
        
        [self initCycleScrollView];
        
        adsArray = scrollImgArr;
        
        if(qianggouArray.count == 0){
            if (_isfirst == YES) {
                 [self showClassification:@"4" title:@"限时特卖"];
            }
            hasFlashSale = NO;
            _isfirst = NO;
        }
        if (remai1Array.count == 0) {
            neiyi = NO;

        }
        [self.tableView reloadData];
        [header endRefresh];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
//        loadView.hidden = NO;
//        [flower stopView];
    }];
}
#pragma mark - ProductCell Delegate

- (void)showProductView:(UIButton *)btn{
    
    //显示商品详情
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.gid = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    if([btn.titleLabel.text isEqualToString:@"0"]){
        [self.navigationController pushViewController:detailVC animated:YES];
           }else{
       MallClassficationDetailViewController *mcdVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MallClassficationDetailViewController"];
               mcdVC.hidesBottomBarWhenPushed = YES;
               mcdVC.categoryId = btn.titleLabel.text;
//               mcdVC.categoryId = [NSString stringWithFormat:@"%ld",(long)btn.tag-100];
               mcdVC.title = nil;
               [self.navigationController pushViewController:mcdVC animated:YES];

    }
    
    
    
}

#pragma mark - MallProductClassificationCell

- (void)showClassification:(NSString *)cid title:(NSString *)title
{
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
//    NSString * categoryid = [NSString stringWithFormat:@"%d",title.intValue - 100];
    detailVC.gid = title;
    if ([cid isEqualToString:@"4"]) {
        MallClassficationDetailViewController *mcdVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MallClassficationDetailViewController"];
        //    mcdVC.hidesBottomBarWhenPushed = YES;
        mcdVC.myTitle  = title;
        mcdVC.categoryId = cid;
        mcdVC.titleLable = @"商城";
        mcdVC.title = nil;
        [self.navigationController pushViewController:mcdVC animated:NO];
        return;
    }
    if([cid isEqualToString:@"0"]){
        MallClassficationDetailViewController *mcdVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MallClassficationDetailViewController"];
        mcdVC.hidesBottomBarWhenPushed = YES;
        mcdVC.categoryId = title;
        mcdVC.title = nil;
        [self.navigationController pushViewController:mcdVC animated:YES];
        
        
    }else{
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    

}

@end
