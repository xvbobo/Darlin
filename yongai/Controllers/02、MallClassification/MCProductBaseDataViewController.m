//
//  MCProductBaseDataViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductBaseDataViewController.h"
#import "CommonUtils.h"

@interface MCProductBaseDataViewController ()

@end

@implementation MCProductBaseDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initlization];
    [self loadNavView];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.editable = NO;
    self.textView.text = self.contentStr;
    self.textView.textColor = BLACKTEXT;
    self.textView.backgroundColor = BJCLOLR;
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initlization{
    
    
}

- (void)loadNavView{
    
    NAV_INIT(self, @"基本参数", @"common_nav_back_icon", @selector(back), nil, nil);
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
