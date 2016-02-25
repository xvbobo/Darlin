//
//  RegisterStepOneViewController.h
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

/**
 *  注册 1
 */
@interface RegisterStepOneViewController : UIViewController

@property (nonatomic, strong)NSString *phoneStr;

@property (strong, nonatomic) IBOutlet UITextField *accountTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
//邀请码
@property (strong, nonatomic) IBOutlet UITextField *vercodeTextField;

@property (strong, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIScrollView *oneScroller;

@property (weak, nonatomic) IBOutlet UIView *scrollerContentView;
@property (weak, nonatomic) IBOutlet UIButton *yongHuXieYiLable;
@property (weak, nonatomic) IBOutlet UILabel *zhangHao;
@property (weak, nonatomic) IBOutlet UILabel *miMa;
@property (weak, nonatomic) IBOutlet UILabel *yaoQingMa;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneTop;

@end
