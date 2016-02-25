//
//  SureOderController.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "SureOderController.h"
#import "SureOderCell.h"
#import "PayWayCell.h"
#import "TransportWayCell.h"
#import "OderNoteCell.h"
#import "CommonUtils.h"
#import "InvoiceInfoCell.h"
#import "AddAddressController.h"
#import "AddressListController.h"
#import "GoodsListController.h"
#import "ProvinceSelectView.h"

#import "PaymentViewController.h"
#import "TTIFont.h"

#import "IQKeyboardManager.h"
#import "Masonry.h"
#import "SureOrderPersonCell.h"
#import "PersonMessageCell.h"
typedef enum : NSUInteger {
    GoldNotEnought, // 金币不足
    GoldCantUse, //不可使用金币
    GoldLimitExceeded, // 超出最大限额
} goldStatus;

@interface SureOderController ()<UITableViewDelegate, PayWayCellDelegate, ProvinceSelectViewDelegate, SureOderCellDelegate, InvoiceInfoCellDelegate, UITextViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{
    UIView  *maskView;
    NSInteger  payWayIndex; //选择的支付方式，默认为0
    ShippingObject *selectShip; // 选择的配送方式
    
    ProvinceSelectView *selectView;
    
    IBOutlet UILabel *totalPriceLabel; // 应付金额
    IBOutlet UILabel *orderDespLabel; // 订单完成可获得的金币数
    NSInteger      goldUseCount; // 使用的金币数
    
    CGFloat goodsOriginalPrice; //商品最初的原始价格，判断是否可以使用金币
    
    InvoiceModel  *invoiceInfo; // 选择的发票信息
    NSString  *postscript;//  订单备注
    
    BOOL bShowShipDesp; //是否显示配送方式的描述
    CGFloat  shipDespHeight;
    UILabel  *shipDespLabel;
    
    BOOL bShowInvoiceInfo; //是否开发票的标识
    
    OrderResponseModel *orderDetailInfo; // 记录订单详情的数据
    
    BOOL _wasKeyboardManagerEnabled;
    
    BOOL bEnableAddGold; //是否还可以增加金币
    
    int canUseMinGoldNum; //可以使用的最小金币数 ＝ 都小于自有金币数与最高抵扣数（使金额为0的金币数字）这两个数字中小的那个
    NSString * addressString;//收货人信息地址
    CGFloat CellHeight;
    UIImageView * imageviewLine;
}

@property (nonatomic, strong) UITextField *tempField;

@end

@implementation SureOderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldMoney.textColor = BLACKTEXT;
    self.dingDanDown.textColor = TEXT;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 5;
    [self.sureBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = beijing;
    //改变地址状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:Notify_updateAddressList object:nil];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    if (IOS7)
    {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"1"] stretchableImageWithLeftCapWidth:1 topCapHeight:10]
                                                      forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"1"] stretchableImageWithLeftCapWidth:1 topCapHeight:10]
                                                      forBarMetrics:UIBarMetricsDefault];
    }
    
     NAV_INIT(self, @"确认订单", @"common_nav_back_icon", @selector(back), nil, nil);
    _sureOderTable.backgroundColor = BJCLOLR;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    footerView.backgroundColor = BJCLOLR;
    _sureOderTable.tableFooterView = footerView;
    
    goodsOriginalPrice = _settleInfo.total.goods_price.floatValue - _settleInfo.total.discount.floatValue;
    totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", goodsOriginalPrice];  // 计算商品原始金额
    orderDespLabel.text = @"0个"; //[NSString stringWithFormat:@"%@个", _settleInfo.total.will_get_integral];
    
    invoiceInfo = [[InvoiceModel alloc] init];
    invoiceInfo.need_inv = @"0"; // 默认不开发票
    
    bEnableAddGold = YES;
    
    payWayIndex = -1;
    
    shipDespLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, self.view.frame.size.width-30, CGFLOAT_MAX)];
    shipDespLabel.font = [UIFont systemFontOfSize:15.0];
    shipDespLabel.numberOfLines = 0;
    
    //监听键盘高度变化
    [self addKeyboardNotifications];
    
    // 应付金额 = 商品金额 - 先款优惠 - 使用金币 + 运费   [应付金额不能为负值]
    int userGoldWhenPriceIsZero =  (_settleInfo.total.goods_price.floatValue - _settleInfo.total.discount.floatValue) *_settleInfo.gold.gold_rate.floatValue;
    
    canUseMinGoldNum = _settleInfo.gold.gold_max.intValue < userGoldWhenPriceIsZero ? _settleInfo.gold.gold_max.intValue : userGoldWhenPriceIsZero;
    //在应付金额上添加分割线
    imageviewLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, UIScreenHeight-66, UIScreenWidth, 0.5)];
    imageviewLine.backgroundColor = LINE;
    [self.navigationController.view addSubview:imageviewLine];
//    [self.view addSubview:imageview];
}

#pragma  mark - Keyboard Notifications

- (void)addKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)removeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)willChangeFrameNotification:(NSNotification *)notification
{
    // 获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    [_sureOderTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(self.view).offset(-keyboardRect.size.height);
    }];
    
    CGRect visibleRect  = [_tempField.superview convertRect:_tempField.frame toView:_sureOderTable];
    
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
        if (IOS6) {//ios6下不会自动滚动，需要代码设置
            
            [_sureOderTable scrollRectToVisible:visibleRect
                                             animated:YES];
        }
    }];
}

- (void)willHideKeyboardNotification:(NSNotification *)notification
{
    
    [_sureOderTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(self.view).offset(-66);
    }];
    
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    imageviewLine.hidden = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    imageviewLine.hidden = YES;
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && alertView.tag == 8) //地址
    {
        [self showAddressListView];
    }
    else if (buttonIndex == 1 && alertView.tag ==9)
    {
        [self commitOrderInfoAction];
    }
    else if(alertView.tag ==10)// 提交订单
    {
        if(buttonIndex == 0)
        {
            // 向前返回两层页面
            [self back];
        }
        else
        {
            // 查看订单
            [self showOrderInfoDetail:orderDetailInfo];
        }
    }
}

-(void)initMaskView
{
    // 初始化半透明背景视图
    maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
    [maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.view addSubview:maskView];
    maskView.hidden = YES;
}


// 试用金币提示
-(void)showUseJingBTipsView:(NSString *)content
{
    if(maskView == nil)
        [self initMaskView];
    else
    {
        for(UIView *view in maskView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((maskView.frame.size.width-300)/2, (maskView.frame.size.height-150)/2-64, 300, 150)];
    centerView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:centerView];
    
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 60)];
    lable.numberOfLines = 0 ;
    lable.textAlignment = NSTextAlignmentCenter;
    
    lable.text = content;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 95, 134, 35)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"cart_cancelJb"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hideMaskView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(155, 95, 134, 35)];
    btn2.backgroundColor = beijing;
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
//    [btn2 setBackgroundImage:[UIImage imageNamed:@"cart_sureJb"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(doUseJingBAction:) forControlEvents:UIControlEventTouchUpInside];

    [centerView addSubview:lable];
    [centerView addSubview:btn];
    [centerView addSubview:btn2];
    
    maskView.hidden = NO;
}

/**
 *  选择配送方式
 */
-(void)showSelectView
{
    if(maskView == nil)
        [self initMaskView];
    else
    {
        for(UIView *view in maskView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    selectView = nil;
    selectView = [[[UINib nibWithNibName:@"ProvinceSelectView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    selectView.frame = CGRectMake((MainView_Width -200)/2,( MainView_Height -300)/2, 200, 177);
    selectView.delegate = self;
    selectView.titleLabel.text =@"是否开发票";
    selectView.dataSource = [NSArray arrayWithObjects:@"不开发票", @"开发票", nil];
    selectView.selectViewType = SelectView_PayWayShow;
    
    CGPoint center;
    center.x = maskView.center.x;
    center.y = maskView.center.y - 64;
    selectView.center = center;
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 200, selectView.myFootView.frame.size.height);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hideMaskView) forControlEvents:UIControlEventTouchUpInside];
    
    [selectView.myFootView addSubview:btn];
    
    if( bShowInvoiceInfo== NO)
    {
        selectView.selectRow = 1;
    }
    else if(bShowInvoiceInfo == YES)
    {
        selectView.selectRow = 2;
    }


    [maskView addSubview:selectView];
    maskView.hidden = NO;
}

#pragma mark --- maskView Action
-(void)hideMaskView
{
    maskView.hidden = YES;
}

#pragma ---使用金币
- (IBAction)doUseJingBAction:(UIButton *)sender
{
    [self hideMaskView];
}


#pragma ------------notices

- (void)reloadTableView:(NSNotification*)notice
{
    AddressModel *current = notice.object;
    _settleInfo.consignee = current;
    
    [self.sureOderTable reloadData];
}

#pragma mark - Detail Actions
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 提交订单

- (IBAction)commintOder:(UIButton *)sender
{
    if(_settleInfo.consignee == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写收货地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 8;
        
        [alert show];
        
        return;
    }
    else if (selectShip == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        return;
    }
    
    //是否需要发票 1：需要 0：不需要
    //  发票类型 1：个人  2：单位
    //发票内容 1：详情  2：办公用品
   // 发票抬头信息

    if([invoiceInfo.need_inv isEqualToString:@"1"])
    {
        if(invoiceInfo.inv_type.length == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入发票类型"];
            return;
        }
        else if(invoiceInfo.inv_payee.length == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入发票抬头"];
            return;
        }
        else if (invoiceInfo.inv_content == nil)
        {
            [SVProgressHUD showErrorWithStatus:@"请选择发票内容"];
            return;
        }
    }
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:_settleInfo.confirm delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    // 遍历 UIAlertView 所包含的所有控件
    for (UIView *tempView in alertView.subviews) {
        
        if ([tempView isKindOfClass:[UILabel class]]) {
            // 当该控件为一个 UILabel 时
            UILabel *tempLabel = (UILabel *) tempView;
            
            if ([tempLabel.text isEqualToString:_settleInfo.confirm])
            {
                tempLabel.textColor = [UIColor redColor];
                break;
            }
        }
    }
    
    alertView.tag = 9;
    alertView.delegate =self;
    [alertView show];
}

-(void)commitOrderInfoAction
{
    NSString *payWay;
    if(payWayIndex == 0)
    {
       payWay = @"cod";
    }
    else if (payWayIndex == 1){
         payWay = @"alipay";
    }else{
        payWay = @"weixin";
    }
    
    
    [[TTIHttpClient shareInstance] doneOrderRequestWithsid:nil
                                               withcart_id:_goodsIds
                                            withaddress_id:_settleInfo.consignee.address_id
                                          withpayment_code:payWay
                                           withshipping_id:selectShip.shipping_id
                                            withpostscript:postscript
                                              withintegral:[NSString stringWithFormat:@"%ld", (long)goldUseCount]
                                              withneed_inv:invoiceInfo.need_inv
                                              withinv_type:invoiceInfo.inv_type
                                             withinv_payee:invoiceInfo.inv_payee
                                           withinv_content:invoiceInfo.inv_content withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
         orderDetailInfo = response.responseModel;
         
//         if([payWay isEqualToString:@"alipay"]) //选择在线支付，则进入支付页面
//         {
//             [self showOrderInfoDetail:orderDetailInfo];
//         }
//         else // 选择货到付款
//         {
             UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"恭喜你，订单提交成功！" delegate:self cancelButtonTitle:@"回上一页" otherButtonTitles:@"查看订单", nil];
             view.tag = 10;
             view.delegate =self;
             [view show];
//         }
        
     } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

#pragma mark -- 提交订单后的事件跳转

-(void)showOrderInfoDetail:(OrderResponseModel *)model
{
    PaymentViewController *paymentVC= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    paymentVC.adString = addressString;
    paymentVC.orderInfo = [[OrderDetailModel alloc] init];
    paymentVC.dataInfo = [[OrderListModel alloc] init];
    paymentVC.orderInfo.order_id = model.order_id;
    paymentVC.orderInfo.order_sn = model.order_sn;
    paymentVC.dataInfo.order_sn = model.order_sn;
    paymentVC.orderID = model.order_id;
    
    if ([model.order_amount isEqualToString:@"0.00"]) {
        
        paymentVC.orderInfo.order_status = @"2";
    }
    else{
       paymentVC.orderInfo.order_status = @"1";
    }
    
    if ([model.pay_code isEqualToString:@"cod"]) {
        paymentVC.myTitleString = @"待发货";
    }else{
        paymentVC.myTitleString = @"待付款";
    }
    paymentVC.orderInfo.order_status_test = @"立即支付";
    paymentVC.orderInfo.pay_code = model.pay_code;
    paymentVC.orderInfo.order_amount = model.order_amount;
    
    NSMutableArray *array = [NSMutableArray array];
    
    // 遍历商品
    for (NSDictionary *info in _settleInfo.goods_list) {
        
        CartListGoodsModel *model = [[CartListGoodsModel alloc] initWithDictionary:info error:nil];
        [array addObject:model];
    }
    // 遍历赠品
    for (NSDictionary *info in _settleInfo.gift_list) {
        
        CartListGoodsModel *model = [[CartListGoodsModel alloc] initWithDictionary:info error:nil];
        [array addObject:model];
    }
    //paymentVC.orderInfo.goods_list = _settleInfo.goods_list;
    paymentVC.orderInfo.goods_list = array;
    paymentVC.orderInfo.consignee = _settleInfo.consignee;
    paymentVC.orderInfo.postscript = postscript;
    
    paymentVC.orderInfo.invoice = invoiceInfo;
    
    paymentVC.orderInfo.shipping_fee = _settleInfo.total.shipping_fee;
    paymentVC.orderInfo.goods_amount = _settleInfo.total.goods_price;
    paymentVC.orderInfo.integral_money = _settleInfo.total.integral_money;
    paymentVC.orderInfo.discount = _settleInfo.total.discount;
    
    [self.navigationController pushViewController:paymentVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(bShowInvoiceInfo == YES)
        return 9;
    else
        return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * image = [[UIImageView alloc] init];
    image.backgroundColor = BJCLOLR;
    return image;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        AddressModel * model = _settleInfo.consignee;
        if (model == nil) {
            CellHeight = 80;
            return 80;
        }else{
            CGFloat PersonHeight = [TTIFont calHeightWithText:model.consignee font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth/2];
            NSString * AddString = [NSString stringWithFormat:@"收货地址：%@ %@ %@",model.province_name,model.city_name,model.address];
            CGFloat Height = [TTIFont calHeightWithText:AddString font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth - 70]-40;
            CellHeight = 80+Height+PersonHeight;
            return 80+Height+PersonHeight;
        }
        

        
    }else if (indexPath.row==1)
    {
        return 155;
    }else if (indexPath.row==2)
    {
        return 50+shipDespHeight;
    }else if (indexPath.row==3)
    {
        return 58;
    }else if (indexPath.row==4)
    {
        return 110;
        
    }
    else if (indexPath.row==5)
    {
        return 115;
    }
    else if (indexPath.row==6)
    {
        return 165;
    }else if (indexPath.row==7)
    {
        return 50;
    }
    else if (indexPath.row == 8)
    {
        return  145;
    }
    return 0;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /**
     *  选择不同的配送方式
     */
    if(tableView == selectView.myTableView)
    {
        if(indexPath.row == 0)
        {
            bShowInvoiceInfo = NO;
            invoiceInfo.need_inv = @"0";
        }
        else
        {
            bShowInvoiceInfo = YES;
            invoiceInfo.need_inv = @"1";
        }
        
        [self.sureOderTable reloadData];
        [self hideMaskView];
        
        if(bShowInvoiceInfo == YES)
            [self.sureOderTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        return;
    }
    
    if (indexPath.row==0)
    {
        [self showAddressListView];
        
    }
    // 配送方式
    else if (indexPath.row==2)
    {
        [self showShipingDescpView:bShowShipDesp];
       
    }else if (indexPath.row==3)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
        GoodsListController *goodsListVC = [board instantiateViewControllerWithIdentifier:@"GoodsListController"];
        goodsListVC.goodsArr = _settleInfo.goods_list;
        goodsListVC.giftsArr = _settleInfo.gift_list;
        
        [self.navigationController pushViewController:goodsListVC animated:YES];
        
    }else if (indexPath.row==4)
    {
       
    }else if (indexPath.row==5)
    {
        
    }else if (indexPath.row==6)
    {
        
    }else if (indexPath.row==7)
    {
        [self showSelectView];
    }

}

#pragma  mark --- 编辑金币框  UITextField Delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self changeGoldNum:textField.text.intValue];
    [_sureOderTable performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    return YES;
}

#pragma mark --- 展示配送方式的描述文字
-(void)showShipingDescpView:(BOOL)bShow
{
    bShowShipDesp = !bShowShipDesp;
    if(bShowShipDesp && selectShip != nil)
    {
        shipDespLabel.text = selectShip.shipping_desc;
        shipDespLabel.textColor = BLACKTEXT;
        CGFloat height = [TTIFont calHeightWithText:shipDespLabel.text font:shipDespLabel.font limitWidth:self.view.frame.size.width-30];
        CGRect rect = shipDespLabel.frame;
        rect.origin.y = 63;
        rect.size.height = height;
        shipDespLabel.frame = rect;
        shipDespHeight = height+20;
    }
    else
    {
        bShowShipDesp = NO;
        [shipDespLabel removeFromSuperview];
        shipDespHeight = 0;
    }
    
    [self.sureOderTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
/**
 *  显示购物车地址列表
 */
-(void)showAddressListView
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    AddAddressController * address = [board instantiateViewControllerWithIdentifier:@"AddAddressController"];
//    addressVC.bEdit = NO;
    AddressListController *addressVC = [board instantiateViewControllerWithIdentifier:@"AddressListController"];
   
    if(_settleInfo.consignee == nil)
    {
       [self.navigationController pushViewController:address animated:YES];
    }else{
         [self.navigationController pushViewController:addressVC animated:YES];
    }
   
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)  // 收货人地址信息
    {
        static NSString * first = @"first";
        PersonMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:first];
        if (cell  == nil) {
            cell = [[PersonMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:first];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        AddressModel * model = _settleInfo.consignee;
        [cell initWithModel:model withAdressString:nil];
        [cell upDateCellWith:CellHeight];
        return cell;

        
    }else if (indexPath.row==1) // 收货人支付方式
    {
        static NSString *SimpleTableIdentifier = @"PayWayCell";
        PayWayCell*cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[[UINib nibWithNibName:@"PayWayCell" bundle:nil]
                     instantiateWithOwner:self options:nil] objectAtIndex:0];
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, UIScreenWidth, 0.5)];
            imageView.backgroundColor = LINE;
            [cell.payMarginView addSubview:imageView];
        }
        cell.payMarginView.backgroundColor = BJCLOLR;
        
        cell.delegate = self;
        [cell setPayment:_settleInfo.payment_list];
        if(payWayIndex == 0)
        {
            cell.codBtn.selected = YES;
            cell.alipayBtn.selected = NO;
            cell.weiXinBtn.selected = NO;
        }
        else if (payWayIndex == 1)
        {
            cell.codBtn.selected = NO;
            cell.alipayBtn.selected = YES;
            cell.weiXinBtn.selected = NO;
        }else if (payWayIndex == 2){
            cell.codBtn.selected = NO;
            cell.alipayBtn.selected = NO;
            cell.weiXinBtn.selected = YES;
        }
        return cell;
    }
    else if (indexPath.row==2) // 收货人配送方式
    {
        static NSString *SimpleTableIdentifier = @"TransportWayCell";
        TransportWayCell*cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[[UINib nibWithNibName:@"TransportWayCell" bundle:nil]
                     instantiateWithOwner:self options:nil] objectAtIndex:0];
        }
        cell.transportMarginView.backgroundColor = BJCLOLR;
        cell.transportMarginView.layer.borderColor = LINE.CGColor;
        cell.transportMarginView.layer.borderWidth = 0.5;
        cell.titleLabel.text = @"配送方式:";
        
        if(selectShip != nil)
            cell.contentLabel.text = selectShip.shipping_name;
        
        if(bShowShipDesp == YES)
        {
            [cell.contentView addSubview:shipDespLabel];
        }
        
        return cell;
    }
    else if (indexPath.row==3) // 查看商品清单
    {
        SureOderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        
        cell.actionName.text = @"查看商品清单";
        cell.actionName.textColor = BLACKTEXT;
//        cell.actionName.font = [UIFont systemFontOfSize:15.0];
        return cell;
    }
    else if (indexPath.row==4) // 订单备注
    {
        static NSString *SimpleTableIdentifier = @"OderNoteCell";
        OderNoteCell*cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[[UINib nibWithNibName:@"OderNoteCell" bundle:nil]
                     instantiateWithOwner:self options:nil] objectAtIndex:0];
        }
        cell.noteMarginView.backgroundColor = BJCLOLR;

        cell.noteTextView.delegate = self;
        
        if(postscript.length != 0)
            cell.noteTextView.text = postscript;
        
        return cell;
    }
    else if (indexPath.row==5) //使用金币
    {
        SureOderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFour"];
        cell.goldCountTextFiled.delegate = self;
        
        cell.delegate = self;
        cell.canUseGoldLabel.text = _settleInfo.gold.gold_num;
        cell.goldCountTextFiled.text =[NSString stringWithFormat:@"%ld", (long)goldUseCount];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else if (indexPath.row==6) // 商品金额
    {
        SureOderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        
        cell.goodsPriceLabel.text =[NSString stringWithFormat:@"￥%.2f", _settleInfo.total.goods_price.floatValue]; // 商品金额
        cell.goodsDiscountLabel.text =[NSString stringWithFormat:@"-￥%.2f",_settleInfo.total.discount.floatValue]; // 先款优惠
        cell.goodsDeductionLabel.text =[NSString stringWithFormat:@"-￥%.2f", _settleInfo.total.integral_money.floatValue]; // 金币抵扣
        cell.goodsFreightLabel.text = [NSString stringWithFormat:@"￥%.2f",_settleInfo.total.shipping_fee.floatValue]; // 运费
        
        return cell;
    }
    else if (indexPath.row== 7) // 发票信息
    {
        TransportWayCell*cell = [tableView dequeueReusableCellWithIdentifier:@"TransportWayCell"];
        
        if (cell == nil)
        {
            cell = [[[UINib nibWithNibName:@"TransportWayCell" bundle:nil]
                     instantiateWithOwner:self options:nil] objectAtIndex:0];
            if(bShowInvoiceInfo == NO)
            {
                UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,49.5, UIScreenWidth, 0.5)];
                lineView.backgroundColor = LINE;
                [cell addSubview:lineView];
            }else{
                cell.contentLabel.text = @"开发票";
            }

        }
        cell.transportMarginView.backgroundColor = BJCLOLR;
        cell.transportMarginView.layer.borderColor = LINE.CGColor;
        cell.transportMarginView.layer.borderWidth = 0.5;

        
        cell.titleLabel.text = @"发票类型:";
        cell.contentLabel.textColor = BLACKTEXT;
        
        if(bShowInvoiceInfo)
        {
            cell.contentLabel.text = @"开发票";
        }else{
            cell.contentLabel.text = @"不开发票"; 
        }
        
        return cell;

    }
    else
    {
        InvoiceInfoCell *invoiceCell = [[[UINib nibWithNibName:@"InvoiceInfoCell" bundle:nil]
                                         instantiateWithOwner:self options:nil] objectAtIndex:0];
        invoiceCell.invoiveMarginView.backgroundColor = BJCLOLR;
        invoiceCell.delegate = self;
        
        if([invoiceInfo.inv_type isEqualToString:@"1"])
        {
            invoiceCell.personalBtn.selected = YES;
            invoiceCell.InvoiceTextFiled.text = @"个人";
            invoiceCell.InvoiceTextFiled.enabled = NO;
        }
        else if ([invoiceInfo.inv_type isEqualToString:@"2"])
        {
            invoiceCell.companyBtn.selected = YES;
            invoiceCell.InvoiceTextFiled.enabled = YES;
            if(invoiceInfo.inv_payee.length != 0)
                invoiceCell.InvoiceTextFiled.text = invoiceInfo.inv_payee;
        }
        
        if([invoiceInfo.inv_content isEqualToString:@"1"])
            invoiceCell.productDetailsBtn.selected = YES;
        else if ([invoiceInfo.inv_content isEqualToString:@"2"])
            invoiceCell.officeBtn.selected = YES;
        
        return  invoiceCell;
    }
    
    return nil;
}

#pragma mark -- UITextView Delegate  // 订单备注信息修改

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView.text.length != 0)
        postscript = textView.text;
    
    return YES;
}
#pragma mark - 根据配送方式更新view

-(void)updateInfoByShipWay
{
    NSString *payWay;
    if(payWayIndex == 0)
    {
        payWay = @"cod";
    }
    else if(payWayIndex == 1){
       payWay = @"alipay";
    }else if (payWayIndex == 2){
        payWay = @"weiXin";
    }
    

    [[TTIHttpClient shareInstance] calculateOrderRequestWithsid:nil
                                                    withcart_id:_goodsIds
                                                 withaddress_id:_settleInfo.consignee.address_id
                                               withpayment_code:payWay
                                                withshipping_id:selectShip.shipping_id
                                                withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        
        _settleInfo.total.discount = [response.result objectForKey:@"discount"];
        _settleInfo.total.shipping_fee = [response.result objectForKey:@"shipping_fee"];
        
        goodsOriginalPrice = _settleInfo.total.goods_price.floatValue - _settleInfo.total.discount.floatValue;
        
        // 应付金额 = 商品金额 - 先款优惠 - 使用金币 + 运费   [应付金额不能为负值]
        int userGoldWhenPriceIsZero =  (_settleInfo.total.goods_price.floatValue - _settleInfo.total.discount.floatValue) *_settleInfo.gold.gold_rate.floatValue;
        
        canUseMinGoldNum = _settleInfo.gold.gold_max.intValue < userGoldWhenPriceIsZero ? _settleInfo.gold.gold_max.intValue : userGoldWhenPriceIsZero;
        
        
        [self updateGoodsTotalPrice];
        
        if(goldUseCount > 0 && payWayIndex == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"货到付款订单无法使用金币抵扣"];
            
            // 清空使用的金币数
            SureOderCell *cell = (SureOderCell *)[_sureOderTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            goldUseCount = 0;
            cell.goldCountTextFiled.text = @"0";
            _settleInfo.total.integral_money =[NSString stringWithFormat:@"%.2f", goldUseCount/_settleInfo.gold.gold_rate.floatValue]; //计算金币抵扣的金额
            [self updateGoodsTotalPrice];
        }
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
    {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
    
   
}

#pragma mark --- InvoiceInfoCell  Delegate <NSObject>
/**
 *  选择发票类型
 *
 *  @param type 1：个人  2：单位
 */
-(void)selectInvoiceType:(NSString *)type
{
    invoiceInfo.inv_type = type;
    if([type isEqualToString:@"1"])
        invoiceInfo.inv_payee = @"个人";
    else if([type isEqualToString:@"2"])
        invoiceInfo.inv_payee = @"";

    [_sureOderTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/**
 *  发票内容
 *
 *  @param type 1：商品详情  2：办公用品
 */
-(void)selectInvoiceContent:(NSString *)type
{
    invoiceInfo.inv_content = type;
}

/**
 *  发票抬头
 *
 *  @param text 抬头信息
 */
-(void)updateInvoiceText:(NSString *)text
{
    invoiceInfo.inv_payee = text;
}

#pragma mark ---  PayWayCell  Delegate <NSObject>

/**
 *  选择支付方式
 *
 *  @param index 0：cod  1：alipay 2:微信
 */
-(void)didSelectPayWay:(NSInteger)index
{
    if(bShowShipDesp)
        [self showShipingDescpView:bShowShipDesp];
    
    if(_settleInfo.consignee == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写收货地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 8;
        
        [alert show];
        
        payWayIndex = -1;
        [_sureOderTable reloadData];
    }
    else
    {
        payWayIndex = index;
        if (index == 2) {
            index = 1;
        }
        if([_settleInfo.shipping_list count] > index)
            selectShip = [_settleInfo.shipping_list objectAtIndex:index];
        else
        {
            selectShip = nil;

        }
        
        [self updateInfoByShipWay];
    }
   
}

#pragma mark ---  SureOderCell  Delegate <NSObject>

#pragma mark -- 修改使用金币数
/**
 *  修改使用金币数
 *
 *  @param num 修改后的值
 */
-(void)changeGoldNum:(NSInteger )num
{
 
    if(bEnableAddGold == NO && num > goldUseCount)
    {
         [SVProgressHUD showErrorWithStatus:@"已达到订单使用金币最高限额"];
        return;
    }
    
    if(payWayIndex < 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        
        return;
    }
    else if(payWayIndex == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"货到付款订单无法使用金币抵扣"];
        return;
    }
    else if(num < 0)
    {
        return;
    }
    
    // 商品金额低于使用条件，－》不可使用金币
    if(goodsOriginalPrice < _settleInfo.gold.order_min.intValue)
    {
        [self showUseJingBTipsView:@"抱歉,本次使用金币数未达到消费金额"];
        return;
    }
    // 用户金币不足＝》提示无法使用 ||  用户金币超过使用金币使订单金额为0 的情况＝》提示无法使用
    else if (num> _settleInfo.gold.gold_num.intValue || num > canUseMinGoldNum)
    {
        
        if(canUseMinGoldNum > _settleInfo.gold.gold_num.intValue)
        {
            [self showUseJingBTipsView:@"抱歉,您的现有金币数不足!"];
            num = _settleInfo.gold.gold_num.intValue;
        }
        else
        {
            NSString *content =[NSString stringWithFormat:@"不能超过最大使用限额%d", canUseMinGoldNum];
            num = canUseMinGoldNum;
            [self showUseJingBTipsView:content];
        }
    }
    
  
    // 更新使用的金币数
    SureOderCell *cell = (SureOderCell *)[_sureOderTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    goldUseCount = num;
    cell.goldCountTextFiled.text = [NSString stringWithFormat:@"%ld", (long)num];
    
    _settleInfo.total.integral_money =[NSString stringWithFormat:@"%.2f", goldUseCount/_settleInfo.gold.gold_rate.floatValue]; //计算金币抵扣的金额
    
    [self updateGoodsTotalPrice];
}

-(void)updateGoodsTotalPrice
{
    // 应付金额 = 商品金额 - 先款优惠 - 使用金币 + 运费   [应付金额不能为负值]
    CGFloat totalNum = _settleInfo.total.goods_price.floatValue - _settleInfo.total.discount.floatValue -_settleInfo.total.integral_money.floatValue + _settleInfo.total.shipping_fee.floatValue;
    if(totalNum < 0)
    {
        bEnableAddGold = NO;
        totalNum = 0;
    }
    else
    {
        bEnableAddGold = YES;
    }
    
    totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", totalNum];
    
    if(payWayIndex == 0) //payWay = @"cod";
    {
        _settleInfo.total.will_get_integral = @"0";
        orderDespLabel.text = @"0个";
    }
    else if(payWayIndex == 1 || payWayIndex == 2) //payWay = @"alipay";
    {
        if(totalPriceLabel.text.floatValue > _settleInfo.total.app_gold_give_min.floatValue)
        {
            int count = totalPriceLabel.text.intValue * _settleInfo.total.app_gold_order.intValue;
            _settleInfo.total.will_get_integral = [NSString stringWithFormat:@"%d", count];
            orderDespLabel.text =[NSString stringWithFormat:@"%d个", count];
        }
        else
        {
            _settleInfo.total.will_get_integral = @"0";
            orderDespLabel.text = @"0个";
        }
    }
    
    [_sureOderTable reloadData];
}

@end
