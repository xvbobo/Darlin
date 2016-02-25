//
//  MyInfoViewController.m
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UserInfoCell.h"
#import "AddressListController.h"
#import "ModifyNickNameViewController.h"
#import "MyRankViewController.h"
#import "ChangePeepPasswordViewController.h"
#import "HostCityViewController.h"
#import "QFControl.h"
#import "AFHTTPRequestOperationManager.h"
#import "ProvinceSelectView.h"

#define HEIGHT_PICKER  210 ///< 时间选择器的高度
#define QDBJ RGBACOLOR(23, 17, 26,0.7)
@interface MyInfoViewController ()<UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ProvinceSelectViewDelegate>
{
    
    UIImagePickerController *imagePicker;
    MyInfoViewController * MINC;
    NSArray *titleArrSection0;
    NSArray *titleArrSection1;
    
    IBOutlet UITableView *myTableView;
    
    UIView *genderView; // 用户性别选择的view
    
    // 选择性别的button
    UIButton *maleBtn;
    UIButton *femaleBtn;

    //  更改用户兴趣爱好
    UIView *maskView;
    ProvinceSelectView *selectView;
    NSMutableArray  *hobbyArray;
    
    UISwitch *switchView;
    UIView *qiandaoView; // 浮层视图
    UIImageView * qiandaoBj;//签到背景
    UILabel * qiandaoLB;

}
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    qiandaoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    qiandaoView.alpha = 0;
    qiandaoView.backgroundColor = QDBJ;
    qiandaoBj = [[UIImageView alloc] initWithFrame:CGRectMake(20, (UIScreenHeight-UIScreenWidth-40)/2, UIScreenWidth-40, UIScreenWidth-40)];
    qiandaoBj.image = [UIImage imageNamed:@"领取金币"];
    qiandaoLB = [[UILabel alloc] initWithFrame:CGRectMake(50, qiandaoBj.frame.size.height/4*3-40, qiandaoBj.frame.size.width-100, 30)];
    qiandaoLB.textColor = [UIColor whiteColor];
    qiandaoLB.font = [UIFont systemFontOfSize:17];
    qiandaoLB.textAlignment = NSTextAlignmentCenter;
    [qiandaoBj addSubview:qiandaoLB];
//    [qiandaoView addSubview:qiandaoBj];
    NAV_INIT(self, @"我的信息", @"common_nav_back_icon", @selector(backAction), nil, nil);
    self.view.backgroundColor = BJCLOLR;
    // 相机
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    myTableView.backgroundColor = BJCLOLR;
    myTableView.tableHeaderView.backgroundColor = BJCLOLR;
    switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchView addTarget:self action:@selector(chick_Switch:) forControlEvents:UIControlEventValueChanged];
    
    
    [self initTableViewData];
    [self initDatePicker];
    
    [self requestUserInfo];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    //    [self SureDataPicker];
    [super viewWillAppear:animated];
    [MINC viewWillAppear:animated];
    [myTableView reloadData];
}
-(void)requestUserInfo
{
    [[TTIHttpClient shareInstance] userInfoRequestWithsid:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [myTableView reloadData];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}

/**
 *  初始化选择兴趣爱好的view
 */
-(void)initMaskView
{
    if (maskView == nil) {
        
        hobbyArray = [[NSMutableArray alloc] init];
        
        if (IOS6) {
            
            maskView = [[UIView alloc] initWithFrame:self.view.frame];
        }
        else
            maskView = [[UIView alloc] initWithFrame:self.view.superview.frame];
        
        [maskView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        
        selectView = [[[UINib nibWithNibName:@"ProvinceSelectView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        selectView.frame = CGRectMake((MainView_Width -200)/2,( MainView_Height -300)/2, 200, 300);
        selectView.delegate = self;
        selectView.titleLabel.text = @"您的兴趣爱好是？";
        selectView.selectViewType = SelectView_Hobby;
        
        CGPoint center;
        center.x = maskView.center.x;
        
        if (IOS6) {
            
            center.y = maskView.center.y;
        }
        else
            center.y = maskView.center.y - 64;
        
        selectView.center = center;
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 100, selectView.myFootView.frame.size.height);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hideMaskView) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(100, 0, 100, selectView.myFootView.frame.size.height);
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(changeHobbyAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *verLine = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 1, selectView.myFootView.frame.size.height)];
        verLine.backgroundColor = [UIColor lightGrayColor];
        [selectView.myFootView addSubview:verLine];
        
        [selectView.myFootView addSubview:rightBtn];
        [selectView.myFootView addSubview:btn];
        
        [maskView addSubview:selectView];
        [self.view addSubview:maskView];
        
        maskView.hidden = YES;
    }
}

-(void)initTableViewData
{
    titleArrSection0 = [NSArray arrayWithObjects:@"我的头像:", @"我的等级:", @"我的昵称:", @"我的账号:", @"修改密码:",nil];
    titleArrSection1 = [NSArray arrayWithObjects:@"性别:", @"生日:", @"年龄:", @"星座:", @"所在城市:", @"兴趣爱好:", @"是否公开年龄与星座信息:", nil];
    [self addTableFooterView];
}


-(void)addTableFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.frame.size.width, 120)];
    footView.backgroundColor =BJCLOLR;
    
    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setBackgroundImage:[UIImage imageNamed:@"receiveManagBtn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showAddrManageView) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:button];
    
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:footView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0]];
    
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:footView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:30]];
    
    myTableView.tableFooterView = footView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0;
    else
        return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * image = [[UIImageView alloc] init];
    image.backgroundColor = BJCLOLR;
    return image;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
            return 75;
        else
            return 50;
    }
    else
        return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 5;
    else
        return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"UserInfoCell";
    
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImgView.hidden = YES;
    
    cell.titleLabel.hidden = NO;
    cell.textLabel.hidden = YES;
    cell.descpLabel.hidden = NO;
     cell.titleLabel.textColor = TEXT;
    cell.accessoryView = nil;
    
    if(indexPath.section == 0)
    {
        cell.titleLabel.text = [titleArrSection0 objectAtIndex:indexPath.row];
       
        if(indexPath.row ==0 )
        {
            // 隐藏不可修改的标识
            cell.promptLabel.hidden = YES;
            cell.descpLabel.hidden = YES;
           
            cell.headImgView.hidden = NO;
            //用户头像
            [cell.headImgView setImageWithURL:[NSURL URLWithString:g_userInfo.user_photo] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];

        }
        else if(indexPath.row == 1)
        {
            // 隐藏不可修改的标识
            cell.promptLabel.hidden = YES;
            if ([g_userInfo.user_rank isEqualToString:@"2"]) {
                 cell.descpLabel.text = @"皇冠会员";
            }else{
                cell.descpLabel.text = @"赤贫会员";
            }
           
        }
        else if (indexPath.row == 2)
        {
            // 隐藏不可修改的标识
            cell.promptLabel.hidden = YES;
            cell.descpLabel.text = g_userInfo.nickname;
        }
        else if (indexPath.row == 3)
        {
            cell.descpLabel.text = g_userInfo.email;
            
            // 显示不可修改的标识
            cell.promptLabel.hidden = NO;
        }
        else if(indexPath.row == 4)
        {
            // 隐藏不可修改的标识
            cell.promptLabel.hidden = YES;
            cell.descpLabel.text = nil;
        }
    }
    else if(indexPath.section == 1)
    {
        // 隐藏不可修改的标识
        cell.promptLabel.hidden = YES;
        cell.descpLabel.hidden = NO;
        cell.titleLabel.hidden = NO;
        cell.textLabel.hidden = YES;
        
        
        cell.titleLabel.text = [titleArrSection1 objectAtIndex:indexPath.row];
        if(indexPath.row ==0 )
        {
            if([g_userInfo.sex isEqualToString:@"1"])
                cell.descpLabel.text = @"男";
            else
                cell.descpLabel.text = @"女";
        }
        else if (indexPath.row == 1)
        {
            [textField removeFromSuperview];
            [cell.contentView addSubview:textField];
            if ([g_userInfo.birthday isEqualToString:@"0000-00-00"]) {
//                cell.descpLabel.text = @"请完善您的生日";
                cell.descpLabel.text = @"未填写";
            }else{
               cell.descpLabel.text = g_userInfo.birthday;
            }
            
        }
        else if (indexPath.row == 2)
        {
            if ([g_userInfo.age isEqualToString:@"0"]){
                cell.descpLabel.text = @"未知";
                cell.descpLabel.textColor = cell.titleLabel.textColor;

            }else{
                cell.descpLabel.text = g_userInfo.age;
  
            }
        }
        
        else if (indexPath.row == 3)
            cell.descpLabel.text = g_userInfo.constellation;
        else if (indexPath.row == 4)
            cell.descpLabel.text = g_userInfo.cityname;
        else if(indexPath.row == 5)
        {
            NSMutableString *hobbyStr = [[NSMutableString alloc] init];
            NSArray *hobbyArr = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_hobby];
            for(HobbyModel *hobby in hobbyArr)
            {
                [hobbyStr appendFormat:@" %@",[hobby name]];
            }
            cell.descpLabel.text = hobbyStr;
        }
        else if (indexPath.row == 6)
        {
            cell.textLabel.text = [titleArrSection1 objectAtIndex:indexPath.row];
            cell.textLabel.textColor = cell.titleLabel.textColor;
            cell.textLabel.font = cell.titleLabel.font;
            
             cell.textLabel.hidden = NO;
            cell.titleLabel.hidden = YES;
            cell.descpLabel.hidden = YES;
            
            switchView.hidden = NO;
            cell.accessoryView = switchView;
            
            NSInteger openTag= g_userInfo.isOpen.intValue;
            if(openTag == 1)
                switchView.on = YES;
            else if(openTag == 2)
                switchView.on = NO;
            
            
        }
    }
    
    // 隐藏右箭头
    if(indexPath.section == 0)
    {
        if(indexPath.row == 3 )
            cell.rightTriangleBtn.hidden = YES;
        else
            cell.rightTriangleBtn.hidden = NO;
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6)
            cell.rightTriangleBtn.hidden = YES;
        else
            cell.rightTriangleBtn.hidden = NO;
    }
    
    if(cell.descpLabel.text.length == 0 && ![cell.titleLabel.text isEqualToString:[titleArrSection0 objectAtIndex:4]])
    {
        if (indexPath.row == 3) {
            cell.descpLabel.text = @"未知";
        }else {
           cell.descpLabel.text = @"未填写";
        }
        cell.descpLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 选择兴趣爱好
    if(tableView == selectView.myTableView)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = (UIButton *)cell.accessoryView;
        if(btn.selected == YES)
        {
            [hobbyArray addObject:[selectView.dataSource objectAtIndex:indexPath.row]];
        }
        else
            [hobbyArray removeObject:[selectView.dataSource objectAtIndex:indexPath.row]];
        
        return;
    }
    
    if(indexPath.section == 0)
    {
        
        if(indexPath.row == 0)
        {
            [self showPictureView];
        }
        else if (indexPath.row == 1)
        {
//            MyRankViewController *nameVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"MyRankViewController"];
            MyRankViewController * nameVC = [[MyRankViewController alloc] init];
            
            [self.navigationController pushViewController:nameVC animated:YES];
        }
        else if (indexPath.row == 2)
        {
            ModifyNickNameViewController *nameVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"ModifyNickNameViewController"];
            [self.navigationController pushViewController:nameVC animated:YES];
        }
        else if(indexPath.row == 4)
        {
            ChangePeepPasswordViewController *peepVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePeepPasswordViewController"];
            [self.navigationController pushViewController:peepVC animated:YES];
        }
    }
    else
    {
        if(indexPath.row == 4) // 所在城市
        {
            HostCityViewController *cityVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HostCityViewController"];
            [self.navigationController pushViewController:cityVC animated:YES];
            
        }
        else if(indexPath.row == 5) // 兴趣爱好
        {
            [self showHobbySelectView];
        }
    }
}

#pragma mark - 更换兴趣爱好
-(void)showHobbySelectView
{
    if(maskView == nil)
        [self initMaskView];
    
    // 将之前选择的hobby清空
    [hobbyArray removeAllObjects];
    
    [[TTIHttpClient shareInstance] hobbyRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        selectView.dataSource = response.responseModel;
        [selectView.myTableView reloadData];
        
        maskView.hidden = NO;
        
        // 完善资料发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFI_MyInfoViewControllerHobby" object:nil];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
    
}

#pragma mark --- 保密开关
-(void)chick_Switch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if(switchView.isOn == YES)
        [self requestSaveUserInfo:1];
    else
        [self requestSaveUserInfo:2];
}

// 0:代表显示  1：代表隐藏
-(void)requestSaveUserInfo:(NSInteger)openTag
{
    [[TTIHttpClient shareInstance] userEditRequestWithOnOff:[NSString stringWithFormat:@"%ld", (long)openTag] withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        g_userInfo.isOpen = [NSString stringWithFormat:@"%ld", (long)openTag];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

#pragma mark - 更换头像
- (void)showPictureView{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中取", nil];
    [sheet showInView:self.view];
}

#pragma mark ---  UIActionSheet  Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // 拍照
        {
            BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if(isCameraSupport)
            {
                
                // 设置为YES，表示 允许用户编辑图片，否则，不允许用户编辑
                imagePicker.allowsEditing = YES;
                
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"不支持拍照"];
            }
        }
            break;
        case 1: // 从相册中取
        {
            BOOL isPhotosAlbumSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            
            if(isPhotosAlbumSupport)
            {
                // 设置为YES，表示 允许用户编辑图片，否则，不允许用户编辑
                imagePicker.allowsEditing = YES;
                
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"不支持相册读取"];
            }
        }
            break;
        case 2: //取消
        {
        }
            break;
        default:
            break;
    }
}

//用户点击选取器中的“choose”按钮时被调用，告知委托对象，选取操作已经完成，同时将返回选取图片的实例
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *orgImage = editingInfo[UIImagePickerControllerOriginalImage];
        //  如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(orgImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithStatus:@"上传中..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    [[TTIHttpClient shareInstance] upload_headRequestWithsid:nil withfile:image withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        g_userInfo.pay_points = [response.result objectForKey:@"pay_points"];
        g_userInfo.user_photo = [response.result objectForKey:@"head_photo"];
        [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [SVProgressHUD dismiss];
        
        // 完善资料发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFI_MyInfoViewControllerHobby" object:nil];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];

    
}

//用户点击图像选取器中的“cancel”按钮时被调用，这说明用户想要中止选取图像的操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissImagePickerController
{
    if (self.presentedViewController)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    
    NSLog(@"saved..");
}

#pragma mark  ----- 收货信息管理
-(void)showAddrManageView
{
    AddressListController *addVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil]  instantiateViewControllerWithIdentifier:@"AddressListController"];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma  mark ----- 时间选择器页面
/**
 *	@brief	初始化UIDatePicker
 */
- (void)initDatePicker
{
    // 初始化UIDatePicker
    datePicker = [[UIDatePicker alloc]init];
    
    // 初始化UIDatePicker
    datePicker.frame = CGRectMake(0, MainView_Height, MainView_Width, HEIGHT_PICKER);
    // 设置时间的中文显示方式
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    // 设置时区
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/beijing"]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMaximumDate:[NSDate date]];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (![g_userInfo.birthday isEqualToString:@"0000-00-00"]) {
        NSDate *birthDate = [formatter dateFromString:g_userInfo.birthday];
        [datePicker setDate:birthDate animated:YES];
    }
   
    
    
    doneBar =[[UIToolbar alloc] initWithFrame:CGRectMake(0, MainView_Height-HEIGHT_PICKER-40, MainView_Width, 40)];
    doneBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    [cancleBtn addTarget:self action:@selector(cancleDataPicker) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainView_Width-50, 0, 40, 40)];
    [button addTarget:self action:@selector(SureDataPicker) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    
    [doneBar addSubview:cancleBtn];
    [doneBar addSubview:button];
    [doneBar setBackgroundColor:[UIColor lightGrayColor]];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(-5, 0, MainView_Width, 44)];
//    textField.text = @"请完善您的生日";
    textField.delegate = self;
    [textField setInputAccessoryView:doneBar];
    [textField setInputView:datePicker];
}

-(void)cancleDataPicker
{
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
//改变生日
-(void)SureDataPicker
{
    // 获得当前UIPickerDate所在的时间
    NSDate *selectedTime = [datePicker date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *birthDay = [formatter stringFromDate:selectedTime];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:selectedTime];
    int age = time/31536000;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:selectedTime];
    
    NSString *constellation = [self getAstroWithMonth:[comps month] day:[comps day]];
    
    [[TTIHttpClient shareInstance] userEditbirthdayRequestWithconstellation:constellation
                                                               withBirthday:birthDay
                                                          withAge:[NSString stringWithFormat:@"%d", age]
                                                  withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
         NSString * str = response.error_desc;
        [self createQianDaoWith:str];
        [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:
                                             [NSIndexPath indexPathForRow:1 inSection:1],
                                             [NSIndexPath indexPathForRow:2 inSection:1],
                                             [NSIndexPath indexPathForRow:3 inSection:1], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        
                                                  } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
    {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
        
                                                  }];
    
    
}
- (void)createQianDaoWith:(NSString *)str
{
    
        if ([str isEqualToString:@"皇冠会员"]) {
                NSString * string = @"恭喜您，升级为皇冠会员 !";
                NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:string];
                NSRange range1 = [string rangeOfString:str];
                NSRange redRange = NSMakeRange(range1.location, range1.length);
                [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
                UILabel * lable = [[UILabel alloc] init];
                [lable setAttributedText:string1];
                UIImageView * shengjiView = [QFControl createUIImageFrame:CGRectMake(30, (UIScreenHeight-UIScreenWidth+100)/2, UIScreenWidth-60, UIScreenHeight/3) imageName:@"升级" withStr1:string1 withStr: @"您可到个人中心“我的等级”页面查看详情" withStr3:@"么么哒~"];
                [UIView animateWithDuration:1.5 animations:^{
                    qiandaoView.alpha = 1;
                }];
                [qiandaoView addSubview:shengjiView];
            }else{
                if (![str isEqualToString:@"个"]) {
                    qiandaoLB.text = [NSString stringWithFormat:@"恭喜~获得%@金币",str];
                    [UIView animateWithDuration:1.5 animations:^{
                        qiandaoView.alpha = 1;
                    }];
                    [qiandaoView addSubview:qiandaoBj];
                }
    
            }
            [self.navigationController.view addSubview:qiandaoView];
    if ([str isEqualToString:@"皇冠会员"]) {
        [self performSelector:@selector(hideView) withObject:nil afterDelay:2.5];
    }else{
        [self performSelector:@selector(hideView) withObject:nil afterDelay:1.5];
    }
    
 
}
/**
 *  根据日月算出星座
 *
 *  @param m 月份
 *  @param d 日期
 *
 *  @return 星座
 */
-(NSString *)getAstroWithMonth:(int)m day:(int)d{
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    
    NSString *astroFormat = @"102123444543";
    
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        
        return @"错误日期格式!";
        
    }
    
    if(m==2 && d>29)
        
    {
        
        return @"错误日期格式!!";
        
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthDate = [formatter dateFromString:@"1991-11-16"];
    [datePicker setDate:birthDate animated:YES];
    return YES;
}

#pragma selectView btn Action
-(void)hideMaskView
{
    maskView.hidden = YES;
}
//改变兴趣爱好
-(void)changeHobbyAction
{
    // 最多可以选择三项
    if (hobbyArray.count > 3) {
        
        [SVProgressHUD showErrorWithStatus:@"兴趣爱好最多可以选择三项！"];
        return;
    }
    
    [self hideMaskView];
    
    if(hobbyArray.count == 0)
        return;
    
    NSMutableString *hobbyStr = [[NSMutableString alloc] init];
    for(HobbyModel *model in hobbyArray)
    {
        [hobbyStr appendFormat:@"%@,", model.id];
    }
    [hobbyStr deleteCharactersInRange:NSMakeRange([hobbyStr length]-1, 1)];
    
    [[TTIHttpClient shareInstance] userEdithobbyRequestWithsid:nil withHobby:hobbyStr withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        NSString * str = response.error_desc;
        [self createQianDaoWith:str];
        [[LocalStoreManager shareInstance] setValueInDefault:hobbyArray withKey:DefaultKey_hobby];
        
        [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:
                                             [NSIndexPath indexPathForRow:5 inSection:1], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}
- (void)hideView
{
    [UIView animateWithDuration:1.5 animations:^{
        qiandaoView.alpha = 0;
    }];
}
@end
