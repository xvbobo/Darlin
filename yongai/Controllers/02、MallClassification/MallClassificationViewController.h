//
//  MallClassificationViewController.h
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 分类根页面
@interface MallClassificationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *array;

@end
