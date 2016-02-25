//
//  MCProductDetailViewController.h
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProductDetailCell.h"
#import "MCProductInfoCell.h"
#import "MCProductPromotionCell.h"
#import "MCProductSpecCell.h"
#import "MCProductOtherInfoCell.h"
#import "MCProductServiceInfoCell.h"
#import "ProductSpecView.h"
#import "MCProductBottomView.h"

// 商品详情
@interface MCProductDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MCProductOtherInfoCellDelegate, ProductSpecViewDelegate, MCProductBottomViewDelegate, MCProductServiceInfoCellDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *productDic;
@property (nonatomic, strong) NSString *gid;//商品ID

@end
