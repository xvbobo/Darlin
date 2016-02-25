//
//  SuccessPViewController.m
//  com.threeti
//
//  Created by alan on 15/11/2.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "SuccessPViewController.h"
#import "CheckJinDuController.h"
#import "ShouHouViewController.h"
@interface SuccessPViewController ()

@end

@implementation SuccessPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.dictType);
    NSString * dateStr = [self.dictType objectForKey:@"addtime"];
//    NSTimeInterval time = [str doubleValue];
//    NSDate * detaildate = [NSDate dateWithTimeIntervalSince1970:time];
//    NSDateFormatter * fomatter = [[NSDateFormatter alloc] init];
//    [fomatter setDateFormat:@"YYYY-MM-dd"];
//    NSString  * dateStr = [fomatter stringFromDate:detaildate];
     NAV_INIT(self,@"提交成功", @"common_nav_back_icon", @selector(back), nil, nil);
    if ([self.serveType isEqualToString:@"1"]) {
        self.serveType = @"退货";
    }else if ([self.serveType isEqualToString:@"2"]){
        self.serveType = @"换货";
    }else if ([self.serveType isEqualToString:@"3"]){
        self.serveType = @"维修";
    }else{
         self.serveType = @"退货";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, UIScreenWidth-20, 30)];
    label.text = @"创建售后服务申请成功！";
    label.textColor = BLACKTEXT;
    label.font = [UIFont systemFontOfSize:15.0];
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x+5, label.frame.origin.y+label.frame.size.height+10, UIScreenWidth, 20)];
    label1.textColor = TEXT;
    label1.text =[NSString stringWithFormat:@"申请时间：%@",dateStr];
    label1.font = [UIFont systemFontOfSize:13.0];
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+label1.frame.size.height+5, UIScreenWidth, 20)];
    label2.text = [NSString stringWithFormat:@"申请类型：%@",self.serveType];
    label2.font = [UIFont systemFontOfSize:13.0];
    label2.textColor = TEXT;
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.origin.x, label2.frame.origin.y+label2.frame.size.height+5, UIScreenWidth, 20)];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"状态：待审核"];
    [string addAttribute:NSForegroundColorAttributeName value:beijing range:NSMakeRange(3, 3)];
    [string addAttribute:NSForegroundColorAttributeName value:TEXT range:NSMakeRange(0, 3)];
    label3.attributedText = string;
    label3.font = [UIFont systemFontOfSize:13.0];
    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, label3.frame.origin.y + label3.frame.size.height+10, UIScreenWidth, 0.5)];
    lineView.backgroundColor = LINE;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = LINE.CGColor;
    btn.layer.borderWidth = 0.5;
    btn.frame = CGRectMake(UIScreenWidth - 100, lineView.frame.origin.y+10, 90, 25);
    [btn setTitle:@"售后进度查询" forState:UIControlStateNormal];
    [btn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view addSubview:lineView];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:label1];
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
}
- (void)action
{
    CheckJinDuController * jindu = [[CheckJinDuController alloc] init];
    [self.navigationController pushViewController:jindu animated:YES];
    NSLog(@"查询成功");
}
- (void)back
{
//    ShouHouViewController * shouHou = [[ShouHouViewController alloc] init];
    NSArray * ctrlArray = self.navigationController.viewControllers;
   [self.navigationController popToViewController:[ctrlArray objectAtIndex:1] animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
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
