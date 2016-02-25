//
//  MallClassificationViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MallClassificationViewController.h"
#import "MallClassificationCell.h"
#import "MallClassficationDetailViewController.h"
#import "TTIHttpClient.h"
#import "SVProgressHUD.h"
#import "SearchProductsViewController.h"
#import "QFControl.h"
@interface MallClassificationViewController ()<MallClassificationCellDelegate,UITextFieldDelegate,UISearchBarDelegate>{
    MallClassificationViewController * MCC;
    UITextField *searchTextFiled;
    UISearchBar * searchBar;
    UIImageView * imageView;
    FCXRefreshHeaderView * headerView;
    NSUserDefaults * UD;
    JuHuaView * flower;
    LoadingView * loadView;
}

@end

@implementation MallClassificationViewController{
    
    UIView *navSearchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UD = [NSUserDefaults standardUserDefaults];
     self.navigationController.navigationBar.barTintColor = beijing;
    imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.hidden = YES;
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor grayColor];
    imageView.alpha = 0.5;
    _tableView.backgroundColor = BJCLOLR;
    [self.view insertSubview:imageView aboveSubview:_tableView];
    flower = [[JuHuaView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    flower.center = CGPointMake(self.view.center.x, self.view.center.y+20);
    [self.navigationController.view addSubview:flower];
    loadView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    
    [loadView addSubview:[QFControl createButtonWithFrame:loadView.frame title:nil target:self action:@selector(actionTouch) tag:0]];
    loadView.hidden = YES;
    [self.navigationController.view addSubview:loadView];
    [self initlization];
    [self loadBaseUI];
    if ([g_version isEqualToString:VERSION]) {
        self.searchButton.hidden = YES;
        NAV_INIT(self, @"分类", nil, nil, nil, nil);
    }else{
        self.searchButton.hidden = NO;
         [self loadNav];
    }
    
    
    self.array = [UD objectForKey:@"fenLei"];
    if (self.array == nil) {
        [self loadMallCategory];
    }
    
    [self creaRefreshHeaderView];
}
- (void)actionTouch
{
    loadView.hidden = YES;
    [self loadMallCategory];
}
- (void)creaRefreshHeaderView
{
     __weak __typeof(self)weakSelf = self;
    headerView = [_tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMallCategory];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MCC viewWillAppear:animated];
    selectedIndex = 1;
    imageView.hidden = YES;
    navSearchView.hidden = NO;
    flower.hidden  = NO;
    self.array = [UD objectForKey:@"fenLei"];
    if (self.array == nil) {
        [self loadMallCategory];
    }

//     [self loadMallCategory];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MCC viewWillDisappear:animated];
    navSearchView.hidden = YES;
    loadView.hidden = YES;
    flower.hidden = YES;
    [searchTextFiled resignFirstResponder];
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initlization{
    
    self.array = [[NSArray alloc] init];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    imageView.hidden = YES;
    [searchBar resignFirstResponder];
}
- (void)loadBaseUI{
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
}

- (void)loadNav{
    
    if(navSearchView == nil)
    {
        navSearchView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, 6,self.view.frame.size.width*0.75, 33)];
        navSearchView.layer.cornerRadius = 4;
        navSearchView.backgroundColor = [UIColor whiteColor];
        UIImageView *navSearchIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 16)];
        navSearchIconView.image = [UIImage imageNamed:@"common_search_icon"];
        searchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(XPOS(navSearchIconView.frame) + 5, 3, navSearchView.frame.size.width - XPOS(navSearchIconView.frame) - 5, 30)];
        searchTextFiled.borderStyle = UITextBorderStyleNone;
        searchTextFiled.placeholder = @"大家都在搜";
        searchTextFiled.delegate = self;
        searchTextFiled.keyboardType = UIKeyboardTypeTwitter;
        [navSearchView addSubview:navSearchIconView];
//        [navSearchView addSubview:searchTextFiled];
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,5, navSearchView.frame.size.width, 25)];
        searchBar.placeholder = @"大家都在搜";
        searchBar.delegate  = self;
        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
        searchField.textColor = BLACKTEXT;
        [navSearchView addSubview:searchBar];
        [self.searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    [self.navigationController.navigationBar addSubview:navSearchView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"搜索");
    SearchProductsViewController *searchProductsViewController = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchProductsViewController"];
    searchProductsViewController.titleStr =searchBar.text;
    searchProductsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchProductsViewController animated:YES];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    imageView.hidden = NO;
}
#pragma mark - TableView Delegate && DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.array.count%3) {
        return (self.array.count/3+1)*(UIScreenWidth/3+60);
    }else{
        return self.array.count/3*(UIScreenWidth/3+60);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellidentifier = @"MallClassificationCell";
    MallClassificationCell * cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell= [[MallClassificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BJCLOLR;
    [cell initDataWithArray:self.array];
    return cell;
}


- (void)imageClicked:(NSString *)idStr withName:(NSString *)nameStr
{
    if (imageView.hidden == YES) {
        MallClassficationDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MallClassficationDetailViewController"];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.categoryId = idStr;
        detailVC.myTitle = nameStr;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
   

}
#pragma mark - Detail Actions
- (void)searchAction:(id)sender{
    
    //关键字搜索商品
    if(ICIsObjectEmpty(searchBar.text)){
        
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容"];
        return;
    }
    
    SearchProductsViewController *searchProductsViewController = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchProductsViewController"];
    searchProductsViewController.titleStr = searchBar.text;
    searchProductsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchProductsViewController animated:YES];
}

- (void)loadMallCategory{
    
    //获取分类列表

    [flower startView];
    [[TTIHttpClient shareInstance] mallshopCategoryRequestWithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
    
        [flower stopView];
        self.array = (NSArray *)response.result[@"result"];
        [UD setObject:self.array forKey:@"fenLei"];
        [UD synchronize];
        [headerView endRefresh];
        [self.tableView reloadData];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
//        loadView.hidden = NO;
        [flower stopView];
    }];
}


@end
