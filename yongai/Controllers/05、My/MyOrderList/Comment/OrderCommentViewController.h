//
//  OrderCommentViewController.h
//  Yongai
//
//  Created by Kevin Su on 14/12/9.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^myBlock)(NSString * myTitle);
//  评价界面
@interface OrderCommentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *productsArray;

@property (strong, nonatomic) NSString *order_id;
@property (nonatomic,copy) myBlock Myblock;
- (void)returnText:(myBlock)block;
@end
