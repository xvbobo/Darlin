//
//  MiaoShaViewController.m
//  com.threeti
//
//  Created by alan on 15/7/16.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "MiaoShaViewController.h"
#import "MiaoShaCell.h"
#import "MCProductDetailViewController.h"
#import "TTIFont.h"
@interface MiaoShaViewController ()<FlashProductCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    LoginModel *userModel;
    UITableView * myTabelView;
    NSInteger _page;
    NSMutableArray *resultArray;
    NSString * nameStr;
    UILabel * labelTime;
    NSString * timeString;
    NSMutableArray * listArr;
    int timeCount;
    BOOL _isfirst;
    FCXRefreshFooterView * footerView;
    FCXRefreshHeaderView * headerView;
}

@end

@implementation MiaoShaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    _isfirst = YES;
    resultArray = [[NSMutableArray alloc] init];
    listArr = [[NSMutableArray alloc] init];
    [self loadBaseUI];
    [self createTabelView];
    [self loadFlashSaleProductListWithPage:_page];
    
    [self addRefreshView];
}
- (void)addRefreshView {
    
    //下拉刷新
     __weak __typeof(self)weakSelf = self;
    headerView = [myTabelView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf Refresh];
    }];
    
    //上拉加载更多
}
#pragma mark -- 监听滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height)
    {
        [self LoadMore];
        
    }
    
    
    
}

- (void)NSthread
{
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop]run];
}
- (void)loadBaseUI
{
    NAV_INIT(self, @"秒杀", @"common_nav_back_icon", @selector(backAction), nil, nil);
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
    image.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = BJCLOLR;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 100, 30)];
    label.textColor = beijing;
    label.text = @"抢购中 限量!";
    label.font = [UIFont systemFontOfSize:15];
    [image addSubview:label];
    int with;
    if (UIScreenWidth>320) {
        with = 0;
    }else{
        with = 30;
    }
    UILabel * shijian = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth/2-with,10,90, 30)];
    shijian.text = @"距本场结束";
    shijian.font = [UIFont systemFontOfSize:15];
    shijian.textColor = TEXT;
    [image addSubview:shijian];
    for (int i= 0; i< 3; i++) {
        labelTime = [[UILabel alloc] initWithFrame:CGRectMake(shijian.frame.origin.x+shijian.frame.size.width+i*30,10,25, 30)];
        labelTime.backgroundColor = RGBACOLOR(56, 60, 60, 1);
        labelTime.textColor = [UIColor whiteColor];
        labelTime.tag = 100+i;
        labelTime.textAlignment = NSTextAlignmentCenter;
        [image addSubview:labelTime];
        if (i != 2) {
            UILabel * maoHao = [[UILabel alloc] initWithFrame:CGRectMake(labelTime.frame.origin.x+labelTime.frame.size.width-1,10,10,30)];
            maoHao.text=@":";
            maoHao.font = font(17);
            maoHao.textColor =  RGBACOLOR(56, 60, 60, 1);
            [image addSubview:maoHao];
        }
        

    }
    [self.view addSubview:image];
}
- (void)returnText:(ReturnTextBlock)block
{
    self.returnTextBlock = block;
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(timeString);
    }
}
- (void)createTabelView
{
    myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, UIScreenWidth, UIScreenHeight-120)];
    myTabelView.dataSource = self;
    myTabelView.delegate = self;
    myTabelView.backgroundColor = BJCLOLR;
    myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTabelView];
}
#pragma mark -- 请求数据
- (void)loadFlashSaleProductListWithPage:(NSInteger)page {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] flashSaleRequestWithPage:[NSString stringWithFormat:@"%ld", (long)page] withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD dismiss];
        
       NSMutableArray * retureArr = response.result[@"group_item"];
        timeString = response.result[@"end_time"];
        if (_isfirst&& timeString != nil) {
            [NSThread detachNewThreadSelector:@selector(NSthread) toTarget:self withObject:nil];
            [self createNstimer];
        }
        _isfirst = NO;
//        if(retureArr.count == 0){
//            
//            [SVProgressHUD showSuccessWithStatus:@"没有更多~"];
//            [footerView endRefresh];
//            return ;
//        }
        
        if(page == 1)
        {   
            resultArray = retureArr;
        }
        else if(retureArr.count!=0)
        {
            NSRange range;
            range.location = 0;
            range.length = (_page-1)*15;
            if (resultArray.count!=0) {
                resultArray =[NSMutableArray arrayWithArray:[resultArray subarrayWithRange:range]];
            }
            [resultArray addObjectsFromArray:retureArr];
        
        }
//        if (retureArr.count == 0) {
//            _page--;
//        }
        [myTabelView reloadData];
        [headerView endRefresh];
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        
    }];
}
#pragma mark -- 时间
- (void)createNstimer
{

    if (timeString) {
        timeCount = timeString.intValue;
    }
}
- (void)timeDown
{
    
    timeCount--;
    if (timeCount == 0) {
        [self loadFlashSaleProductListWithPage:1];
    }
    int H = timeCount/3600;
    int m = (timeCount%3600)/60;
    int s = (timeCount%3600)%60;
    UILabel * label1 = (UILabel*)[self.view viewWithTag:100];
    label1.text = [NSString stringWithFormat:@"%02d",H];
    UILabel * label2 = (UILabel*)[self.view viewWithTag:101];
    label2.text = [NSString stringWithFormat:@"%02d",m];
    UILabel * label3 = (UILabel*)[self.view viewWithTag:102];
    label3.text = [NSString stringWithFormat:@"%02d",s];
   
}
#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat H = [TTIFont calHeightWithText:nameStr font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth - (320-189)];
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   MiaoShaCell * Cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell==nil) {
        Cell  = [[[UINib nibWithNibName:@"MiaoShaCell" bundle:nil]
                  instantiateWithOwner:self options:nil] objectAtIndex:0];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 129, UIScreenWidth, 0.5)];
        line.backgroundColor = LINE;
        [Cell.contentView addSubview:line];
    }
    NSDictionary * dict = [resultArray objectAtIndex:indexPath.row];
    if (dict!=nil) {
        [Cell initDataWithDictionary:dict];
        nameStr = dict[@"goods_name"];
    }
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Cell.contentView.backgroundColor = BJCLOLR;
//    CGFloat H = [TTIFont calHeightWithText:nameStr font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth-(320-189)];
   
    Cell.delegate =self;
    return Cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary * dict = [resultArray objectAtIndex:indexPath.row];
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.gid = dict[@"goods_id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)LoadMore
{
   
        _page++;
        [self loadFlashSaleProductListWithPage:_page];
    

   
}
- (void)Refresh
{
    _page = 1;
    [self loadFlashSaleProductListWithPage:_page];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cellBtnClickByRow:(NSInteger)row
{
    //显示商品详情
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.gid = [NSString stringWithFormat:@"%ld",row] ;
    [self.navigationController pushViewController:detailVC animated:YES];
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
