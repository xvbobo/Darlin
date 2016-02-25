//
//  SearchProductsViewController.h
//  Yongai
//
//  Created by Kevin Su on 14/12/1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  搜索商品结果页
#import <UIKit/UIKit.h>
#import "SearchProductCell.h"

@interface SearchProductsViewController : UIViewController< UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *productsTableView;
@property (strong, nonatomic) NSMutableArray *productsArray;
@property (nonatomic) int pageIndex;

@property (nonatomic, strong) NSString *titleStr;

@end
