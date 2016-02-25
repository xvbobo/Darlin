//
//  SHHelpViewController.m
//  com.threeti
//
//  Created by alan on 15/11/13.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "SHHelpViewController.h"
#import "TTIFont.h"
@interface SHHelpViewController ()

@end

@implementation SHHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BJCLOLR;
    NAV_INIT(self,@"售后帮助", @"common_nav_back_icon", @selector(back), nil, nil);
    [self creteInterface];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creteInterface
{
//    CGFloat H = [TTIFont calHeightWithText:self.HelpString font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth - 20];
    UITextView * contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-60)];
//    contentTextView.userInteractionEnabled = NO;
    contentTextView.editable = NO;
    contentTextView.text = self.HelpString;
    contentTextView.textColor = BLACKTEXT;
    contentTextView.font = [UIFont systemFontOfSize:14.5];
    contentTextView.backgroundColor = BJCLOLR;
    [self.view addSubview:contentTextView];
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
