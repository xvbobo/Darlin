//
//  YunDanDetailViewController.m
//  com.threeti
//
//  Created by alan on 15/6/26.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//
//http://wap.kuaidi100.com/wap_result.jsp?rand=20120517&id=[快递公司编码]&fromWeb=null&&postid=[快递单号]
#import "YunDanDetailViewController.h"
#import "YunDanCell.h"
#import "TTIFont.h"
@interface YunDanDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * MytableView;
    NSString *detailString;
    NSMutableArray * dataArray;
    BOOL Y;
    JuHuaView * flower;
}

@end

@implementation YunDanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BJCLOLR;
     NAV_INIT(self, @"运单详情", @"common_nav_back_icon", @selector(back), nil, nil);
    flower = [[JuHuaView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    flower.center = CGPointMake(self.view.center.x, self.view.center.y+20);
    [self.navigationController.view addSubview:flower];
    [self createWebView];
    MytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-60)];
    MytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MytableView.dataSource = self;
    MytableView.delegate = self;
    MytableView.backgroundColor = BJCLOLR;
    [self.view addSubview:MytableView];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createWebView
{
//    圆通804909084343     申通220531847019
//    NSString * str = @"802809947648";
    NSString * string;
    Y = NO;
    if ([self.kuaiDiType isEqualToString:@"申通快递"]) {
        string = @"http://wap.kuaidi100.com/wap_result.jsp?rand=20120517&id=shentong&fromWeb=null&&postid=";
    }else{
        string =@"http://wap.kuaidi100.com/wap_result.jsp?rand=20120517&id=yuantong&fromWeb=null&&postid=";
    }
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",string,_yundanHao]]];
    [flower startView];
    NSString * dataString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",string,_yundanHao]] encoding:NSUTF8StringEncoding error:nil];

    if (dataString) {
        [flower stopView];
    }else{
        [flower startView];
 
    }
    NSLog(@"%@",dataString);
    if ([dataString rangeOfString:@"单号不正确"].location != NSNotFound) {
        [SVProgressHUD showErrorWithStatus:@"单号不正确"];
    }else if ([dataString rangeOfString:@"此单号暂无物流信息"].location != NSNotFound){
        Y = YES;
        [dataArray addObject:@"此单号暂无物流信息，请稍后再查"];
//        [SVProgressHUD showErrorWithStatus:@"此单号暂无物流信息，请稍后再查"];
    }
    else{
        NSString * string1 = [dataString stringByReplacingOccurrencesOfString:@" " withString:@""];
        //    NSString * string2 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSArray * array1 = [string1 componentsSeparatedByString:@"</form>"];
        NSString * string2 = [NSString stringWithFormat:@"%@",array1[0]];
        NSArray * array2 = [string2 componentsSeparatedByString:@"<p><strong>"];
        NSString * string3  = [NSString stringWithFormat:@"%@",array2[1]];
        NSArray * array3 = [string3 componentsSeparatedByString:@"</p><p>&middot;"];
        NSLog(@"%@",array3);
        [dataArray addObjectsFromArray:array3];
        NSLog(@"%@",array1);
 
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (Y == YES) {
        return 1;
    }else{
        return dataArray.count;
 
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = dataArray[indexPath.row];
    if (indexPath.row == 0) {
        return 40;
    }else{
        NSArray * newArray = [string componentsSeparatedByString:@"<br/>"];
        NSString * string = [NSString stringWithFormat:@"%@",newArray[1]];
        CGFloat detailabelH = [TTIFont calHeightWithText:string font:[UIFont systemFontOfSize:14.0] limitWidth:UIScreenWidth - 20];
       return 50+detailabelH;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"cell";
    YunDanCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[YunDanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    if (Y == YES) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        cell.textLabel.textColor = BLACKTEXT;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }else{
        NSString * string = dataArray[indexPath.row];
        if (indexPath.row == 0) {
            NSString * newString = [string stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
            [cell initWithTime:newString andDetailString:@""];
        }else{
            NSArray * newArray = [string componentsSeparatedByString:@"<br/>"];
            NSString * string = [NSString stringWithFormat:@"%@",newArray[1]];
            if (indexPath.row == dataArray.count - 1) {
                [cell initWithTime:newArray[0] andDetailString:[string stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
            }else{
                [cell initWithTime:newArray[0] andDetailString:string];
            }
            
        }
  
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
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
