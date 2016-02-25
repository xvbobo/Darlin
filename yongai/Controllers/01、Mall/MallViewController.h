//
//  MallViewController.h
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"
#import "MallProductClassificationCell.h"
#import "FlashSaleCell.h"
#import "HotCircleCell.h"


/// 商场首页
@interface MallViewController : UIViewController< UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, ProductCellDelegate, MallProductClassificationCellDelegate>

//导航按钮
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSString * Vstr;
@property (strong, nonatomic) NSArray *array;
@end
