//
//  MyViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-10-27.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyViewController.h"
#import "MyInfoLoginedCell.h"
#import "MyCell.h"
#import "CommonUtils.h"
#import "LoginNavViewController.h"
#import "MyColViewController.h"
#import "KeFuViewController.h"
#import "MyGoldViewController.h"
#import "MyAttentionViewController.h"
#import "MyMessageViewController.h"
#import "MyTopicViewController.h"
#import "SettingViewController.h"
#import "MyOrderListViewController.h"
#import "MyInfoViewController.h"
#import "ExchangeCenterViewController.h"
#import "TieBaViewController.h"
#import "MyRankViewController.h"
#import "MyOrderViewCell.h"//我的订单cell
#import "ShouHouViewController.h"//售后服务
#import "NewOrderListController.h"
@interface MyViewController ()<loginDelegate,MyOrderViewCellDelegate>
{
    UIView *_maskView;
    BOOL YN;
    BOOL if_new_chat;
    NSDictionary * listDict;
    UIImageView * shezhiView;
    NSUserDefaults * UD;
    NSString * addTime;
    BOOL red;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YN = NO;
    red = NO;
    UD = [NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.barTintColor = beijing;
    shezhiView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
    shezhiView.backgroundColor = BJCLOLR;
    shezhiView.layer.borderColor = LINE.CGColor;
    shezhiView.layer.borderWidth = 0.5;
    // Do any additional setup after loading the view.
   //order/type_list  page  user_id  order_type
    _myTableView.tableFooterView.backgroundColor = BJCLOLR;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self loadBaseUI];
//    [self getMyOderList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginState) name:Notify_updateLoginState object:nil];

}
- (void)getMyOderList
{
    if(g_userInfo.loginStatus.intValue == 1){
        [[TTIHttpClient shareInstance] MyOrderList:g_userInfo.uid withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            //        listArr = response.result objectForKey:@""
            
            listDict = response.result;
            [self.myTableView reloadData];
            NSLog(@"%@",response.result);
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
        }];
    }else{
        listDict = nil;
    }
    

}
- (void)viewWillAppear:(BOOL)animated{
    
    MyViewController * MV;
    [super viewWillAppear:animated];
    [MV viewWillAppear:animated];
    selectedIndex = 4;
    [self getUserInfo];
    [self getMyOderList];
    g_LoginStatus = g_userInfo.loginStatus.intValue;
    // 更新用户信息
    [self.myTableView reloadData];
}

-(void)getUserInfo
{
    if(g_userInfo.loginStatus.intValue == 1)
    {
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[TTIHttpClient shareInstance] userInfoRequestWithsid:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
//
            NSString * str = [NSString stringWithFormat:@"%@",[response.result objectForKey:@"if_reply_unread"]];
            NSString * chatNew = [NSString stringWithFormat:@"%@",[response.result objectForKey:@"if_new_chatting"]];
            NSString * if_new_follow_thread = [NSString stringWithFormat:@"%@",[response.result objectForKey:@"if_new_follow_thread"]];
            if ([if_new_follow_thread isEqualToString:@"1"]) {
                red = YES;
            }else{
                red = NO;
            }
            if ([chatNew isEqualToString:@"no"]) {
                if_new_chat = NO;
            }else if ([chatNew isEqualToString:@"yes"]){
                if_new_chat = YES;
            }
            if ([str isEqualToString:@"0"]) {
                YN = YES;
            }else{
                YN = NO;
            }
            
            [self.myTableView reloadData];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
        }];
    }else {
        
    }

}

-(void)updateLoginState
{
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
     
- (void)loadBaseUI{
    
    NAV_INIT(self, @"我的个人中心", nil, nil, nil, nil);
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = BJCLOLR;
//    _myTableView.backgroundColor = [UIColor colorWithRed:241 green:242 blue:243 alpha:1];
}

#pragma mark - TableView Delegate && DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        
        return 6;
    }else{
        
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0){
        
        if(row == 0){
            
            return 210;
        }else if(row == 1){
            
            return 150;
        }else{
            return 65;
        }
    }else{
        return 75;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    if(section == 1){
//        
//        return 0;
//    }
//    return 25;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIImageView * image = [[UIImageView alloc ] init];
//    image.backgroundColor = BJCLOLR;
//    return image;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0){
        
        if(row == 0){
            
            MyInfoLoginedCell * cell = [[MyInfoLoginedCell alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 210)];
            cell.delegate = self;
            [cell.headBtn addTarget:self action:@selector(UesrHeadClicked) forControlEvents:UIControlEventTouchUpInside];
            NSString *messageRed = [NSString stringWithFormat:@"%@", g_userInfo.message_red];
            if([messageRed isEqualToString:@"0"])
            {
                cell.redImage.hidden = YES;
            }
            else
            {
                cell.redImage.hidden = NO;
            }
            if (red == YES) {
                cell.redImage1.hidden = NO;
            }else{
                cell.redImage1.hidden = YES;
            }
            
            return cell;
        }else if(row == 1){
            
            //订单
            static NSString *cellIdentifier = @"MyOrderViewCell";
            MyOrderViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[ MyOrderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.delegate = self;
//            if (listDict && g_LoginStatus) {
            [cell initWithDict:listDict];
//            }else{
//                
//            }
            return cell;
        }else if(row == 2){
            
            //收藏
            static NSString *cellIdentifier = @"MyCell";
            [tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
            MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            cell.pointRemindImageView.hidden = YES;
            cell.iconImageView.image = [UIImage imageNamed:@"my_cell_storage_icon"];
            cell.titleLabel.text = @"我的收藏";
            cell.titleLabel.textColor = BLACKTEXT;
            return cell;
        }else if(row == 3){
            
            //客服
            static NSString *cellIdentifier = @"MyCell";
            [tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
            MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
//            cell.pointRemindImageView.hidden = YES;
            if (if_new_chat == YES) {
                cell.pointRemindImageView.hidden = NO;
            }else if (if_new_chat == NO){
                cell.pointRemindImageView.hidden = YES;
            }else{
                cell.pointRemindImageView.hidden = YES;
            }
            cell.iconImageView.image = [UIImage imageNamed:@"my_cell_phone_icon"];
            cell.titleLabel.text = @"客服热线";
//            cell.labelWidth.constant = 80;
            cell.titleLabel.textColor = BLACKTEXT;
            return cell;
        }
        else if (row == 4)
        {
            //兑换中心
            static NSString *cellIdentifier = @"MyCell";
            [tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
            MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            cell.pointRemindImageView.hidden = YES;
            cell.iconImageView.image = [UIImage imageNamed:@"my_cell_duihuan_icon"];
            cell.titleLabel.text = @"兑换中心";
            cell.titleLabel.textColor = BLACKTEXT;
            return cell;
        }
            else{
            static NSString *cellIdentifier = @"MyCell";
            [tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
            MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (YN == YES) {
                    cell.pointRemindImageView.hidden = NO;
                }else{
                    cell.pointRemindImageView.hidden = YES;
                }
            
            cell.cellLine.hidden = YES;
            cell.iconImageView.layer.masksToBounds = YES;
            cell.iconImageView.layer.cornerRadius = 5;
            [cell.iconImageView  setImageWithURL:[NSURL  URLWithString:[NSString stringWithFormat:@"%@",g_userInfo.latest_msg_photo]]  placeholderImage:[UIImage  imageNamed: Default_UserHead]];
            cell.titleLabel.text = @"社区通知";
            cell.titleLabel.textColor = BLACKTEXT;
            return cell;
        }
    }
    else{
        

        static NSString * shezhi = @"shezhi";
        UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:shezhi];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shezhi];
            UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 31, 31)];
            imageview.image = [UIImage imageNamed:@"my_cell_set_icon"];
            [cell.contentView addSubview:imageview];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.origin.x+imageview.frame.size.width+10, imageview.frame.origin.y, UIScreenWidth, 31)];
            label.text = @"设置";
            label.textColor = BLACKTEXT;
            label.font = [UIFont systemFontOfSize:15.0];
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:shezhiView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}
- (void)downBtnAction:(UIButton *)button
{
    if (button.tag == 100) {
        [self showMyGoldView];
    }
    if (button.tag == 101) {
        [self showMyTopicView];
    }
    if (button.tag == 102) {
        if(!g_LoginStatus)
        {
            [self showLoginView];
            return;
        }
        MyRankViewController * mrc = [[MyRankViewController alloc] init];
        [self.navigationController pushViewController:mrc animated:YES];
    }
    if (button.tag == 103) {
        [self showMyFocusView];
    }
    if (button.tag == 104) {
        [self showMyMessageView];
    }
   
}
#pragma mark -- 订单列表
- (void)DingDanLieBiaoFenLei:(UIButton *)button
{
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    if (button.tag == 1000) {
    MyOrderListViewController *orderVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MyOrderListViewController"];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
    }else if (button.tag == 104){
        ShouHouViewController * shouHou = [[ShouHouViewController alloc] init];
        shouHou.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shouHou animated:YES];
    }else{
        NewOrderListController * newList = [[NewOrderListController alloc ] init];
        newList.listBtn = button;
        newList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newList animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 1)// 我的订单
        {
            // 判断是否登录
            if(!g_LoginStatus)
            {
                [self showLoginView];
                return;
            }
            

        }
        else if(indexPath.row == 2)// 我的收藏
        {
            // 判断是否登录
            if(!g_LoginStatus)
            {
                [self showLoginView];
                return;
            }
            
            MyColViewController *collectVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyColViewController"];
            collectVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collectVC animated:YES];
        }
        else if (indexPath.row == 3)// 客服热线
        {
            KeFuViewController * kvc = [[KeFuViewController alloc] init];
            kvc.hidesBottomBarWhenPushed = YES;
            kvc.if_new_message = if_new_chat;
            [self.navigationController pushViewController:kvc animated:YES];
            
        }
        else if(indexPath.row == 4)// 兑换中心
        {
            // 判断是否登录
            if(!g_LoginStatus)
            {
                [self showLoginView];
                return;
            }
            ExchangeCenterViewController *exchangeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExchangeCenterViewController"];
            exchangeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:exchangeVC animated:YES];
        }
        else if(indexPath.row == 5){
            if(!g_LoginStatus)
            {
                [self showLoginView];
                return;
            }
            TieBaViewController *tiebaVc = [[TieBaViewController alloc]init];
            tiebaVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tiebaVc animated:YES];
        }
    }
    else
    {
        // 设置
        SettingViewController *settingVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (void)longPressViewBtn:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {// 取消
        
        
    }
    else if (button.tag == 1)// 确定
    {
        NSString *phone = [NSString stringWithFormat:@"tel://%@", @"4008000021"];
        NSURL *telURL =[NSURL URLWithString:phone];
        
        if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
            
            [[UIApplication sharedApplication] openURL:telURL];

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"该设备不支持电话功能！"];
        }
    }
    
    [_maskView removeFromSuperview];
}

// 显示个人资料
-(void)UesrHeadClicked
{
    MyInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
    infoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark - MyInfoUnLoginedCell  Delegate

// 登录
-(void)showLoginView
{
    LoginNavViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
    [self presentViewController:loginVC animated:YES completion:nil];
}

// 我的金币
-(void)showMyGoldView
{
    // 判断是否登录
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    
    MyGoldViewController *goldVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyGoldViewController"];
    goldVC.hidesBottomBarWhenPushed = YES;
    goldVC.myTitle = @"我的金币";
    [self.navigationController pushViewController:goldVC animated:YES];
}

// 我的话题
-(void)showMyTopicView {
    
    // 判断是否登录
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    
    MyTopicViewController *topicVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyTopicViewController"];
    topicVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topicVC animated:YES];
}

// 我的消息
-(void)showMyMessageView {
    
    // 判断是否登录
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    
    MyMessageViewController *messageVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyMessageViewController"];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

// 我的关注
-(void)showMyFocusView
{
    // 判断是否登录
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    
    MyAttentionViewController *attentionVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyAttentionViewController"];
//     MyGuZhuViewController *attentionVC = [[MyGuZhuViewController alloc] init];
    red = NO;
    attentionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:attentionVC animated:YES];
}

#pragma mark - getter

- (ServiceView *)serviceView {
    
    if (_serviceView == nil) {
        
        _serviceView = [[[NSBundle mainBundle] loadNibNamed:@"ServiceView" owner:self options:nil] lastObject];
        _serviceView.frame = CGRectMake(0, 0, 294, 165);
    }
    return _serviceView;
}

@end
