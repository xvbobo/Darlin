//
//  SettingViewController.h
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CacheView.h"

/**
 *  设置
 */
@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *myTableView;

@property (strong, nonatomic) CacheView *cacheView;

@end
