//
//  JuBaoViewController.h
//  xv
//
//  Created by alan on 15/4/2.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuBaoViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;
- (IBAction)selectBtn:(UIButton *)sender;

- (IBAction)BCBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *buLabel;
@property (weak, nonatomic) IBOutlet UILabel *lablel1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;
@property (weak, nonatomic) IBOutlet UILabel *lable4;
@property (weak, nonatomic) IBOutlet UILabel *lable5;
@property (weak, nonatomic) IBOutlet UILabel *lable6;
@property (weak, nonatomic) IBOutlet UILabel *lable7;
@property (weak, nonatomic) IBOutlet UILabel *lalbel8;
@property (weak, nonatomic) IBOutlet UILabel *lable9;

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (strong, nonatomic) NSString *tid; // 话题id
@property (strong, nonatomic) NSString *user_id; // 用户id
@end
