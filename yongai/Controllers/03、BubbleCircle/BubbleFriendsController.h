//
//  BubbleFriendsController.h
//  Yongai
//
//  Created by arron on 14/11/7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  泡友圈首页
 */
@interface BubbleFriendsController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *bubbleTable;
@property (strong,nonatomic) NSString * Tstring;
@end
