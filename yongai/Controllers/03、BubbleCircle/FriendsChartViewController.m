//
//  FriendsChartViewController.m
//  Yongai
//
//  Created by myqu on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "FriendsChartViewController.h"
#import "FriendsChartCell.h"
#import "ChartRuleViewController.h"
#import "MyInfoViewController.h"
#import "HisTopicViewController.h"
#import "TTIFont.h"
@interface FriendsChartViewController ()
{
    RankModel *userInfo;
    NSMutableArray  *rankArr;
    IBOutlet UITableView *myTableView;
    
    //tableHeaderView
    IBOutlet UIImageView *headImgView;
    IBOutlet UILabel *nickNameLabel;
    IBOutlet UIImageView *sexImgView;
    IBOutlet UILabel *rankLabel;
    IBOutlet UILabel *distanceLabel;
    IBOutlet UILabel *goldNumLabel;
    IBOutlet UIButton *headImgButton;
    NSString * ver;
    UIImageView * image;
    UILabel * dengjiLabel;
    __weak IBOutlet UIImageView *dengJIVIew;
    __weak IBOutlet NSLayoutConstraint *dengjiBViewW;
}

@end

@implementation FriendsChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ver = VERSION;
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0,2, 16, 16)];
//    dengJIVIew.backgroundColor = [UIColor yellowColor];
    [dengJIVIew addSubview:image];
    dengjiLabel  =[[UILabel alloc] init];
    dengjiLabel.textColor = [UIColor whiteColor];
    dengjiLabel.backgroundColor = expBJ;
    dengjiLabel.layer.masksToBounds = YES;
    dengjiLabel.layer.cornerRadius = 2;
    dengjiLabel.font =[UIFont systemFontOfSize:13];
    [dengJIVIew addSubview:dengjiLabel];

    NAV_INIT(self, @"达人榜", @"common_nav_back_icon", @selector(backView), nil, nil);
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = headImgView.frame.size.width/2;
    nickNameLabel.textColor = BLACKTEXT;
    self.paiMingLable.textColor = BLACKTEXT;
    self.bangLable.textColor = BLACKTEXT;
    self.monthLabel.textColor = BLACKTEXT;
    rankLabel.textColor = beijing;
    distanceLabel.textColor = beijing;
    goldNumLabel.textColor = beijing;
    self.footerView.backgroundColor = BJCLOLR;
    // 添加导航栏右侧按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 26)];
    [button setImage:[UIImage imageNamed:@"askBtnBg"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showCharRule) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    myTableView.backgroundColor = BJCLOLR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    rankArr = [[NSMutableArray alloc] init];
    
    [self initTableData];
    
    [headImgButton addTarget:self action:@selector(headBtn) forControlEvents:UIControlEventTouchUpInside];
}

// 点击用户头像， 查看对方用户的个人中心
- (void)headBtn {
    
    MyInfoViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
    myInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myInfoVC animated:YES];
}

-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 显示泡友规则
-(void)showCharRule
{
    ChartRuleViewController *chartVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"ChartRuleViewController"];
    [self.navigationController pushViewController:chartVC animated:YES];
}

-(void)initTableData
{
    [[TTIHttpClient shareInstance] rankingBbsRequestWithFid:_fid withVersion:ver   withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        userInfo = [response.responseModel objectForKey:@"myinfo"];
        rankArr = [response.responseModel objectForKey:@"ranking"];
        
        [self updateTableHead];
    
        [myTableView reloadData];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
    
}

-(void)updateTableHead
{
    if(g_LoginStatus)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[TTIHttpClient shareInstance] userInfoRequestWithsid:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response)
         {
             dengjiLabel.text = [NSString stringWithFormat:@"LV.%@",g_userInfo.dengji];
            CGFloat  dengJiW = [TTIFont calWidthWithText:dengjiLabel.text font:[UIFont systemFontOfSize:13] limitWidth:18];
             dengjiLabel.frame = CGRectMake(image.frame.origin.x+image.frame.size.width+2, image.frame.origin.y, dengJiW, 16);
             dengjiBViewW.constant = dengJiW+16;
         } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
             
         }];
    }

    image.hidden = NO;
    [headImgView setImageWithURL:[NSURL URLWithString:userInfo.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    nickNameLabel.text = userInfo.nickname;
   
    if([userInfo.sex  isEqualToString:@"0"])
        image.image = [UIImage imageNamed:@"post_detail_female"];
    else if([userInfo.sex  isEqualToString:@"1"])
        image.image = [UIImage imageNamed:@"post_detail_male"];
   
    rankLabel.text =[NSString stringWithFormat:@"%d", userInfo.rank.intValue] ;
    distanceLabel.text = [NSString stringWithFormat:@"%d",userInfo.distance.intValue];
    goldNumLabel.text = [NSString stringWithFormat:@"%d分", userInfo.gold_num.intValue];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rankArr count];
//    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsChartCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RankModel *rank = [rankArr objectAtIndex:indexPath.row];
    
    [cell setRankInfo:rank];
    
    cell.headImgButton.tag = indexPath.row;
    [cell.headImgButton addTarget:self action:@selector(headImgBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

// 点击用户头像， 查看对方用户的个人中心
- (void)headImgBtn:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    RankModel *rank = [rankArr objectAtIndex:button.tag];
    
    // 判断泡友榜列表是否显示的时自己
    if ([rank.user_id isEqualToString:g_userInfo.uid]) {
        
        MyInfoViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        myInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myInfoVC animated:YES];

    } else {
        
        HisTopicViewController *otherVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
        otherVC.hidesBottomBarWhenPushed = YES;
        otherVC.userId = rank.user_id;
        [self.navigationController pushViewController:otherVC animated:YES];
    }    
}


@end
