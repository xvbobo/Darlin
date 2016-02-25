//
//  MCProductFreeFreightViewController.m
//  Yongai
//
//  Created by Kevin Su on 14/11/28.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductFreeFreightViewController.h"
#import "CommonUtils.h"

@interface MCProductFreeFreightViewController ()

@end

@implementation MCProductFreeFreightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNavView];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.textView];
    self.textView.text = self.contentStr;
    self.textView.textColor = BLACKTEXT;
    self.textView.font = [UIFont systemFontOfSize:14.5];
    self.textView.backgroundColor = BJCLOLR;
    self.textView.editable = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavView{
    
    NAV_INIT(self, @"免运费政策", @"common_nav_back_icon", @selector(back), nil, nil);
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
