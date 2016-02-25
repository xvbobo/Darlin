//
//  LeftViewController.m
//  Yongai
//
//  Created by arron on 14/11/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@property (strong, nonatomic) IBOutlet UIButton *showTopicBtn;
@property (strong, nonatomic) IBOutlet UIButton *showEmailBtn;
@property (strong, nonatomic) IBOutlet UIButton *showAttentionBtn;
@property (strong, nonatomic) IBOutlet UIButton *showGoldBtn;

- (IBAction)showTopicBtnClick:(id)sender;
- (IBAction)showEmailBtnClick:(id)sender;
- (IBAction)showAttentionBtnClick:(id)sender;
- (IBAction)showGoldBtnClick:(id)sender;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor blackColor];
    self.redPointImg.hidden = YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    LeftViewController * LVC ;
    [super viewWillAppear:animated];
    [LVC viewWillAppear:animated];
    if(g_LoginStatus)
    {
        [[TTIHttpClient shareInstance] messageRedRequestwithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            NSString *red =  response.responseModel;
            if( red.intValue == 1)
                self.redPointImg.hidden = NO;
            else
                self.redPointImg.hidden = YES;
            
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
        }];
    }
}

- (IBAction)showTopicBtnClick:(id)sender {// 话题
    
    [self updateBtnStatus];
    
    [self.topicImg setImage:[UIImage imageNamed:@"topic_image_select"]];
    self.topicLable.textColor = [UIColor colorWithRed:36/255.0 green:156/255.0 blue:217/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showMyTopicView object:nil];
}

- (IBAction)showEmailBtnClick:(id)sender {// 消息
    [self updateBtnStatus];
    
    [self.emailImg setImage:[UIImage imageNamed:@"left_email_select"]];
    self.emailLable.textColor = [UIColor colorWithRed:36/255.0 green:156/255.0 blue:217/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showMyMessageView object:nil];
}

- (IBAction)showAttentionBtnClick:(id)sender {// 关注
    [self updateBtnStatus];
    
    [self.attentionImg setImage:[UIImage imageNamed:@"left_ellipse_select"]];
    self.attentionLable.textColor = [UIColor colorWithRed:36/255.0 green:156/255.0 blue:217/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showAttentionView object:nil];
}

- (IBAction)showGoldBtnClick:(id)sender {// 金币
    [self updateBtnStatus];
    
    [self.goldImg setImage:[UIImage imageNamed:@"jingBi_select"]];
    self.goldLable.textColor = [UIColor colorWithRed:36/255.0 green:156/255.0 blue:217/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_showMyGoldView object:nil];
}

-(void)updateBtnStatus
{
    [self.topicImg setImage:[UIImage imageNamed:@"topic_image"]];
    self.topicLable.textColor = [UIColor whiteColor];
    
    [self.emailImg setImage:[UIImage imageNamed:@"left_email"]];
    self.emailLable.textColor = [UIColor whiteColor];
    
    [self.attentionImg setImage:[UIImage imageNamed:@"left_ellipse"]];
    self.attentionLable.textColor = [UIColor whiteColor];
    
    [self.goldImg setImage:[UIImage imageNamed:@"jingBi"]];
    self.goldLable.textColor = [UIColor whiteColor];
}

@end
