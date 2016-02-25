//
//  BubbleFriendsController.m
//  Yongai
//
//  Created by arron on 14/11/7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "BubbleFriendsController.h"
#import "CircleFriendsCell.h"
#import "PostMenuDetailController.h"
#import "MyAttentionViewController.h"
#import "MyTopicViewController.h"
#import "MyMessageViewController.h"
#import "MyGoldViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginNavViewController.h"
#import "LingChenHeadView.h"
#import "ExchangeCenterViewController.h"
#import "MyInfoViewController.h"
#import "MobClick.h"
#import "QFControl.h"
#import "TuiSongController.h"
#import "MCProduceHViewCell.h"
#import "MCProductDetailViewController.h"
#define TitleFont  [UIFont systemFontOfSize:17.0]
#define QDBJ RGBACOLOR(23, 17, 26,0.7)
@interface BubbleFriendsController ()<CircleFriendsCellDelegate,LingChenHeadViewDelegate>
{

    LingChenHeadView * header;
    UIButton  *loginBtn;
    NSString * tid;
    UIView *maskView; // 浮层视图
    UIImageView * qiandaoBj;//签到背景
    UILabel * qiandaoLB;
    UIImageView * shengjiView;//升级
    UILabel * shengjiLabel;
    JuHuaView * flower;
    LoadingView * loadView;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *circleTableLeft;
@property (strong, nonatomic) NSMutableArray  *myCircleArray;// 我加入的圈子
@property (strong, nonatomic) NSMutableArray  *reCircleArray;// 推荐圈子
@end

@implementation BubbleFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    loadView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    
    [loadView addSubview:[QFControl createButtonWithFrame:loadView.frame title:nil target:self action:@selector(actionTouch) tag:0]];
    loadView.hidden = YES;
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    maskView.alpha = 0;
    maskView.backgroundColor = QDBJ;
    qiandaoBj = [[UIImageView alloc] initWithFrame:CGRectMake(20, (UIScreenHeight-UIScreenWidth-40)/2, UIScreenWidth-40, UIScreenWidth-40)];
    qiandaoBj.image = [UIImage imageNamed:@"领取金币"];
    qiandaoLB = [[UILabel alloc] initWithFrame:CGRectMake(50, qiandaoBj.frame.size.height/4*3-40, qiandaoBj.frame.size.width-100, 30)];
    qiandaoLB.textColor = [UIColor whiteColor];
    qiandaoLB.font = [UIFont systemFontOfSize:17];
    qiandaoLB.textAlignment = NSTextAlignmentCenter;
    [qiandaoBj addSubview:qiandaoLB];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    _myCircleArray = [[NSMutableArray alloc ] init];
    _reCircleArray = [[NSMutableArray alloc ] init];
    self.navigationController.navigationBar.barTintColor = beijing;
    NAV_INIT(self, @"Darlin", @"cirle_leftBtn", @selector(showLeftMenu),nil,nil);
    self.bubbleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bubbleTable.backgroundColor = BJCLOLR;

    header = [[LingChenHeadView alloc]init];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width*330)/720);
    header.delegate = self;
    header.frame =rect;
    flower = [[JuHuaView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    flower.center = CGPointMake(self.view.center.x, self.view.center.y+20);
    [self.navigationController.view addSubview:flower];
    [self.navigationController.view addSubview:loadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMyTopicView) name:Notify_showMyTopicView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMyMessageView) name:Notify_showMyMessageView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAttentionView) name:Notify_showAttentionView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMyGoldView) name:Notify_showMyGoldView object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPostDetailViewContoller:) name:Notify_showPostDetailViewContoller object:nil];
   
    _bubbleTable.tableHeaderView = header;
    [self refreshComments];
    [self addtTableFooterView];
    [self createRightButton];
   
}
- (void)actionTouch
{
    loadView.hidden = YES;
    [self refreshBubbleData];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createRightButton
{
    UIImageView * btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(20,-10, 80,30)];
    btnImage.backgroundColor = RGBACOLOR(255, 155, 122, 1);
    btnImage.layer.masksToBounds = YES;
    btnImage.layer.cornerRadius = 15;
    btnImage.image = [UIImage imageNamed:@"签到1"];
    btnImage.userInteractionEnabled = YES;
    UILabel * label = [[UILabel alloc ] initWithFrame:CGRectMake(10,8, 40,15)];
    label.text = @"签到";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    [btnImage addSubview:label];
    UIImageView * jinBiImage = [[UIImageView alloc ] initWithFrame:CGRectMake(label.frame.origin.x+30,3, 30,25)];
    //金币有问题
    jinBiImage.image = [UIImage imageNamed:@"金币1-1"];
    [btnImage addSubview:jinBiImage];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [button addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [btnImage addSubview:button];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = rightBtnItem;

}
- (void)rightAction
{
  if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    NSString *str = @"daily_signin";
    [[TTIHttpClient shareInstance] get_integralRequestWithsid:nil withtask_type:str fid:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
       
        NSString * str = [response.result objectForKey:@"rank_up"];
        if ([str isEqualToString:@"皇冠会员"]) {
            NSString * string = @"恭喜您，升级为皇冠会员 !";
            NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:string];
            NSRange range1 = [string rangeOfString:str];
            NSRange redRange = NSMakeRange(range1.location, range1.length);
            [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
            UILabel * lable = [[UILabel alloc] init];
            [lable setAttributedText:string1];
            shengjiView = [QFControl createUIImageFrame:CGRectMake(30, (UIScreenHeight-UIScreenWidth+100)/2, UIScreenWidth-60, UIScreenHeight/3) imageName:@"升级" withStr1:string1 withStr: @"您可到个人中心“我的等级”页面查看详情" withStr3:@"么么哒~"];
            [UIView animateWithDuration:1.5 animations:^{
                maskView.alpha = 1;
            }];
            [maskView addSubview:shengjiView];
            [self performSelector:@selector(hideView) withObject:nil afterDelay:2.5];
        }else{
            g_userInfo.pay_points = [response.result objectForKey:@"pay_points"];
            NSString  *goldNum = [response.result objectForKey:@"daily_signin"];
            [UIView animateWithDuration:1.5 animations:^{
                maskView.alpha = 1;
            }];
            qiandaoLB.text = [NSString stringWithFormat:@"恭喜~获得%@个金币",goldNum];
            [maskView addSubview:qiandaoBj];
            [self performSelector:@selector(hideView) withObject:nil afterDelay:1.5];
 
        }
        [self.navigationController.view addSubview:maskView];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
    
    }];
}
- (void)hideView
{
    [UIView animateWithDuration:1.5 animations:^{
        maskView.alpha = 0;
    }];
}
#pragma mark-- lingChenHeadViewDelegate
- (void)jinBiAction
{
    
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    ExchangeCenterViewController *exchangeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExchangeCenterViewController"];
    exchangeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:exchangeVC animated:YES];
}
- (void)zhuCeAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showLoginView object:nil];
}
- (void)headBtn
{
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    MyInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
    infoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVC animated:YES];

}
- (void)moneyBtn
{
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    MyGoldViewController *goldVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyGoldViewController"];
    goldVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goldVC animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    //页面统计
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Darlin"];
    loginBtn.hidden = YES;
    g_LoginStatus =g_userInfo.loginStatus.intValue;
    flower.hidden = NO;
    [self refreshBubbleData];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width*330)/720);
    if(!g_LoginStatus)
    {
        header.headImgView.layer.masksToBounds = NO;
        header.headImgView.layer.borderWidth =0;
        header.lable1.text = @"0 金币";
        header.button2.hidden = NO;
        header.zhuCeLable.hidden = YES;
        header.headImgView.image = [UIImage imageNamed:@"一点灰色1"];
        header.headImgView.layer.cornerRadius = 90/2;
        header.headImgView.frame = CGRectMake(30, rect.size.height - 147, 90, 90);
        
    }
    else
    {
        header.headImgView.layer.masksToBounds = YES;
        header.headImgView.layer.borderWidth = 1;
        header.headImgView.layer.borderColor = [RGBACOLOR(255, 191, 176, 1) CGColor];
        [header.headImgView  setImageWithURL:[NSURL  URLWithString:[NSString stringWithFormat:@"%@",g_userInfo.user_photo]]  placeholderImage:[UIImage  imageNamed: Default_UserHead]];
        header.headImgView.layer.cornerRadius = 70/2;
        header.headImgView.frame = CGRectMake(40, rect.size.height - 135, 70, 70);
        header.button2.hidden = YES;
        header.zhuCeLable.hidden = NO;
        [self myJinBi];
       
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBottom" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    //页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Darlin"];
    loadView.hidden = YES;
    flower.hidden = YES;
    [flower stopView];
}
- (void)myJinBi
{
    [[TTIHttpClient shareInstance] nowGoldRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        header.lable1.text = [NSString stringWithFormat:@"%@ 金币",response.responseModel];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
    }];
}
-(void)showPostDetailViewContoller:(NSNotification *)notify
{

    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    PostMenuDetailController *PostMenuDetailVC = [board instantiateViewControllerWithIdentifier:@"PostMenuDetailController"];
    PostMenuDetailVC.fid = [notify object];
    [self.navigationController pushViewController:PostMenuDetailVC animated:YES];
}

- (void)addtTableFooterView {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    view.backgroundColor = BJCLOLR;
//    self.bubbleTable.tableFooterView = view;
}

#pragma mark - CircleFriendsViewDelegate

// 推荐圈子 显示泡友圈详情
-(void)showCircleDetailByRow:(NSInteger)row  btnTag:(NSInteger)tag  type:(NSInteger)type
{
    BbsModel *info = [[BbsModel alloc] initWithDictionary:[self.reCircleArray objectAtIndex:tag] error:nil];

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    PostMenuDetailController *PostMenuDetailVC = [board instantiateViewControllerWithIdentifier:@"PostMenuDetailController"];
    PostMenuDetailVC.fid = info.fid;
    [self.navigationController pushViewController:PostMenuDetailVC animated:YES];
}

#pragma mark - 初始化  JCTopic
/**
 *  添加轮播图
 */

// 请求泡友圈列表数据
- (void)refreshBubbleData {
    
    [flower startView];
    [[TTIHttpClient shareInstance] indexBbsRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        if ([g_version isEqualToString:VERSION]) {
            NSArray * array1 = [response.result objectForKey:@"my_circle"];
            NSArray * array2 = [response.result objectForKey:@"re_circle"];
            [self.myCircleArray removeAllObjects];
            [self.reCircleArray removeAllObjects];
            for (NSDictionary * dict in array1) {
                if ([[dict objectForKey:@"name"] isEqualToString:@"请不要害羞"]||[[dict objectForKey:@"name"] isEqualToString:@"床上那点事"]) {
                    continue;
                }else{
                    [self.myCircleArray addObject:dict];
                }
            }
            for (NSDictionary * dict in array2) {
                if ([[dict objectForKey:@"name"] isEqualToString:@"请不要害羞"]|| [[dict objectForKey:@"name"] isEqualToString:@"床上那点事"]) {
                    continue;
                }else{
                    [self.reCircleArray addObject:dict];
                }
            }

        }else{
            self.myCircleArray  = [response.result objectForKey:@"my_circle"];
            self.reCircleArray =  [response.result objectForKey:@"re_circle"];
        }
        
        [self.bubbleTable reloadData];
        [flower stopView];
       
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
//         loadView.hidden = NO;
//        [flower stopView];
    }];
}

/**
 *  显示弹出的所有圈子【圈子分类】
 */
/**
 *  显示左侧的分类页面
 */
- (void)showLeftMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showLeftView object:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
       return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 30)];
        view.backgroundColor = BJCLOLR;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7, 10, 100, 20)];
        [view addSubview:label];
        
        label.backgroundColor = BJCLOLR;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:15];
        
        UIImageView * imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 12,4, 16)];
        imageView.backgroundColor = beijing;
        [view addSubview:imageView];
        if(section == 0)
        {
            label.text = @"我的圈子";
            
        }
        else
        {
            label.text = @"推荐圈子";
        }
        return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (section == 0)
        {
            if(!g_LoginStatus)
                return 1;
            else
            {
                return self.myCircleArray.count;
            }
        }
        else
        {
            return self.reCircleArray.count;
        }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(indexPath.section == 0)
        {
            return 80;
        }
        else
        {
            NSDictionary * info = [self.reCircleArray objectAtIndex:indexPath.row];
            if ([[info objectForKey:@"fid"] isKindOfClass:[NSNull class]]) {
                return 0;
            }else{
                return 80;
            }
            
            
        }
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(g_LoginStatus && indexPath.section == 0)
    {
        CircleFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"circleFriendsCell"];
        cell.delegate = self;
        cell.type = 0;
        cell.tag = indexPath.row;
        cell.contentView.hidden = NO;
        BbsModel * info = [[BbsModel alloc]initWithDictionary:[self.myCircleArray objectAtIndex:indexPath.row] error:nil];
        [cell updateCellDataDic:info];
        if (indexPath.row == _myCircleArray.count-1) {
            cell.lineView.hidden = YES;
        }else{
            cell.lineView.hidden = NO;
        }
        return cell;
    }
    else if(!g_LoginStatus && indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BJCLOLR;
        
        for(UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 40)];
        image.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 40)];
        label.text = @"您需要先登录才能使用我的圈子";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = beijing;
        label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:label];
        return cell;
        
    }
    else
    {
        CircleFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"circleFriendsCell"];
        cell.delegate = self;
        cell.type = 1;
        cell.tag = indexPath.row;
        BbsModel * info = [[BbsModel alloc]initWithDictionary:[self.reCircleArray objectAtIndex:indexPath.row] error:nil];
        if (info.fid) {
            cell.contentView.hidden = NO;
            [cell updateCellDataDic:info];
        }else{
            cell.contentView.hidden = YES;
        }
        if (indexPath.row == _reCircleArray.count -1) {
            cell.lineView.hidden = YES;
        }else{
            cell.lineView.hidden = NO;
        }
        return cell;

    }

}

#pragma mark - CircleFriendsCellDelegate

// 我加入的圈子 显示泡友圈详情
-(void)showCircleDetailViewByRow:(NSInteger)row  btnTag:(NSInteger)tag type:(NSInteger)type
{
    BbsModel *info;
    if(type == 0)
    {
        info = [[BbsModel alloc] initWithDictionary:[self.myCircleArray objectAtIndex:row] error:nil];
    }
    else
        info = [[BbsModel alloc] initWithDictionary:[self.reCircleArray objectAtIndex:row] error:nil];
       UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    PostMenuDetailController *PostMenuDetailVC = [board instantiateViewControllerWithIdentifier:@"PostMenuDetailController"];
    PostMenuDetailVC.fid = info.fid;
    [self.navigationController pushViewController:PostMenuDetailVC animated:YES];
}

// 登录
-(void)showLoginView
{
    LoginNavViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
    [self presentViewController:loginVC animated:YES completion:nil];
}


#pragma mark --- Notify Action

-(void)showMyTopicView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showRootView object:[NSNumber numberWithBool:NO]];
    
    // 判断是否登录
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    
    
    MyTopicViewController *attentionVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyTopicViewController"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottom" object:nil];
    [self.navigationController pushViewController:attentionVC animated:YES];
}

-(void)showMyMessageView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showRootView object:[NSNumber numberWithBool:NO]];
    
    // 判断是否登录
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    
    MyMessageViewController *attentionVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyMessageViewController"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottom" object:nil];
    [self.navigationController pushViewController:attentionVC animated:YES];
}
-(void)showAttentionView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showRootView object:[NSNumber numberWithBool:NO]];
    
    // 判断是否登录
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    
    MyAttentionViewController *attentionVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyAttentionViewController"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottom" object:nil];
    [self.navigationController pushViewController:attentionVC animated:YES];
    
}
-(void)showMyGoldView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showRootView object:[NSNumber numberWithBool:NO]];
    
    // 判断是否登录
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
    
    MyGoldViewController *attentionVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyGoldViewController"];
    attentionVC.bFromBubbleCircle = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottom" object:nil];
    [self.navigationController pushViewController:attentionVC animated:YES];
}


-(void)refreshComments
{
    if(g_LoginStatus)
    {
        [self refreshBubbleData];
    }
    
}


#pragma mark- getter

@end
