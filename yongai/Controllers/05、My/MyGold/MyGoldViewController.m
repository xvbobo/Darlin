//
//  MyGoldViewController.m
//  Yongai
//
//  Created by myqu on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyGoldViewController.h"
#import "GoldHomeCell.h"
#import "GoldFigureCell.h"
#import "GoldCustomViewController.h"
#import "GoldRuleViewController.h"
#import "QFControl.h"
#import "HisTopicViewController.h"
#import "ExchangeCenterViewController.h"
#import "MyOrderListViewController.h"
#import "SendGoldListViewController.h"
#import "MallNavViewController.h"
#import "MallViewController.h"
#import "MingxiCell.h"
#import "JiBITableViewCell.h"
@interface MyGoldViewController ()<GoldFigureCelldelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *myTableView;
    MyGoldViewController * MG;
    // tableviewheader 控件
    NSString * jinBiString;
    UILabel *mallDesLabel; // 商城购物描述的label
    UITableView * tabelViewMing;
    GoldModel *goldInfo;
    NSMutableArray * mingXiArr;
    BOOL jinBI;
    int page;
    UIImageView * headView;
    NSInteger cellNumber;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
    BOOL isfirst;
}
// 金币规则
- (IBAction)showGoldRuleBtnClick:(id)sender;

@end

@implementation MyGoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    jinBI = YES;
    isfirst = YES;
    page = 1;
    mingXiArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = BJCLOLR;
    [self createSletment];
    if (self.myTitle) {
        tabelViewMing = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UIScreenWidth, UIScreenHeight-64*2-1)];
    }else {
    tabelViewMing = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UIScreenWidth, UIScreenHeight-64 - 115)];
    }
    tabelViewMing.separatorStyle = UITableViewCellSeparatorStyleNone;
    headView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 10, UIScreenWidth, 54)];
    headView.layer.borderColor = LINE.CGColor;
    headView.layer.borderWidth = 0.5;
    [self createHeadView];
    headView.hidden = YES;
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    tabelViewMing.dataSource = self;
    tabelViewMing.delegate = self;
    tabelViewMing.backgroundColor = BJCLOLR;
    tabelViewMing.hidden = YES;
    
   
    UILabel * label = [QFControl createLabelWithFrame:CGRectMake(10,5, 100, 20) text:@"金币任务"];
    label.textColor = [UIColor whiteColor];
    [self.goldTask addSubview:label];
   
    [self addRefreshView];
    [self initTableViewData];
     [self requestViewData];

    
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [tabelViewMing addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        if (jinBI == NO) {
            [weakSelf refreshComments];
        }
        
    }];
    
    //上拉加载更多
    footerView = [tabelViewMing addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
//                [weakSelf loadMoreComments];
    }];
    
    //自动刷新
    footerView.autoLoadMore = YES;
}
#pragma mark -- 监听滚动事
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

   
    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height)
    {
        if (jinBI == NO) {
             [self loadMoreComments];
        }
       
        
    }
    
    
    
}

- (void)createSletment
{
    UIFont * font = [UIFont systemFontOfSize:16];
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"金币",@"明细",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0.0, 0.0, 170, 30.0);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  font,UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [segmentedControl addTarget:self  action:@selector(segmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];

    
    
}
- (void)segmentedControl:(UISegmentedControl *)sg
{
    switch (sg.selectedSegmentIndex) {
        case 0:
            myTableView.hidden = NO;
            tabelViewMing.hidden = YES;
            headView.hidden = YES;
            jinBI = YES;
//            [tabelViewMing removeFromSuperview];
            [self requestViewData];
            break;
            case 1:
            
            myTableView.hidden = YES;
            tabelViewMing.hidden = NO;
            headView.hidden = NO;
            jinBI = NO;
            [self.view addSubview:tabelViewMing];
            [self createRequsetWithPage:page];
            break;
        default:
            break;
    }
}
- (void)createHeadView
{
    int with = (UIScreenWidth - 40)/2-20;
    NSArray * nameArr = @[@"日期",@"操作",@"数量"];
    for (int i = 0;i<3; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20+i*with, 10, 40, 30)];
        label.text = nameArr[i];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = TEXTCOLOR;
        [headView addSubview:label];
    }
}
#pragma mark -- 明细请求
- (void)createRequsetWithPage:(int)page
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] goldMingxiRequestWithtype:[NSString stringWithFormat:@"%d",page] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        NSMutableArray * array = [response.result objectForKey:@"result"];
        NSMutableArray * array1 = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in array) {
            if (![[dict objectForKey:@"gold_num"]isEqualToString:@"+0"]) {
                [array1 addObject:dict];
            }
        }
        if (page == 1) {
            [mingXiArr removeAllObjects];
        }
        if (array.count == 0) {
            [headerView endRefresh];
            [footerView endRefresh];
            return ;
        }
        
        [mingXiArr addObjectsFromArray:array1];
        cellNumber = mingXiArr.count;
        [tabelViewMing reloadData];
        [headerView endRefresh];
        [footerView endRefresh];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [footerView endRefresh];
    }];
}

- (void)refreshComments{
    
    page= 1;
    [self createRequsetWithPage:page];
   
}

- (void)loadMoreComments{
    
    page ++;
    [self createRequsetWithPage:page];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MG viewWillAppear:animated];
    [[TTIHttpClient shareInstance] nowGoldRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        g_userInfo.pay_points = response.responseModel;
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
    }];
    [myTableView reloadData];
//    [self requestViewData];
}



-(void)initTableViewData
{
    NAV_INIT(self,nil, @"common_nav_back_icon", @selector(backAction), nil, nil);
    myTableView.backgroundColor = BJCLOLR;
    
//    [self addTableFooterView];
}

-(void)requestViewData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] goldruleRequestWithtype:@"1"
                                           withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
                                               jinBiString = [response.result objectForKey:@"rank_gold"];
                                               goldInfo = response.responseModel;
                                               [myTableView reloadData];
                                               
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        return ;
    }];
}

-(NSString *)getImgByName:(NSString *)titleName
{
    if([titleName isEqualToString:@"完善个人资料"])
    {
        return  @"goldCell_0";
    }
    else if ([titleName isEqualToString:@"每日签到"])
    {
        return  @"goldCell_1";
    }
    else if ([titleName isEqualToString:@"邀请好友"])
    {
        return  @"goldCell_2";
    }
    else if ([titleName isEqualToString:@"商城购物"])
        
        return  @"goldCell_6";
    
    else if ([titleName isEqualToString:@"商品评价"])
        return @"goldCell_3";
    
    else  if([titleName isEqualToString:@"话题加精华"])
            return  @"goldCell_5";
    
    else
            return  @"goldCell_4";

}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (jinBI == YES) {
        if (indexPath.section == 0) {
            if ([g_userInfo.rank_name isEqualToString:@"高级会员"]) {
                return 150;
            }else{
                return 180;
            }
            
        }else if(indexPath.section == 1)
        {
            if(indexPath.row == [goldInfo.rule_list count])
                return 40;
            else
                return 44;
        }
        else{
          return 120;
        }
        
    }else {
        return 40;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (jinBI == YES) {
        return 3;
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (jinBI == YES) {
        if (section == 1) {
            return 31;
        }else if(section == 2 && goldInfo.gold_list.count != 0)
            return 31;
        else
            return 0;
    }else{
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 31)];
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 229, 31)];
    imageV.image = [UIImage imageNamed:@"goldTask"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 31)];
    label.text = @"收礼排行榜";
    label.textColor = [UIColor whiteColor];
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+30, 5, 60, 20)];
    label2.textColor = RGBACOLOR(245, 254, 0, 1);
    label2.text = @"查看所有";
    label2.font = [UIFont systemFontOfSize:13];
    [imageV addSubview:label2];
    [imageV addSubview:label];
    [view addSubview:imageV];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 13, 229, 31);
    [button addTarget:self action:@selector(showSendGoldPersonList) forControlEvents:UIControlEventTouchUpInside];
    
    if(section == 2 && goldInfo.gold_list.count != 0)
    {
       [view addSubview:button];
        return view;
 
    }else if(section == 1)
    {
        label.text = @"金币任务";
        label2.hidden = YES;
        imageV.frame = CGRectMake(0,5, 100, 31);
        return view;
    }
    else
    {
        return nil;
    }
    
}

// 查看收礼排行榜
- (void)showSendGoldPersonList {
    
    SendGoldListViewController *sendGoldVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"SendGoldListViewController"];
    sendGoldVC.userId = g_userInfo.uid;
    [self.navigationController pushViewController:sendGoldVC animated:YES];
}


#pragma mark ---  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    if (jinBI == YES) {
        if (section ==  0) {
            return 1;
        }else if(section == 1)
            return [goldInfo.rule_list count] + 1; //8;
        else
        {
            NSInteger last = goldInfo.gold_list.count%3;
            if(last == 0)
                return goldInfo.gold_list.count/3;
            else
                return goldInfo.gold_list.count/3+1;
        }

    }else {
        return mingXiArr.count;
        
       
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (jinBI == YES) {
        if (indexPath.section == 0) {
            NSString * strCell = @"cell";
            JiBITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strCell];
            if (cell == nil) {
                cell = [[JiBITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
                [cell.changeBtn addTarget:self action:@selector(exchangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            if (g_userInfo.pay_points) {
                cell.jinbiLabel.text = g_userInfo.pay_points;
            }
            
        if (![g_userInfo.rank_name isEqualToString:@"高级会员"]) {
            cell.chajuLabel.hidden = NO;
            int a = jinBiString.intValue;
            int b = g_userInfo.pay_points.intValue;
            NSString * cha = [NSString stringWithFormat:@"%d",abs(a - b)];
            NSString * str = [NSString stringWithFormat:@"您距离升级为皇冠会员，还差%@个金币",cha];
            
            NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:str];
            NSRange redRange = NSMakeRange(str.length-3-cha.length, 3);
            [string1 addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(253,222,15, 1) range:redRange];
            
            [cell.chajuLabel setAttributedText:string1];
        }else{
            cell.chajuLabel.hidden = YES;
        }
            return cell;
        }else if(indexPath.section == 1 && indexPath.row != [goldInfo.rule_list count] )
        {
        GoldRuleModel *rule = [goldInfo.rule_list objectAtIndex:indexPath.row];
        
        static NSString *GoldHomeCellIdentifier = @"GoldHomeCell";
        GoldHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:GoldHomeCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       
        if ([rule.name isEqualToString:@"publish"]) {
            cell.cellNameLabel.text = @"发布话题";
            cell.cellImgView.image =  [UIImage imageNamed:[self getImgByName:rule.name]];
        }else{
            cell.cellNameLabel.text = rule.name;
            cell.cellImgView.image =  [UIImage imageNamed:[self getImgByName:rule.name]];
        }
        cell.cellNameLabel.textColor = RGBACOLOR(108, 97, 85, 1);
        cell.goldNumLabel.text = rule.num;
        cell.ratioLabel.text =[NSString stringWithFormat:@"%@/%@", rule.completed, rule.total];
        cell.ratioLabel.textColor = RGBACOLOR(108, 97, 85, 1);
        if([rule.name isEqualToString:@"商品评价"])
        {
            cell.ratioLabel.text = @"";
        }
        else if ([rule.name isEqualToString:@"商城购物"])
        {
            cell.ratioLabel.text = @"";
            cell.goldNumLabel.text =@"";
        }
        else if ([rule.name isEqualToString:@"话题加精华"])
        {
            cell.ratioLabel.text =@"";
        }
        else if ([rule.name isEqualToString:@"泡友榜排行前50"])
        {
            cell.ratioLabel.text =@"";
        }
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == [goldInfo.rule_list count])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [mallDesLabel removeFromSuperview];
        mallDesLabel = nil;
        
        mallDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 10, myTableView.frame.size.width-30, 21)];
        if ( goldInfo.app_gold_order) {
             mallDesLabel.hidden = NO;
            mallDesLabel.text =[NSString stringWithFormat: @"(在线支付的订单完成后，每1元送%@金币)", goldInfo.app_gold_order];
        }else{
            mallDesLabel.hidden = YES;
        }
        
        mallDesLabel.font = [UIFont systemFontOfSize:14.0];
        mallDesLabel.textColor = TEXT;
        [cell.contentView addSubview:mallDesLabel];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    else
    {
        static NSString *GoldFigureCellIdentifier = @"GoldFigureCell";
        GoldFigureCell * cell = [tableView dequeueReusableCellWithIdentifier:GoldFigureCellIdentifier];
        if(cell == nil)
        {
            cell = [[GoldFigureCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GoldFigureCellIdentifier];
        }
        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate =self;
        if (goldInfo.gold_list.count != 0&& isfirst == YES) {
            [cell createCellWithArray:goldInfo.gold_list];
            isfirst = NO;
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;

    }
    }else{
        static NSString * strMing = @"mingXi";
        MingxiCell * cell = [tableView dequeueReusableCellWithIdentifier:strMing];
        if (cell == nil) {
            cell = [[MingxiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMing];
        }
        NSDictionary * dict = [mingXiArr objectAtIndex:indexPath.row];
        if (![[dict objectForKey:@"gold_num"] isEqualToString:@"+0"]) {
            [cell cellWithModel:dict];
        }
        
        return cell;
    }
    
    return nil;
}
- (void)createUpCell
{
//    myHeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//    myHeadImgView.center = self.backView.center;
//    myHeadImgView.layer.masksToBounds = YES;
//    myHeadImgView.layer.cornerRadius = myHeadImgView.frame.size.width/2;
//    [myHeadImgView setImageWithURL:[NSURL  URLWithString:[NSString stringWithFormat:@"%@",g_userInfo.user_photo]]  placeholderImage:[UIImage  imageNamed:Default_UserHead]];
//    [self.backView addSubview:myHeadImgView];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (jinBI == YES) {
        if (indexPath.section == 0) {
            return;
        }
    if(indexPath.row == [goldInfo.rule_list count] || indexPath.section == 2)
        return;
    
//    GoldViewType_Personal= 1,  // 完善个人资料
//    GoldViewType_Attendance,   //每日签到
//    GoldViewType_Invite,       //邀请好友
//    GoldViewType_Ranking,      //泡友排行榜
//    GoldViewType_Topic,        //话题加精华
//    GoldViewType_Mall,         //商城购物
//    GoldViewType_Evaluation,   //商品评价
    
    GoldCustomViewType type;
    
    GoldRuleModel *rule = [goldInfo.rule_list objectAtIndex:indexPath.row];
//    if([rule.name isEqualToString:@"完善个人资料"])
//    {
////        type = GoldViewType_Personal;
//    }
//    else if ([rule.name isEqualToString:@"每日签到"])
//    {
////        type = GoldViewType_Attendance;
//    }
//    else if ([rule.name isEqualToString:@"邀请好友"])
//    {
////        type = GoldViewType_Invite;
//    }
//    else if ([rule.name isEqualToString:@"商城购物"])
//    {
////        type = GoldViewType_Mall;
//    }
//    else
    if ([rule.name isEqualToString:@"商品评价"])
    {
//        type = GoldViewType_Evaluation;
        
        // 我的订单
        MyOrderListViewController *orderVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MyOrderListViewController"];
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        return;
    }
    else // 泡友排行榜
    {
//        type = GoldViewType_Ranking;
    }
    
    GoldCustomViewController *customVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GoldCustomViewController"];
    customVC.bFromCircle = _bFromBubbleCircle;
    customVC.imgTagName = [self getImgByName:rule.name];
    customVC.ruleInfo = [goldInfo.rule_list objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:customVC animated:YES];
    }
}

#pragma mark ---  Button Action

- (void)exchangeBtnClick:(UIButton*)sender
{
    ExchangeCenterViewController *exchangeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExchangeCenterViewController"];
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

- (IBAction)showGoldRuleBtnClick:(id)sender
{
    GoldRuleViewController *ruleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"GoldRuleViewController"];
    ruleVC.type = ExplainType_GoldRule;
    ruleVC.content = goldInfo.gold_rule;
    [self.navigationController pushViewController:ruleVC animated:YES];
}

#pragma mark ---  GoldFigureCell delegate

// 跳转到他人个人中心页面
-(void)gotoOthersCenterWithbuttonIndex:(NSInteger)index;
{
    HisTopicViewController *others = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
    others.userId = [NSString stringWithFormat:@"%ld",index];;
    [self.navigationController pushViewController:others animated:YES];
    
    
}

@end
