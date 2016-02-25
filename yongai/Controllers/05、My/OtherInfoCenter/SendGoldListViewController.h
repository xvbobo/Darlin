//
//  SendGoldListViewController.h
//  yongai
//
//  Created by wangfang on 15/1/22.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  查看收礼排行榜页面
 */
@interface SendGoldListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSString *userId;

@end
