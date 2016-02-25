//
//  BuChongViewController.m
//  xv
//
//  Created by alan on 15/4/3.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "BuChongViewController.h"
#import "JuBaoViewController.h"
@interface BuChongViewController ()<UITextViewDelegate>
{
    NSString * _string;
    NSString * _str;
    NSUserDefaults * db;
}

@end

@implementation BuChongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numLabel.text = @"50";
     db = [NSUserDefaults standardUserDefaults ];
    self.title = @"补充说明";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem * item = [[UIBarButtonItem alloc ] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(fanhuiBtn)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    self.contentView.delegate = self;
    self.view.backgroundColor = BJCLOLR;
    // Do any additional setup after loading the view.
}
- (void)fanhuiBtn
{
    _string = self.contentView.text;
    [db setObject:_string forKey:@"contenView"];
    [db synchronize];
    _MyBlock(_string);

    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%@",text);
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > 50) {
        textView.text = [temp substringToIndex:50];
        NSLog(@"%ld",temp.length);
        return NO;
    }else
    {
        self.numLabel.text = [NSString stringWithFormat:@"%ld",50 - temp
                              .length];
        [db setObject:self.numLabel.text forKey:@"num"];
        return YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.numLabel.text = [db objectForKey:@"num"];

}
- (void)viewWillAppear:(BOOL)animated
{
    BuChongViewController * BCC;
    [super viewWillAppear:animated];
    [BCC viewWillAppear:animated];
     self.contentView.text = [db objectForKey:@"contenView"];
    self.numLabel.text = [db objectForKey:@"num"];
    [self.contentView becomeFirstResponder];
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
