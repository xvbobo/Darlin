//
//  MyViewController.h
//  Yongai
//
//  Created by Kevin Su on 14-10-27.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceView.h"

/**
 *  我的个人中心根页面
 */
@interface MyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) ServiceView *serviceView;

@end
