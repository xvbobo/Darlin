//
//  ShoppingCartController.m
//  Yongai
//
//  Created by arron on 14/11/2.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ShoppingCartController.h"
#import "ShoppingCartCell.h"
#import "CommonUtils.h"
#import "CartEmptyView.h"
#import "UpdateGoodsCountView.h"
#import "SureOderController.h"
#import "LoginNavViewController.h"

#import "AddAddressController.h"

@interface ShoppingCartController ()<ShopCartCellDelegate,ChangeGoodsCountDelegate,CartEmptyDelegate>
{
    UpdateGoodsCountView *sureView;
    UIView *maskBgd;
    CartEmptyView *empetyView;
    int  gCount;
    NSArray *constraints;
    
    NSMutableArray *dataSource;
    
    NSInteger  editCountRow; //正在编辑数量的cell的行数
    
    BOOL bShowLogin; //是否显示登陆页面
    JuHuaView * flower;
    IBOutlet UIButton *cartDeleteBtn;// 购物车删除按钮
}

- (IBAction)cartDeleteBtnClick:(id)sender; //购物车删除事件

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *feeLoyoutHeight;

@end

@implementation ShoppingCartController
@synthesize policyLbl1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.bFromOtherView == YES)
        NAV_INIT(self, @"购物车", @"common_nav_back_icon", @selector(back), nil, nil);
    else
        NAV_INIT(self, @"购物车", nil, nil, nil, nil);
        // 购物车中“结算”一栏的底色
    _payView.translatesAutoresizingMaskIntoConstraints = NO;
    _payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _payBtn.backgroundColor = beijing;
    _payBtn.layer.masksToBounds = YES;
    _payBtn.layer.cornerRadius = 5;
    _cartTableView.backgroundColor = BJCLOLR;
    _cartTableView.bounces = YES;
    _cartTableView.tableHeaderView.backgroundColor = BJCLOLR;
    flower = [[JuHuaView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    flower.center = CGPointMake(self.view.center.x, self.view.center.y+UIScreenHeight/6);
    [self.navigationController.view addSubview:flower];
    dataSource = [[NSMutableArray alloc] init];
    [self loadViews];
    // 默认隐藏右侧的删除按钮
    cartDeleteBtn.hidden= YES;
    // 更新所有商品为未选中状态
    _cartGoodsPrice.text = @"0";
    self.navigationController.navigationBar.barTintColor = beijing;
    [self.navigationController.navigationBar setTranslucent:NO];
//    if (IOS7)
//    {
//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"1"] stretchableImageWithLeftCapWidth:1 topCapHeight:10]
//                                                      forBarMetrics:UIBarMetricsDefault];
//    }
//    else
//    {
//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"1"] stretchableImageWithLeftCapWidth:1 topCapHeight:10]
//                                                      forBarMetrics:UIBarMetricsDefault];
//    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    ShoppingCartController * Shop;
    [super viewWillAppear:animated];
    [Shop viewWillAppear:animated];
    // 未登录 && 未显示登陆页面 =》 显示登陆页面
    if(g_userInfo.loginStatus.intValue == 0 && !bShowLogin)
    {
        [self showLoginView];
//        return;
    }
    // 未登录 && 显示登陆页面  =》 登陆页面消失时，跳转至个人中心
    else if (g_userInfo.loginStatus.intValue == 0 && bShowLogin)
    {
        self.tabBarController.selectedIndex = selectedIndex;
    }
    else
    {
        [self initTableData];
        _choiceAllBtn.selected = NO;
    }
    flower.hidden = NO;
    bShowLogin = !bShowLogin;
}
- (void)viewWillDisappear:(BOOL)animated
{
    ShoppingCartController * Shop;
    [super viewWillDisappear:animated];
    [Shop viewWillDisappear:animated];
    flower.hidden = YES;
}

// 登录
-(void)showLoginView
{
    LoginNavViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
    [self presentViewController:loginVC animated:YES completion:nil];
}

-(void)initTableData
{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [flower startView];
    [[TTIHttpClient shareInstance] cartListRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        [flower stopView];
        NSMutableArray *dataList = [response.responseModel objectForKey:@"data"];

        if(dataList.count == 0)
            empetyView.hidden = NO;
        else
        {
            empetyView.hidden = YES;
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:dataList];
            policyLbl1.text = [response.responseModel objectForKey:@"eight_free"];
            [self reloadAllViews];
            
        }
        
        if(!IOS7)
        {
            CGSize size = [policyLbl1.text  sizeWithFont:policyLbl1.font  constrainedToSize:CGSizeMake(policyLbl1.frame.size.width -20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect rect = policyLbl1.frame;
            rect.size.width = size.width;
            rect.size.height = size.height;
            policyLbl1.frame = rect;
        }
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
//        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

-(void)reloadAllViews
{
    [_cartTableView reloadData];
    [self updateCartGoodsPrice];
    [self updateAllGoodsCount];
}

- (void)loadViews
{
    //购物车为空时显示view
    empetyView = [[[UINib nibWithNibName:@"CartEmptyView" bundle:nil]
             instantiateWithOwner:self options:nil] objectAtIndex:0];
    empetyView.hidden = NO;
    empetyView.emptyDelegate = self;
    empetyView.translatesAutoresizingMaskIntoConstraints = NO;
    empetyView.backgroundColor = BJCLOLR;
    [self.view addSubview: empetyView];
    
    
    
    NSDictionary *empetyViews = NSDictionaryOfVariableBindings(self.view, empetyView);
    // 添加自动布局规则
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[empetyView]-0-|" options:0 metrics:0 views:empetyViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[empetyView]-0-|" options:0 metrics:0 views:empetyViews]];


    //阴影背景
    maskBgd = [[UIView alloc] initWithFrame:CGRectZero];
    [maskBgd setBackgroundColor:RGBACOLOR(0, 0, 0, 0.3)];
    maskBgd.hidden = YES;
    maskBgd.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationController.view addSubview:maskBgd];

    sureView = [[[UINib nibWithNibName:@"UpdateGoodsCountView" bundle:nil]
             instantiateWithOwner:self options:nil] objectAtIndex:0];
    sureView.hidden = YES;
    sureView.delegate = self;
    sureView.sureBtn.backgroundColor = blueBtn;
    sureView.translatesAutoresizingMaskIntoConstraints = NO;
    [maskBgd addSubview:sureView];
    
    [maskBgd addConstraint:[NSLayoutConstraint constraintWithItem:sureView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:maskBgd
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0]];
    
    [maskBgd addConstraint:[NSLayoutConstraint constraintWithItem:sureView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:maskBgd
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0]];
    
    [maskBgd addConstraint:[NSLayoutConstraint constraintWithItem:sureView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:maskBgd
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0
                                                         constant:300]];
    
    [maskBgd addConstraint:[NSLayoutConstraint constraintWithItem:sureView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:maskBgd
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:0
                                                         constant:177]];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self.view, maskBgd);
    // 添加自动布局规则
    [self.navigationController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[maskBgd]-0-|" options:0 metrics:0 views:views]];
    [self.navigationController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[maskBgd]-0-|" options:0 metrics:0 views:views]];
    
    NSDictionary *views3 = NSDictionaryOfVariableBindings(self.view, _payView);
    constraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_payView(==150)]" options:0 metrics:0 views:views3];
}
//返回购物车页面
- (void)comeBack
{
    [UIView animateWithDuration:0.3 animations:^{
        
        sureView.hidden = YES;
        maskBgd.hidden = YES;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

//显示菜单
- (void)successSumit
{
    [UIView animateWithDuration:0.3 animations:^{
        
        maskBgd.hidden = NO;
        sureView.hidden = NO;
        
    } completion:^(BOOL finished) {
        
  }];
}

#pragma mark ------- CartEmptyDelegate
- (void)goToMall
{
    self.tabBarController.selectedIndex = 1;
}

#pragma mark -------ChangeGoodsCountDelegate
- (void)addGoodsCount:(NSString*)goodsCount
{
    gCount = goodsCount.intValue;
    gCount++;
    sureView.goodsCountField.text = [NSString stringWithFormat:@"%d",gCount];
}
- (void)plusGoodsCount:(NSString*)goodsCount
{
    gCount = goodsCount.intValue;
    if (gCount<2) {
        return;
    }
    gCount--;
    sureView.goodsCountField.text = [NSString stringWithFormat:@"%d",gCount];
}
- (void)cancel
{
    [self comeBack];
}

- (void)sureChoice:(NSString*)goodsCount
{
     CartListGoodsModel *goods = [dataSource objectAtIndex:editCountRow];
    
    // 删除该商品
    if([goodsCount isEqualToString:@"0"])
    {
        [dataSource removeObject:goods];
        [self reloadAllViews];
    }
    else
    {
        // 确认数量被修改
        if(![goods.goods_number isEqualToString:goodsCount])
        {
            goods.goods_number = goodsCount;
            [dataSource replaceObjectAtIndex:editCountRow withObject:goods];
            [self reloadAllViews];
        }
    }
    
    [self comeBack];
}

#pragma mark -------actions
//点击开启和关闭免运费政策窗口
- (IBAction)doShowFreeFeePolicy:(UIButton *)sender {

    if (sender.selected==NO) {
        [_payView removeConstraint:self.feeLoyoutHeight];
        [UIView animateWithDuration:0.5f animations:^{
          //  [_payView layoutIfNeeded];
            [self.view addConstraints:constraints];
            
        }];
        sender.selected = YES;
    }else{
        [self.view removeConstraints:constraints];
        [UIView animateWithDuration:0.5f animations:^{
            
           // [_payView layoutIfNeeded];
            [_payView addConstraint:self.feeLoyoutHeight];

        }];
        sender.selected = NO;
    }
}

//点击选中所有购物车商品计算总价
- (IBAction)doSelectAllGoods:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    self.choiceAllBtn.selected = !btn.selected;
    
    if (_choiceAllBtn.selected==YES) {
        
        [self updateAllGoodsState:YES];
        [self updateAllGoodsCount];
    }else{
        [self updateAllGoodsState:NO];
        [_payBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
    }
    [self.cartTableView reloadData];
    [self updateCartGoodsPrice];
}

-(void)updateAllGoodsState:(BOOL)select
{
    for(int i =0; i<[dataSource count]; i++)
    {
        CartListGoodsModel *model = [dataSource objectAtIndex:i];
        
        if(select == YES)
            model.bSelect = @"1";
        else
            model.bSelect = @"0";
        [dataSource replaceObjectAtIndex:i withObject:model];
    }
    
}

#pragma mark ---- 更新购物车结算商品的数量

-(void)updateAllGoodsCount
{
    NSInteger allCountNum = 0;
    for(CartListGoodsModel *model in dataSource)
    {
        if([model.bSelect isEqualToString:@"1"])
            allCountNum+= model.goods_number.intValue;
    }
    
    [_payBtn setTitle:[NSString stringWithFormat:@"结算(%ld)", allCountNum] forState:UIControlStateNormal];
}

#pragma mark----------------- ShopCartCellDelegate
/**
 *  更新某一行的cell商品数量
 */
-(void)updateGoodsCountWithRow:(NSInteger)row  goodsCount:(NSString*)countStr
{
    editCountRow = row;
    CartListGoodsModel *goods = [dataSource objectAtIndex:row];
    
    sureView.goodsID = goods.rec_id;
    sureView.goodsCountField.text = countStr;
    sureView.originCount = countStr;
    
    
    gCount = countStr.intValue;
    [self successSumit];
}
/**
 *  删除某一行cell
 */
-(void)delGoodsCell:(NSInteger)row
{
    CartListGoodsModel *goods = [dataSource objectAtIndex:row];
    NSArray *arr = [NSArray arrayWithObject:goods.rec_id];
    
    [[TTIHttpClient shareInstance]  deleteCartRequestWithsid:nil
                                                 withcart_id:arr
                                             withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         [dataSource removeObject:goods];
         [self reloadAllViews];
                                                 
                                             } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
    {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
                                             }];
}

/**
 *  选择/取消选择 某一行cell
 *
 *  @param row     cell的行数
 *  @param bSelect 选择的状态
 */
-(void)selectGoodsCell:(NSInteger)row status:(BOOL)bSelect
{
    CartListGoodsModel *model = [dataSource objectAtIndex:row];
    if(bSelect == YES)
        model.bSelect = @"1";
    else
    {
        model.bSelect = @"0";
        _choiceAllBtn.selected = NO;
    }
    
    [dataSource replaceObjectAtIndex:row withObject:model];
    
    [self updateAllGoodsCount];
    [self updateCartGoodsPrice];
    
    __block BOOL bSelectAll = YES;
    [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CartListGoodsModel *info = obj;
        if([info.bSelect isEqualToString:@"0"] || info.bSelect == nil)
        {
            bSelectAll = NO;
        }
    }];
    
    if([dataSource count] == 0)
        bSelectAll = NO;
    
    if(bSelectAll == YES)
        [self doSelectAllGoods:nil];
}

#pragma mark - 结算

- (IBAction)payAction:(UIButton *)sender
{
    if(_cartGoodsPrice.text.floatValue == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选中商品"];
        return;
    }
    
    NSMutableString *deleteIds = [[NSMutableString alloc] init];
    
    for(CartListGoodsModel *model in dataSource)
    {
        if([model.bSelect isEqualToString:@"1"])
        {
            [deleteIds appendFormat:@"%@,", model.rec_id];
        }
    }
    [deleteIds deleteCharactersInRange:NSMakeRange([deleteIds length]-1, 1)];
    [deleteIds insertString:@"[" atIndex:0];
    [deleteIds insertString:@"]" atIndex:deleteIds.length];
    
    [[TTIHttpClient shareInstance] settleCartRequestWithsid:nil withcart_id:deleteIds withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
        SureOderController *SureOderVC = [board instantiateViewControllerWithIdentifier:@"SureOderController"];
        SureOderVC.hidesBottomBarWhenPushed = YES;
        SureOderVC.settleInfo = response.responseModel;
        SureOderVC.goodsIds = deleteIds;
        
        [self.navigationController pushViewController:SureOderVC animated:YES];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
        if(response.error_code.intValue == 10000)
        {
            [self performSelector:@selector(showAddAddressView) withObject:nil afterDelay:1.0];
        }
        
    }];
}

-(void)showAddAddressView
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    AddAddressController *addressVC = [board instantiateViewControllerWithIdentifier:@"AddAddressController"];
    addressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark - 更新购物车商品总价

-(void)updateCartGoodsPrice
{
    float countNum = 0;
    for(CartListGoodsModel *model in dataSource)
    {
        if([model.bSelect isEqualToString:@"1"])
            countNum+= (model.goods_price.floatValue * model.goods_number.intValue);
    }
    
    if(countNum == 0)
        cartDeleteBtn.hidden = YES;
    else
        cartDeleteBtn.hidden = NO;
    
    _cartGoodsPrice.text = [NSString stringWithFormat:@"%.2f", countNum];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"ShoppingCartIdentify";
    
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = BJCLOLR;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    CartListGoodsModel *goods = [dataSource objectAtIndex:indexPath.row];
    cell.goodsInfo = goods;
    
    return cell;
}

- (IBAction)cartDeleteBtnClick:(id)sender {
    
    NSMutableArray *deleteIdArrs = [[NSMutableArray alloc] init];
    NSMutableArray *deleteArrs = [[NSMutableArray alloc] init];
    
    for(CartListGoodsModel *model in dataSource)
    {
        if([model.bSelect isEqualToString:@"1"])
        {
            [deleteIdArrs addObject:model.rec_id];
            [deleteArrs addObject:model];
        }
    }
    
    [[TTIHttpClient shareInstance] deleteCartRequestWithsid:nil withcart_id:deleteIdArrs withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [dataSource removeObjectsInArray:deleteArrs];
        
        if (dataSource.count == 0) {
            
            [self initTableData];
        }
        else
        {
            [self reloadAllViews];
            [self updateAllGoodsCount];
        }
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

@end
