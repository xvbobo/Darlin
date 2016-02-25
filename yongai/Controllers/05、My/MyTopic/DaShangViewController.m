//
//  DaShangViewController.m
//  com.threeti
//
//  Created by alan on 15/8/28.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "DaShangViewController.h"
#import "QFControl.h"
#import "DaShangCell.h"
#import "MyTopicViewController.h"
#import "HisTopicViewController.h"
#import "MyGoldViewController.h"
@interface DaShangViewController ()<UITableViewDataSource,UITableViewDelegate,DaShangCellDelegate,QFControlDelegate>{
    UITableView * myTableView;
    UIImageView * qianDaoView;
    UIImageView * jibiView;
    NSMutableArray * dashangArr;
    UILabel * dashanglabel;
    UIImageView * dashangImage;
    UIImageView * newjibiView ;
    
}

@end

@implementation DaShangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dashangArr = [[NSMutableArray alloc] init];
    qianDaoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    //    dashangYOrN = YES;
    qianDaoView.alpha = 0;
    qianDaoView.userInteractionEnabled = YES;
    qianDaoView.backgroundColor = QDBJ;
    self.view.backgroundColor = BJCLOLR;
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-180)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    NAV_INIT(self, nil, @"common_nav_back_icon", @selector(backAction), nil, nil);
    [self createDaShangView];
    [self.view addSubview:myTableView];
    // Do any additional setup after loading the view.
 
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createDaShangView
{
   dashangImage = [[UIImageView alloc ] initWithFrame:CGRectMake(0, UIScreenHeight - 180, UIScreenWidth, 180)];
    dashangImage.userInteractionEnabled = YES;
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5)];
    line.backgroundColor = LINE;
    [dashangImage addSubview:line];
    newjibiView = [QFControl createUIImageFrame:CGRectMake((UIScreenWidth - 65)/2, (dashangImage.frame.size.height- 65)/2-20, 65, 65) withname:@"打赏成功"];
    newjibiView.hidden = YES;
    [dashangImage addSubview:newjibiView];
    dashangImage.backgroundColor = [UIColor whiteColor];
    jibiView = [QFControl createUIImageFrame:CGRectMake((UIScreenWidth - 65)/2, (dashangImage.frame.size.height- 65)/2-20, 65, 65) withname:@"打赏"];
    jibiView.hidden = NO;
    dashanglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, UIScreenWidth, 20)];
    dashanglabel.text = [NSString stringWithFormat:@"%ld人打赏",self.array.count];
    dashanglabel.textColor = beijing;
    dashanglabel.textAlignment = NSTextAlignmentCenter;
    dashanglabel.font = [UIFont systemFontOfSize:13];
    [dashangImage addSubview:dashanglabel];
    [dashangImage addSubview:jibiView];
    UIButton * dashang = [UIButton buttonWithType:UIButtonTypeCustom];
//    dashang.hidden = YES;
    dashang.tag = 200;
//    dashang.backgroundColor = BJCLOLR;
    dashang.frame = CGRectMake((UIScreenWidth - 65)/2, (dashangImage.frame.size.height- 65)/2-20, 65, 65);
//    [dashang setImage:[UIImage imageNamed:@"打赏"] forState:UIControlStateNormal];
//    [dashang setImage:[UIImage imageNamed:@"打赏成功"] forState:UIControlStateSelected];
    [dashang addTarget:self action:@selector(dashang:) forControlEvents:UIControlEventTouchUpInside];
    [dashangImage addSubview:dashang];
    [self.view addSubview:dashangImage];
}
- (void)dashang:(UIButton*)btn
{
        if (g_userInfo.pay_points.intValue < 2) {
        CGRect frame = CGRectMake(40, (UIScreenHeight - 150)/2, UIScreenWidth - 80, 150);
        UIImageView * image = [[UIImageView alloc] initWithFrame:frame];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 5;
        image.userInteractionEnabled = YES;
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/4, frame.size.width, frame.size.height/7)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = font(20);
        lable.text = @"您的金币不够哟~";
        lable.textColor = BLACKTEXT;
        [image addSubview:lable];
        CGFloat buttonW = (frame.size.width - 80)/2;
        for (int i=0; i< 2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 3;
            button.frame = CGRectMake(30+i*(buttonW+20), lable.frame.origin.y+lable.frame.size.height+20,buttonW , frame.size.height/3-10);
            if (i==0) {
                [button setTitle:@"好吧" forState:UIControlStateNormal];
                button.backgroundColor = TEXT;
            }else{
                [button setTitle:@"去赚金币" forState:UIControlStateNormal];
                button.backgroundColor = beijing;
            }
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(dashangbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [image addSubview:button];
        }
        
        image.backgroundColor = [UIColor whiteColor];
        QFControl * qf = [[QFControl alloc] init];
        qf.delegate  = self;
        [UIView animateWithDuration:1.5 animations:^{
            qianDaoView.alpha = 1;
        }];
        [qianDaoView addSubview:image];
        [self.navigationController.view addSubview:qianDaoView];
        
        
    }else{
        [[TTIHttpClient shareInstance] bbsPostRequestWithTid:self.tid withFid:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            jibiView.hidden = YES;
            newjibiView.hidden = NO;
            [self requestdaShang];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            [SVProgressHUD showErrorWithStatus:response.error_desc];
        }];
    }

}
- (void)dashangbuttonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"好吧"]) {
            qianDaoView.alpha = 0;
        }else{
            //去赚金币
            qianDaoView.alpha = 0;
            MyGoldViewController *goldVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyGoldViewController"];
            goldVC.hidesBottomBarWhenPushed = YES;
            goldVC.myTitle = @"我的金币";
            [self.navigationController pushViewController:goldVC animated:YES];
        }
}
- (void)requestdaShang
{
    [[TTIHttpClient shareInstance] bbsPostRequestWithTid:self.tid withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        dashangArr = [response.result objectForKey:@"result"];
        self.array = dashangArr;
        dashanglabel.text = [NSString stringWithFormat:@"%ld人打赏",self.array.count];
//        [self updatedaShang:dashangArr];
        [myTableView reloadData];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == self.array.count-1) {
//        return 0;
//    }else{
      return 0.5;
//    }
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     UIImageView * line = [[UIImageView alloc] init];
       line.backgroundColor = LINE;
    return line;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dashangcell = @"dashangcell";
    DaShangCell * cell = [tableView dequeueReusableCellWithIdentifier:dashangcell];
    if (cell == nil) {
        cell = [[DaShangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dashangcell];
    }
    NSDictionary * dict = [self.array objectAtIndex:indexPath.section];
    if (dict) {
        [cell upCellWithDict:dict];
    }
    cell.delegate =self;
    return cell;
    
}
#pragma mark - PullTableViewDelegate
- (void)headClick:(NSString *)user_id
{
    if ([user_id isEqualToString:g_userInfo.uid]) {
        MyTopicViewController *topicVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyTopicViewController"];
        topicVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topicVC animated:YES];
    }
    else{
        HisTopicViewController *topicVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
        topicVC.userId = user_id;
        [self.navigationController pushViewController:topicVC animated:YES];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
