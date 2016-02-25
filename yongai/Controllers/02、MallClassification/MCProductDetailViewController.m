//
//  MCProductDetailViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductDetailViewController.h"
#import "CommonUtils.h"
#import "MCProductPicTextDetailViewController.h"
#import "MCProductCommentViewController.h"
#import "MCProductPromotiomViewController.h"
#import "MCProductPicTextDetailViewController.h"
#import "MCProductBaseDataViewController.h"
#import "MCProductFreeFreightViewController.h"
#import "DataModel.h"
#import "LoginNavViewController.h"
#import "MCProductGoodRuleViewController.h"
#import "SureOderController.h"
#import "TTIFont.h"
#import "GoldRuleViewController.h"
#import "CaiNiXiHuan.h"
#import "ZaiXianKeFuViewController.h"
@interface MCProductDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate,CaiNiXiHuanDelegate>{
    
    //是否显示货到付款简介
    BOOL isContentShown;
    MCProductDetailViewController * MCP;
    //商品规格
    ProductSpecView *productSpecView;
    NSLayoutConstraint  *productSpecViewBottom; //商品规格距离下方的间隔
    
    BOOL isCollect;
    
    NSDictionary *selectedSpecDic;
    
    LoginModel *userModel;
    //收藏按钮
    UIButton *rightButton;
    
    BOOL bShowTabbar; // 是否显示tabbar
    
    IBOutlet NSLayoutConstraint *tableBottom;
    
    NSInteger cartGoodsCount; // 购物车商品总数
    
    CGFloat payMentHeight;
    
    NSString  *currentPrice;//当前选择的规格下商品的金额
    
    GoodsInfoModel *goodsInfo;
    CGFloat cellHeight;
    UIScrollView * scrollView;
    UIWebView * tuwenWeb;
    UILabel * xiaLalable;
    UIImageView * xiala;
    UIButton * xiaLabtn;
    NSMutableArray * link_goods;
    UIButton * kefuBtn;//客服
    BOOL _isFirst;
    UILabel * kefuLable;
    NSString * keFustring;
    BOOL click;//在没有数据之前按钮不能点击

}

@end

@implementation MCProductDetailViewController{
    
    //加载底部购买栏
    MCProductBottomView *bottomView;
    CaiNiXiHuan * xihuan ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册 显示/隐藏 刷新列表通知
//    self.timeStr = @"";
    _isFirst = YES;
    click = NO;
    link_goods = [[NSMutableArray alloc] init];
    xiaLalable = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth/2-50,0, UIScreenWidth, 50)];
    xiaLalable.text = @"下拉查看商品详情";
    xiaLalable.hidden = YES;
    xiaLalable.font = [UIFont systemFontOfSize:14];
    xiaLalable.textColor = BLACKTEXT;
    [self.view addSubview:xiaLalable];
    xiaLabtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xiaLabtn.frame = CGRectMake(0, 0, UIScreenWidth, 50);
    xiaLabtn.userInteractionEnabled = NO;
    [xiaLabtn addTarget:self action:@selector(xialaBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xiaLabtn];
    xiala = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth/2-80,15,15,15)];
    xiala.image = [UIImage imageNamed:@"朝下1"];
    xiala.hidden = YES;
    [self.view addSubview:xiala];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMCProduct:) name:Notify_RefreshMCProductCell object:nil];
    
    xihuan = [[CaiNiXiHuan alloc] init];
    //图文详情
    tuwenWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0,UIScreenHeight, UIScreenWidth, UIScreenHeight-70)];
    self.tableView.backgroundColor = BJCLOLR;
    currentPrice =[NSString stringWithFormat:@"￥%@", self.productDic[@"goods_info"][@"price"]];
    [self loadProductDetailWithGoodsId:self.gid];
    [self loadProductDetailTableView];
    
    [self initliaztion];
    [self loadBaseUI];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MCP viewWillAppear:animated];
    //获取商品详情
//    [self loadProductDetailWithGoodsId:self.gid];
//    self.tabBarController.tabBar.hidden = YES;
    userModel = g_userInfo;
    
    // 隐藏tabbar
    tableBottom.constant = 45;
    bottomView.hidden = NO;
    if(bShowTabbar == NO)
        self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MCP viewWillDisappear:animated];
    bottomView.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:Notify_RefreshMCProductCell];
}

- (void)initliaztion{
    
    selectedSpecDic = [[NSDictionary alloc] init];
}

- (void)loadBaseUI{
    
    NAV_INIT(self, @"商品详情", @"common_nav_back_icon", @selector(back), nil, nil);
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 18)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"product_store_icon"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"product_like_full_icon"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(selectLikeProductAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self loadBottomFunctionView];
    
    //加载商品规格View
    [self loadProductSpecView];
}

- (void)loadProductSpecView{
    
    productSpecView = [[[NSBundle mainBundle] loadNibNamed:@"ProductSpecView" owner:self options:nil] lastObject];
    productSpecView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40);
    productSpecView.hidden = YES;
    productSpecView.delegate = self;
    [self.view addSubview:productSpecView];
    
    

}

- (void)loadProductDetailTableView{
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadBottomFunctionView{
    
    //加载底部购买栏
    bottomView = [[MCProductBottomView alloc] initWithFrame:CGRectMake(-1, UIScreenHeight - 48, UIScreenWidth+5, 50)];
    
//    bottomView.delegate = self;
    bottomView.backgroundColor = BJCLOLR;
    bottomView.layer.borderColor = LINE.CGColor;
    bottomView.layer.borderWidth = 0.5;
    bottomView.confirmBuyButton.hidden = YES;
    bottomView.confirmAddButton.hidden = YES;
    [self.navigationController.view addSubview:bottomView];
    //    在线客服(1)
   
}
- (void)ReloadBottomFunctionView
{
    bottomView.delegate = self;
}
#pragma mark - Detail Actions

- (void)back{
    bottomView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDataSource && TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section ==0 || section == 1) {
        return 10;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView * image  = [[UIImageView alloc ] init];
    image.backgroundColor = BJCLOLR;
    image.layer.borderColor = LINE.CGColor;
    image.layer.borderWidth = 0.5;
    return image;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0:
        {
            float height = UIScreenWidth;
            float h1 =[TTIFont calHeightWithText:self.productDic[@"goods_info"][@"goods_name"] font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth-20];
            float h2 =[TTIFont calHeightWithText:self.productDic[@"goods_info"][@"keywords"] font:[UIFont systemFontOfSize:15] limitWidth:UIScreenWidth-20];
            
            if([self.productDic[@"goods_info"][@"goods_name"]  length] == 0)
                h1 = 0;
            if([self.productDic[@"goods_info"][@"keywords"]  length] == 0)
                h2 = 0;
            float h3 = 0;
            NSString * str = [NSString stringWithFormat:@"%@",self.productDic[@"goods_info"][@"end_time"]];
            if ([str isEqualToString:@"-1"]) {
                h3 = 0;
            
            }else{
                h3 = 20;
            }
            cellHeight = height+h1+h2+60;
            return height+h1+h2+60 + h3;
        }
            break;
        case 1: //商品信息
        {
            if (UIScreenWidth>320) {
                return 45-0.5;
            }else{
                return 40;
            }
            
        }
            break;
        case 2:
        {
            NSString * str = [NSString stringWithFormat:@"%@",self.productDic[@"goods_info"][@"end_time"]];
            if([self.productDic[@"goods_info"][@"is_zeng"] intValue]==0 && [self.productDic[@"goods_info"][@"promotion_count"] intValue]==0)
            {
                if ([str isEqualToString:@"-1"]) {
                    return 45;
                }else{
                    return 80;
                }
                
            }
            if([self.productDic[@"goods_info"][@"is_zeng"] intValue]==0 || [self.productDic[@"goods_info"][@"promotion_count"] intValue]==0)
            {
                if ([str isEqualToString:@"-1"]) {
                    return 80;
                }else{
                    return 100;
                }
               
            }
            
            return 90;
            
            
        }
            break;
        case 3:
        {
            return 45;
        }
            break;
        case 5:
        {
            return 45;
        }
            break;
        case 4:
        {
            return 45;
        }
            break;
        case 7:
        {
            if ([goodsInfo.goods_desc isEqualToString:@""]) {
                return 0;
            }else{
               return 40;
            }
            
            break;
        }
        case 6:{
            if (![g_version isEqualToString:VERSION]) {
                if([(NSArray *)self.productDic[@"link_goods_new"] count] > 3){
                    
                    return 400;
                }else if ([(NSArray *)self.productDic[@"link_goods_new"] count] ==0){
                    return 0;
                }else{
                    return 200;
                }

            }else{
                return 0;
            }
            
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    switch (section) {
        case 0: // 商品图片和价格cell
        {
            static NSString * MCCell = @"MCCell";
            
            MCProductDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:MCCell];
            if (cell == nil) {
                cell = [[MCProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MCCell];
            }
            GoodsDetailInfoModel  *detail;
            if(self.productDic != nil)
                detail = [[GoodsDetailInfoModel alloc] initWithDictionary:self.productDic error:nil];
            NSString * saleNum = [NSString stringWithFormat:@"%@",[[self.productDic objectForKey:@"goods_info"] objectForKey:@"salenum"]];
            NSString * string;
            if ([saleNum isEqualToString:@"0"]) {
                string = @"没有成交记录";
            }else{
                string = [NSString stringWithFormat:@"已成交: %@笔",saleNum];
            }
            if (detail) {
                [cell initCellWithDeatilInfo:detail withCellHeight:cellHeight with:string];
            }
            
            
            return cell;
        }
            break;
        case 1: //商品信息
        {
            static NSString * infoCell = @"infoCell";
            
            MCProductInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:infoCell];
            if (cell == nil) {
                cell = [[MCProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCell];
            }
            return cell;
        }
            break;
        case 2:
        {
            static NSString * PromotionCell = @"PromotionCell";
            
            MCProductPromotionCell * cell = [tableView dequeueReusableCellWithIdentifier:PromotionCell];
            if (cell == nil) {
                cell = [[MCProductPromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PromotionCell];
            }
            cell.yunFeiStr = self.productDic[@"service_info"][@"eight_free"];
            NSString * str = [NSString stringWithFormat:@"%@",self.productDic[@"goods_info"][@"end_time"]];
            if (goodsInfo) {
                [cell initWithGoodsInfo:goodsInfo withEndTime:str];
               return cell; 
            }
            
            
        }
            break;
        case 3:  
        {
            //规格
            static NSString * SpecCell = @"SpecCell";
            MCProductSpecCell * cell = [tableView dequeueReusableCellWithIdentifier:SpecCell];
            if (cell == nil) {
                cell = [[MCProductSpecCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SpecCell];
            }
//            cell.backgroundColor = BJCLOLR;
            if(selectedSpecDic[@"attr_value"] == nil)
            {
                cell.specLabel.text =@"未选择";
            }
            else
            {
                cell.specLabel.text = selectedSpecDic[@"attr_value"];
            }
            return cell;
        }
            break;
        case 5:
        {
            // 商品评价
            NSString *cellIdentifier = @"MCProductOtherInfoCell";
            [tableView registerNib:[UINib nibWithNibName:@"MCProductOtherInfoCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
            MCProductOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (goodsInfo) {
                [cell initDataWithGoodsInfo:goodsInfo];
            }
            if ([goodsInfo.goods_desc isEqualToString:@""]) {
                cell.line2.hidden = YES;
            }else{
                cell.line2.hidden = NO;
            }
            cell.delegate = self;
            return cell;
        }
            break;
        case 4:
        {
            NSString * serviceCell = @"serviceCell";
            
            MCProductServiceInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:serviceCell];
            if (cell == nil) {
                cell = [[MCProductServiceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceCell];
            }
//            cell.backgroundColor = beijing;
            return cell;
        }
            break;
        case 7:
        {
            //推荐商品
                NSString * cellStr = @"cell7";
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
                    if ([goodsInfo.goods_desc isEqualToString:@""]) {
                        NSLog(@"没有图文详情");
                    }else{
                        UILabel * lable=[[ UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth/2-50,5, 120, 30)];
                        lable.text = @"上拉查看图文详情";
                        lable.font = [UIFont systemFontOfSize:14];
                        lable.textColor = BLACKTEXT;
                        [cell.contentView addSubview:lable];
                        UIImageView * shangla = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth/2-80,12,15,15)];
                        shangla.image = [UIImage imageNamed:@"朝上1"];
                        [cell.contentView addSubview:shangla];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }
            cell.layer.borderColor = LINE.CGColor;
            cell.layer.borderWidth = 0.5;
                return cell;

        }
            
            break;
        case 6:{

            static NSString *cellIdentifier = @"ProductRecemmendCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            NSArray * arr = self.productDic[@"link_goods_new"];
            if (arr.count != 0) {
                xihuan.frame = CGRectMake(0,10, UIScreenWidth, 400-20);
                xihuan.layer.borderWidth = 0.5;
                xihuan.layer.borderColor = LINE.CGColor;
                xihuan.backgroundColor = [UIColor whiteColor];
                xihuan.delegate = self;
                [xihuan initWithArray:self.productDic[@"link_goods_new"]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = BJCLOLR;
                if (![g_version isEqualToString:VERSION]) {
                     [cell.contentView addSubview:xihuan];
                }
               
            }
            
            return cell;

        }
            break;
        default:
            break;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}
#pragma mark -- 猜你喜欢
- (void)ShangPinAction:(NSString *)goods_id
{
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.gid = goods_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 2:
        {
            //显示促销赠品页
            if([self.productDic[@"goods_info"][@"is_zeng"] intValue] == 1)
                [self productsPromotions];
            
            break;
        }
        case 3:
        {
            [self showProductSpecView:nil];
            break;
        }
        case 4:{
            [self showGoldRuleView];
            break;
        }
        case 7:{
            [self createNewFace];
            break;
        }
        default:
            break;
    }
}
#pragma mark -- 上拉
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    //_pullUp 是否可以上拉加载，向上拉的偏移超过50就加载
    if (scrollView.frame.size.height+scrollView.contentOffset.y > scrollView.contentSize.height + 50)
    {
        if (bottomView.hidden == NO) {
            if ([goodsInfo.goods_desc isEqualToString:@""]) {
                return;
            }else{
                tuwenWeb.hidden = NO;
                [self createNewFace];
            }
            
        }

        
    }
    if (tuwenWeb.scrollView.contentOffset.y < -50)
    {
        if (bottomView.hidden == YES) {
            [self createnewTabelView];
        }
        
    }
    
}
- (void)xialaBtn
{
    [self createnewTabelView];
}
- (void)createnewTabelView
{
    tuwenWeb.hidden = YES;
    xiaLalable.hidden = YES;
    xiala.hidden = YES;
    self.tableView.hidden = NO;
    bottomView.hidden = NO;
}
- (void)createNewFace
{
    self.tableView.hidden = YES;
    bottomView.hidden = YES;
    xiala.hidden = NO;
    xiaLalable.hidden = NO;
    xiaLabtn.userInteractionEnabled = YES;
    
    tuwenWeb.scalesPageToFit = YES;
    tuwenWeb.backgroundColor = BJCLOLR;
    tuwenWeb.delegate = self;
    tuwenWeb.scrollView.delegate = self;
    NSLog(@"%@",goodsInfo.goods_desc);
    NSString * stringHtml = @"";
    if (goodsInfo.goods_desc != nil) {
        stringHtml = goodsInfo.goods_desc;
        CGFloat beishu = UIScreenWidth/750;
        NSString * str = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=%f\" />",beishu ];
        NSString * newHtml = [str stringByAppendingString:stringHtml];
        NSLog(@"newHtml = %@",newHtml);
        [tuwenWeb loadHTMLString:newHtml baseURL:nil];
        [UIView animateWithDuration:0.5 animations:^{
            tuwenWeb.frame = CGRectMake(0,50, UIScreenWidth, UIScreenHeight-100);
        }];
        [self.view addSubview:tuwenWeb];
    }
    
    
}

#pragma mark - Detail Actions
#pragma mark ------------ 添加收藏 或 取消收藏
- (void)selectLikeProductAction:(id)sender{
    
    if(g_LoginStatus == 0){
        
        //判断用户是否登录
        LoginNavViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    
    //喜欢/取消喜欢商品
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        
        //取消喜欢
        [self cancelStorage:button];
    }else{
        
        //喜欢
        [self addStorage:button];
    }
}
- (void)addStorage:(UIButton *)button{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] goodsEditprovinceRequestWithsid:userModel.sid withGoods_id:self.productDic[@"goods_info"][@"goods_id"] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"已添加收藏"];
        button.selected = YES;
        isCollect = YES;
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

- (void)cancelStorage:(UIButton *)button{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] goodsCancelRequestWithsid:userModel.sid withgoods_id:self.productDic[@"goods_info"][@"goods_id"] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
        button.selected = NO;
        isCollect = NO;
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

// 查看赠品
- (void)productsPromotions{
    
    //加载赠品列表
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] gift_listRequestWithgoods_id:self.productDic[@"goods_info"][@"goods_id"]
                                                withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                    
                                                    [SVProgressHUD dismiss];
                                                    
                                                    MCProductPromotiomViewController *promotionVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductPromotiomViewController"];
                                                    promotionVC.giftsArray = (NSArray *)response.result[@"result"];
                                                    [self.navigationController pushViewController:promotionVC animated:YES];
                                                    
                                                } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
                                                    
                                                    [SVProgressHUD showErrorWithStatus:response.error_desc];
                                                }];
}

#pragma mark - CellDelegate
- (void)showPicTextView:(UITapGestureRecognizer *)gesture{
    
    //显示图文页
    MCProductPicTextDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductPicTextDetailViewController"];
    vc.contentHtmlStr = self.productDic[@"goods_info"][@"goods_desc"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showProductCommentView:(UITapGestureRecognizer *)gesture{
    
    //显示商品评论页
    MCProductCommentViewController *commentVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductCommentViewController"];
    commentVC.goods_id = self.productDic[@"goods_info"][@"goods_id"];
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)showBaseDataView:(UITapGestureRecognizer *)gesture{
    
    //显示基本参数
    MCProductBaseDataViewController *vc = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductBaseDataViewController"];
    vc.contentStr = self.productDic[@"goods_info"][@"goods_brief"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshMCProduct:(NSNotification *)notificaton{
    
    isContentShown = [[notificaton.userInfo objectForKey:@"isContentShown"] isEqualToString:@"0"]?NO:YES;
    payMentHeight = [[notificaton.userInfo objectForKey:@"payContentHeight"] floatValue];
    [_tableView reloadData];
}

#pragma mark - ProductSpecView Delegate
- (void)showProductSpecView:(id)sender{

    // 若当前tabbar已显示， 则隐藏处理
    if(bShowTabbar == YES)
    {
        [self showShopcartView];
        
    }
    
    productSpecView.hidden = NO;
    kefuBtn.hidden = YES;
    kefuLable.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        
        productSpecView.frame = CGRectMake(0, 0, self.view.frame.size.width, productSpecView.frame.size.height);
    }];
    
    
}

- (void)closeProductSpecView:(id)sender{
    
    //关闭商品选择规格View
    
    [UIView animateWithDuration:0.3 animations:^{
        
//        productSpecView.frame = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, self.view.frame.size.height - 60);
    }];
    productSpecView.hidden = YES;
    kefuBtn.hidden = NO;
    bottomView.confirmAddButton.hidden = YES;
    bottomView.confirmBuyButton.hidden = YES;
    bottomView.imageView1.hidden = NO;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
}

/**
 *  选择物品规格
 *
 *  @param dic 规格字典
 */
- (void)specButtonSelected:(NSDictionary *)dic{
    
    selectedSpecDic = dic;
    currentPrice = [NSString stringWithFormat:@"￥%@", selectedSpecDic[@"attr_price"]];
    MCProductDetailCell *cell = ( MCProductDetailCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    int priceW  = [currentPrice sizeWithFont:font(20)].width;
    cell.priceLable.frame = CGRectMake(cell.priceLable.frame.origin.x,cell.priceLable.frame.origin.y, priceW, 30);
    cell.priceLable.text = currentPrice;
}

#pragma mark - MCProductBottomView Delegate
- (void)kefuClick
{
    
    if (g_userInfo.loginStatus.intValue == 0) {
        //判断用户是否登录
        LoginNavViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;

    }
    if (goodsInfo.img_url) {
        bottomView.hidden = YES;
        ZaiXianKeFuViewController * zaiXian = [[ZaiXianKeFuViewController alloc] init];
        zaiXian.keFuZaiXian = keFustring;
        zaiXian.goodsInfo = goodsInfo;
        [self.navigationController pushViewController:zaiXian animated:YES];
    }else{
        return;
    }

    
}

- (void)addToShopcartAction{
    [self showProductSpecView:nil];
//    kefuBtn.hidden = YES;
    bottomView.confirmAddButton.hidden = NO;
    bottomView.confirmBuyButton.hidden = YES;
    bottomView.imageView1.hidden = YES;
}

- (void)buyAction{
    
    [self showProductSpecView:nil];
//    kefuBtn.hidden = YES;
    bottomView.confirmAddButton.hidden = YES;
    bottomView.confirmBuyButton.hidden = NO;
    bottomView.imageView1.hidden = YES;
}



#pragma - mark  ----------   加入购物车
- (void)confirmAddAction{
    
    if(g_LoginStatus == 0){
        
        //判断用户是否登录
        LoginNavViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    
    if(selectedSpecDic.count == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择：规格/购买数量"];
        return;
    }
    
    if(![selectedSpecDic[@"goods_status"] isEqualToString:@"现货"]){
        
        //该规格的商品断货,不能加入购物车或立即购买
        [SVProgressHUD showErrorWithStatus:@"该规格产品缺货中~"];
        return;
    }
    
    //加入购物车
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] addCartRequestWithsid:userModel.sid withgoods_id:self.productDic[@"goods_info"][@"goods_id"] withgoods_attr_id:productSpecView.selectedSpecDic[@"goods_attr_id"] withgoods_number:[NSString stringWithFormat:@"%i", productSpecView.resultCount] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
        
        //底部购物车数量
        cartGoodsCount++;
        bottomView.shopcartCountLabel.text = [NSString stringWithFormat:@"%ld", (long)cartGoodsCount];
        g_userInfo.cart_num =[NSString stringWithFormat:@"%ld", (long)cartGoodsCount];
        
        
        [self closeProductSpecView:nil];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
        
    }];
}

#pragma - mark  ----------   确定购买 -- 加入购物车后直接跳转到购物车
- (void)confirmBuyAction{
    
    if(g_userInfo.loginStatus == 0){
        
        //判断用户是否登录
        LoginNavViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    
    if(selectedSpecDic.count == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择：规格/购买数量"];
        return;
    }
    
    if(![selectedSpecDic[@"goods_status"] isEqualToString:@"现货"]){
        
        //该规格的商品断货,不能加入购物车或立即购买
        [SVProgressHUD showErrorWithStatus:@"该规格产品缺货中~"];
        return;
    }
    
    //加入购物车
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] addCartRequestWithsid:userModel.sid withgoods_id:self.productDic[@"goods_info"][@"goods_id"] withgoods_attr_id:productSpecView.selectedSpecDic[@"goods_attr_id"] withgoods_number:[NSString stringWithFormat:@"%i", productSpecView.resultCount] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        //底部购物车数量
        cartGoodsCount++;
        bottomView.shopcartCountLabel.text = [NSString stringWithFormat:@"%ld", (long)cartGoodsCount];
        g_userInfo.cart_num =[NSString stringWithFormat:@"%ld", (long)cartGoodsCount];
        
        self.tabBarController.selectedIndex = 3;
        
        [self closeProductSpecView:nil];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

#pragma mark -----------  查看商品详情
- (void)loadProductDetailWithGoodsId:(NSString *)goods_id{
    
    //查看商品详情
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] productsDetailRequestWithGoodsId:goods_id user_id:g_userInfo.uid withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        click = YES;
        [self ReloadBottomFunctionView];
        keFustring = response.error_desc;
        if ([keFustring isEqualToString:@"获取成功"]) {
            bottomView.kefuImage.image = [UIImage imageNamed:@"客服彩色"];
        }else{
           bottomView.kefuImage.image = [UIImage imageNamed:@"客服"];
        }
        [SVProgressHUD dismiss];
        //跳转到商品详情
        if (response.result) {
            self.productDic =[NSMutableDictionary dictionaryWithDictionary:response.result];
        }else{
            return ;
        }
        

        if(self.productDic[@"goods_info"] != nil)
            goodsInfo = [[GoodsInfoModel alloc] initWithDictionary:self.productDic[@"goods_info"] error:nil];
        
        //是否收藏
        if([self.productDic[@"goods_info"][@"is_collect"] intValue] == 0){
            
            isCollect = NO;
        }else{
            
            isCollect = YES;
        }
        if(isCollect){
            
            rightButton.selected = YES;
        }else{
            
            rightButton.selected = NO;
        }
        
        NSString *count = self.productDic[@"cart_num"];
        if(![count isKindOfClass:[NSNull class]] && count.length > 0)
            cartGoodsCount = [count intValue];
        else
            cartGoodsCount = 0;
        g_userInfo.cart_num =[NSString stringWithFormat:@"%ld", (long)cartGoodsCount];
        
        //底部购物车数量
        [bottomView initDataWithDictionary:self.productDic];
        //默认规格
        [productSpecView initDataWithDictionary:self.productDic width:self.view.frame.size.width];
        
        [self.tableView reloadData];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

#pragma mark - ProductServiceInfoDelegate
- (void)showFreeFreightView{
    
    MCProductFreeFreightViewController *freeFreightVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductFreeFreightViewController"];
    freeFreightVC.contentStr = self.productDic[@"service_info"][@"eight_free"];
    [self.navigationController pushViewController:freeFreightVC animated:YES];
}

- (void)showGoldRuleView{
    
    GoldRuleViewController *ruleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"GoldRuleViewController"];
    ruleVC.type = ExplainType_GoldRule;
    ruleVC.content = self.productDic[@"service_info"][@"gold"];
    [self.navigationController pushViewController:ruleVC animated:YES];
}


/**
 *  跳转至购物车页面
 */
-(void)showShopcartView
{
    if(g_userInfo.loginStatus == 0){
        
        //判断用户是否登录
        LoginNavViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    
    self.tabBarController.selectedIndex = 3;
    
}

@end
