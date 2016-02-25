//
//  MCProductCommentViewController.h
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  商品评论页面
#import <UIKit/UIKit.h>
//#import "PullPsCollectionView.h"

@interface MCProductCommentViewController : UIViewController< UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *commentGradeView;

@property (strong, nonatomic) IBOutlet UILabel *commentGradeLabel;

//@property (nonatomic, strong) PullPsCollectionView *commentsCollectionView;
@property (nonatomic, strong) IBOutlet UITableView *commentsTableView;

@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic) NSInteger commentIndex;
@property (weak, nonatomic) IBOutlet UILabel *haoPingDu;

@end
