//
//  AddressListController.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "AddressListController.h"
#import "AddressListCell.h"
#import "CommonUtils.h"
#import "AddAddressController.h"
#import "TTIFont.h"
@interface AddressListController ()<EditAddressDelegate>
{
    IBOutlet UITableView *myTableView;
    NSInteger pageCount;
}

@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation AddressListController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTableView.backgroundColor = BJCLOLR;
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
    
    NAV_INIT(self, @"收货人信息", @"common_nav_back_icon", @selector(back), @"新建地址", @selector(doCreateNewAddress));
    
    pageCount = 1;
    _dataSource = [[NSMutableArray alloc] init];
//    [self getDataSourceWithPage:pageCount];
}

-(void)viewWillAppear:(BOOL)animated
{
    AddAddressController * add;
    [super viewWillAppear:animated];
    [add viewWillAppear:animated];
    [self getDataSourceWithPage:pageCount];
}

-(void)getDataSourceWithPage:(NSInteger)page
{
    [[TTIHttpClient shareInstance] getAddressRequestWithsid:nil withpage:[NSString stringWithFormat:@"%ld", (long)page] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        if(page == 1)
        {
            [_dataSource removeAllObjects];
        }
        
        [response.responseModel  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AddressModel *model = (AddressModel *)obj;
            if([model.default_address isEqualToString:@"1"])
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_updateAddressList object:model];
        }];
        
        [_dataSource addObjectsFromArray:response.responseModel];
//        self.backValue([NSString stringWithFormat:@"%ld",_dataSource.count]);
        [myTableView reloadData];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}

#pragma mark - Detail Actions
- (void)doCreateNewAddress
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    AddAddressController *addressVC = [board instantiateViewControllerWithIdentifier:@"AddAddressController"];
//    addressVC.bEdit = YES;
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -  EditAddressDelegate

// 设置默认地址
- (void)selectDefaultAddress:(NSInteger)addId
{
    AddressModel *current = [_dataSource objectAtIndex:addId];
    [[TTIHttpClient shareInstance] setDefaultAddressRequestWithsid:nil withaddress_id:current.address_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        if(response.isSuccess)
        {
            for(AddressModel *model in _dataSource)
            {
                model.default_address = @"0";
            }
            
            current.default_address = @"1";
            [_dataSource replaceObjectAtIndex:addId withObject:current];
            [myTableView reloadData];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_updateAddressList object:current];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];

}


- (void)editCurrentAddress:(NSInteger)addId
{
    AddressModel *current = [_dataSource objectAtIndex:addId];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    AddAddressController *addressVC = [board instantiateViewControllerWithIdentifier:@"AddAddressController"];
    addressVC.bEdit = YES;
    addressVC.addressInfo = current;
    [self.navigationController pushViewController:addressVC animated:YES];
    
}


#pragma mark -  UITableView  Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * image =   [[UIImageView alloc] init];
    image.backgroundColor = BJCLOLR;
    return image;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dataSource count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel * addrInfo = [_dataSource objectAtIndex:indexPath.row];
    CGFloat nameHeight = [TTIFont calHeightWithText:addrInfo.consignee font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth - 40];
   NSString * string = [NSString stringWithFormat:@"%@ %@ %@", addrInfo.province_name, addrInfo.city_name, addrInfo.address];
    CGFloat addH = [TTIFont calHeightWithText:string font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth - 40];
    return 152+ addH -39+nameHeight - 21;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectDefaultAddress:indexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   AddressListCell *cell = (AddressListCell *)[tableView dequeueReusableCellWithIdentifier:@"addressListCell"];
    cell.delegate = self;
    
    cell.addrInfo = [_dataSource objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    return cell;
}
#pragma mark ---- 左划删除地址
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteAddressInfoAtIndex:indexPath];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)deleteAddressInfoAtIndex:(NSIndexPath *)indexPath
{
    AddressModel *model = [_dataSource objectAtIndex:indexPath.row];
    
    [[TTIHttpClient shareInstance] deleteAddressRequestWithsid:nil withaddress_id:model.address_id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        //删除的若为默认地址，则清除地址
        if([model.default_address isEqualToString:@"1"])
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_updateAddressList object:nil];
            
        
        [_dataSource removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
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
