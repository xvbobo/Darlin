//
//  TuiSongController.m
//  com.threeti
//
//  Created by alan on 15/8/31.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "TuiSongController.h"
#import "QFControl.h"
#import "ShangPinViewCell.h"
#import "TieZiCell.h"
#import "MyTopicDetailViewController.h"
#import "MCProductDetailViewController.h"
@interface TuiSongController ()<UITableViewDataSource,UITableViewDelegate,TieZiCellDelegate,ShangPinViewCellDelegate>{
    UITableView * myTableView;
    NSMutableArray * goods;
    NSMutableArray * thread_info;
}

@end

@implementation TuiSongController

- (void)viewDidLoad {
    [super viewDidLoad];
     NAV_INIT(self,@"通知", @"common_nav_back_icon", @selector(back), nil, nil);
    goods = [[NSMutableArray alloc] init];
    thread_info = [[NSMutableArray alloc] init];
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, UIScreenWidth, UIScreenHeight)];
    myTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = BJCLOLR;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    self.view.backgroundColor = BJCLOLR;
    [self createRequestWith:g_userInfo.uid];
    // Do any additional setup after loading the view.
}
#pragma mark -- 创建请求
- (void)createRequestWith:(NSString*)uid
{
    [[TTIHttpClient shareInstance] tuisongRequestWith:uid withtype:self.type withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        NSLog(@"%@",[response.responseModel objectForKey:@"goods"]);
        goods = [response.responseModel objectForKey:@"goods"];
        thread_info = [response.responseModel objectForKey:@"thread_info"];
        [myTableView reloadData];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
    
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat With = (UIScreenWidth-30)/4;
    if (indexPath.row == 0) {
        if (goods.count == 0) {
//            return With + 90;
            return 0;
        }
        else if (goods.count < 3) {
            
            return With + 90;

        }else{
            return With*2+100;
        }
    }else{
        if (thread_info.count) {
            return 80*thread_info.count+80;
        }else{
            return 600;
        }
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * cell1 = @"shangPinCell";
        ShangPinViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (cell == nil) {
            cell = [[ShangPinViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
        }
        if (goods.count!= 0) {
            [cell ShangPinWithArray:goods];
        }
        cell.delegate = self;
        cell.backgroundColor = BJCLOLR;
        return cell;
        
    }else{
        static NSString * cell2 = @"tiezicell";
        TieZiCell * cell = [tableView dequeueReusableCellWithIdentifier:cell2];
        if (cell == nil) {
            cell = [[TieZiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2];
        }
        if (thread_info.count) {
            [cell TieZiWithArray:thread_info];

        }
        cell.delegate = self;
        cell.backgroundColor = BJCLOLR;
        return cell;
    }
}
#pragma mark -- 商品详情
- (void)ShangPinViewCellButtonAction:(NSString *)goods_id
{
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.gid = goods_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark -- 帖子详情
- (void)buttonAction:(NSString *)tid withFid:(NSString *)fid
{
    MyTopicDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyTopicDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.tid = tid;
    detailVC.fid = fid;
    [self.navigationController pushViewController:detailVC animated:YES];

}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];

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
