//
//  MyColViewController.m
//  Yongai
//
//  Created by myqu on 14/11/7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyColViewController.h"
#import "MyCollectCell.h"
#import "MCProductDetailViewController.h"

@interface MyColViewController ()
{
    NSInteger  g_Page;
    NSMutableArray  *_dataSource;
    IBOutlet UITableView *myTableView;
}
@end

@implementation MyColViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"我的收藏", @"common_nav_back_icon", @selector(backAction), nil, nil);
    
    myTableView.tableFooterView = [[UIView alloc] init];
    myTableView.backgroundColor = BJCLOLR;
    _dataSource = [[NSMutableArray alloc] init];
//    myTableView
    g_Page = 1;
    [self initTableDataWithPage:g_Page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initTableDataWithPage:(NSInteger)page
{
    
    [[TTIHttpClient shareInstance] goodsEditlistRequestWithsid:nil
                                                      withpage:[NSString stringWithFormat:@"%d", page]
                                               withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        if(page == 1)
        {
            [_dataSource removeAllObjects];
        }
        
        [_dataSource addObjectsFromArray:response.responseModel];
        [myTableView reloadData];
        
                                               } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
     }];
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
    return 120.0;
}

#pragma mark ---  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"MyCollectCell";
    
    MyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil)
    {
        cell = [[[UINib nibWithNibName:@"MyCollectCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoodModel *goods = [_dataSource objectAtIndex:indexPath.row];
    [cell setGoodsInfo:goods];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodModel *goods = [_dataSource objectAtIndex:indexPath.row];
    
    //显示商品详情
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.gid = goods.goods_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
