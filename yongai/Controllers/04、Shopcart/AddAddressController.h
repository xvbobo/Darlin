//
//  AddAddressController.h
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  编辑/新建地址
 */
@interface AddAddressController : UIViewController
@property(nonatomic, strong)AddressModel *addressInfo; //收货地址的数据
@property(nonatomic, assign)BOOL bEdit; // 是否编辑收货地址


@property (strong, nonatomic) IBOutlet UITextField *nameLabel; // 收货人
@property (strong, nonatomic) IBOutlet UITextField *mobileLable; //手机
@property (strong, nonatomic) IBOutlet UITextField *addressLabel; //地址

@property (strong, nonatomic) IBOutlet UITextField *codeLabel; //邮编
@property (strong, nonatomic) IBOutlet UIButton *provinceBtn;
@property (strong, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UILabel *peopleLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *shengLabel;
@property (weak, nonatomic) IBOutlet UILabel *diZhiLable;
@property (weak, nonatomic) IBOutlet UILabel *youBianLable;
@property (weak, nonatomic) IBOutlet UILabel *feiBTLable;

// 选择省份的事件
- (IBAction)provinceBtnClick:(id)sender;
//选择城市的事件
- (IBAction)cityBtnClick:(id)sender;



@end
