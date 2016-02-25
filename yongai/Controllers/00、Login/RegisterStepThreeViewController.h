//
//  RegisterStepThreeViewController.h
//  Yongai
//
//  Created by Kevin Su on 14-10-31.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"
#import "ProvinceSelectView.h"

/**
 *  注册 3
 */
@interface RegisterStepThreeViewController : UIViewController<ProvinceSelectViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *finishButton;

@property (strong, nonatomic) IBOutlet UIView *maleView;

@property (strong, nonatomic) IBOutlet UIView *femaleView;

@property (strong, nonatomic) IBOutlet UIImageView *maleSelectIcon;

@property (strong, nonatomic) IBOutlet UIImageView *femaleSelectIcon;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *sexLable;
@property (weak, nonatomic) IBOutlet UILabel *nanLable;
@property (weak, nonatomic) IBOutlet UILabel *nvLable;
@property (weak, nonatomic) IBOutlet UILabel *gengGaiLabel;


@property (nonatomic, strong) RegisterModel *registerModel;
@end
