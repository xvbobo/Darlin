//
//  ChangePeepPasswordViewController.h
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  修改密码
 */
@interface ChangePeepPasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *oldPassowrd;
@property (strong, nonatomic) IBOutlet UITextField *passowrd;
@property (strong, nonatomic) IBOutlet UITextField *passowrd2;
@property (weak, nonatomic) IBOutlet UILabel *shuruMiMa;
@property (weak, nonatomic) IBOutlet UILabel *shuRuNewMiMa;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;
@property (weak, nonatomic) IBOutlet UILabel *sureMiMa;

- (IBAction)sureBtn:(id)sender;

@end
