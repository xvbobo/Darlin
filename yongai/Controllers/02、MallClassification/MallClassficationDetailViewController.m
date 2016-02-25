//
//  MallClassficationDetailViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-11-7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MallClassficationDetailViewController.h"
#import "MallClassificationSearchView.h"
#import "CommonUtils.h"
#import "ScreeningView.h"
#import "MCProduceHViewCell.h"
#import "MCProductVViewCell.h"
#import "MCProductDetailViewController.h"
#import "ShoppingCartController.h"
#import "DataModel.h"

#define PRODUCTS_VIEW_TABLE 1   // tableview 列表类型
#define PRODUCTS_VIEW_GRID 2   // collection 页面类型

//“common”：综合 “sales”：销量 “price”：售价 “date”：上架时间
#define ORDER_COMMON @"common"
#define ORDER_SALES @"sales"
#define ORDER_PRICE @"price"
#define ORDER_DATE @"date"

@interface MallClassficationDetailViewController ()<UITableViewDataSource, UITableViewDelegate, MCProductVCellDelegate>{
    
    IBOutlet UITableView *productsTableView;
    MallClassficationDetailViewController * MCD;
    NSMutableArray *productsArray;
    NSInteger productIndex;
    
    //选择显示样式
    NSInteger selectionType;
    
    NSString *selectOrderCondition;
    
    UIButton *changeViewBtn; // 筛选按钮
    NSMutableArray *screeningArray; //筛选下拉菜单view
    NSMutableArray *screeningButtonArray;  // 筛选按钮数组
    
    IBOutlet UIView *shopCartBtnBgView;
    IBOutlet UIButton *shopcartButton; //购物车按钮
    IBOutlet UILabel *countLabel; // 购物车显示的数量
    IBOutlet NSLayoutConstraint *shopcartBtnBottom; // 购物车按钮距离下方的约束间隔

    NSString *selectedCategoryId;
    
    LoginModel *userModel;
    
    BOOL bShowTabbar; // 是否显示tabbar
    IBOutlet NSLayoutConstraint *bottomConstraint; // 表格试图距离下方的约束间隔
    
    BOOL priceASCSort; //价格排序方式， 默认为升序
    FCXRefreshHeaderView * headerView;
    FCXRefreshFooterView * footerView;
    NSInteger lastNum;
    BOOL isFirst;
}

@end

@implementation MallClassficationDetailViewController{
    
    //顶部条件搜索框
    MallClassificationSearchView *searchView;
    UIImageView *screeningView;
    UIImageView * shaixuanView;
    BOOL shai;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initlization];
    [self loadBaseUI];
    shai = YES;
    isFirst = YES;
    productsTableView.backgroundColor = BJCLOLR;
    searchView.backView.backgroundColor = BJCLOLR;
    searchView.saleBottomImageView.backgroundColor = beijing;
    searchView.priceBottomImageView.backgroundColor = beijing;
    searchView.comBottomImageView.backgroundColor = beijing;
    screeningView = [[UIImageView alloc] init];
    [screeningView setBackgroundColor:BJCLOLR];
    [self.view addSubview:screeningView];
    
    [self.view bringSubviewToFront:shopCartBtnBgView];
    [shopcartButton addTarget:self  action:@selector(showShopCartViewController) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, searchView.backView.frame.size.height, UIScreenWidth, 1)];
    imageLine.image = [UIImage imageNamed:@"common_line"];
    [searchView.backView addSubview:imageLine];
    [self refreshProducts];
    [self addRefreshView];
}
- (void)addRefreshView {
    
    //下拉刷新
    __weak __typeof(self)weakSelf = self;
    headerView = [productsTableView  addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshProducts];
    }];
    
    //上拉加载更多
    footerView = [productsTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
    }];
    
    //自动刷新
    footerView.autoLoadMore = YES;
    footerView.hidden = YES;
}
#pragma mark -- 监听滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height)
    {
        [self loadMoreProducts];
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MCD viewWillAppear:animated];
    if (self.titleLable) {
        
        shopcartButton.hidden = YES;
        shopCartBtnBgView.hidden = YES;
    }else{
        shopcartButton.hidden = NO;
        shopCartBtnBgView.hidden = NO;
    }
}
- (void)loadBaseUI{
    
    [self loadNav];
    
    [self loadSearchBan];
    
    [self loadProductsView];
}

- (void)initlization{
    
    //默认显示Grid样式
    selectionType = PRODUCTS_VIEW_GRID;
    //默认综合
    selectOrderCondition = ORDER_COMMON;
    productsArray = [[NSMutableArray alloc] init];
    screeningArray = [[NSMutableArray alloc] init];
    screeningButtonArray = [[NSMutableArray alloc] init];
    
    selectedCategoryId = self.categoryId;
    
    userModel = g_userInfo;
}

- (void)loadNav {
    if (self.titleLable) {
         NAV_INIT(self,@"特卖" ,nil, nil, nil, nil);
        [self.navigationItem setHidesBackButton:YES];
    }else if(self.myTitle != nil)
    {
       NAV_INIT(self, self.myTitle, @"common_nav_back_icon", @selector(back), nil, nil);
    }
    else{
         NAV_INIT(self, @"商品分类", @"common_nav_back_icon", @selector(back), nil, nil);
    }
    
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 19)];
    [selectBtn addTarget:self action:@selector(navSelectbtnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"mc_nav_select_icon_1"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"mc_nav_select_icon_2"] forState:UIControlStateSelected];
    UIBarButtonItem *selectBtnItem = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    
    changeViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    
    UIBarButtonItem *changeViewBtnItem = [[UIBarButtonItem alloc] initWithCustomView:changeViewBtn];
    NSArray *rightBtnArray = @[selectBtnItem, changeViewBtnItem];
    self.navigationItem.rightBarButtonItems = rightBtnArray;
}

- (void)navSelectbtnSelectAction:(id)sender{
    
    
    //列表视图显示的控制
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        
        //选中 显示Grid样式
        button.selected = NO;
        selectionType  = PRODUCTS_VIEW_GRID;
    }else{
        
        //不选中 显示 tableview
        button.selected = YES;
        selectionType  = PRODUCTS_VIEW_TABLE;
    }
    
    //刷新collectionview
    [self refreshProductsView];
}


- (void)loadSearchBan{
    
    //加载条件搜索悬浮框
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MallClassificationSearchView" owner:self options:nil];
    searchView = nibs.lastObject;
    searchView.volumeImageView.backgroundColor = LINE;
    [self.view addSubview:searchView];
    
    UITapGestureRecognizer *comTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressComView:)];
    searchView.comprehensiveView.userInteractionEnabled = YES;
    [searchView.comprehensiveView addGestureRecognizer:comTapGest];
    UITapGestureRecognizer *volumeTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressVolumeView:)];
    searchView.salesVolumeView.userInteractionEnabled = YES;
    [searchView.salesVolumeView addGestureRecognizer:volumeTapGest];
    
    UITapGestureRecognizer *priceTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPriceView:)];
    searchView.priceView.userInteractionEnabled = YES;
    [searchView.priceView addGestureRecognizer:priceTapGest];
    
    UITapGestureRecognizer *salesTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressSalesTimeView:)];
    searchView.saleTimeView.userInteractionEnabled = YES;
    [searchView.saleTimeView addGestureRecognizer:salesTapGest];
    
    searchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
}

- (void)loadProductsView {
    
    productsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    productsTableView.backgroundColor = [UIColor clearColor];
   
}

- (void)refreshProductsView{
    
    [productsTableView reloadData];
}

- (void)showShopCartViewController
{
    if(!bShowTabbar)
    {
        bShowTabbar = YES;
        bottomConstraint.constant = 45;
        self.tabBarController.tabBar.hidden = NO;
        shopcartBtnBottom.constant = 15 + 45;
        
    }
    else
    {
        bShowTabbar = NO;
        bottomConstraint.constant = 0;
        self.tabBarController.tabBar.hidden = YES;
        shopcartBtnBottom.constant = 15;
    
    }
}

#pragma mark - TapGestures  更新排序方式

- (void)pressComView:(UITapGestureRecognizer *)gesture{
    
    searchView.comIconImageView.image = [UIImage imageNamed:@"mc_comprehensive_select_icon"];
    searchView.comBottomImageView.hidden = NO;
    
    searchView.volumeIconImageView.image = [UIImage imageNamed:@"筛选1"];
    searchView.volumeImageView.hidden = YES;
    
    searchView.priceIconImageView.image = [UIImage imageNamed:@"mc_price_disselect_icon"];
    searchView.priceBottomImageView.hidden = YES;
    
    searchView.saleIconImageView.image = [UIImage imageNamed:@"mc_time_disselect_icon"];
    searchView.saleBottomImageView.hidden = YES;
    
    selectOrderCondition = ORDER_COMMON;
    
    [self refreshProducts];
}

- (void)pressVolumeView:(UITapGestureRecognizer *)gesture{
    searchView.volumeImageView.hidden = NO;
    if(screeningArray.count == 0){
        
        [SVProgressHUD showErrorWithStatus:@"该类商品没有子分类"];
        return;
    }
    if (shai == YES) {
        shaixuanView.hidden = NO;
        searchView.volumeIconImageView.image = [UIImage imageNamed:@"筛选"];
        [self  createShaiXuan];

    }
    if (shai == NO) {
        searchView.volumeIconImageView.image = [UIImage imageNamed:@"筛选1"];
        for (UIButton *button in screeningButtonArray) {
            
            [button removeFromSuperview];
        }
        [UIView animateWithDuration:0.3 animations:^{
            
            shaixuanView.frame = CGRectZero;
        } completion:^(BOOL finished) {
            
            shaixuanView.hidden = YES;
        }];
       
    }
    shai = !shai;
}

- (void)pressPriceView:(UITapGestureRecognizer *)gesture{
    
    priceASCSort = !priceASCSort;
    
    searchView.comIconImageView.image = [UIImage imageNamed:@"mc_comprehensive_disselect_icon"];
    searchView.comBottomImageView.hidden = YES;
    
    searchView.volumeIconImageView.image = [UIImage imageNamed:@"筛选1"];
    searchView.volumeImageView.hidden = YES;
    
    if(priceASCSort == YES)
        searchView.priceIconImageView.image = [UIImage imageNamed:@"priceSelected_Asc_icon"];
    else
        searchView.priceIconImageView.image = [UIImage imageNamed:@"priceSelected_Desc_icon"];
    searchView.priceBottomImageView.hidden = NO;
    
    searchView.saleIconImageView.image = [UIImage imageNamed:@"mc_time_disselect_icon"];
    searchView.saleBottomImageView.hidden = YES;
    
    selectOrderCondition = ORDER_PRICE;
    
    [self refreshProducts];
}

- (void)pressSalesTimeView:(UITapGestureRecognizer *)gesture{
    
    searchView.comIconImageView.image = [UIImage imageNamed:@"mc_comprehensive_disselect_icon"];
    searchView.comBottomImageView.hidden = YES;
    
    searchView.volumeIconImageView.image = [UIImage imageNamed:@"筛选1"];
    searchView.volumeImageView.hidden = YES;
    
    searchView.priceIconImageView.image = [UIImage imageNamed:@"mc_price_disselect_icon"];
    searchView.priceBottomImageView.hidden = YES;
    
    searchView.saleIconImageView.image = [UIImage imageNamed:@"mc_time_select_icon"];
    searchView.saleBottomImageView.hidden = NO;
    
    selectOrderCondition = ORDER_DATE;
    
    [self refreshProducts];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (selectionType == PRODUCTS_VIEW_GRID) {
        
        NSInteger  rows = [productsArray count] / 2 + [productsArray count] % 2;
        return rows;
    }
    return [productsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectionType == PRODUCTS_VIEW_GRID)
    {
        static NSString *vViewCell = @"MCProductVViewCell";
        MCProductVViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vViewCell];
        if (cell == nil)
        {
            cell = [[MCProductVViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.contentView.backgroundColor = BJCLOLR;
//        [cell initWithDataArray:productsArray];
        if (productsArray[indexPath.row * 2]) {
            [cell initWithData:productsArray[indexPath.row * 2]];
                cell.dataDic1 = productsArray[indexPath.row*2];
        }else{
            NSLog(@"%@",productsArray[indexPath.row * 2]);
        }

        if (indexPath.row * 2 + 1 >= [productsArray count])
        {
            [cell hiddleCellView];
        }
        else
        {
            [cell showCellView];
            if (productsArray[indexPath.row * 2 + 1]) {
                [cell initWithData2:productsArray[indexPath.row * 2 + 1]];
                cell.dataDic2 = productsArray[indexPath.row*2+1];
            }
        
        }
        
        cell.delegate = self;
        return cell;
    }
    else
    {
        static NSString *hViewCell = @"MCProduceHViewCell";
        MCProduceHViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hViewCell];
        if (cell == nil)
        {
            cell = [[MCProduceHViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.contentView.backgroundColor = BJCLOLR;
        if (productsArray[indexPath.row]) {
            [cell initWithData:productsArray[indexPath.row]];
        }else{
            NSLog(@"%@",productsArray[indexPath.row]);
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectionType == PRODUCTS_VIEW_GRID){
        int imageW = (UIScreenWidth-30)/2;
        return imageW+80;
    }
    return 117;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectionType == PRODUCTS_VIEW_TABLE) {
        
        //显示商品详情
        MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
        detailVC.gid = productsArray[indexPath.row][@"goods_id"];
        [self.navigationController pushViewController:detailVC animated:YES];
       
    }
}

#pragma mark -  MCProductVCellDelegate <NSObject>

-(void)cellSelectBtnClick:(NSString *)goodid;
{
    //显示商品详情
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.gid = goodid;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)createShaiXuan
{
    shaixuanView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
    shaixuanView.backgroundColor = BJCLOLR;
    shaixuanView.userInteractionEnabled = YES;
     CGFloat singleButtonWidth = (self.view.frame.size.width - 40)/3;
       CGFloat screeningHeight;
    if((screeningArray.count+1)%3 == 0){
        
        screeningHeight  = (screeningArray.count+1)/3 *50 + 10;
    }else{
        
        screeningHeight = ((screeningArray.count+1)/3 + 1) *50 + 10;
    }
   
    [UIView animateWithDuration:0.3 animations:^{
        shaixuanView.frame = CGRectMake(0,51, UIScreenWidth, screeningHeight);
    } completion:^(BOOL finished) {
        for (int i =0 ; i< screeningArray.count+1; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0) {
                button.frame = CGRectMake(10, 10, singleButtonWidth, 40);
                [button setTitle:@"全部" forState:UIControlStateNormal];
                button.tag = 0;
            }else{
                button.frame = CGRectMake(10+(i%3)*(singleButtonWidth+10), (i/3)*50+10, singleButtonWidth, 40);
                [button setTitle:screeningArray[i-1][@"name"] forState:UIControlStateNormal];
                button.tag = [screeningArray[i-1][@"id"] intValue];
            }
            [button setTitleColor:BLACKTEXT forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"common_button_bg_circle_blue"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"common_button_background_blank"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
            [shaixuanView addSubview:button];
            [screeningButtonArray addObject:button];
        }

    }];
    [self.view addSubview:shaixuanView];

}
- (void)shaixuanAction:(UIButton *) btn
{
    if (btn.tag ==0) {
        selectedCategoryId = self.categoryId;
    }else{
        selectedCategoryId = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    }
    
    for(UIButton *button in screeningButtonArray){
        
        if(button.isSelected){
            
            button.selected = NO;
            break;
        }
    }
    
    btn.selected = YES;
    [self refreshProducts];
    
    [self hideScreeningViewAction:btn];
}
- (void)refreshProducts{
        productIndex = 1;
        [self loadMallClassificationProductsWithPage:productIndex];
    if(!screeningView.hidden){
        
        //如果筛选下拉菜单还显示着,在刷新列表时 将View隐藏
        [self hideScreeningViewAction:nil];
    }
}

- (void)loadMoreProducts{
    
    productIndex++;
    
    [self loadMallClassificationProductsWithPage:productIndex];
    if(!screeningView.hidden){
        
        //如果筛选下拉菜单还显示着,在加载列表时 将View隐藏
        [self hideScreeningViewAction:nil];
    }
}

#pragma mark - Detail Actions

- (void)back{
    
//    bottomConstraint.constant = 0;
//    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  点击某个筛选按钮
 *
 *  @param sender 选择的按钮
 */

- (void)hideScreeningViewAction:(id)sender{
    
    //隐藏筛选框
    for (UIButton *button in screeningButtonArray) {
        
        [button removeFromSuperview];
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        shaixuanView.frame = CGRectZero;
    } completion:^(BOOL finished) {
        
        shaixuanView.hidden = YES;
    }];
    shai = YES;
//    changeViewBtn.selected = NO;
}

- (void)loadMallClassificationProductsWithPage:(NSInteger)page{
    
    NSString *priceOrder;
    if([selectOrderCondition isEqualToString:ORDER_PRICE])
    {
        if(priceASCSort == YES)
            priceOrder = @"ASC"; // 升序
        else
            priceOrder = @"DESC"; // 降序
    }
    else
        priceOrder = nil;
    
    //加载商品列表
    NSLog(@"%ld",productsArray.count);
    if (productsArray.count < 20) {
        footerView.hidden = YES;
        if (isFirst == NO) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        }else{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        }
        isFirst = NO;
        
    }else {
        footerView.hidden = NO;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    NSLog(@"%ld",page);
    
    [[TTIHttpClient shareInstance] productsListRequestWithId:selectedCategoryId
                                                        page:[NSString stringWithFormat:@"%ld",   (long)productIndex]
                                                       order:selectOrderCondition
                                                  priceOrder:priceOrder
                                                     user_id:g_userInfo.uid
                                             withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        
        if(productIndex == 1){
            [productsArray removeAllObjects];
        }
        
      [SVProgressHUD dismiss];
        
        NSArray *resultArray = [[NSMutableArray alloc] initWithArray:(NSArray *)response.result[@"goods"]];
        countLabel.text = [NSString stringWithFormat:@"%@", response.result[@"cart_num"]];
        if(resultArray.count == 0){
            [footerView endRefresh];
//            [SVProgressHUD showSuccessWithStatus:@"没有更多~"];
            productIndex--;
            return;
        }
        else
        {
            [productsArray addObjectsFromArray:resultArray];
        }
       
        if(screeningArray.count == 0){
            
            //第一次才会改变筛选列表
            screeningArray = [[NSMutableArray alloc] initWithArray:(NSArray *)response.result[@"sub_category"]];
            
        }
        if (productsArray.count < 20) {
            lastNum = page;
        }

        [productsTableView reloadData];
        [headerView endRefresh];
        [footerView endRefresh];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        
    }];
}


#pragma mark --- 隐藏tabbar

-(void)makeTabBarHidden:(BOOL)hide {
    // Custom code to hide TabBar
    if ( [self.tabBarController.view.subviews count] < 2 ) {
        return;
    }
    
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    }
    
    if (hide) {
        contentView.frame = self.tabBarController.view.bounds;
    } else {
        contentView.frame = CGRectMake(self.tabBarController.view.bounds.origin.x,
                                       self.tabBarController.view.bounds.origin.y,
                                       self.tabBarController.view.bounds.size.width,
                                       self.tabBarController.view.bounds.size.height -
                                       self.tabBarController.tabBar.frame.size.height);
    }
    
    self.tabBarController.tabBar.hidden = hide;
}

@end
