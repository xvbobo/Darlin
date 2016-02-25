//
//  HisTopicViewController.m
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "HisTopicViewController.h"
#import "TopicViewCell.h"
#import "MyTopicDetailViewController.h"
#import "MyInfoViewController.h"
#import "SendGoldViewController.h"
#import "JuBaoViewController.h"
#import "ChatViewController.h"
#import "MyRankViewController.h"
#import "SendGoldListViewController.h"
#import "TTIFont.h"
#define sapce 10
@interface HisTopicViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *myTableView;
    
    ContactInfoModel *userInfo;
    NSMutableArray   *topicListArr;
    
    // table head view
    UILabel *nickNameLabel;
    IBOutlet UIImageView *headImgView;
    IBOutlet UILabel *descpLabel;
    UIImageView * btnImageLeft;
    UIImageView * btnImageRight;
    NSInteger g_Page;
    NSIndexPath * index;
    UIImageView * MessageView;
    TopicViewCell *cell;
    UILabel * HobbyLabel;
     UILabel * ageLabel;
     UILabel * starLabel;
    NSMutableArray * goldListArr;
     UIView *maskView; // 浮层视图
    UILabel * leftLable;
    UILabel * rightLable;
    UIView * buttonView;
    UIImageView * sexImage;//性别
    UILabel * dengJiLabel;//等级
    NSString * dengJiStr;
    UIImageView * huangGuan;//皇冠
    UIButton * sendBtn;//发信息
     BOOL bSeniorMember;//是否是资深会员
    UIImageView * btnImage;//左按钮
    UIImageView * btnImage1;//右按钮
    BOOL Hiden;//是否隐藏他的资料
    UIImageView * nameLabelView;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
    BOOL xianshiJuHua;
    NSMutableArray * arrayTopic;
    CGFloat CellHeight;
}

@end

@implementation HisTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    nameLabelView = [[UIImageView alloc]init];
    arrayTopic = [[NSMutableArray alloc] init];
    xianshiJuHua = YES;
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"Ta的资料", @"common_nav_back_icon", @selector(backAction), nil, nil);
    goldListArr = [[NSMutableArray alloc ] init];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = self.headW.constant/2;
    self.headViewLeft.constant = (UIScreenWidth-headImgView.frame.size.width)/2;
    self.bigView.userInteractionEnabled = YES;
    topicListArr = [[NSMutableArray alloc] init];
    g_Page = 1;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,25,5)];
    [button setBackgroundImage:[UIImage imageNamed:@"省略号"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shengLueHaoAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    [self requestTableDataWithPage:g_Page];
    [self createBottomView];
    [self createUpView];
    [self createZiLiao];
//    MessageView.hidden = YES;
    Hiden = YES;
    if(g_userInfo.user_rank.intValue == 2)
        bSeniorMember = YES;
    else
        bSeniorMember = NO;

    NSLog(@"%f",self.UpBigView.frame.size.height);
    self.noMessageLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0, self.UpBigView.frame.size.height+150, UIScreenWidth,40)];
    self.noMessageLabel.backgroundColor = [UIColor whiteColor];
    self.noMessageLabel.textColor = TEXT;
    
    self.noMessageLabel.textAlignment = NSTextAlignmentCenter;
    [myTableView addSubview:self.noMessageLabel];
   

    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [myTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshComments];
    }];
    
    //上拉加载更多
    footerView = [myTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        //        [weakSelf loadMoreComments];
    }];
    
    //自动刷新
    footerView.hidden = YES;
    footerView.autoLoadMore = YES;
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height)
    {
        [self loadMoreComments];
        
    }
    
    
    
}

- (void)shengLueHaoAction
{
    buttonView = [[UIView alloc] initWithFrame:self.view.superview.frame];
    [buttonView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    buttonView.userInteractionEnabled = YES;
     [self.navigationController.view addSubview:buttonView];
    NSArray * array = @[@"加入黑名单",@"举报",@"取消"];
    UIImageView * btnView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, UIScreenHeight-200, UIScreenWidth, 200)];
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.userInteractionEnabled = YES;
    [buttonView addSubview:btnView];
    for (int i =0 ; i<3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10+i*60, UIScreenWidth-20, 50);
        if (i == 2) {
            button.backgroundColor = RGBACOLOR(208, 204, 192, 1);
        }else{
         button.backgroundColor = beijing;
        }
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        button.tag = 1000+i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(buttonViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:button];
    }
}
- (void)buttonViewAction:(UIButton *)button
{
    if (button.tag == 1000) {
        [self createHeiMingdan];
    }else if (button.tag == 1001)
    {
        [self createJuBao];
        buttonView.hidden = YES;
    }else{
        buttonView.hidden = YES;
    }
}
- (void)createHeiMingdan
{
    if([userInfo.is_black isEqualToString:@"0"])
    {
        [[TTIHttpClient shareInstance] addBlackRequestWithUserid:userInfo.user_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            [SVProgressHUD showSuccessWithStatus:@"加入黑名单后，您将不会再收到该用户的私信"];
            
            userInfo.is_black = @"1";
            [self updateFooterView];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            [SVProgressHUD showErrorWithStatus:response.error_desc];
        }];
    }
    else
    {
        [[TTIHttpClient shareInstance] cancelBlackRequestWithUserid:userInfo.user_id withSucessBlock:^(TTIRequest *request, TTIResponse *response)
         {
             [SVProgressHUD showSuccessWithStatus:@"已从黑名单移出"];
             
             userInfo.is_black = @"0";
             [self updateFooterView];
             
         } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
         {
             [SVProgressHUD showErrorWithStatus:response.error_desc];
         }];
    }
    

}
- (void)createJuBao
{
    JuBaoViewController * jb = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"JuBao"];
    jb.user_id = _userId;
    [self.navigationController pushViewController:jb animated:YES];
}
//他的资料
- (void)createZiLiao
{
    [self initTableData];
   
    MessageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0,0, UIScreenWidth, UIScreenHeight*1000)];
    MessageView.backgroundColor = [UIColor whiteColor];
    MessageView.userInteractionEnabled = YES;
    NSArray * labelArr = @[@"年龄",@"星座",@"兴趣爱好"];
    for (int i = 0; i<3; i++) {
        UILabel * label = [[UILabel alloc ] initWithFrame:CGRectMake(0, 20+i*40, 70, 20)];
        label.text = labelArr[i];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = TEXTCOLOR;
        label.font = [UIFont systemFontOfSize:15];
        [MessageView addSubview:label];
        if (i == 0) {
            ageLabel = [[UILabel alloc ] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+sapce, label.frame.origin.y, 200, 20)];
            ageLabel.textColor = TEXT;
            ageLabel.font = [UIFont systemFontOfSize:15];
        }else if (i== 1)
        {
            starLabel = [[UILabel alloc ] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+sapce, label.frame.origin.y, 200, 20)];
             starLabel.textColor = TEXT;
            
            starLabel.font = [UIFont systemFontOfSize:15];
        }else {
            HobbyLabel = [[UILabel alloc ] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+sapce, label.frame.origin.y, 200, 20)];
             HobbyLabel.textColor = TEXT;
            HobbyLabel.font = [UIFont systemFontOfSize:15];
        }
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+sapce, label.frame.origin.y+label.frame.size.height+5, UIScreenWidth, 1)];
        lineView.image = [UIImage imageNamed:@"post_line"];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, UIScreenWidth, label.frame.size.height);
        [btn addTarget:self action:@selector(myDengJi) forControlEvents:UIControlEventTouchUpInside];
        [MessageView addSubview:btn];
        [MessageView addSubview:lineView];
        [MessageView addSubview:ageLabel];
        [MessageView addSubview:HobbyLabel];
        [MessageView addSubview:starLabel];
    }
}
- (void)myDengJi
{
    if (bSeniorMember == YES) {
        return;
    }else{
        MyRankViewController *nameVC = [[MyRankViewController alloc] init];
     [self.navigationController pushViewController:nameVC animated:YES];
    }
}
- (void)createGoldList
{
    UILabel * shouLiLabel = [[UILabel alloc ] initWithFrame:CGRectMake(10, 20+3*40, 70, 20)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = shouLiLabel.frame;
    [btn addTarget: self action:@selector(shouliAction) forControlEvents:UIControlEventTouchUpInside];
    [MessageView addSubview:btn];
    shouLiLabel.text  =@"收礼排行";
    shouLiLabel.textColor = TEXTCOLOR;
    shouLiLabel.font = [UIFont systemFontOfSize:15];
    [MessageView addSubview:shouLiLabel];
    UILabel * noShouLiLabel = [[UILabel alloc] initWithFrame:CGRectMake(shouLiLabel.frame.origin.x, shouLiLabel.frame.origin.y+50, UIScreenWidth, 40)];
    noShouLiLabel.text = @"暂时还未收到金币哟~";
    noShouLiLabel.textColor = TEXT;
    noShouLiLabel.textAlignment = NSTextAlignmentCenter;
    if (goldListArr.count == 0) {
        [MessageView addSubview:noShouLiLabel];
    }
    
    int space;
    if (UIScreenWidth > 320) {
        space = 100;
    }else{
        space = 80;
    }
    for (int j = 0; j< goldListArr.count; j++) {
        GoldListModel *gold = [goldListArr objectAtIndex:j];
        UIButton * headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame = CGRectMake(0, 0, 50, 50);
        headBtn.tag = gold.user_id.integerValue;
        [headBtn addTarget:self action:@selector(headViewWAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * headView = [[UIImageView alloc ] initWithFrame:CGRectMake(shouLiLabel.frame.origin.x+shouLiLabel.frame.size.width+(j%3)*space, shouLiLabel.frame.origin.y+(j/3)*110-5, 65, 65)];
        [headView  setImageWithURL:[NSURL URLWithString:gold.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
        headView.userInteractionEnabled = YES;
        headView.layer.masksToBounds = YES;
        headView.layer.cornerRadius = headView.frame.size.width/2;
        headView.backgroundColor = beijing;
        [headView addSubview:headBtn];
        NSString * nameStr = gold.nickname;
        CGSize size = [nameStr sizeWithFont:[UIFont systemFontOfSize:12]];
        UILabel * name = [[UILabel alloc ] initWithFrame:CGRectMake(0,0,size.width, 20)];
        name.center = CGPointMake(headView.center.x, headView.center.y+headView.frame.size.height/2+10);
        name.text = nameStr;
        name.textColor = TEXT;
        name.textAlignment = NSTextAlignmentCenter;
        name.font = [UIFont systemFontOfSize:12];
        NSString * str0 = [NSString stringWithFormat:@"送币数:%@",gold.fg_num];
        CGSize labelsize = [str0 sizeWithFont:name.font];
         UILabel * jinBiNumber = [[UILabel alloc ] initWithFrame:CGRectMake(0,0,labelsize.width, name.frame.size.height)];
        jinBiNumber.text = str0;
        jinBiNumber.textColor = TEXT;
        jinBiNumber.center = CGPointMake(name.center.x, name.center.y+name.frame.size.height/2+10);
        jinBiNumber.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:jinBiNumber.text];
        NSString * str = [jinBiNumber.text componentsSeparatedByString:@":"].lastObject;
        NSRange redRange = NSMakeRange(4, [str length]);
        [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
        [jinBiNumber setAttributedText:string1];
        jinBiNumber.font = [UIFont systemFontOfSize:12];
        [MessageView addSubview:name];
        [MessageView addSubview:jinBiNumber];
        [MessageView addSubview:headView];
    }
    if (goldListArr.count!=0) {
        int a;
        if (goldListArr.count%3 == 0) {
            a = goldListArr.count/3-1;
        }else
        {
            a = goldListArr.count%3;
        }
        UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(shouLiLabel.frame.origin.x+shouLiLabel.frame.size.width,shouLiLabel.frame.origin.y+a*100, UIScreenWidth, 1)];
        lineView1.image = [UIImage imageNamed:@"post_line"];
        [MessageView addSubview:lineView1];
    }
    
//    [myTableView addSubview:MessageView];

}
- (void)shouliAction
{
    SendGoldListViewController *sendGoldVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"SendGoldListViewController"];
    sendGoldVC.userId = userInfo.user_id;
    [self.navigationController pushViewController:sendGoldVC animated:YES];
}
#pragma mark -- 排行榜头像被点击
- (void)headViewWAction:(UIButton *)button
{
//    GoldListModel *gold = [goldListArr objectAtIndex:3*row+index];
    
    if(button.tag == g_userInfo.uid.integerValue)
    {
        MyInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        infoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
    else
    {
        HisTopicViewController *others = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
        others.userId = [NSString stringWithFormat:@"%ld",button.tag];
        [self.navigationController pushViewController:others animated:YES];
    }
    

}
- (void)createBottomView
{
    //    self.BackView.backgroundColor = BJCLOLR;
    UIImageView * BottomView = [[UIImageView alloc ] initWithFrame:CGRectMake(UIScreenWidth/2,0, 1, 47)];
    BottomView.userInteractionEnabled = YES;
    BottomView.image = [UIImage imageNamed:@"post_line"];
    [self.BackView addSubview:BottomView];
    UIImageView * LineView = [[UIImageView alloc ] initWithFrame:CGRectMake(0,0, UIScreenWidth, 1)];
    LineView.userInteractionEnabled = YES;
    LineView.image = [UIImage imageNamed:@"post_line"];
    [self.BackView addSubview:LineView];
    NSArray * btnArray = @[@"关注",@"送金币"];
    for (int i =0 ; i<2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(BottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 200+i;
        button.frame = CGRectMake(i*UIScreenWidth/2, 0, UIScreenWidth/2, 47);
        [self.BackView addSubview:button];

    }
    btnImage = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth/2-20)/2-20,(self.BackView.frame.size.height - 20)/2, 20, 20)];
    btnImage.image = [UIImage imageNamed:@"加关注-1"];
    [self.BackView addSubview:btnImage];
    leftLable = [[UILabel alloc ] initWithFrame:CGRectMake(btnImage.frame.origin.x+btnImage.frame.size.width,btnImage.frame.origin.y, 80, 20)];
    leftLable.font = [UIFont systemFontOfSize:17];
    leftLable.textColor = beijing;
    leftLable.text = btnArray[0];
    btnImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth/2+UIScreenWidth/4-35,(self.BackView.frame.size.height - 20)/2, 20, 20)];
    btnImage1.image = [UIImage imageNamed:@"金币-1"];
    [self.BackView addSubview:btnImage1];
    rightLable  = [[UILabel alloc] initWithFrame:CGRectMake(btnImage1.frame.origin.x+btnImage1.frame.size.width, btnImage1.frame.origin.y, 80, 20)];
    rightLable.text = btnArray[1];
    rightLable.textColor = beijing;
    rightLable.font = [UIFont systemFontOfSize:17];
    [self.BackView addSubview:rightLable];
    [self.BackView addSubview:leftLable];
}
- (void)BottomButtonAction:(UIButton * )btn
{
    if (btn.tag == 200) {
        [self createGuanzhu];
    }else
    {
        [self sendGold];
    }
}
- (void)createMaskView
{
    maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
    [maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.navigationController.view addSubview:maskView];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((maskView.frame.size.width-300)/2, (maskView.frame.size.height-150)/2, 300, 145)];
    centerView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:centerView];
}
- (void)createGuanzhu
{
    if([userInfo.is_follow isEqualToString:@"0"])
    {
        [[TTIHttpClient shareInstance] addFollowRequestWithUserid:userInfo.user_id
                                                  withSucessBlock:^(TTIRequest *request, TTIResponse *response)
         {
             maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
             [maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
             [self.navigationController.view addSubview:maskView];
             
             UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-294)/2, (self.view.frame.size.height - 54)/2 , 294, 54)];
             imgView.image = [UIImage imageNamed:@"attentionSucBg"];
             [maskView addSubview:imgView];
             
             [maskView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
             
             userInfo.is_follow = @"1";
             [self updateFooterView];
         } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
         {
             [SVProgressHUD showErrorWithStatus:response.error_desc];
         }];
    }
    else
    {
        [[TTIHttpClient shareInstance] cancelFollowRequestWithUserId:userInfo.user_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            
            [SVProgressHUD showSuccessWithStatus:@"已取消关注"];
            
            userInfo.is_follow = @"0";
            [self updateFooterView];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
        }];
    }
}
-(void)updateFooterView
{
    if([userInfo.is_follow isEqualToString:@"0"])
    {
        leftLable.text = @"关注";
        leftLable.textColor = beijing;
        btnImage.image = [UIImage imageNamed:@"加关注-1"];
    }
    else
    {
        leftLable.text  = @"已关注";
        leftLable.textColor = TEXT;
       btnImage.image = [UIImage imageNamed:@"关注"];
    }
    UIButton * btn = (UIButton*)[buttonView viewWithTag:1000];
    if([userInfo.is_black isEqualToString:@"0"])
    {
        
        [btn setTitle:@"加入黑名单" forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:@"屏蔽中" forState:UIControlStateNormal];
    }
}

- (void)sendGold
{
    SendGoldViewController *sendGoldVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"SendGoldViewController"];
    sendGoldVC.receiverId = userInfo.user_id;
    [self.navigationController pushViewController:sendGoldVC animated:YES];

}
- (void)createUpView
{
//    [self initTableData];
    btnImageLeft = [[UIImageView alloc ] initWithFrame:CGRectMake(self.leftLableLeft.constant-8,self.UpViewH.constant-2 , 50, 2)];
    btnImageLeft.backgroundColor = beijing;
    [self.upView addSubview:btnImageLeft];
    for (int i= 0; i<2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(i*UIScreenWidth/2, 0, UIScreenWidth/2, 50);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.upView addSubview:btn];
    }
    nickNameLabel = [[UILabel alloc ] init];
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = font(20);
    [nameLabelView addSubview:nickNameLabel];
    sexImage = [[UIImageView alloc] init];
    [nameLabelView addSubview:sexImage];
    dengJiLabel = [[UILabel alloc ] init];
    dengJiLabel.layer.masksToBounds = YES;
    dengJiLabel.layer.cornerRadius = 2;
    dengJiLabel.font = [UIFont systemFontOfSize:12];
    dengJiLabel.textColor = [UIColor whiteColor];
    dengJiLabel.backgroundColor = expBJ;
//    dengJiImage.image = [UIImage imageNamed:@"等级-1"];
    [nameLabelView addSubview:dengJiLabel];
    huangGuan = [[UIImageView alloc] init];
    [nameLabelView addSubview:huangGuan];
    [self.bigView addSubview:nameLabelView];
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"发消息-1"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendMessageClick) forControlEvents:UIControlEventTouchUpInside];
//    sendBtn.backgroundColor = beijing;
    [self.bigView addSubview:sendBtn];
}
#pragma mark -- 发送私信
- (void)sendMessageClick
{
    if ( bSeniorMember == YES) {
//        [self requestMessageListWithPage:0];
        [self push];
        
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"只有皇冠会员才有权限发送私信哦~"
                                                               delegate:self
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:@"查看详情", nil];
//            Al = YES;
            [alertView show];

//        [SVProgressHUD showErrorWithStatus:@"只有皇冠会员才有权限发送私信哦~"];
    }
   
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            MyRankViewController *nameVC = [[MyRankViewController alloc] init];
            [self.navigationController pushViewController:nameVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)requestMessageListWithPage:(int)page
{
    [[TTIHttpClient shareInstance] messagelistRequestWithType:@"1"
                                                         page:[NSString stringWithFormat:@"%d", page]
                                              withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                  for (MessageModel * message in response.responseModel) {
                                                      if ([message.user_id isEqualToString:userInfo.user_id]) {
                                                          _msid = message.message_id;
                                                      }
                                                  }
                                                
                                              } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
                                                  
                                              }];
}
- (void)push
{
    MessageModel *message = [[MessageModel alloc] init];
    message.user_id = userInfo.user_id;
    message.message_id = _msid;
    message.nickname = userInfo.nickname;
    
    
    ChatViewController *chatVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.message = message;
    chatVC.meStr = @"他的资料";
    [self.navigationController pushViewController:chatVC animated:YES];

}
- (void)btnAction:(UIButton *) btn
{

    if (btn.tag == 100) {
        [UIView animateWithDuration:0.5 animations:^{
            btnImageLeft.frame = CGRectMake(self.leftLableLeft.constant-8,self.UpViewH.constant - 2 , 50, 2);
        } completion:^(BOOL finished) {
            
        }];
        if (topicListArr.count == 0) {
            self.noMessageLabel.hidden = NO;
            self.noMessageLabel.text = @"此人很懒，还未发表任何话题~";
            
        }else{
            self.noMessageLabel.hidden = YES;
        }

        Hiden = YES;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            btnImageLeft.frame = CGRectMake(UIScreenWidth - self.rightLableRight.constant-50, self.UpViewH.constant - 2 , 50, 2);
        } completion:^(BOOL finished) {
            
        }];
        self.noMessageLabel.hidden = YES;
        Hiden = NO;
    }
    [myTableView reloadData];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestTableDataWithPage:(NSInteger)page
{
    NSLog(@"%ld",topicListArr.count);
    if (arrayTopic.count < 25) {
        footerView.hidden = YES;
        if (xianshiJuHua == NO) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        }else{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        }
        xianshiJuHua = NO;
        
    }else {
        footerView.hidden = NO;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    NSLog(@"%ld",page);

    [[TTIHttpClient shareInstance] userThreadRequestWithUserId:self.userId
                                                      withPage:[NSString stringWithFormat:@"%ld", (long)page]
                                               withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        NSMutableArray *postList = [response.responseModel objectForKey:@"post_list"];
        arrayTopic = postList;
        if(page == 1)
        {
            [topicListArr removeAllObjects];
            [topicListArr addObjectsFromArray:postList];
        }
        else
        {
            [topicListArr addObjectsFromArray:postList];
        }
        if (topicListArr.count == 0) {
            self.noMessageLabel.hidden = NO;
            if (Hiden == YES) {
                self.noMessageLabel.text = @"此人很懒，还未发表任何话题~";
            }else
            {
               self.noMessageLabel.hidden = YES;
            }
            
           
        }else{
            self.noMessageLabel.hidden = YES;
        }

            [myTableView reloadData];
        [headerView endRefresh];
        [footerView endRefresh];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}
//他的资料
-(void)initTableData
{
    [[TTIHttpClient shareInstance] bbsFriendRequestWithUserId:self.userId withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         userInfo = [response.responseModel objectForKey:@"user_info"];
          dengJiStr = [[response.result objectForKey:@"user_info"]objectForKey:@"exp_rank"];
          goldListArr = [response.responseModel objectForKey:@"gold_list"];
            if ([userInfo.user_rank isEqualToString:@"1"]) {
                 huangGuan.hidden = YES;
             }else{
                 huangGuan.hidden = NO;
                 huangGuan.image = [UIImage imageNamed:@"post_detail_hguang"];
             }
         if ([userInfo.sex isEqualToString:@"0"]) {
             sexImage.image = [UIImage imageNamed:@"post_detail_female"];
         }else{
             sexImage.image = [UIImage imageNamed:@"post_detail_male"];
         }
         [self createGoldList];
         // 资深炮友才可以看见他的资料
         if(bSeniorMember == YES)
         {
             NSMutableString *hobbyStr = [[NSMutableString alloc] init];
             for(HobbyModel *hobby in userInfo.hobby)
             {
                 NSString *hobbyName = [hobby name];
                 [hobbyStr appendFormat:@"%@ ",hobbyName];
             }
             HobbyLabel.text = hobbyStr;
             ageLabel.text = userInfo.age;
             starLabel.text = userInfo.constellation;
         }else
         {
             HobbyLabel.text = @"仅皇冠会员可见";
             ageLabel.text = @"仅皇冠会员可见";
             starLabel.text = @"仅皇冠会员可见";
         }
         [self updateHeadView];
         [self updateFooterView];
     } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
         [SVProgressHUD showErrorWithStatus:response.error_desc];
     }];
    
}

-(void)updateHeadView
{
    nickNameLabel.text = userInfo.nickname;
    CGSize size = [nickNameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font(20),NSFontAttributeName, nil]];
    CGFloat dengjiLabelW = [TTIFont calWidthWithText:[NSString stringWithFormat:@"LV.%@",dengJiStr] font:[UIFont systemFontOfSize:13] limitWidth:20];
    int huang;
    if ([userInfo.user_rank isEqualToString:@"2"]) {
        huang = 2;
    }else{
        huang = 1;
    }
    nameLabelView.frame = CGRectMake(0, 0, size.width+3*huang+20*huang+dengjiLabelW, 30);
    nameLabelView.center = CGPointMake(self.bigView.center.x, self.bigView.center.y+20);
     nickNameLabel.frame =  CGRectMake(0,0, size.width, 40);
    sexImage.frame = CGRectMake(nickNameLabel.frame.origin.x+nickNameLabel.frame.size.width+3, nickNameLabel.frame.origin.y+10,20,20);
    huangGuan.frame = CGRectMake(sexImage.frame.origin.x+sexImage.frame.size.width+3, sexImage.frame.origin.y, sexImage.frame.size.width, sexImage.frame.size.height);
    dengJiLabel.text = [NSString stringWithFormat:@"LV.%@",dengJiStr];
    if ([userInfo.user_rank isEqualToString:@"2"]) {
       dengJiLabel.frame = CGRectMake(huangGuan.frame.origin.x+huangGuan.frame.size.width+3, huangGuan.frame.origin.y, dengjiLabelW, huangGuan.frame.size.height);
    }else{
        dengJiLabel.frame = CGRectMake(sexImage.frame.origin.x+sexImage.frame.size.width+3, sexImage.frame.origin.y, dengjiLabelW, sexImage.frame.size.height);
    }
    
    sendBtn.frame = CGRectMake((UIScreenWidth -120)/2, nameLabelView.frame.origin.y+nameLabelView.frame.size.height+10, 120, 25);
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 4;
    [headImgView setImageWithURL:[NSURL URLWithString:userInfo.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    descpLabel.hidden = YES;
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
    if (Hiden == YES) {
        PostListModel *post = [topicListArr objectAtIndex:indexPath.row];
        CGFloat height = [TTIFont calHeightWithText:post.subject font:[UIFont systemFontOfSize:17.0] limitWidth:252]-10;
        if([post.is_pic isEqualToString:@"0"])
        {
//            CellHeight = 110+height;
            return 110+height;
        }
        else
        {
//            CellHeight = 195;
            return 185;
        }

//        PostListModel *post = [topicListArr objectAtIndex:indexPath.row];
//        if([post.is_pic isEqualToString:@"1"])
//        {
//            return 190;
//        }
//        else
//            return 110;
    }else{
        return 40*3 + (goldListArr.count/3+1)*65+100;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 6;
    else
    {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIImageView * image = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 6)];
        image.backgroundColor = BJCLOLR;
        UIImageView * lineView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 1)];
        lineView.image = [UIImage imageNamed:@"post_line"];
        [image addSubview:lineView];
        UIImageView * lineView1 = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 6, UIScreenWidth, 1)];
        lineView1.image = [UIImage imageNamed:@"post_line"];
        [image addSubview:lineView1];

        return image;
    }else
    {
        return nil;
    }
    
}

#pragma mark ---  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (Hiden == YES) {
        return [topicListArr count];
    }else{
        return 1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (Hiden == YES) {
        static NSString *GoldFigureCellIdentifier = @"TopicViewCell";
        
        cell = (TopicViewCell*)[tableView dequeueReusableCellWithIdentifier:GoldFigureCellIdentifier];
        if(cell == nil)
        {
            cell =[[[UINib nibWithNibName:@"TopicViewCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellName = @"HisTopic";
        cell.cancelBtn.hidden = YES;
        PostListModel *post = [topicListArr objectAtIndex:indexPath.row];
        cell.postInfo = post;
//        [cell initWith:CellHeight];
        return cell;
    }else
    {
        static NSString * cellStr = @"ZiLiaoCell";
       UITableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:cellStr];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        [cell1.contentView addSubview:MessageView];
        return cell1;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  显示话题详情页面
     */
    if (Hiden == YES) {
        PostListModel *post = [topicListArr objectAtIndex:indexPath.row];
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
        MyTopicDetailViewController *PostMenuDetailVC = [board instantiateViewControllerWithIdentifier:@"MyTopicDetailViewController"];
        PostMenuDetailVC.string = @"他的话题";
        PostMenuDetailVC.tid = post.tid;
        PostMenuDetailVC.isJoic = post.is_join;
        PostMenuDetailVC.number = post.reply_num;
        PostMenuDetailVC.fid = post.fid;
//        PostMenuDetailVC.quanString = post. 
        [self.navigationController pushViewController:PostMenuDetailVC animated:YES];
    }else{
        return;
    }
   
}

-(void)refreshComments
{
        g_Page = 1;
        [self requestTableDataWithPage:g_Page];
    
  
}

-(void)loadMoreComments
{
    
        g_Page++;
        [self requestTableDataWithPage:g_Page];
    

    
}

@end
