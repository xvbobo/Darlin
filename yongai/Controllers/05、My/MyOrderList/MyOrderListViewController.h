//
//  MyOrderListViewController.h
//  Yongai
//
//  Created by Kevin Su on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCellFooterView.h"
#define TYPE_MONTH_AGO @"month_ago"
#define TYPE_MONTH_ONE @"month_one"

@interface MyOrderListViewController : UIViewController< UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet  UITableView *orderListTableView;
@property (nonatomic) NSInteger orderindex;
//@property (strong, nonatomic) NSMutableArray *ordersArray;

@end
