//
//  GoodsListController.h
//  Yongai
//
//  Created by arron on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 购物车订单确认页面中跳转的 商品清单列表
@interface GoodsListController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *goodsListTable;//商品清单列表

@property(nonatomic, strong)NSArray *goodsArr; //购买商品列表
@property(nonatomic, strong)NSArray *giftsArr; // 赠品列表
@end
