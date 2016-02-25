//
//  LoginNavViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "LoginNavViewController.h"

@interface LoginNavViewController ()

@end

@implementation LoginNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setTranslucent:NO];
//    if (IOS7)
//    {
//        [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"1"] stretchableImageWithLeftCapWidth:1 topCapHeight:10]
//                                                      forBarMetrics:UIBarMetricsDefault];
//    }
//    else
//    {
//        [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"1"] stretchableImageWithLeftCapWidth:1 topCapHeight:10]
//                                                      forBarMetrics:UIBarMetricsDefault];
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
