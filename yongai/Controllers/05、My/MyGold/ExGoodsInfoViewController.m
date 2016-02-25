//
//  ExGoodsInfoViewController.m
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ExGoodsInfoViewController.h"
#import "TTICycleScrollView.h"
#import "MCProductInfoCell.h"
#import "ConfirmExchangeViewController.h"
#import "TTIFont.h"

@interface ExGoodsInfoViewController ()<TTICycleScrollViewDatasource, TTICycleScrollViewDelegate>
{
//    IBOutlet UIView *tableHeadView;
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *scrollBgView; //轮播图背景视图
    
    IBOutlet UIView *tableHeadView;
    
    // 轮播图
    TTICycleScrollView *bannnerView;
    
    ExchangeInfoModel  *goodsInfo;
    IBOutlet UILabel *goodsGoldLabel;
    IBOutlet UILabel *goodsNumLabel;
    IBOutlet UILabel *allGoldNumLabel;
   
}
// 点击去兑换按钮的事件响应
- (IBAction)toExchangeBtnClick:(id)sender;

@end

@implementation ExGoodsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"兑换商品详情", @"common_nav_back_icon", @selector(backAction), nil, nil);
    myTableView.backgroundColor = BJCLOLR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    goodsNumLabel.textColor  = BLACKTEXT;
    self.nowLabel.textColor = BLACKTEXT;
    self.viewFooter.backgroundColor = BJCLOLR;
    self.duiHuanBtn.backgroundColor = beijing;
    self.duiHuanBtn.layer.masksToBounds = YES;
    self.duiHuanBtn.layer.cornerRadius = 5;
    [self requestTableData];
    [self initScrollView];
    //创建刷新
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    ExGoodsInfoViewController * exg;
    [super viewWillAppear:animated];
    [exg viewWillAppear:animated];
    allGoldNumLabel.text = g_userInfo.pay_points;
}

-(void)requestTableData
{
    [[TTIHttpClient shareInstance] infoExchangeRequestWithsid:nil withgoods_id:_goodsId withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        goodsInfo = response.responseModel;
        
        goodsGoldLabel.text = goodsInfo.exchange_integral;
        goodsNumLabel.text =[NSString stringWithFormat:@"数量：%@件", goodsInfo.goods_number];
        allGoldNumLabel.text = g_userInfo.pay_points;
        
        
        [myTableView reloadData];
        [bannnerView reloadData];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
    
    }];
}

-(void)initScrollView
{
    //加载ads轮播图
    bannnerView = [[TTICycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    bannnerView.datasource = self;
    bannnerView.delegate = self;
    bannnerView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    bannnerView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [scrollBgView addSubview:bannnerView];
    
    tableHeadView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width+44);
    myTableView.tableHeaderView = tableHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int with = UIScreenWidth - 15 - 15;
    
    int nameLength = [TTIFont calHeightWithText:goodsInfo.goods_name font:[UIFont systemFontOfSize:13] limitWidth:with];
    
    int descLength = [TTIFont calHeightWithText:goodsInfo.goods_desc font:[UIFont systemFontOfSize:13] limitWidth:with];
    
    return nameLength + descLength + 48 + 10 + 9;
}

#pragma mark ---  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MCProductInfoCell";
    [tableView registerNib:[UINib nibWithNibName:@"MCProductInfoCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    MCProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.pDescLabel.text = goodsInfo.goods_name;
    cell.preferentialLabel.text = goodsInfo.goods_desc;
    return cell;
}

#pragma mark - TTICycleScrollViewDelegate methods

- (void)didClickPage:(TTICycleScrollView *)csView atIndex:(NSInteger)index{
    
//    //点击事件
//    NSString *url = @"www.baidu.com";
//    [[ UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

#pragma mark - TTICycleScrollViewDatasource methods

- (NSInteger)numberOfPages{
    
    return goodsInfo.gallery.count;
}

- (UIView *)pageAtIndex:(NSInteger)index{
    
    ScrollImgModel *image = [goodsInfo.gallery objectAtIndex:index];
    
    UIImageView *newsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
//    newsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [newsImageView  setImageWithURL:[NSURL URLWithString:image.logo] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    
    return newsImageView;
}

- (IBAction)toExchangeBtnClick:(id)sender {
    
    [[TTIHttpClient shareInstance] changingExchangeRequestWithGoods_id:_goodsId withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        ConfirmExchangeViewController *confirmVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmExchangeViewController"];
        
        
        
        
        confirmVC.goodsInfo =[[ExchangeListModel alloc] initWithDictionary:[response.result objectForKey:@"exchange_info"] error:nil];
        confirmVC.goodsInfo.goods_id = _goodsId;
        confirmVC.address =[[AddressModel alloc] initWithDictionary:[response.result objectForKey:@"consignee"] error:nil];
        
        [self.navigationController pushViewController:confirmVC animated:YES];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
       
    }];

}

@end
