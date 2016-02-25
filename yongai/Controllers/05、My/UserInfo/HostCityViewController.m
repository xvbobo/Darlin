//
//  HostCityViewController.m
//  Yongai
//
//  Created by myqu on 14/11/27.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "HostCityViewController.h"
#import "ProvinceSelectView.h"

@interface HostCityViewController ()<ProvinceSelectViewDelegate>
{
    UIView *maskView;
    ProvinceSelectView *selectView;
    
    RegionModel *provinceModel; //选择的省
    RegionModel *cityModel; //选择的市
}
@end

@implementation HostCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baoCunBtn.backgroundColor = beijing;
    NAV_INIT(self, @"所在城市", @"common_nav_back_icon", @selector(backAction), nil, nil);
    self.view.backgroundColor = BJCLOLR;
    [_provinceBtn setTitle:g_userInfo.provincename forState:UIControlStateNormal];
    [_cityBtn setTitle:g_userInfo.cityname forState:UIControlStateNormal];
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

-(void)backAction
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


-(void)hideMaskView
{
    maskView.hidden = YES;
}


- (IBAction)provinceBtnClick:(id)sender
{
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


- (IBAction)cityBtnClick:(id)sender
{
    if(provinceModel == nil)
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

- (IBAction)saveBtnClick:(id)sender
{
    if (provinceModel == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择省份"];
        return;
    }
    else if (cityModel == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择城市"];
        return;
    }
    
    [[TTIHttpClient shareInstance] userEditprovinceRequestWithsid:nil
                                                     withProvince:provinceModel.id
                                                         withCity:cityModel.id
                                                  withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         g_userInfo.province = provinceModel.id;
         g_userInfo.provincename = provinceModel.name;
         
         g_userInfo.city = cityModel.id;
         g_userInfo.cityname = cityModel.name;
         
         [[LocalStoreManager shareInstance] setValueInDefault:g_userInfo withKey:DefaultKey_Userinfo];
         
         [self backAction];
                                                  } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
    {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
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
