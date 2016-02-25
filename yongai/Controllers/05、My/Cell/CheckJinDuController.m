//
//  CheckJinDuController.m
//  com.threeti
//
//  Created by alan on 15/11/4.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "CheckJinDuController.h"
#import "JinDuCell.h"
#import "TTIFont.h"
@interface CheckJinDuController ()<UITableViewDataSource,UITableViewDelegate,JinDuCellDelegate>
{
    NSInteger g_page;
    UITableView * myTableView;
    NSMutableArray * dataSource;
    NSString * address;
    UIImageView * blackView;
    UILabel * label1;//商家地址
    UILabel * label2;//联系人
    UILabel * label3;//联系电话
    UILabel * label4;//寄回信息
    UIImageView * whiteView;
    UIImageView * lineView;
    UIButton * closeBtn;
    FCXRefreshHeaderView * header;
    FCXRefreshFooterView * footerView;
    NSString * serviceID;
}

@end

@implementation CheckJinDuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BJCLOLR;
     NAV_INIT(self,@"进度查询", @"common_nav_back_icon", @selector(back), nil, nil);
    blackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    blackView.userInteractionEnabled = YES;
    blackView.backgroundColor = RGBACOLOR(4, 4, 4, 0.8);
//    blackView.alpha = 0.8;
    blackView.hidden = YES;
    whiteView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, UIScreenWidth - 80, 140)];
//    whiteView.alpha = 1;
    whiteView.userInteractionEnabled = YES;
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 5;
     whiteView.center  =CGPointMake(self.view.center.x, self.view.center.y-20);
    whiteView.backgroundColor = [UIColor whiteColor];
    
    label1 = [[UILabel alloc] init];
    label1.textColor = BLACKTEXT;
    label1.font = [UIFont systemFontOfSize:13.0];
    label1.numberOfLines = 0;
    [whiteView addSubview:label1];
    label2 = [[UILabel alloc] init];
    label2.textColor = BLACKTEXT;
    label2.font = [UIFont systemFontOfSize:13.0];
    [whiteView addSubview:label2];
    label3 = [[UILabel alloc] init];
    label3.textColor = BLACKTEXT;
    label3.font = [UIFont systemFontOfSize:13.0];
    label4 = [[UILabel alloc] init];
    label4.textColor = BLACKTEXT;
    label4.numberOfLines = 0;
    label4.font = [UIFont systemFontOfSize:13.0];
    [whiteView addSubview:label4];
    lineView = [[UIImageView alloc] init];
    lineView.backgroundColor =BJCLOLR;
    [whiteView addSubview:lineView];
    [whiteView addSubview:label3];
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:beijing forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
//    closeBtn.backgroundColor = [UIColor redColor];
    closeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeBtn addTarget:self action:@selector(closeAcion) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeBtn];
    [blackView addSubview:whiteView];
    
    g_page = 1;
    dataSource = [[NSMutableArray alloc] init];
    [self RequestDataSourceWithPage:g_page];
    [self createTableView];
    // Do any additional setup after loading the view.
    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    header = [myTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshOrderList];
    }];
    
    //    上拉加载更多
    footerView = [myTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        //        [weakSelf loadMoreComments];
    }];
    footerView.hidden = YES;
    
    //        自动刷新
    footerView.autoLoadMore = YES;
}
- (void)refreshOrderList
{
    [self RequestDataSourceWithPage:g_page];
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (UIScreenHeight > scrollView.contentSize.height-scrollView.contentOffset.y)
    {
        [self loadMoreComments];
        
    }
    NSLog(@"%f",scrollView.contentSize.height - scrollView.contentOffset.y);
    NSLog(@"%f",UIScreenHeight);
    
}
- (void)loadMoreComments
{
    g_page++;
    [self RequestDataSourceWithPage:g_page];
}

- (void)closeAcion
{
    blackView.hidden = YES;
}
- (void)refershShangJiaMessage:(NSString *) string
{
    NSArray * array = [string componentsSeparatedByString:@";"];
    NSString * str1 = array[0];
    NSString * str2 = array[1];
    NSString * str3 = array[2];
    NSString * str4 = array[3];
    CGFloat str1H = [TTIFont calHeightWithText:str1 font:[UIFont systemFontOfSize:13.0] limitWidth:whiteView.frame.size.width-20];
    CGFloat str4H = [TTIFont calHeightWithText:str4 font:[UIFont systemFontOfSize:13.0] limitWidth:whiteView.frame.size.width-20];
    label1.frame = CGRectMake(10, 20, whiteView.frame.size.width-20, str1H);
    label2.frame = CGRectMake(label1.frame.origin.x, label1.frame.origin.y+label1.frame.size.height+5, label1.frame.size.width, 20);
    label3.frame = CGRectMake(label1.frame.origin.x, label2.frame.origin.y+label2.frame.size.height+5, label1.frame.size.width, 20);
    label4.frame = CGRectMake(label1.frame.origin.x, label3.frame.origin.y+label3.frame.size.height+5, label1.frame.size.width, str4H);
    lineView.frame = CGRectMake(0, label4.frame.origin.y+label4.frame.size.height+5, whiteView.frame.size.width, 1);
    label1.text = str1;
    label2.text = str2;
    label3.text = str3;
    label4.text = str4;
    closeBtn.frame = CGRectMake(0, lineView.frame.origin.y, lineView.frame.size.width,40);
    whiteView.frame = CGRectMake(20, 0, UIScreenWidth-80,label1.frame.size.height+label2.frame.size.height+label3.frame.size.height+str4H+80);
    whiteView.center  =CGPointMake(self.view.center.x, self.view.center.y-20);
    
}
- (void)createTableView
{
    myTableView = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 64)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = BJCLOLR;
    [self.view addSubview:myTableView];
    [self.view addSubview:blackView];
    
//    [self.view insertSubview:blackView aboveSubview:myTableView];
    
}
- (void)RequestDataSourceWithPage:(NSInteger)page
{
    [[TTIHttpClient shareInstance] checkJinDu:g_userInfo.uid withpage:[NSString stringWithFormat:@"%ld",page] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        address = [response.result objectForKey:@"address"];
        [self refershShangJiaMessage:address];
        NSArray * array  = [response.result objectForKey:@"list"];
        if (page == 1) {
            [dataSource removeAllObjects];
        }
        [dataSource addObjectsFromArray:array];
        NSLog(@"%@",response.result);
        [myTableView reloadData];
        [header endRefresh];
        [footerView endRefresh];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}
#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [dataSource objectAtIndex:indexPath.row];
    NSString * isreturn = [dict objectForKey:@"is_return"];
    NSString * serveStr = [dict objectForKey:@"service_id"];
     NSString * statusStr = [dict objectForKey:@"service_status"];
    NSString * str = [dict objectForKey:@"backup"];//留言@“”
    NSString * is_refund = [dict objectForKey:@"is_refund"];
    NSString * refund_money = [dict objectForKey:@"refund_money"];//返回的钱
    NSString * goods_name = [dict objectForKey:@"goods_name"];//商品的名称
    CGFloat nameH = [TTIFont calHeightWithText:goods_name font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth-30]-10;
    CGFloat leaveMessageH;
    if (![str isEqualToString:@""]) {
        leaveMessageH = [TTIFont calHeightWithText:[NSString stringWithFormat:@"审核留言：%@",str] font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth]+5;
    }else{
        leaveMessageH = 0;
    }
    CGFloat H2;
    if (isreturn.intValue == 1) {
      NSString * string = [NSString stringWithFormat:@"审核通过，形成新订单，单号为：%@",serveStr];
        H2 = [TTIFont calHeightWithText:string font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth];
        return 100 + leaveMessageH + nameH + H2;
    }else{
        H2 = 0;
    }
    NSString * string;
    switch (statusStr.intValue) {
        case 0:
            string = @"审核中";
            break;
        case 1:
            string = @"等待用户寄出";
            break;
        case 2:
            string = @"已完成";
//            return 120+leaveMessageH + nameH;
            break;
        case 3:
            string = @"驳回";
            break;
        case 4:
            string = @"客服关单";
//            return 120+leaveMessageH+nameH;
            break;
        case 5:
            string = @"用户关单";
            break;
        case 6:
            string = @"客服处理中";
            break;
            
        default:
            break;
    }
//    return 0;
//    if (is_refund.intValue == 1) {
//        return 120+ nameH;
//    }else{
        if (statusStr.intValue == 0 ||statusStr.intValue == 1|| statusStr.intValue == 6) {
            if ([refund_money isEqualToString:@""]) {
                 return 160+leaveMessageH + nameH+H2;
            }else{
                return 120 + leaveMessageH + nameH + H2;
            }
           
        }else{
            return 120+leaveMessageH + nameH+H2;
        }
//
//    }

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [dataSource objectAtIndex:indexPath.row];
    static NSString * strCell = @"cell";
    JinDuCell * cell  = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (cell == nil) {
        cell = [[JinDuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    }
    cell.model = dict;
    cell.delegate = self;
    [cell initWithDict:dict withIndexPath:indexPath];
    return cell;
}
- (void)buttonAction:(UIButton *)button withServeId:(NSString *)serveid
{
    if ([button.titleLabel.text isEqualToString:@"取消审核"]) {
//        NSString * service_id = [NSString stringWithFormat:@"%ld",button.tag];
        [self cancleSheHe:serveid];
        NSLog(@"取消审核");
    }else{
        NSLog(@"查看邮寄地址");
        blackView.hidden = NO;
    }

}
- (void)cancleSheHe:(NSString *)service_id
{
    serviceID = service_id;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您确定要取消申请"
                                                       delegate:self
                                              cancelButtonTitle:@"是"
                                              otherButtonTitles:@"否", nil];
    //    Al = YES;
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self cancle];
            break;
        case 1:
            break;
            
        default:
            break;
    }
}
- (void)cancle
{
    [[TTIHttpClient shareInstance]cancelServeListWithuser_id:g_userInfo.uid withservice_id:serviceID withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        [self refreshOrderList];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];

}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
