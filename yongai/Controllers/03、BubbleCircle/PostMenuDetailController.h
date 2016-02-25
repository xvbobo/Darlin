//
//  PostMenuDetailController.h
//  Yongai
//
//  Created by arron on 14/11/11.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  泡友圈 详情页面
 */
@interface PostMenuDetailController : UIViewController<UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *postMenuDetailTable; //圈子详情table
@property (strong,nonatomic) UIScrollView * myScrollerView;
@property (strong, nonatomic) NSString *fid; // 圈子id
@property (strong,nonatomic) NSString * tag_id;
@property (assign, nonatomic) BOOL  bShowTabBar; //返回时，是否显示tabbar
@property (nonatomic,strong) NSString * str;

@end
