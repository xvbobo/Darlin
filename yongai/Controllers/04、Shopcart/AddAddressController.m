//
//  AddAddressController.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "AddAddressController.h"
#import "CommonUtils.h"
#import "ProvinceSelectView.h"
@interface AddAddressController ()<ProvinceSelectViewDelegate>
{
    UIView *maskView;
    ProvinceSelectView *selectView;
    
    RegionModel *provinceModel; //选择的省
    RegionModel *cityModel; //选择的市
}
@end

@implementation AddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.peopleLable.textColor = BLACKTEXT;
    self.phoneLable.textColor = BLACKTEXT;
    self.diZhiLable.textColor = BLACKTEXT;
    self.youBianLable.textColor = BLACKTEXT;
    self.shengLabel.textColor = BLACKTEXT;
    self.feiBTLable.text = @"(非必填)";
    self.feiBTLable.font = [UIFont systemFontOfSize:13];
    self.feiBTLable.textColor = TEXT;
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
    
    if(_bEdit == YES)
    {
        NAV_INIT(self, @"编辑收货地址", @"common_nav_back_icon", @selector(back), @"完成", @selector(saveAddressInfo));
    }
    else
        NAV_INIT(self, @"填写收货地址", @"common_nav_back_icon", @selector(back), @"完成", @selector(saveAddressInfo));
    
    [self initDataView];
}

-(void)initDataView
{
    provinceModel = [[RegionModel alloc] init];
    cityModel = [[RegionModel alloc] init];
    
    if(_bEdit == YES)
    {
        _nameLabel.text = _addressInfo.consignee;
        _mobileLable.text = _addressInfo.mobile;
        [_provinceBtn setTitle:_addressInfo.province_name forState:UIControlStateNormal];
        [_cityBtn setTitle:_addressInfo.city_name forState:UIControlStateNormal];
        _addressLabel.text = _addressInfo.address;
        _codeLabel.text = _addressInfo.zipcode;
        
        provinceModel.id = _addressInfo.province;
        cityModel.id = _addressInfo.city;
//        [self createCity];
    }
    
}

/**
 *  初始化选择省市的view
 */
-(void)initMaskView
{
    if (maskView == nil) {
        
        maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
        [maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        
        selectView = [[[UINib nibWithNibName:@"ProvinceSelectView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        selectView.frame = CGRectMake((MainView_Width -200)/2,( MainView_Height -300)/2, 200, 300);
        selectView.delegate = self;
        selectView.selectViewType = SelectView_Province;
        
        CGPoint center;
        center.x = maskView.center.x;
        center.y = maskView.center.y - 64;
        selectView.center = center;
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 200, selectView.myFootView.frame.size.height);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hideMaskView) forControlEvents:UIControlEventTouchUpInside];

        
        [selectView.myFootView addSubview:btn];
        [maskView addSubview:selectView];
        [self.view addSubview:maskView];
        maskView.hidden = YES;
    }
}

#pragma mark - Detail Actions
- (void)back{
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

- (IBAction)provinceBtnClick:(id)sender {
    
    if(maskView == nil)
        [self initMaskView];
    
    [[TTIHttpClient shareInstance] regionAddressRequestWithparent_id:@"1" withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        selectView.dataSource = response.responseModel;
        [selectView.myTableView reloadData];
        selectView.titleLabel.text = @"请选择省";
         maskView.hidden = NO;
        
        
        
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}
- (void)createCity
{
    [[TTIHttpClient shareInstance] regionAddressRequestWithparent_id:provinceModel.id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
       NSArray * array = response.responseModel;
        if (array.count == 1) {
            NSLog(@"%@",selectView.dataSource);
            cityModel = [array objectAtIndex:0];
            [_cityBtn setTitle:cityModel.name forState:UIControlStateNormal];
            _cityBtn.enabled = NO;
        }else{
            _cityBtn.enabled = YES;
        }
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];

}
- (IBAction)cityBtnClick:(id)sender {
    if(provinceModel.id == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择省"];
        return;
    }
    
    if(maskView == nil)
        [self initMaskView];
    [[TTIHttpClient shareInstance] regionAddressRequestWithparent_id:provinceModel.id withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        selectView.dataSource = response.responseModel;
        [selectView.myTableView reloadData];
        selectView.titleLabel.text = @"请选择市";
        maskView.hidden = NO;
        
        
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];

    
    
}

-(void)hideMaskView
{
    maskView.hidden = YES;
}

/**
 *  完成按钮的事件
 */
-(void)saveAddressInfo
{
    if(_nameLabel.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人"];
        return;
    }
    else if (_mobileLable.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    else if (provinceModel == nil || provinceModel.name == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择省份"];
        return;
    }
    else if (cityModel == nil || cityModel.name == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择城市"];
        return;
    }
    else if (_addressLabel.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入具体地址"];
        return;
    }
    
    else if (_mobileLable.text.length != 11)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    else if (_codeLabel.text.length>0 && _codeLabel.text.length != 6)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的邮编"];
        return;
    }
    
    
    if(_bEdit == YES)
    {
        [[TTIHttpClient shareInstance] updateAddressRequestWithsid:nil
                                                    withaddress_id:_addressInfo.address_id
                                                     withconsignee:_nameLabel.text
                                                        withmobile:_mobileLable.text
                                                      withprovince:provinceModel.id
                                                          withcity:cityModel.id
                                                       withaddress:_addressLabel.text
                                                       withzipcode:_codeLabel.text
                                                   withSucessBlock:^(TTIRequest *request, TTIResponse *response)
         {
             
             AddressModel *model = response.responseModel;
             //  新创建的若为默认地址，则通知更新
            if([model.default_address isEqualToString:@"1"])
                [[NSNotificationCenter defaultCenter] postNotificationName:Notify_updateAddressList object:model];
             

             [self back];
                                                    } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
        {
            [SVProgressHUD showErrorWithStatus:response.error_desc];
            
                                                    }];
    }
    
    else
    {
        [[TTIHttpClient shareInstance] addAddressRequestWithsid:nil
                                                  withconsignee:_nameLabel.text
                                                     withmobile:_mobileLable.text
                                                   withprovince:provinceModel.id
                                                       withcity:cityModel.id
                                                    withaddress:_addressLabel.text
                                                    withzipcode:_codeLabel.text withSucessBlock:^(TTIRequest *request, TTIResponse *response)
        {
            AddressModel *model = response.responseModel;
            //  新创建的若为默认地址，则通知更新
//            if([model.default_address isEqualToString:@"1"])
                [[NSNotificationCenter defaultCenter] postNotificationName:Notify_updateAddressList object:model];
            [self back];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            [SVProgressHUD showErrorWithStatus:response.error_desc];
        }];
    }
    
}


#pragma mark--- ProvinceSelectViewDelegate <NSObject>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([selectView.titleLabel.text isEqualToString:@"请选择省"])
    {
        provinceModel = [selectView.dataSource objectAtIndex:indexPath.row];
        [_provinceBtn setTitle:provinceModel.name forState:UIControlStateNormal];
        [_provinceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        cityModel = nil;
        [_cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_cityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self createCity];
    }
    else
    {
        cityModel = [selectView.dataSource objectAtIndex:indexPath.row];
        [_cityBtn setTitle:cityModel.name forState:UIControlStateNormal];
        [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [self hideMaskView];
}


@end
