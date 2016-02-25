//
//  MCProductPromotiomViewController.m
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductPromotiomViewController.h"
#import "CommonUtils.h"
#import "PromotionProductCell.h"

@interface MCProductPromotiomViewController ()

@end

@implementation MCProductPromotiomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initlization];
    [self loadNavView];
    [self loadProductsTable];
}

- (void)initlization{
    
    
}

- (void)loadNavView{
    
    NAV_INIT(self, @"查看赠品", @"common_nav_back_icon", @selector(back), nil, nil);
    
}

- (void)loadProductsTable{
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = BJCLOLR;
    self.tableView.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
}

#pragma mark - TableView Datasource && Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 125;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.giftsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"PromotionProductCell";
    [tableView registerNib:[UINib nibWithNibName:@"PromotionProductCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    PromotionProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell initDataWithDic:self.giftsArray[indexPath.row]];
    
    return cell;
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
