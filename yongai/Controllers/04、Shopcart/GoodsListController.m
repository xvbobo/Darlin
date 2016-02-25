//
//  GoodsListController.m
//  Yongai
//
//  Created by arron on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "GoodsListController.h"
#import "CommonUtils.h"
#import "OderGoodsCell.h"
@interface GoodsListController ()

@end

@implementation GoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    NAV_INIT(self, @"商品清单", @"common_nav_back_icon", @selector(back), nil, nil);
    
    self.goodsListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.goodsListTable.backgroundColor = BJCLOLR;
}
#pragma mark - Detail Actions
- (void)back{
        [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_giftsArr.count == 0)
        return 1;
    else
        return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)
        return _goodsArr.count;
    else
        return _giftsArr.count;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section ==1)
    {
        OderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zengCell"];
        cell.contentView.backgroundColor = BJCLOLR;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CartListGoodsModel *model = [_goodsArr objectAtIndex:indexPath.row];
        OderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell"];
        
        [cell setGoodsInfo:model];
        return cell;
    }else if (indexPath.section==1)
    {
        GiftGoodsModel *model = [_giftsArr objectAtIndex:indexPath.row];
        OderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zpCell"];
        [cell setGiftInfo:model];
//        cell.contentView.backgroundColor = BJCLOLR;
        return cell;
    }
    return  nil;
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
