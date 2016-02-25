//
//  ForgetPwdViewController.h
//  yongai
//
//  Created by myqu on 15/1/12.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UITextField *vcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *baocunBtn;


@property (strong, nonatomic) IBOutlet UIButton *sendVcodeBtn;

- (IBAction)sendVcodeBtnClick:(id)sender;
- (IBAction)savePwdBtn:(id)sender;
@end
