//
//  MCProductGoodRuleViewController.m
//  Yongai
//
//  Created by Kevin Su on 14/12/1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductGoodRuleViewController.h"
#import "CommonUtils.h"

@interface MCProductGoodRuleViewController ()

@end

@implementation MCProductGoodRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadBaseUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBaseUI{
    
    NAV_INIT(self, @"金币规则", @"common_nav_back_icon", @selector(back), nil, nil);
    
    self.contentTextView.text = self.contentStr;
    self.contentTextView.editable = NO;
    self.contentTextView.backgroundColor = BJCLOLR;
    self.contentTextView.textColor = BLACKTEXT;
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
